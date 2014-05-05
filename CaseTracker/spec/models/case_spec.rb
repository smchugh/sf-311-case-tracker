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

require 'spec_helper'

describe Case do
  it 'loads data without errors' do
    errors = false
    begin
      Case.load_data(true)
    rescue => e
      puts e.message
      errors = true
    end

    expect(errors).to eq(false)
  end
end
