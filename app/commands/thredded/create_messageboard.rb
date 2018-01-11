# frozen_string_literal: true

module Thredded
  # Creates a new messageboard and seeds it with a topic.
  class CreateMessageboard
    # @param messageboard [Thredded::Messageboard]
    # @param user [Thredded.user_class]
    def initialize(messageboard, user)
      @messageboard = messageboard
      @user = user
    end

    # @return [boolean] true if the messageboard was created and seeded with a topic successfully.
    def run
      Thredded::Messageboard.transaction do
        fail ActiveRecord::Rollback unless @messageboard.save
        topic = Thredded::Topic.create!(
          messageboard: @messageboard,
          user: @user,
          title: first_topic_title
        )
        Thredded::Post.create!(
          messageboard: @messageboard,
          user: @user,
          postable: topic,
          content: first_post_content
        )
        true
      end
    end

    def first_topic_title
      "Don't forget to check out our forum rules before you post"
    end

    def first_post_content
      <<-MARKDOWN
##We take moderation very seriously so make sure you're familiar with the rules before you post to make sure your posts don't get removed!
    1. DO NOT identify yourself in any way
    2. If you suspect you know someone on the forum, DO NOT identify them in any way
    3. DO NOT use any information to find out real world facts about anyone on the forum
    4. Be kind, courteous, and respectful
    5. If any personally identifiable information (such as names, emails, phone numbers, etc.) is posted, it will be removed from the site as soon as possible.
    6. Any members that are disrespectful, inappropriate, or aggressive will be blocked.
    MARKDOWN
    end
  end
end
