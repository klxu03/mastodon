# frozen_string_literal: true

class ActivityPub::ProcessingWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'ingress', backtrace: true, retry: 8

  def perform(actor_id, body, delivered_to_account_id = nil, actor_type = 'Account') # NOTE: can have an 'External' type for reddit
    puts "TOM DEBUG: ProcessingWorker::perform"
    case actor_type
    when 'Account'
      puts "ACTOR START!"
      actor = Account.find_by(id: actor_id)
      puts "TOM DEBUG:: Finding account in processing_working.perform"
      puts actor
      puts "ACTOR END"
    end

    return if actor.nil?

    ActivityPub::ProcessCollectionService.new.call(body, actor, override_timestamps: true, delivered_to_account_id: delivered_to_account_id, delivery: true)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.debug { "Error processing incoming ActivityPub object: #{e}" }
  end
end
