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

class Neighborhood < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
