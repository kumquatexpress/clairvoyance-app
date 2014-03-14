class MainController < ApplicationController

    def index
        @champs = Champion.all
        @compat = @champs.map{|x| Compatibility.find(x.compatibility_id)}
    end

end
