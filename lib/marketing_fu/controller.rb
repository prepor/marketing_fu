module MarketingFu
  module Controller
    module ClassMethods
      
    end
    module InstanceMethods
      def set_referral
        if set_referral?
          if !cookies[:referral_id]
            self.referral = create_referral_from_env
            cookies[:referral_id] = referral.id
          elsif cookies[:referral_id] && (ref = ::Referral.find_by_id(cookies[:referral_id]))
            self.referral = ref
          else
            self.referral = create_referral_from_env
            cookies[:referral_id] = referral.id
          end
        end
      end
      
      def create_referral_from_env
        ::Referral.create_from_env(:params => params, :referrer => request.headers["HTTP_REFERER"])
      end
      
      def set_referral?
        true
      end
    end
    
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.class_eval do
        attr_accessor :referral
      end
    end
    
  end
end