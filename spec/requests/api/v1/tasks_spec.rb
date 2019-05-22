require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  before { host! 'api.task-manager.test' }
	let!(:user) { create(:user) }
	let(:headers) do
    { 
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
     }    
  end

  describe 'Get /tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get '/tasks', params: {}, headers: headers
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 taks from databases' do
      expect(json_body[:tasks].count).to eq(5)
    end
  end

  describe 'Get /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before { get "/tasks/#{task.id}", params: {}, headers: headers }
   
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for task' do
      expect(json_body[:title]).to eq(task.title)
    end
  end
end