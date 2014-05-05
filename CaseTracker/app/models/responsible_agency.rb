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

  # Attempt to create a new responsible_agency or return an existing responsible_agency
  #
  # @param responsible_agency_attributes [Hash] Attributes to create the responsible_agency with
  #                                               Currently consists of:
  #                                                 - name: name of the responsible_agency
  #
  # @return persisted responsible_agency or nil
  def self.get_or_create(responsible_agency_attributes)
    return nil unless responsible_agency_attributes

    # Attempt to create a new responsible_agency record
    responsible_agency = ResponsibleAgency.create(responsible_agency_attributes)

    # If responsible_agency failed the uniqueness validation,
    # try to find existing responsible_agency
    unless responsible_agency.valid?
      responsible_agency = ResponsibleAgency.find_by(
          name: responsible_agency_attributes[:name]
      )
    end

    responsible_agency
  end
end
