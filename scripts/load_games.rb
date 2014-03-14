require_relative "constants"
require 'net/http'
require 'json'

BLUEID = 100
PURPLEID = 200

def get_request_uri(player, key)
    uri = API_URL + "/na/v1.3/game/by-summoner/#{player}/recent?api_key=" + key
    URI(uri)
end

def get_json(player, key=API_KEY)
    dict = {}
    begin
        dict = JSON.parse(Net::HTTP.get(get_request_uri(player, key)))
    rescue
        return []
    end
    data = dict["games"]
    players_returned_total = []

    data.each do |game|
        players_returned = []
        bluePlayers = []
        purplePlayers = []
        begin
            id = game["gameId"]
            type = game["gameMode"]
            if game["teamId"] == BLUEID
                bluePlayers << game["championId"]
                win = game["stats"]["win"] ? 0 : 1
            else
                purplePlayers << game["championId"]
                win = game["stats"]["win"] ? 1 : 0
            end

            game["fellowPlayers"].each do |player|
                if player["teamId"] == BLUEID
                    bluePlayers << player["championId"]
                else
                    purplePlayers << player["championId"]
                end

                begin
                    player_id = player["summonerId"]
                    p = Player.find_or_create_by(
                        id: player_id)
                    players_returned << player_id
                rescue
                    print "Duplicate Player!"
                end
            end        
        rescue
            #handle
        ensure
            bluePlayers.sort!
            purplePlayers.sort!
            blueString = bluePlayers.map{|x| x.to_s}.reduce{|x,y| x + y}
            purpleString = purplePlayers.map{|x| x.to_s}.reduce{|x,y| x + y}

            if bluePlayers.length == 5 and purplePlayers.length == 5
                begin
                    tc1 = TeamComp.create(
                        c1: bluePlayers[0],
                        c2: bluePlayers[1],
                        c3: bluePlayers[2],
                        c4: bluePlayers[3],
                        c5: bluePlayers[4],
                        id: blueString)
                rescue
                    print "Duplicate TeamComp!"
                end
                begin
                    tc2 = TeamComp.create(
                        c1: purplePlayers[0],
                        c2: purplePlayers[1],
                        c3: purplePlayers[2],
                        c4: purplePlayers[3],
                        c5: purplePlayers[4],
                        id: purpleString)
                rescue
                    print "Duplicate TeamComp!"
                end
                begin
                    g = Game.new(
                        id: id,
                        win: win)
                    g.team_comps = [tc1,tc2]
                    g.players = players_returned
                    g.save
                rescue
                    print "Duplicate Game!"
                end
            end
            players_returned_total.concat(players_returned)
        end
    end

    players_returned_total

end