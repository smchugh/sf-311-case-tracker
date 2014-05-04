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
  validates :name, presence: true, uniqueness: true

  # Attempt to create a new neighborhood or return an existing neighborhood
  #
  # @param neighborhood_attributes [Hash] Attributes to create the neighborhood with
  #                                         Currently consists of:
  #                                           - name: name of the neighborhood
  #                                           - supervisor_district: supervisor district
  #
  # @return persisted neighborhood or nil
  def self.get_or_create(neighborhood_attributes)
    return nil unless neighborhood_attributes

    # Attempt to create a new neighborhood record
    neighborhood = Neighborhood.create(neighborhood_attributes)

    # If neighborhood failed the uniqueness validation,
    # try to find existing neighborhood
    unless neighborhood.valid?
      neighborhood = Neighborhood.find_by(name: neighborhood_attributes[:name])
    end

    neighborhood
  end
end
