require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'

require 'celluloid'
Celluloid.logger = nil

require "http"
require "json"
require "pry"

# cl3m3n7
# status: 0 // = vacant
# status: 1 // = engaged

class PoopBot < SlackRubyBot::Bot

    match(/floor\s*(?<floor>\d*)/i) do |client, data, match|
        finder = BathFinder
        floor = match[:floor].to_i

        text = finder.finding_text(floor)

        if finder.is_valid(floor)
            client.say(text: text, channel: data.channel)

            text = finder.find_bath(floor)
        else
            text = finder.invalid_floor(floor)
        end

        client.say(text: text, channel: data.channel)
    end

end


PoopBot.run
