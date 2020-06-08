# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Achievements API', type: :request do
    let(:user) { FactoryBot.create(:user) }
  it 'sends public achievements' do
    _public_achievement = FactoryBot.create(:public_achievement, title: 'My achievement',user_id: user.id )
    _private_achievement = FactoryBot.create(:private_achievement, title: 'My private achievement', user_id: user.id )
    get '/api/achievements', params: {}, headers: {"Content-Type": "application/vnd.api+json"}

    expect(response.status).to  eq(200)
    json = JSON.parse(response.body) 

    expect(json['data'].count).to eq(1)
    expect(json['data'][0]['type']).to eq('achievements') 
    expect(json['data'][0]['attributes']['title']).to eq('My achievement') 
  end
end
