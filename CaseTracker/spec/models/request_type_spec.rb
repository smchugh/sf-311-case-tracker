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
  context 'testing first_or_create with validations' do
    it 'should create a new request_type with a unique name' do
      one_request_type = create(:request_type, name: 'One Name')
      another_request_type = RequestType.where({name: 'Another Name'}).first_or_create

      expect(one_request_type).not_to eq(nil)
      expect(another_request_type).not_to eq(nil)
      expect(one_request_type.id).not_to eq(another_request_type.id)
      expect(one_request_type.name).not_to eq(another_request_type.name)
    end

    it 'should get an existing request_type with a non-unique name' do
      one_request_type = create(:request_type, name: 'Same Name')
      another_request_type = RequestType.where({name: 'Same Name'}).first_or_create

      expect(one_request_type).not_to eq(nil)
      expect(another_request_type).not_to eq(nil)
      expect(one_request_type.id).to eq(another_request_type.id)
      expect(one_request_type.name).to eq(another_request_type.name)
    end

    it 'should get an existing request_type with a non-unique name regardless of case' do
      one_request_type = create(:request_type, name: 'Same Name')
      another_request_type = RequestType.where({name: 'same name'}).first_or_create

      expect(one_request_type).not_to eq(nil)
      expect(another_request_type).not_to eq(nil)
      expect(one_request_type.id).to eq(another_request_type.id)
      expect(one_request_type.name).to eq(another_request_type.name)
    end

    it 'should return nil when no attributes are provided' do
      one_request_type = RequestType.where(nil).first_or_create

      expect(one_request_type.id).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_request_type = RequestType.where({}).first_or_create

      expect(one_request_type.id).to eq(nil)
    end
  end
end
