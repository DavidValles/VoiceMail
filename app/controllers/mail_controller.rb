class MailController < ApplicationController
  def index
    token = session[:azure_access_token]
    email = session[:user_email]
    if token
      # If a token is present in the session, get messages from the inbox
      conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
        # Outputs to the console
        faraday.response :logger
        # Uses the default Net::HTTP adapter
        faraday.adapter  Faraday.default_adapter  
      end
      response = conn.get do |request|
        # Get messages from the inbox
        # Sort by ReceivedDateTime in descending orderby
        # Get the first 20 results

        request.url '/api/v2.0/Me/Messages?$orderby=ReceivedDateTime desc&$select=ReceivedDateTime,Subject,From&$top=5'
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['Accept'] = "application/json"
        request.headers['X-AnchorMailbox'] = email

         # - binding.pry 

      end
      # Assign the resulting value to the @messages
      # variable to make it available to the view template.
      @messages = JSON.parse(response.body)['value']
 


     resp = conn.get do |req|                          
        req.url '/api/v2.0/me/messages/AAMkADYwZDA2OWY4LTBjYTQtNDNlZi1hYjczLTIzNWFhZWY5YmExMQBGAAAAAADt7uS1u_oeRqf1J5YaXxyyBwCbwRrcIKoOQZB_sfQK5Z-rAAAAAAEMAACbwRrcIKoOQZB_sfQK5Z-rAAECrixxAAA='
        req.headers['Authorization'] = "Bearer #{token}"
        req.headers['Accept'] = "application/json"
      end 



    @body = JSON.parse(resp.body)['Body']['Content']


    else
      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to root_url
    end
  end




end