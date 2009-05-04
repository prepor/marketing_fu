module MarketingFu::Referrers
  module User
    include MarketingFu::Referrers::Base
    module ClassMethods
      def detect(options = {})
        if options[:params][:uref] && (referrer = self.find_by_login(options[:params][:uref]))
          referrer
        else
          false
        end
      end
    end
    
    module InstanceMethods
      
    end
    
    def self.included(receiver)
      MarketingFu::Referrers::Base.base_included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end