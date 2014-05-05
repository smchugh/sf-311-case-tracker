# == Schema Information
#
# Table name: request_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :request_type do
    sequence :name do |i| "MyString#{i}" end
  end
end
