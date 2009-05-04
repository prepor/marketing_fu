module MarketingFu::Referrers
  module Campaign
    include MarketingFu::Referrers::Base
    module ClassMethods
      def detect(options = {})
        if options[:params][:ref] && (campaign = self.find_by_name(options[:params][:ref]))
          campaign
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