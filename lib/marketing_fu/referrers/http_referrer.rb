module MarketingFu::Referrers
  module HttpReferrer
    include MarketingFu::Referrers::Base
    module ClassMethods
      def detect(options = {})
        if options[:referrer]
          self.find_or_create(options[:referrer])
        else
          false
        end
      end
      
      def find_or_create(string)
        string = string.strip
        if (ref = self.find_by_url(string))
          ref
        else
          self.create :url => string
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