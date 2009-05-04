require 'searcher'
module MarketingFu::Referrers
  module Keyword
    include MarketingFu::Referrers::Base
    module ClassMethods
      def detect(options = {})
        if options[:referrer] && (se = Searcher.parse(options[:referrer]))
          self.find_or_create(se)
        else
          false
        end
      end
      def find_or_create(options)
        if (ref = self.find(:first, :conditions => {:se => options[:se], :name => options[:keywords]}))
          ref
        else
          self.create :se => options[:se], :name => options[:keywords]
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