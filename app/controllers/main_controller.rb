require_relative './constants.rb'

class MainController < ApplicationController

    def index
        @champs = Champion.all.sort_by{|x| x.name}
        @compat = @champs.map{|x| Compatibility.find(x.compatibility_id)}
    end

    def riot
    
    end

    def get_live_match
        summoner = params[:name]
        returnstring = %x("#{RUNPATH} #{summoner}")

        render json: returnstring
    end
    # {"_blueteam":{"Kha\u0027Zix":121,"Rengar":107,"Fiora":114,"Ashe":22,"Zyra":143},"_purpleteam":{"Rengar":107,"Ashe":22,"Lulu":117,"Jarvan IV":59,"Karthus":30}}


end
