class Item < ActiveRecord::Base
    validates :id, presence: true
    self.primary_key = 'id'    
end
