# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Category do
  context 'testing get_or_create' do
    it 'should create a new category with a unique name' do
      one_category = FactoryGirl.create(:category, name: 'One Name')
      another_category = Category.get_or_create({name: 'Another Name'})

      expect(one_category).not_to eq(nil)
      expect(another_category).not_to eq(nil)
      expect(one_category.id).not_to eq(another_category.id)
      expect(one_category.name).not_to eq(another_category.name)
    end

    it 'should get an existing category with a non-unique name' do
      one_category = FactoryGirl.create(:category, name: 'Same Name')
      another_category = Category.get_or_create({name: 'Same Name'})

      expect(one_category).not_to eq(nil)
      expect(another_category).not_to eq(nil)
      expect(one_category.id).to eq(another_category.id)
      expect(one_category.name).to eq(another_category.name)
    end

    it 'should get an existing category with a non-unique name regardless of case' do
      one_category = FactoryGirl.create(:category, name: 'Same Name')
      another_category = Category.get_or_create({name: 'same name'})

      expect(one_category).not_to eq(nil)
      expect(another_category).not_to eq(nil)
      expect(one_category.id).to eq(another_category.id)
      expect(one_category.name).to eq(another_category.name)
    end

    it 'should return nil when no attributes are provided' do
      one_category = Category.get_or_create(nil)

      expect(one_category).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_category = Category.get_or_create({})

      expect(one_category).to eq(nil)
    end
  end
end
