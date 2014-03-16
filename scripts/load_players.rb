require_relative "constants"
require 'net/http'
require 'json'

def get_request_uri_p pid
    uri = API_URL + "/na/v2.3/league/by-summoner/#{pid}/entry?api_key=" + DENNIS_API_KEY
    URI(uri)
end

def update_tier_one_player p
    begin
        dict = JSON.parse(Net::HTTP.get(get_request_uri_p(p.id)))
        p.tier = dict.first["tier"]
        p.save
    rescue
        print "No player found!"
        p.delete
    ensure
        sleep(1.2)
    end
end


def update_tier    
    Player.where(tier: "none").each do |p|
        update_tier_one_player p
    end
end
            
