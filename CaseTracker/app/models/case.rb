# == Schema Information
#
# Table name: cases
#
#  id                    :integer          not null, primary key
#  point_id              :integer
#  category_id           :integer
#  request_details       :string(255)
#  request_type_id       :integer
#  status_id             :integer
#  updated               :datetime
#  media_url             :string(255)
#  neighborhood_id       :integer
#  sf_case_id            :integer
#  responsible_agency_id :integer
#  opened                :datetime
#  source_id             :integer
#  address               :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  closed                :datetime
#

class Case < ActiveRecord::Base
  belongs_to :point
  belongs_to :category
  belongs_to :request_type
  belongs_to :status
  belongs_to :neighborhood
  belongs_to :responsible_agency
  belongs_to :request_source, class_name: 'Source', foreign_key: 'source_id'

  validates :sf_case_id, presence: true, uniqueness: true
  validates :opened, presence: true
  validates_length_of :request_details, :media_url, maximum: 255

  MAX_RESULTS = Rails.configuration.max_case_results

  def to_json_body
    body = {case_id: sf_case_id, opened: opened}
    body[:point] = point.to_json_body if point
    body[:category] = category.name if category
    body[:request_details] = request_details if request_details
    body[:source] = request_source.name if request_source
    body[:address] = address if address
    body[:request_type] = request_type.name if request_type
    body[:status] = status.name if status
    body[:updated] = updated if updated
    body[:neighborhood] = neighborhood.name if neighborhood
    body[:closed] = closed if closed
    body[:supervisor_district] = neighborhood.supervisor_district if neighborhood
    body[:responsible_agency] = responsible_agency.name if responsible_agency
    body
  end

  # Return the cases that meet the specified filter criteria
  #  N.B. This approach will choose to simply not filter the results when an
  #  invalid filter value is passed in. Another approach could be to force the
  #
  # @param filters [Hash] Filters to apply to the Point scope
  #                       Currently consists of:
  #                         - near: {latitude: latitude, longitude: longitude}
  #                         - since: datetime opened
  #                         - status: status name
  #                         - source: source name
  #                         - limit: maximum number of results to return (default: 1000)
  #                         - offset: offset for results (default: 0)
  # @return [Collection] All cases that meet the filter criteria
  scope :filtered_cases, ->(filters) {
    # Get the points within five miles of the given point, or nil if none was provided
    if filters[:near] && filters[:near][:latitude] && filters[:near][:longitude]
      points = Point.within_five_miles(
          filters[:near][:latitude],
          filters[:near][:longitude]
      )
    else
      points = nil
    end

    # Get the status to filter by or nil if none was provided
    if filters[:status]
      # Get the status that matches the filter value, or a dummy Status that
      # no case will match if the filter value is bogus
      status = Status.find_by(name: filters[:status]) || Status.new(id: 0)
    else
      status = nil
    end

    # Get the source to filter by or nil if none was provided
    if filters[:source]
      # Get the source that matches the filter value, or a dummy Source that
      # no case will match if the filter value is bogus
      source = Source.find_by(name: filters[:source]) || Source.new(id: 0)
    else
      source = nil
    end

    cases = []
    Point.transaction do
      cases = all
      cases = cases.where(point_id: points) if points
      cases = cases.where('opened > ?', filters[:since]) if filters[:since]
      cases = cases.where(status: status) if status
      cases = cases.where(request_source: source) if source
      cases = cases.limit(filters[:limit]).offset(filters[:offset])
    end

    cases
  }

  # Load the data from the sfgov site into the local db
  #
  # @return nothing
  def self.load_data(for_test = false)
    max_case_id = select('MAX(sf_case_id) AS max_id').first[:max_id] || 0
    result_count = 0

    begin
      # Get the next thousand results
      case_reports = ApplicationHelper::CaseData.request_case_data(max_case_id)

      # Set the count of the new result set, or keep it at zero if this is a test
      result_count = case_reports.length unless for_test

      # Insert each case into the DB
      case_reports.each do |case_report|
        point = case_report[:point] ? Point.where(
          latitude: case_report[:point][:latitude],
          longitude: case_report[:point][:longitude]
        ).first_or_create(
          needs_recoding: case_report[:point][:needs_recoding]
        ) : nil

        category = case_report[:category] ? Category.where(
          name: case_report[:category]
        ).first_or_create : nil

        request_type = case_report[:request_type] ? RequestType.where(
          name: case_report[:request_type]
        ).first_or_create : nil

        status = case_report[:status] ? Status.where(
          name: case_report[:status]
        ).first_or_create : nil

        neighborhood = case_report[:neighborhood] ? Neighborhood.where(
          name: case_report[:neighborhood]
        ).first_or_create(
          supervisor_district: case_report[:supervisor_district]
        ) : nil

        responsible_agency = case_report[:responsible_agency] ? ResponsibleAgency.where(
          name: case_report[:responsible_agency]
        ).first_or_create : nil

        source = case_report[:source] ? Source.where(
          name: case_report[:source]
        ).first_or_create : nil

        Case.create(
            point: point,
            category: category,
            request_details: case_report[:request_details],
            request_type: request_type,
            status: status,
            updated: case_report[:updated],
            media_url: case_report[:media_url] ? case_report[:media_url][:url] : nil,
            neighborhood: neighborhood,
            sf_case_id: case_report[:case_id],
            responsible_agency: responsible_agency,
            opened: case_report[:opened],
            request_source: source
        )

        max_case_id = [max_case_id, case_report[:case_id].to_i].max
      end

    end while result_count >= MAX_RESULTS

  end

end
