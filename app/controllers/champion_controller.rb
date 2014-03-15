class ChampionController < ApplicationController

    def name
        name = params[:name]
        champs = Champion.where(name: name)
        
        render json: champs
    end

    def compat
        champ1 = Champion.find(params[:id1])
        champ2 = Champion.find(params[:id2])
        nums = Compatibility.get_full_compat(champ1, champ2)
        compat_number = nums[:c].to_f/nums[:n]

        render json: {:c1=> champ1.name, :c2 => champ2.name, :num_games => nums[:n], :wins => nums[:c], :compat => compat_number}

    end

    def by_id
        id = params[:id]
        champ = Champion.find(id)
        render json: champ
    end

    def find_compat_team_comp
        cid_list = params[:cids].split(",").map{|x| x.to_i}
        render json: { :compat => Compatibility.get_teamcomp_compat(cid_list) }
    end

end
