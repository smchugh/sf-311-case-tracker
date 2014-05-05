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

  MILES_PER_LATITUDE = 69.047
  MILES_PER_LONGITUDE = 54.653 # Assuming a flat earth relative to the SF area

  def to_json_body
    {
        latitude: latitude,
        longitude: longitude,
        needs_recoding: needs_recoding
    }
  end

  # Return the points within a five mile radius of the given coordinate
  #  For the purposes of query efficiency, and the time constraints of this
  #  project, the logic herein assumes a 10x10 mile square centered at the
  #  point to be a close enough approximation. In future work, geometrical
  #  calculations can be done in the SQL statement itself to find the points.
  #
  # @param latitude  [float] Latitude of the circle center
  # @param longitude [float] Longitude of the circle center
  #
  # @return [Collection] All points within five miles of the given point
  scope :within_five_miles, ->(latitude, longitude) {
    latitudes_per_five_miles = 5 / MILES_PER_LATITUDE
    longitudes_per_five_miles = 5 / MILES_PER_LONGITUDE

    where(
        '(latitude BETWEEN ? AND ?) AND (longitude BETWEEN ? AND ?)',
        latitude - latitudes_per_five_miles,
        latitude + latitudes_per_five_miles,
        longitude - longitudes_per_five_miles,
        longitude + longitudes_per_five_miles
    )
  }

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
