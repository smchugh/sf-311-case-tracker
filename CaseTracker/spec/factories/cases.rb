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

FactoryGirl.define do
  factory :case do
    point
    category
    request_details 'MyString'
    request_type
    status
    sequence :updated do |i| (Date.today - i).to_time end
    media_url 'MyString'
    neighborhood
    sequence :sf_case_id do |i| i end
    responsible_agency
    sequence :opened do |i| (Date.today - (i + 1)).to_time end
    request_source
    address 'MyString'
    sequence :closed do |i| (Date.today - i).to_time end
  end
end
