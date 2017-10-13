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

    floors = Hash.new
    floors[1] = "Planta baja"
    floors[2] = "Segundo piso"
    floors[3] = "Tercer piso"

    match(/floor\s*(?<floor>\d*)/i) do |client, data, match|
        floor = match[:floor].to_i

        text = "trying to find bathroom in floor: *#{floor}* :toilet:"

        if [1,2,3].include? floor
            client.say(text: text, channel: data.channel)

            poop = HTTP.get("http://twcc.fr/poop/api/")
            availability = JSON.parse(poop.body.to_s)

            found = availability.find { |info| info["name"] == floors[floor] }

            if found == nil
                text = "sorry bato, could not found that bathroom, check with @c13m3n7 or @jmsalcido"
            else
                if found["status"] == "0" # status = 0 // vacant.
                    text = ":toilet: *[AVAILABLE]* :white_check_mark:"
                else
                    text = ":toilet: *[UNAVAILABLE]* :negative_squared_cross_mark: - check https://goo.gl/AeZY49"
                end
            end
        else
            text = ":toilet: *#{floor}* is not valid bato."
        end

        client.say(text: text, channel: data.channel)
    end

end


PoopBot.run
