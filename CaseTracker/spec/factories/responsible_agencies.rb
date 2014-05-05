# == Schema Information
#
# Table name: responsible_agencies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :responsible_agency do
    sequence :name do |i| "MyString#{i}" end
  end
end
