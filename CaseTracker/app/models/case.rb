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
  belongs_to :source

  validates :sf_case_id, presence: true, uniqueness: true
  validates :opened, presence: true
  validates_length_of :request_details, :media_url, maximum: 255

  # Load the data from the sfgov site into the local db
  #
  # TODO: Encapsulate the http request
  #
  # @return nothing
  def self.load_data
    uri = URI.parse(Rails.configuration.case_data)
    response = Net::HTTP.get_response(uri)
    case_reports = JSON.parse(response.body, symbolize_names: true)

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
          source: source
      )
    end
  end

end
