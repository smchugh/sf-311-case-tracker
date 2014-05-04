require 'net/http'
require 'json'
require 'uri'

module ApplicationHelper
  class CaseData
    MAX_RESULTS = Rails.configuration.max_case_results

    # Request the next MAX_RESULTS cases from the case server that are more
    # recent than the current maximum case_id
    #
    # N.B. This logic assumes that a case_id is a unique incremental identifier
    # for 311 cases, so that the load can take advantage of the efficiency of
    # primary key sorting over date sorting / lookups
    #
    # @param max_case_id [int] The maximum case ID currently stored locally
    #
    # @return [Array] Array of hashes with case data
    def self.request_case_data(max_case_id)
      uri = URI(
          Rails.configuration.case_data_url +
          "?$limit=#{MAX_RESULTS}&$order=case_id%20ASC&" +
          "$where=case_id%20%3E%20#{max_case_id}"
      )
      response = Net::HTTP.get_response(uri)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
