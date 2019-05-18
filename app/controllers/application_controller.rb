class ApplicationController < ActionController::API
    require 'attr_default'
    include Authenticable
end
