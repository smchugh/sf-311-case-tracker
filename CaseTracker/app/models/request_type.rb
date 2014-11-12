# == Schema Information
#
# Table name: request_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class RequestType < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
