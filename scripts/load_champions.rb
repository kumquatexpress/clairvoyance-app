require_relative "constants"
require 'net/http'
require 'json'

def get_request_uri
    uri = API_URL + "/static-data/na/v1/champion?champData=all&api_key=" + API_KEY
    URI(uri)
end

def get_json
    dict = JSON.parse(Net::HTTP.get(get_request_uri()))
    keys = dict["keys"]
    for key in keys
        begin
            id = key[0]
            name = key[1]
            image = dict["data"][name]["image"]["sprite"]
        rescue
            #handle
        ensure
            champ = Champion.new(
                id: id,
                name: name,
                image: image)
            champ.save()
        end
    end
end