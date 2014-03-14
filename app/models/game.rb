class Game < ActiveRecord::Base
    has_and_belongs_to_many :items
    has_and_belongs_to_many :champions
    has_and_belongs_to_many :team_comps
    has_and_belongs_to_many :players

    self.primary_key = 'id'

    def process_game
        if self.processed
            return
        end
        tc1, tc2 = self.team_comps
        blue_ids = [tc1.c1, tc1.c2, tc1.c3, tc1.c4, tc1.c5]
        purple_ids = [tc2.c1, tc2.c2, tc2.c3, tc2.c4, tc2.c5]
        blue_champs = blue_ids.map{|x| Champion.find(x)}
        purple_champs = purple_ids.map{|x| Champion.find(x)}

        winners = self.win == 0 ? blue_champs : purple_champs
        losers = self.win == 0 ? purple_champs : blue_champs

        winners.each do |winner|
            compat1 = Compatibility.find(winner.compatibility_id)
            winners.each do |w2|
                compat2 = Compatibility.find(w2.compatibility_id)
                cid = w2.id.to_i
                compat1.compat[cid][:c] += 1
                compat1.compat[cid][:n] += 1
            end
            compat1.save
        end

        losers.each do |loser|
            compat1 = Compatibility.find(loser.compatibility_id)
            losers.each do |l2|
                compat2 = Compatibility.find(l2.compatibility_id)
                cid = l2.id.to_i
                compat1.compat[cid][:c] += 0
                compat1.compat[cid][:n] += 1
            end
            compat1.save
        end
        self.update(processed: true)
        self.save
    end

    def self.process_all_new_games
        count = 0
        Game.where(processed: false).each do |g|
            g.process_game
            count += 1
        end
        count
    end

    def self.process_in_reverse
        count = 0
        Game.where(processed: false).reverse.each do |g|
            g.process_game
            count += 1
        end
        count        
    end

end
