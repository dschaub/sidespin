class SlackUser
  def initialize(user)
    @user = user
  end

  def id
    unless instance_variable_defined?(:@id)
      found_user = all_users.find do |slack_user|
        slack_user['profile'].email == user.email
      end

      @id = found_user&.id
    end
    @id
  end

  private
  attr_reader :user

  def client
    @client ||= Slack::Web::Client.new
  end

  def all_users
    @all_users ||= client.users_list['members']
  end
end
