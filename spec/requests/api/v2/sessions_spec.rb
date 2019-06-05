require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
	before { host! 'api.task-manager.test' }
	let(:user) { create(:user) }
	let(:auth_data) { user.create_new_auth_token  }
	let(:headers) do
    { 
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'client' => auth_data['client'],
      'uid' => auth_data['uid']
     }    
	end
	
	describe 'POST /auth/sign_in' do
		before do
			post '/auth/sign_in', params: credentials.to_json, headers: headers
		end

		context 'when the credentials are correct' do
			let(:credentials) { { email: user.email, password: '123456' } }

			it 'returns status code 200' do
				expect(response).to have_http_status(200)
			end

			it 'return the auth data in the headers' do
				expect(response.headers).to have_key('access-token')
				expect(response.headers).to have_key('client')
				expect(response.headers).to have_key('uid')
      end
		end

		context 'when the credentials are incorrect' do
			let(:credentials) { { email: user.email, password: 'invalid' } }

			it 'returns status code 401' do
				expect(response).to have_http_status(401)
			end

			it 'return jason data for the created user' do
        expect(json_body).to have_key(:errors)
      end
		end
	end

	describe 'DELETE /auth/sign_out' do
		let(:auth_token) { user.auth_token }

		before do
			delete '/auth/sign_out', params: {}, headers: headers
		end

		it 'returns status code 200' do
			expect(response).to have_http_status(200)
		end

		it 'change the user auth token' do
			user.reload
			expect( user ).not_to be_valid_token(auth_data['access-token'], auth_data['client']) 
		end
	end
end