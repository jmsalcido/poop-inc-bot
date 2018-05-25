require_relative '../bathfinder'

RSpec.describe BathFinder, "#text" do
    context "find_bath" do
        it "should return the unavailable text correctly" do
            instance = BathFinder.new
            json = [{"mac"=>"18:FE:34:CB:06:1A", "date"=>"2018-02-23 18:02:26", "duration"=>"838:59:59", "name"=>"Planta baja", "batteries"=>"2.44", "status"=>"1"}]
            text = instance.find_bath(json, 1)
            expect(text).to eq(":toilet: *[UNAVAILABLE]* :negative_squared_cross_mark: - check https://goo.gl/AeZY49")
        end

        it "should return the available text correctly" do
            instance = BathFinder.new
            json = [{"mac"=>"18:FE:34:CB:06:1A", "date"=>"2018-02-23 18:02:26", "duration"=>"838:59:59", "name"=>"Planta baja", "batteries"=>"2.44", "status"=>"0"}]
            text = instance.find_bath(json, 1)
            expect(text).to eq(":toilet: *[AVAILABLE]* :white_check_mark:")
        end

        it "should return an invalid bathroom when the number is out of range" do
            instance = BathFinder.new            
            text = instance.find_bath([], 0)
            expect(text).to eq("sorry bato, could not found that bathroom, check with @c13m3n7 or @jmsalcido")
        end
    end
end