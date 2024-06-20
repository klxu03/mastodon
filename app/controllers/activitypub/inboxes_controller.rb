# frozen_string_literal: true

class ActivityPub::InboxesController < ActivityPub::BaseController
  include JsonLdHelper

  before_action :skip_unknown_actor_activity
  before_action :require_actor_signature!
  skip_before_action :authenticate_user!

  def create
    Rails.logger.info 'TOM DEBUG:: inbox controller created!'
    puts 'TOM DEBUG:: inbox controller created!'
    upgrade_account #NOTE: security measure
    process_collection_synchronization #NOTE: for a relay Announce, here the new user Account is fetched into the database.
    process_payload #NOTE: here the new statuses is fetched with the given url (relay).
    head 202
  end

  private

  def skip_unknown_actor_activity
    head 202 if unknown_affected_account?
  end

  def unknown_affected_account?
    json = Oj.load(body, mode: :strict)
    json.is_a?(Hash) && %w(Delete Update).include?(json['type']) && json['actor'].present? && json['actor'] == value_or_id(json['object']) && !Account.exists?(uri: json['actor'])
  rescue Oj::ParseError
    false
  end

  def account_required?
    params[:account_username].present?
  end

  def skip_temporary_suspension_response?
    true
  end

  def body
    return @body if defined?(@body)

    @body = request.body.read
    @body.force_encoding('UTF-8') if @body.present?

    request.body.rewind if request.body.respond_to?(:rewind)

    @body
  end

  def upgrade_account
    if signed_request_account&.ostatus?
      signed_request_account.update(last_webfingered_at: nil)
      puts "TOM DEBUG::12 Resolving Account! For acct="
      puts signed_request_account.acct
      ResolveAccountWorker.perform_async(signed_request_account.acct)
    end

    DeliveryFailureTracker.reset!(signed_request_actor.inbox_url)
  end

  def process_collection_synchronization
    raw_params = request.headers['Collection-Synchronization']
    # puts "TOM DEBUG:: Collection-Synchronization"
    return if raw_params.blank? || ENV['DISABLE_FOLLOWERS_SYNCHRONIZATION'] == 'true' || signed_request_account.nil?

    # Re-using the syntax for signature parameters
    params = SignatureParser.parse(raw_params)

    ActivityPub::PrepareFollowersSynchronizationService.new.call(signed_request_account, params)
  rescue SignatureParser::ParsingError
    Rails.logger.warn 'Error parsing Collection-Synchronization header'
  end

  def process_payload
    # Rails.logger.info 'TOM DEBUG:: inbox controller process_payload activated!'
    puts 'TOM DEBUG:: inbox controller process_payload activated!'
    puts "signed_request_actor.id, body, @account&.id, signed_request_actor.class.name"
    puts signed_request_actor.id
    puts body
    puts @account&.id
    puts signed_request_actor.class.name
    ActivityPub::ProcessingWorker.perform_async(signed_request_actor.id, body, @account&.id, signed_request_actor.class.name)
    puts "Process Payload END"
  end
end
