# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  longitude      :decimal(18, 14)
#  latitude       :decimal(18, 14)
#  needs_recoding :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Point do
  context 'testing get_or_create' do
    it 'should create a new point with a unique name' do
      one_point = FactoryGirl.create(:point, latitude: 37.7, longitude: -122.4)
      another_point = Point.get_or_create({latitude: 37.7, longitude: -122.41})

      expect(one_point).not_to eq(nil)
      expect(another_point).not_to eq(nil)
      expect(one_point.id).not_to eq(another_point.id)
    end

    it 'should get an existing point with a non-unique name' do
      one_point = FactoryGirl.create(:point, latitude: 37.71, longitude: -122.41)
      another_point = Point.get_or_create({latitude: 37.71, longitude: -122.41})

      expect(one_point).not_to eq(nil)
      expect(another_point).not_to eq(nil)
      expect(one_point.id).to eq(another_point.id)
      expect(one_point.latitude).to eq(another_point.latitude)
      expect(one_point.longitude).to eq(another_point.longitude)
    end

    it 'should return nil when no attributes are provided' do
      one_point = Point.get_or_create(nil)

      expect(one_point).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_point = Point.get_or_create({})

      expect(one_point).to eq(nil)
    end
  end
end
