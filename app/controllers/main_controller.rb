class MainController < ApplicationController

    def index
        @champs = Champion.all.sort_by{|x| x.name}
        @compat = @champs.map{|x| Compatibility.find(x.compatibility_id)}
    end

end
