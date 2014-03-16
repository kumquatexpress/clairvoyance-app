class Compatibility < ActiveRecord::Base
    serialize :compat
    has_one :champion

    def self.init_new_champs
        Champion.all.each do |champ|
            if Compatibility.where(champion_id: champ.id).empty?
                c = Compatibility.new
                c.champion = champ
                c.save
            else
                next
            end
        end
    end

    def self.set_to_default
        champs = Champion.all.map{|x| x.id.to_i}
        Compatibility.all.each do |c|
            champs.each do |ch|
                if c.compat[ch]
                    next
                else
                    c.compat[ch] = {:c=>0.5,:n=>0}
                end
            end
            c.save
        end
    end

    def self.get_full_compat(champ1, champ2)
        Compatibility.find(champ1.compatibility_id).compat[champ2.id.to_i]
    end

    def self.get_compatibility_number(champ1, champ2)
        nums = Compatibility.get_full_compat(champ1, champ2)
        nums[:c].to_f/nums[:n]
    end

    def self.find_compat(name1, name2)
        Compatibility.get_compatibility_number(Champion.name_to_champ(name1),
            Champion.name_to_champ(name2))
    end

    def get_top_compat_champs count
        c = Champion.all.map{|x| x.id.to_i}
        Champion.all.zip(c.map{|x| get_compat x}).sort_by{|ch, com| com * -1}[0..count-1]
    end

    def self.get_teamcomp_compat(cid_list)
        total_compat = 1;

        cid_list.each_index do | index1 |
            indiv_compat = 1;
            cid1 = cid_list[index1]
            compat = Champion.find(cid1).return_full_compat
            cid_list.each_index do | index2 |
                if index1 != index2
                    cid2 = cid_list[index2]
                    indiv_compat *= compat.get_compat(cid2)
                end
            end
            indiv_compat **= (1.0/(cid_list.length-1))
            total_compat *= indiv_compat
        end
        total_compat ** (1.0/cid_list.length)
    end

    def get_compat champid
        nums = self.compat[champid]
        nums[:c].to_f/nums[:n]
    end

    def self.calculate_using_threads(start_, end_)
        t = []
        Compatibility.all[start_..end_].each do |c|
            t << Thread.new{
                c.find_compatibility
                }
        end
        t
    end

end
