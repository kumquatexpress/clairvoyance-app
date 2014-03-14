class ChampionController < ApplicationController

    def name
        name = params[:name]
        champs = Champion.where(name: name)
        
        render json: champs
    end

    def compat
        champ1 = Champion.find(params[:id1])
        champ2 = Champion.find(params[:id2])

        render json: {compat: Compatibility.get_compatibility_number(champ1, champ2)}

    end

end
