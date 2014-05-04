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

require 'net/http'
require 'json'
require 'uri'

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
      cases = cases.where(source: source) if source
    end

    cases
  }

  # Load the data from the sfgov site into the local db
  #
  # TODO: Encapsulate the http request
  #
  # @return nothing
  def self.load_data
    max_case_id = select('MAX(sf_case_id) AS max_id').first[:max_id] || 0
    result_count = 0

    begin
      # Get the next thousand results
      uri = URI(
          Rails.configuration.case_data_url +
          "?$limit=#{MAX_RESULTS}&$order=case_id%20ASC&" +
          "$where=case_id%20%3E%20#{max_case_id}"
      )
      response = Net::HTTP.get_response(uri)
      case_reports = JSON.parse(response.body, symbolize_names: true)

      # Set the count of the new result set
      result_count = case_reports.length

      # Insert each case into the DB
      case_reports.each do |case_report|
        point = Point.get_or_create(case_report[:point])
        category = Category.get_or_create(
            case_report[:category] ? {name: case_report[:category]} : nil
        )
        request_type = RequestType.get_or_create(
            case_report[:request_type] ? {name: case_report[:request_type]} : nil
        )
        status = Status.get_or_create(
            case_report[:status] ? {name: case_report[:status]} : nil
        )
        neighborhood = Neighborhood.get_or_create(
            case_report[:neighborhood] ?
                {
                    name: case_report[:neighborhood],
                    supervisor_district: case_report[:supervisor_district]
                } :
                nil
        )
        responsible_agency = ResponsibleAgency.get_or_create(
            case_report[:responsible_agency] ?
                {name: case_report[:responsible_agency]} :
                nil
        )
        source = Source.get_or_create(
            case_report[:source] ? {name: case_report[:source]} : nil
        )

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
