# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :source, aliases: [:request_source] do
    sequence :name do |i| "MyString#{i}" end
  end
end
