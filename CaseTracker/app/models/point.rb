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

class Point < ActiveRecord::Base
  validates :longitude, presence: true, uniqueness: {scope: :latitude}

end
