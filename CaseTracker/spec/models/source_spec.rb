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
  context 'testing get_or_create' do
    it 'should create a new source with a unique name' do
      one_source = FactoryGirl.create(:source, name: 'One Name')
      another_source = Source.get_or_create({name: 'Another Name'})

      expect(one_source).not_to eq(nil)
      expect(another_source).not_to eq(nil)
      expect(one_source.id).not_to eq(another_source.id)
      expect(one_source.name).not_to eq(another_source.name)
    end

    it 'should get an existing source with a non-unique name' do
      one_source = FactoryGirl.create(:source, name: 'Same Name')
      another_source = Source.get_or_create({name: 'Same Name'})

      expect(one_source).not_to eq(nil)
      expect(another_source).not_to eq(nil)
      expect(one_source.id).to eq(another_source.id)
      expect(one_source.name).to eq(another_source.name)
    end

    it 'should get an existing source with a non-unique name regardless of case' do
      one_source = FactoryGirl.create(:source, name: 'Same Name')
      another_source = Source.get_or_create({name: 'same name'})

      expect(one_source).not_to eq(nil)
      expect(another_source).not_to eq(nil)
      expect(one_source.id).to eq(another_source.id)
      expect(one_source.name).to eq(another_source.name)
    end

    it 'should return nil when no attributes are provided' do
      one_source = Source.get_or_create(nil)

      expect(one_source).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_source = Source.get_or_create({})

      expect(one_source).to eq(nil)
    end
  end
end
