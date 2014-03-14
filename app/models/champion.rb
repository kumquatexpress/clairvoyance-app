class Champion < ActiveRecord::Base
    validates :id, presence: true
    self.primary_key = 'id'

    def self.name_to_champ(name)
        cs = Champion.where(name: name)
        if cs then cs[0] else nil end
    end

    def get_compat(id)
        comid = self.compatibility_id

        Compatibility.find(comid).compat[id.to_i]
    end

    def get_self_compat
        get_compat(self.id)
    end

end
