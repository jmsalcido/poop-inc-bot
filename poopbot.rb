require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'

require 'celluloid'
Celluloid.logger = nil

require "http"
require "json"
require "pry"
require "./bathfinder"

# cl3m3n7
# status: 0 // = vacant
# status: 1 // = engaged

class PoopBot < SlackRubyBot::Bot

    finder = BathFinder.new

    match(/floor\s*(?<floor>\d*)/i) do |client, data, match|
        floor = match[:floor].to_i

        text = finder.finding_text(floor)

        if finder.is_valid(floor)
            client.say(text: text, channel: data.channel)

            request = HTTP.follow.get(ENV['POOP_INC_URL'])
            json = JSON.parse(request.body.to_s)
            text = finder.find_bath(json, floor)
        else
            text = finder.invalid_floor(floor)
        end

        client.say(text: text, channel: data.channel)
    end

end


PoopBot.run
