# frozen_string_literal: true

class Stacky::DataInjectionController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :add
  def add
    puts "TOM DEBUG::32 data injection add endpoint reached"
    puts params # try to receive the POST params!

    #step0: TODO: add an authentication method to make sure this comes from curate.

    #step1: TODO: check if the external user exist, if not, add it using ResolveAccountService


    #step2: TODO: create the activitypub json file and call an existing service to insert the create status message.
    # (Bypassing the Webfinger lookup in code, as well as the authentication service)


    #step3: TODO: return a success message to the external user.

    render plain: 'Inject Successfully'
  end

  def modify
    puts "TOM DEBUG::32 data injection modify endpoint reached"
    puts params
    render plain: 'Inject Successfully'
  end

  def delete
    puts "TOM DEBUG::32 data injection delete endpoint reached"
    puts params
    render plain: 'Inject Successfully'
  end

  def inject_post(params)
    puts "Injecting..."
  end
end
