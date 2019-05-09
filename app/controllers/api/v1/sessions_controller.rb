class Api::V1::SessionsController < ApplicationController
		def create
			user = User.find_by(email: session_params[:email])

			if user && user.valid_password?(session_params[:password])
				sign_in user, store: false
				user.generate_auth_token!
				user.save
				render json: user, status: 200
			else
				render json: { errors: 'Email ou senha invalido'}, status: 401
			end
		end

		private

		def session_params
			params.require(:session).permit(:email, :password)
		end
end
