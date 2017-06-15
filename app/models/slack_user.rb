class SlackUser
  def initialize(email: nil, user_name: nil)
    @email = email
    @user_name = user_name
  end

  def id
    unless instance_variable_defined?(:@id)
      found_user = all_users.find do |slack_user|
        slack_user['profile'].email == email
      end

      @id = found_user&.id
    end
    @id
  end

  private

  attr_reader :email, :user_name

  def client
    @client ||= Slack::Web::Client.new
  end

  def all_users
    @all_users ||= client.users_list['members']
  end

  def found_user
    if user_name.present?
      find_by_user_name
    elsif email.present?
      find_by_email
    else
      raise "Must pass email or user name"
    end
  end

  def find_by_email
    all_users.find do |slack_user|
      slack_user['profile'].email == email
    end
  end

  def find_by_user_name
    all_users.find do |slack_user|
      slack_user['profile'].user_name == user_name
    end
  end
end
