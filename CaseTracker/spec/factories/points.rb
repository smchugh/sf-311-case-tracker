# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  longitude      :float
#  latitude       :float
#  needs_recoding :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

FactoryGirl.define do
  factory :point do
    needs_recoding false
    sequence :longitude do |i| 1.5 + i end
    sequence :latitude do |i| 1.5 + i end
  end
end
