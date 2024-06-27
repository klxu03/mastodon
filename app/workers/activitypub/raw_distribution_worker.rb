# frozen_string_literal: true

class ActivityPub::RawDistributionWorker
  include Sidekiq::Worker
  include Payloadable

  sidekiq_options queue: 'push'

  # Base worker for when you want to queue up a bunch of deliveries of
  # some payload. In this case, we have already generated JSON and
  # we are going to distribute it to the account's followers minus
  # the explicitly provided inboxes
  def perform(json, source_account_id, exclude_inboxes = [])
    @account         = Account.find(source_account_id)
    @json            = json
    @exclude_inboxes = exclude_inboxes


    distribute!
  rescue ActiveRecord::RecordNotFound
    true
  end

  protected

  def distribute!
    puts "TOM DEBUG inboxes=#{inboxes}, @account.ext_flag || payload[:ext_flag]= #{@account.ext_flag || payload[:ext_flag]}"
    return if inboxes.empty?
    # NOTE: If ext_flag is shown in either account or activitypub message, cut outgoing traffic.
    if @account.ext_flag || payload[:ext_flag]
      puts 'DEBUG:: action related to injected posts, cut outgoing traffic'
      return
    end

    ActivityPub::DeliveryWorker.push_bulk(inboxes, limit: 1_000) do |inbox_url|
      [payload, source_account_id, inbox_url, options]
    end
  end

  def payload
    @json
  end

  def source_account_id
    @account.id
  end

  def inboxes
    @inboxes ||= @account.followers.inboxes - @exclude_inboxes
  end

  def options
    {}
  end
end
