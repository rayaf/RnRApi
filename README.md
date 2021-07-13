# Api Task manager


[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

This application (front still in development stage) aims at create a simple and easy to use todo list.
## 🚨 important!
In order tu run this project you need attending the following requirements 
- Ruby 2.4 or greater
- Ruby on Rails 5.x.x

## 🛠 Setup
First you need to create a subdomain in your localhost on the host file, I recomend using this:
```sh
127.0.0.2 api.task-manager.test
```
Them you can run:
```sh
bundle install
```
## 💻 Usage
If you prefere can use this url: [https://taskmanager--api.herokuapp.com/](https://taskmanager--api.herokuapp.com/) to make the requestes.

To create a user postman or insomnia and make the request to /auth
>{
	"email": "your email",
	"password": "your password",
	"password_confirmation": "confirme password"
}
to sign in just send the email and password to auth/sign_in

## 💎 Gems 
- To auth is use [Devise token auth](https://github.com/lynndylanhurley/devise_token_auth) with [Omniauth](https://github.com/omniauth/omniauth)
- To run test is use [Rspec](), [Shoulda Matchers](),[Factory Girl Rails]() and [Faker]()
- And to auxiliate is use [Ransack](), [Rack cors]() and [Active Model Serializers]()
