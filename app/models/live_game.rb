class LiveGame < ApplicationRecord
	belongs_to :home_user, class_name: 'User', foreign_key: :home_user_id
	belongs_to :away_user, class_name: 'User', foreign_key: :away_user_id

    scope :current, ->() { where(current: true) }
	# Maybe alias both methods (:home_elo_rating, :away_elo_rating) on :user to :elo_rating
	# delegate :home_elo_rating, to: :home_user
	# delegate :away_elo_rating, to: :away_user

	def update_user_score(user_side, operation=:+)
		current_score = send("#{user_side}_user_score")
		send("#{user_side}_user_score=", current_score.send(:+, 1))
	end

	alias_method :increment_user_score, :update_user_score

	def decrement_user_score(user_side)
		update_user_score(user_score, :-)
	end

	def server
		[:home, :away][total_score/5%2]
	end

	def underdog
		return nil if home_elo_rating == away_elo_rating
		home_elo_rating < away_elo_rating ? :home : :away
	end

	def finish_game!
        update_attribute(:current, false)
		# Game.new({
		# 	home_user: home_user,
		# 	away_user: away_user,
		# 	home_user_score: home_user_score,
		# 	away_user_score: away_user_score
		# })
	end

	private

	def total_score
		home_user_score + away_user_score
	end
end