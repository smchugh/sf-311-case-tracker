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
  context 'testing first_or_create with validations' do
    it 'should create a new neighborhood with a unique name' do
      one_neighborhood = create(:neighborhood, name: 'One Name')
      another_neighborhood = Neighborhood.where({name: 'Another Name'}).first_or_create

      expect(one_neighborhood).not_to eq(nil)
      expect(another_neighborhood).not_to eq(nil)
      expect(one_neighborhood.id).not_to eq(another_neighborhood.id)
      expect(one_neighborhood.name).not_to eq(another_neighborhood.name)
    end

    it 'should get an existing neighborhood with a non-unique name' do
      one_neighborhood = create(:neighborhood, name: 'Same Name')
      another_neighborhood = Neighborhood.where({name: 'Same Name'}).first_or_create

      expect(one_neighborhood).not_to eq(nil)
      expect(another_neighborhood).not_to eq(nil)
      expect(one_neighborhood.id).to eq(another_neighborhood.id)
      expect(one_neighborhood.name).to eq(another_neighborhood.name)
    end

    it 'should get an existing neighborhood with a non-unique name regardless of case' do
      one_neighborhood = create(:neighborhood, name: 'Same Name')
      another_neighborhood = Neighborhood.where({name: 'same name'}).first_or_create

      expect(one_neighborhood).not_to eq(nil)
      expect(another_neighborhood).not_to eq(nil)
      expect(one_neighborhood.id).to eq(another_neighborhood.id)
      expect(one_neighborhood.name).to eq(another_neighborhood.name)
    end

    it 'should return nil when no attributes are provided' do
      one_neighborhood = Neighborhood.where(nil).first_or_create

      expect(one_neighborhood.id).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_neighborhood = Neighborhood.where({}).first_or_create

      expect(one_neighborhood.id).to eq(nil)
    end
  end
end
