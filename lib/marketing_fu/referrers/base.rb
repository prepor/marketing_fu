module MarketingFu::Referrers
  List = %w{Campaign User Keyword HttpReferrer}
  # options[:params]
  module Base
    def self.base_included(receiver)
      receiver.extend ClassMethods
      receiver.class_eval do
        has_many :referrals, :as => :referrer
      end
    end
    module ClassMethods
      def top_referrers(number = 10)
        top_ids = ::GoalReferral.count(:include => [:referral], :conditions => ['referrals.referrer_type = ?', self.name], :group => 'referrals.referrer_id', :order => 'count_all DESC', :limit => 15)
        self.find(top_ids.keys).map {|v| [top_ids[v.id.to_s], v]}
      end
    end
    
    module InstanceMethods
      def goal_count(name = nil)
        if name.nil?
          referrals.count(:include => :goal_referrals)
        elsif (goal = ::Goal.find_by_name(name))
          referrals.count(:include => :goal_referrals, :conditions => {'goal_referrals.goal_id' => goal.id})
        else
          nil
        end
      end  

      def goal_counts
        counts = referrals.count(:include => :goal_referrals, :group => 'goal_referrals.goal_id')
        goals = ::Goal.find(counts.keys).index_by {|v| v.id}
        res = {}
        counts.each {|k, v| res[goals[k.to_i].name] = v}   
        res
      end
      
      def referrer_stats(options = {})
        stats = {}
        stats[:goals] = goal_counts
        stats[:referrals_count] = referrals.count
        stats[:counters] = if options[:counters]
          options[:counters].map {|v| [v, referrals.sum(v)]}
        else
          nil
        end
        stats
      end
      

    end
    
    def self.included(receiver)
      
      receiver.send :include, InstanceMethods
    end
  end

end