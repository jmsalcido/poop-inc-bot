require 'dotenv'
Dotenv.load

require "http"
require "json"
require "pry"

class BathFinder

    def initialize
        @floors = Hash.new
        @floors[1] = "Planta baja"
        @floors[2] = "Segundo piso"
        @floors[3] = "Tercer piso"
    end

    def is_valid(floor)
        [1,2,3].include? floor
    end

    def finding_text(floor)
        "trying to find bathroom in floor: *#{floor}* :toilet:"
    end

    def invalid_floor(floor)
        ":toilet: *#{floor}* is not valid bato."
    end

    def find_bath(json, floor)
        found = find_bath_in_response(json, floor)

        if found == nil
            text = not_found_text
        else
            if found["status"] == "0" # status = 0 // vacant.
                text = found_available_text
            else
                text = found_not_available_text
            end
        end

        text
    end

    private

    def find_bath_in_response(json, floor)
        json.find { |info| info["name"] == @floors[floor] }
    end

    def not_found_text
        "sorry bato, could not found that bathroom, check with @c13m3n7 or @jmsalcido"
    end

    def found_available_text
        ":toilet: *[AVAILABLE]* :white_check_mark:"
    end

    def found_not_available_text
        ":toilet: *[UNAVAILABLE]* :negative_squared_cross_mark: - check https://goo.gl/AeZY49"
    end

end