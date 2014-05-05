# == Schema Information
#
# Table name: request_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe RequestType do
  context 'testing get_or_create' do
    it 'should create a new request_type with a unique name' do
      one_request_type = FactoryGirl.create(:request_type, name: 'One Name')
      another_request_type = RequestType.get_or_create({name: 'Another Name'})

      expect(one_request_type).not_to eq(nil)
      expect(another_request_type).not_to eq(nil)
      expect(one_request_type.id).not_to eq(another_request_type.id)
      expect(one_request_type.name).not_to eq(another_request_type.name)
    end

    it 'should get an existing request_type with a non-unique name' do
      one_request_type = FactoryGirl.create(:request_type, name: 'Same Name')
      another_request_type = RequestType.get_or_create({name: 'Same Name'})

      expect(one_request_type).not_to eq(nil)
      expect(another_request_type).not_to eq(nil)
      expect(one_request_type.id).to eq(another_request_type.id)
      expect(one_request_type.name).to eq(another_request_type.name)
    end

    it 'should get an existing request_type with a non-unique name regardless of case' do
      one_request_type = FactoryGirl.create(:request_type, name: 'Same Name')
      another_request_type = RequestType.get_or_create({name: 'same name'})

      expect(one_request_type).not_to eq(nil)
      expect(another_request_type).not_to eq(nil)
      expect(one_request_type.id).to eq(another_request_type.id)
      expect(one_request_type.name).to eq(another_request_type.name)
    end

    it 'should return nil when no attributes are provided' do
      one_request_type = RequestType.get_or_create(nil)

      expect(one_request_type).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_request_type = RequestType.get_or_create({})

      expect(one_request_type).to eq(nil)
    end
  end
end
