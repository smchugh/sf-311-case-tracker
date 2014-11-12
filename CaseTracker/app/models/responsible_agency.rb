# == Schema Information
#
# Table name: responsible_agencies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ResponsibleAgency < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
