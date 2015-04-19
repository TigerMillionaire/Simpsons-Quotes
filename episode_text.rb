class EpisodeText
  attr_accessor :text, :name, :season, :episode
  def initialize(text: text, name: name, season: season, episode: episode)
    @text = text
    @name = name
    @season = season
    @episode = episode
  end

  def regex_match(pattern)
    text.select {|line| line =~ /#{pattern}/ }
  end

  def case_insensitive_regex_match(pattern)
    text.select {|line| line =~ /#{pattern}/i }
  end
end
