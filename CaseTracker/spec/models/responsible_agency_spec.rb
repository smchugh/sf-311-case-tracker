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
  context 'testing get_or_create' do
    it 'should create a new responsible_agency with a unique name' do
      one_responsible_agency = FactoryGirl.create(:responsible_agency, name: 'One Name')
      another_responsible_agency = ResponsibleAgency.get_or_create({name: 'Another Name'})

      expect(one_responsible_agency).not_to eq(nil)
      expect(another_responsible_agency).not_to eq(nil)
      expect(one_responsible_agency.id).not_to eq(another_responsible_agency.id)
      expect(one_responsible_agency.name).not_to eq(another_responsible_agency.name)
    end

    it 'should get an existing responsible_agency with a non-unique name' do
      one_responsible_agency = FactoryGirl.create(:responsible_agency, name: 'Same Name')
      another_responsible_agency = ResponsibleAgency.get_or_create({name: 'Same Name'})

      expect(one_responsible_agency).not_to eq(nil)
      expect(another_responsible_agency).not_to eq(nil)
      expect(one_responsible_agency.id).to eq(another_responsible_agency.id)
      expect(one_responsible_agency.name).to eq(another_responsible_agency.name)
    end

    it 'should get an existing responsible_agency with a non-unique name regardless of case' do
      one_responsible_agency = FactoryGirl.create(:responsible_agency, name: 'Same Name')
      another_responsible_agency = ResponsibleAgency.get_or_create({name: 'same name'})

      expect(one_responsible_agency).not_to eq(nil)
      expect(another_responsible_agency).not_to eq(nil)
      expect(one_responsible_agency.id).to eq(another_responsible_agency.id)
      expect(one_responsible_agency.name).to eq(another_responsible_agency.name)
    end

    it 'should return nil when no attributes are provided' do
      one_responsible_agency = ResponsibleAgency.get_or_create(nil)

      expect(one_responsible_agency).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_responsible_agency = ResponsibleAgency.get_or_create({})

      expect(one_responsible_agency).to eq(nil)
    end
  end
end
