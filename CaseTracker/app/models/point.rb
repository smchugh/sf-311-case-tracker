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

  # Attempt to create a new point or return an existing point
  #
  # @param point_attributes [Hash] Attributes to create the point with
  #                                Currently consists of:
  #                                  - latitude: latitude of the point
  #                                  - longitude: longitude of the point
  #                                  - needs_recoding: boolean
  #
  # @return persisted point or nil
  def self.get_or_create(point_attributes)
    return nil unless point_attributes

    # Attempt to create a new point record
    point = Point.create(point_attributes)

    # If point failed the uniqueness validation, try to find existing point
    unless point.valid?
      point = Point.find_by(
          longitude: point_attributes[:longitude],
          latitude: point_attributes[:latitude]
      )
    end

    point
  end
end
