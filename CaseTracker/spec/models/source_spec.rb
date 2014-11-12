# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Source do
  context 'testing first_or_create with validations' do
    it 'should create a new source with a unique name' do
      one_source = FactoryGirl.create(:source, name: 'One Name')
      another_source = Source.where({name: 'Another Name'}).first_or_create

      expect(one_source).not_to eq(nil)
      expect(another_source).not_to eq(nil)
      expect(one_source.id).not_to eq(another_source.id)
      expect(one_source.name).not_to eq(another_source.name)
    end

    it 'should get an existing source with a non-unique name' do
      one_source = FactoryGirl.create(:source, name: 'Same Name')
      another_source = Source.where({name: 'Same Name'}).first_or_create

      expect(one_source).not_to eq(nil)
      expect(another_source).not_to eq(nil)
      expect(one_source.id).to eq(another_source.id)
      expect(one_source.name).to eq(another_source.name)
    end

    it 'should get an existing source with a non-unique name regardless of case' do
      one_source = FactoryGirl.create(:source, name: 'Same Name')
      another_source = Source.where({name: 'same name'}).first_or_create

      expect(one_source).not_to eq(nil)
      expect(another_source).not_to eq(nil)
      expect(one_source.id).to eq(another_source.id)
      expect(one_source.name).to eq(another_source.name)
    end

    it 'should return nil when no attributes are provided' do
      one_source = Source.where(nil).first_or_create

      expect(one_source.id).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_source = Source.where({}).first_or_create

      expect(one_source.id).to eq(nil)
    end
  end
end
