module MarketingFu
  module Goal
    module ClassMethods
      def find_or_create(name)
        name = name.strip
        if (goal = self.find_by_name(name))
          goal
        else
          self.create :name => name
        end
      end
    end
    
    module InstanceMethods
      
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end