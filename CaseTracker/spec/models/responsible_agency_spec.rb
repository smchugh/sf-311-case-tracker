# == Schema Information
#
# Table name: responsible_agencies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ResponsibleAgency do
  context 'testing first_or_create with validations' do
    it 'should create a new responsible_agency with a unique name' do
      one_responsible_agency = create(:responsible_agency, name: 'One Name')
      another_responsible_agency = ResponsibleAgency.where({name: 'Another Name'}).first_or_create

      expect(one_responsible_agency).not_to eq(nil)
      expect(another_responsible_agency).not_to eq(nil)
      expect(one_responsible_agency.id).not_to eq(another_responsible_agency.id)
      expect(one_responsible_agency.name).not_to eq(another_responsible_agency.name)
    end

    it 'should get an existing responsible_agency with a non-unique name' do
      one_responsible_agency = create(:responsible_agency, name: 'Same Name')
      another_responsible_agency = ResponsibleAgency.where({name: 'Same Name'}).first_or_create

      expect(one_responsible_agency).not_to eq(nil)
      expect(another_responsible_agency).not_to eq(nil)
      expect(one_responsible_agency.id).to eq(another_responsible_agency.id)
      expect(one_responsible_agency.name).to eq(another_responsible_agency.name)
    end

    it 'should get an existing responsible_agency with a non-unique name regardless of case' do
      one_responsible_agency = create(:responsible_agency, name: 'Same Name')
      another_responsible_agency = ResponsibleAgency.where({name: 'same name'}).first_or_create

      expect(one_responsible_agency).not_to eq(nil)
      expect(another_responsible_agency).not_to eq(nil)
      expect(one_responsible_agency.id).to eq(another_responsible_agency.id)
      expect(one_responsible_agency.name).to eq(another_responsible_agency.name)
    end

    it 'should return nil when no attributes are provided' do
      one_responsible_agency = ResponsibleAgency.where(nil).first_or_create

      expect(one_responsible_agency.id).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_responsible_agency = ResponsibleAgency.where({}).first_or_create

      expect(one_responsible_agency.id).to eq(nil)
    end
  end
end
