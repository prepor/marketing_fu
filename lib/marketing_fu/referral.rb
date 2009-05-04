module MarketingFu::Referral
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
    receiver.class_eval do
      belongs_to :referrer, :polymorphic => true
      belongs_to :user
      has_many :goal_referrals
      has_many :goals, :through => :goal_referrals
    end
  end
  module ClassMethods
    def create_from_env(options = {})
      referral = ::Referral.new
      referral.choose_referrer(options)
      referral.save
      referral
    end
  end
  
  module InstanceMethods
    def choose_referrer(options)      
      self.referrer = detect_referrer(options)
    end
    
    def detect_referrer(options)
      for referrer_type in MarketingFu::Referrers::List
        if (res = referrer_type.constantize.detect(options))
          return res
        end
      end
      nil
    end
    
    def reach_goal(name)
      if (goal = ::Goal.find_or_create(name)) && !goal_referrals.find_by_goal_id(goal.id)
        goal_referrals.create :goal_id => goal.id
      else
        nil
      end
    end
    
    def reach_goal?(name)
      if (goal = ::Goal.find_by_name(name)) && goal_referrals.find_by_goal_id(goal.id)
        true
      else
        false
      end
    end
  end
  
  
  


end