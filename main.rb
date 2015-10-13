require './episode_text'
require 'sinatra'
require 'levenshtein'

episodes = Marshal.load(File.open("#{File.expand_path(".")}/episode_dump.dmp", "r").read)



get '/' do
  if params.empty?
    haml(:index)
  else
    redirect to("/search?#{request.query_string}")
  end
end
get "/search" do
  quote_to_match = params["input"]
  episode = episodes.find { |episode| ! episode.case_insensitive_regex_match(quote_to_match).empty? }
  quote = episode.case_insensitive_regex_match(quote_to_match).first
  index = episode.text.index(quote)
  quote = episode.text[index - 2] + ' ' + episode.text[index - 1] + ' ' + quote
  quote = quote.gsub(/"/, '')
  haml(:search,  locals: { episode: episode, quote: quote })
end
