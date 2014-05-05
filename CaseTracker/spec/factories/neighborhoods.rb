# == Schema Information
#
# Table name: neighborhoods
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  supervisor_district :integer
#  created_at          :datetime
#  updated_at          :datetime
#

FactoryGirl.define do
  factory :neighborhood do
    sequence :name do |i| "MyString#{i}" end
    supervisor_district 1
  end
end
