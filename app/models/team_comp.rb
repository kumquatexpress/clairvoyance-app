class TeamComp < ActiveRecord::Base
    has_and_belongs_to_many :games

    self.primary_key = 'id'

    def self.find_all_comps_with champ
        if champ.class == String
            champ = Champion.name_to_champ(champ)
        end
        if champ.class == Fixnum
            cid = champ
        else
            cid = champ.id
        end
        TeamComp.where("c1 = ? or c2 = ? or c3 = ? or c4 = ? or c5 = ?",
            cid, cid, cid, cid, cid)
    end

end
