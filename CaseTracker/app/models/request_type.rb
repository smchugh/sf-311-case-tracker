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
  validates :name, presence: true, uniqueness: true

  # Attempt to create a new request_type or return an existing request_type
  #
  # @param request_type_attributes [Hash] Attributes to create the request_type with
  #                                         Currently consists of:
  #                                           - name: name of the request_type
  #
  # @return persisted request_type or nil
  def self.get_or_create(request_type_attributes)
    return nil unless request_type_attributes

    # Attempt to create a new request_type record
    request_type = RequestType.create(request_type_attributes)

    # If request_type failed the uniqueness validation,
    # try to find existing request_type
    unless request_type.valid?
      request_type = RequestType.find_by(name: request_type_attributes[:name])
    end

    request_type
  end
end
