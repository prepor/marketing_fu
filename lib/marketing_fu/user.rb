module MarketingFu
  module User
    module ClassMethods
      
    end
    
    module InstanceMethods
      def create_with_referral(referral)
        referral.user_id = self.id
        referral.save
      end
      
      def auth_with_referral(referral)
        if referral.user_id != self.id
          referral.destroy
        end
      end
      
      def for_referrer(&block)
        if self.referral.referrer.is_a? User
          block.call(self.referral.referrer)
        else
          nil
        end
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.class_eval do
        has_one :referral
        belongs_to :user
      end
    end
  end
end