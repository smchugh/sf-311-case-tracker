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
  context 'testing first_or_create with validations' do
    it 'should create a new category with a unique name' do
      one_category = create(:category, name: 'One Name')
      another_category = Category.where({name: 'Another Name'}).first_or_create

      expect(one_category).not_to eq(nil)
      expect(another_category).not_to eq(nil)
      expect(one_category.id).not_to eq(another_category.id)
      expect(one_category.name).not_to eq(another_category.name)
    end

    it 'should get an existing category with a non-unique name' do
      one_category = create(:category, name: 'Same Name')
      another_category = Category.where({name: 'Same Name'}).first_or_create

      expect(one_category).not_to eq(nil)
      expect(another_category).not_to eq(nil)
      expect(one_category.id).to eq(another_category.id)
      expect(one_category.name).to eq(another_category.name)
    end

    it 'should get an existing category with a non-unique name regardless of case' do
      one_category = create(:category, name: 'Same Name')
      another_category = Category.where({name: 'same name'}).first_or_create

      expect(one_category).not_to eq(nil)
      expect(another_category).not_to eq(nil)
      expect(one_category.id).to eq(another_category.id)
      expect(one_category.name).to eq(another_category.name)
    end

    it 'should return nil when no attributes are provided' do
      one_category = Category.where(nil).first_or_create

      expect(one_category.id).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_category = Category.where({}).first_or_create

      expect(one_category.id).to eq(nil)
    end
  end
end
