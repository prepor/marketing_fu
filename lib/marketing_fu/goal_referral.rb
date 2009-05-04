module MarketingFu
  module GoalReferral
    def self.included(receiver)
      receiver.extend ClassMethods
      receiver.send :include, InstanceMethods
      receiver.class_eval do
        belongs_to :referral
        belongs_to :goal
        validates_uniqueness_of :referral_id, :scope => :goal_id
      end
    end
    module ClassMethods

    end

    module InstanceMethods

    end
  end
end