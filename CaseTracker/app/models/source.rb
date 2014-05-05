# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Source < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  # Attempt to create a new source or return an existing source
  #
  # @param source_attributes [Hash] Attributes to create the source with
  #                                   Currently consists of:
  #                                     - name: name of the source
  #
  # @return persisted source or nil
  def self.get_or_create(source_attributes)
    return nil unless source_attributes

    # Attempt to create a new source record
    source = Source.create(source_attributes)

    # If source failed the uniqueness validation, try to find existing source
    unless source.valid?
      source = Source.find_by(
          name: source_attributes[:name]
      )
    end

    source
  end
end
