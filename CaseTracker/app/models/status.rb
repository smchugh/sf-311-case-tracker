# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Status < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  # Attempt to create a new status or return an existing status
  #
  # @param status_attributes [Hash] Attributes to create the status with
  #                                   Currently consists of:
  #                                     - name: name of the status
  #
  # @return persisted status or nil
  def self.get_or_create(status_attributes)
    return nil unless status_attributes

    # Attempt to create a new status record
    status = Status.create(status_attributes)

    # If status failed the uniqueness validation,
    # try to find existing status
    unless status.valid?
      status = Status.find_by(name: status[:name])
    end

    status
  end
end
