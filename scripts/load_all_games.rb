require_relative "constants"
require_relative "load_games"
require 'net/http'
require 'json'

SLEEP = 1.2

def load!
    players = [Player.first.id]
    while players do
        p = players.shift
        players += get_json(p)
        sleep(SLEEP)
    end
end

def load_skipping count
    players = [Player.all[count].id]
    while players do
        p = players.shift
        players += get_json(p)
        sleep(SLEEP)
    end
end

def load_from_summoner id
    players = get_json(id)
    while players do
        p = players.shift
        players += get_json(p)
        sleep(SLEEP)
    end
end