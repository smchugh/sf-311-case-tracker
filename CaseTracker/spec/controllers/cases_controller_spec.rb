require 'spec_helper'

describe CasesController do
  context 'non-json request' do
    it 'index returns http 404' do
      get 'index', {format: :html}
      expect(response.status).to eq(404)
    end
  end

  context 'json request on server with a ten cases' do

    it 'index returns http success and three cases' do
      10.times do
        create(:case)
      end

      get 'index', {format: :json}
      expect(response).to be_success

      cases = JSON.parse(response.body)
      expect(cases.length).to eq(10)
    end

    it 'index returns http success and five cases with the same source' do
      request_source = create(:source)
      10.times do |i|
        if i % 2 == 0
          create(:case, request_source: request_source)
        else
          create(:case)
        end
      end

      get 'index', {format: :json, source: request_source.name}
      expect(response).to be_success

      cases = JSON.parse(response.body)
      expect(cases.length).to eq(5)
    end

    it 'index returns http success and five cases with the same status' do
      status = create(:status)
      10.times do |i|
        if i % 2 == 0
          create(:case, status: status)
        else
          create(:case)
        end
      end

      get 'index', {format: :json, status: status.name}
      expect(response).to be_success

      cases = JSON.parse(response.body)
      expect(cases.length).to eq(5)
    end

    it 'index returns http success and five cases opened before yesterday' do
      10.times do |i|
        if i % 2 == 0
          create(:case, opened: Date.today - 2.day)
        else
          create(:case, opened: Date.today)
        end
      end

      get 'index', {format: :json, since: (Date.today - 1.day).to_time.to_i}
      expect(response).to be_success

      cases = JSON.parse(response.body)
      expect(cases.length).to eq(5)
    end

    it 'index returns http success and five cases within 5 miles' do
      point_1 = create(:point, latitude: 37.7, longitude: -122.4)
      point_2 = create(
          :point,
          latitude: point_1.latitude - 2 / Point::MILES_PER_LATITUDE,
          longitude: -122.4 + 4 / Point::MILES_PER_LATITUDE
      )
      point_3 = create(
          :point,
          latitude: point_1.latitude + 3 / Point::MILES_PER_LATITUDE,
          longitude: -122.4 - 1 / Point::MILES_PER_LATITUDE
      )
      10.times do |i|
        if i % 2 == 0
          if i % 4 == 0
            create(:case, point: point_2)
          else
            create(:case, point: point_3)
          end
        else
          create(:case)
        end
      end

      get 'index', {format: :json, near: [point_1.latitude, point_1.longitude].join(',')}
      expect(response).to be_success

      cases = JSON.parse(response.body)
      expect(cases.length).to eq(5)
    end

    it 'index returns http success and two cases with the same source and status' do
      request_source = create(:source)
      status = create(:status)
      10.times do |i|
        if i % 2 == 0
          if i > 4
            create(:case)
          else
            create(:case, request_source: request_source)
          end
        else
          if i > 4
            create(:case, status: status)
          else
            create(:case, request_source: request_source, status: status)
          end
        end
      end

      get 'index', {format: :json, source: request_source.name, status: status.name}
      expect(response).to be_success

      cases = JSON.parse(response.body)
      expect(cases.length).to eq(2)
    end

  end
end
