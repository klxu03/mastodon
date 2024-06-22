# frozen_string_literal: true

class Stacky::DataInjectionController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:add, :delete, :modify]
  def add
    puts "TOM DEBUG::32 data injection add endpoint reached"
    puts params # try to receive the POST params!
    @text = params[:text] # the content of the post.
    @actor_id = params[:actor_id] # actor_id should be unique.
    @username = params[:username] # user's display name.
    @domain = params[:domain] # user's domain.
    @json = params[:json] # the json file of the post.


    #step0: TODO: add an authentication method to make sure this comes from curate.

    #step1: TODO: check if the external user exist, if not, add it using ResolveAccountService
    actor = Account.find_by(id: @actor_id)

    if actor.nil?
      # create the account
      ActivityPub::ProcessAccountService.new.stacky_inject_data_call(@username, @domain, @json)
    end
    # ActivityPub::ProcessAccountService.new.stacky_inject_data_call(@username, @domain, @json, only_key: only_key, verified_webfinger: !only_key, request_id: request_id)

    #step2: TODO: create the activitypub json file and call an existing service to insert the create status message.
    # (Bypassing the Webfinger lookup in code, as well as the authentication service)


    #step3: TODO: return a success message to the external user.

    render plain: 'Inject Successfully'
  end

  def modify
    puts "TOM DEBUG::32 data injection modify endpoint reached"
    puts params
    render json: {msg: 'Modify Successfully', params: params}
  end

  def delete
    puts "TOM DEBUG::32 data injection delete endpoint reached"
    puts params
    render json: {msg: 'Delete Successfully', params: params}
  end

  def inject_post(params)
    puts "Injecting..."
  end
end
