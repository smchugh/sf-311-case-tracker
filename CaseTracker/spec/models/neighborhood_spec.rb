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

require 'spec_helper'

describe Neighborhood do
  context 'testing get_or_create' do
    it 'should create a new neighborhood with a unique name' do
      one_neighborhood = FactoryGirl.create(:neighborhood, name: 'One Name')
      another_neighborhood = Neighborhood.get_or_create({name: 'Another Name'})

      expect(one_neighborhood).not_to eq(nil)
      expect(another_neighborhood).not_to eq(nil)
      expect(one_neighborhood.id).not_to eq(another_neighborhood.id)
      expect(one_neighborhood.name).not_to eq(another_neighborhood.name)
    end

    it 'should get an existing neighborhood with a non-unique name' do
      one_neighborhood = FactoryGirl.create(:neighborhood, name: 'Same Name')
      another_neighborhood = Neighborhood.get_or_create({name: 'Same Name'})

      expect(one_neighborhood).not_to eq(nil)
      expect(another_neighborhood).not_to eq(nil)
      expect(one_neighborhood.id).to eq(another_neighborhood.id)
      expect(one_neighborhood.name).to eq(another_neighborhood.name)
    end

    it 'should get an existing neighborhood with a non-unique name regardless of case' do
      one_neighborhood = FactoryGirl.create(:neighborhood, name: 'Same Name')
      another_neighborhood = Neighborhood.get_or_create({name: 'same name'})

      expect(one_neighborhood).not_to eq(nil)
      expect(another_neighborhood).not_to eq(nil)
      expect(one_neighborhood.id).to eq(another_neighborhood.id)
      expect(one_neighborhood.name).to eq(another_neighborhood.name)
    end

    it 'should return nil when no attributes are provided' do
      one_neighborhood = Neighborhood.get_or_create(nil)

      expect(one_neighborhood).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_neighborhood = Neighborhood.get_or_create({})

      expect(one_neighborhood).to eq(nil)
    end
  end
end
