require 'nokogiri'
require 'open-uri'
TRANSCRIPTS_URL = 'http://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=the-simpsons&episode='


def get_episode(season_index, episode_index)
  this_url = TRANSCRIPTS_URL +
    "s#{season_index.to_s.rjust(2, "0")}e#{episode_index.to_s.rjust(2, "0")}"
  episode_transcript = Nokogiri::HTML(open(this_url)) rescue nil
  return unless episode_transcript
  text = episode_transcript.css(".scrolling-script-container").children.map(&:text)
  text_array = text.
    join.
    encode('UTF-8', :invalid => :replace, :undef => :replace).
    gsub(/\r|\t|\n/,''). #removing garbage
    scan(/[^\.!?]+[\.!?]/) #splitting based on sentence final punctuation
  episode_name = episode_transcript.search('h3').map(&:text)[1].split("-")[1].strip
  { text: text_array, name: episode_name, season: season_index, episode: episode_index }
end
###Made the dump file with command File.open('/home/lizzy/play/Simpsons-Quotes/episodeHash.dmp', "w+") {|file| file.write(Marshal.dump(season_guide))} ###

###Reopen file with Marshal.load(File.open('/home/lizzy/play/Simpsons-Quotes/episodeHash.dmp', "r").read) ###

season_guide = []
(1..26).each do |season_index|
  episode_index = 1
  while (episode = get_episode(season_index, episode_index))
    season_guide << episode
    episode_index += 1
  end
end
