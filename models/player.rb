class Player
  include DataMapper::Resource
  include Gravtastic


  property :id, Serial
  property :name, String, :required => true
  property :email, String, :required => true

  has_gravatar
  has n, :won_challenges, 'Challenge', :child_key => [:winner_id]
  has n, :initiated_challenges, 'Challenge', :child_key => [:from_player_id]
  has n, :challenged_challenges, 'Challenge', :child_key => [:to_player_id]

  def challenges
    (initiated_challenges + challenged_challenges).uniq
  end

  def challenged_by?(another_player)
    !self.challenges.select do |challenge|
      challenge.from_player_id == another_player.id or challenge.to_player_id == another_player.id
    end.empty?
  end

  def total_wins
    self.won_challenges.length
  end

  def winning_percentage(return_string = true)
    if self.challenges.length > 0
      percentage = ((self.total_wins.to_f / self.challenges.length.to_f) * 100).to_i
      return_string ? percentage.to_s.concat("%") : percentage
    else
      return_string ? "0%" : 0
    end
  end

  def ranking
    # Array is zero-indexed - let's add one
    Player.all.sort_by { |player| player.winning_percentage(false) }.reverse.index(self) + 1
  end

  def ranking_as_percentage
    ((ranking.to_f / Player.count.to_f) * 100).to_i.to_s.concat("%")
  end
end
