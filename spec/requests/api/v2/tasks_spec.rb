require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  before { host! 'api.task-manager.test' }
	let!(:user) { create(:user) }
	let(:headers) do
    { 
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
     }    
  end

  describe 'GET /tasks' do
    context 'when no filter and sorting params is sent' do 
      before do
        create_list(:task, 5, user_id: user.id)
        get '/tasks', params: {}, headers: headers
      end

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns 5 taks from databases' do
        expect(json_body[:data].count).to eq(5)
      end
    end

    context 'when no filter and sorting params is sent' do
      let!(:laptop_task_1){ create(:task, title: 'check is the laptop is broken', user_id: user.id)}
      let!(:laptop_task_2){ create(:task, title: 'buy a new laptop', user_id: user.id)}
      let!(:other_task_1){ create(:task, title: 'fix the door', user_id: user.id)}
      let!(:other_task_2){ create(:task, title: 'buy a new sofa', user_id: user.id)}

      before do
        get '/tasks?q[title_cont]=laptop&q[s]=title+ASC', params: {}, headers: headers
      end

      it 'returns only the tasks matching' do
        returned_tasks_title = json_body[:data].map { |t| t[:attributes][:title]}
        expect(returned_tasks_title).to eq([laptop_task_2.title, laptop_task_1.title])
      end
    end
  end

  describe 'Get /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before { get "/tasks/#{task.id}", params: {}, headers: headers }
   
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for task' do
      expect(json_body[:data][:attributes][:title]).to eq(task.title)
    end
  end

  describe 'POST /tasks' do
    before do
      post '/tasks', params: { task: task_pararams }.to_json, headers: headers
    end

    context 'when the params are valid' do
      let(:task_pararams) { attributes_for(:task) }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the task on database' do
        expect( Task.find_by(title: task_pararams[:title]) ).not_to be_nil
      end

      it 'return jason data for the created task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_pararams[:title])
      end

      it 'assings the created task to the current user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end

    context 'where the request params aren`t valid' do
      let(:task_pararams) { attributes_for(:task, title: '') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not saves the task on database' do
        expect( Task.find_by(title: task_pararams[:title]) ).to be_nil
      end

      it 'return jason error for title' do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end

  describe 'PUT /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }
    before do
       put "/tasks/#{task.id}", params: {task: task_pararams }.to_json, headers: headers 
    end

    context 'when the params are valid' do
      let(:task_pararams) { {title: 'new task title'} }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return jason data for the updated task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_pararams[:title])
      end

      it 'update task in the database' do
        expect( Task.find_by(title: task_pararams[:title]) ).not_to be_nil
      end
    end

    context 'where the request params aren`t valid' do
      let(:task_pararams) { attributes_for(:task, title: '') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return jason error for title' do
        expect(json_body[:errors]).to have_key(:title)
      end

      it 'does not update the task on database' do
        expect( Task.find_by(title: task_pararams[:title]) ).to be_nil
      end

      
    end
  end

  describe 'Delete /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }
    before do
      delete "/tasks/#{task.id}", params: {}, headers: headers 
    end
    it 'return status code 204' do
      expect(response).to have_http_status(204) 
    end
    
    it 'removes the task from databases' do
      expect{ Task.find( task.id ) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end