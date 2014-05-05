# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Status do
  context 'testing get_or_create' do
    it 'should create a new status with a unique name' do
      one_status = FactoryGirl.create(:status, name: 'One Name')
      another_status = Status.get_or_create({name: 'Another Name'})

      expect(one_status).not_to eq(nil)
      expect(another_status).not_to eq(nil)
      expect(one_status.id).not_to eq(another_status.id)
      expect(one_status.name).not_to eq(another_status.name)
    end

    it 'should get an existing status with a non-unique name' do
      one_status = FactoryGirl.create(:status, name: 'Same Name')
      another_status = Status.get_or_create({name: 'Same Name'})

      expect(one_status).not_to eq(nil)
      expect(another_status).not_to eq(nil)
      expect(one_status.id).to eq(another_status.id)
      expect(one_status.name).to eq(another_status.name)
    end

    it 'should get an existing status with a non-unique name regardless of case' do
      one_status = FactoryGirl.create(:status, name: 'Same Name')
      another_status = Status.get_or_create({name: 'same name'})

      expect(one_status).not_to eq(nil)
      expect(another_status).not_to eq(nil)
      expect(one_status.id).to eq(another_status.id)
      expect(one_status.name).to eq(another_status.name)
    end

    it 'should return nil when no attributes are provided' do
      one_status = Status.get_or_create(nil)

      expect(one_status).to eq(nil)
    end

    it 'should return nil when empty attributes are provided' do
      one_status = Status.get_or_create({})

      expect(one_status).to eq(nil)
    end
  end
end
