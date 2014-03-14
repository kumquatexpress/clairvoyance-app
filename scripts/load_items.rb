require_relative "constants"
require 'net/http'
require 'json'

def get_request_uri
    uri = API_URL + "/static-data/na/v1/item?itemListData=all&api_key=" + API_KEY
    URI(uri)
end

def get_json
    dict = JSON.parse(Net::HTTP.get(get_request_uri()))
    data = dict["data"]
    data.each do |k, v|
        begin
            id = k
            name = v["name"]
            image = v["image"]["sprite"]
        rescue
            #handle
        ensure
            item = Item.new(
                id: id,
                name: name,
                image: image)
            item.save()
        end
    end
end