class GoogleApisController < ApplicationController

	def oauth2callback
		require	'faraday'

		conn = Faraday.new(:url => 'https://accounts.google.com',:ssl => {:verify => false}) do |faraday|
			faraday.request  :url_encoded
			faraday.response :logger
			faraday.adapter  Faraday.default_adapter
		end

		@result = conn.post '/o/oauth2/token', {'code' => params[:code],
			'client_id' => "677854967636-bbgnasktr2e0pk7iboj5kt4fflsaaap8.apps.googleusercontent.com",
			'client_secret' => "GiWQtkXnxjVSO2WIHnG8H_T5",
			'redirect_uri' => "http://localhost:3000/oauth2callback",
			'grant_type' => 'authorization_code'}

		render layout: false
	end
end