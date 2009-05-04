require 'rubygems'
require 'test/unit'
gem 'thoughtbot-shoulda'
require 'shoulda'


require 'active_record'
require 'active_support'
require 'action_controller'

require 'marketing_fu'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])


def rebuild_models
  ActiveRecord::Base.connection.create_table :keywords, :force => true do |t|
    t.column :name, :string
    t.column :se, :string
  end
  ActiveRecord::Base.connection.create_table :http_referrers, :force => true do |t|
    t.column :url, :string
  end
  
  ActiveRecord::Base.connection.create_table :campaigns, :force => true do |t|
    t.column :name, :string
  end
  
  ActiveRecord::Base.connection.create_table :referrals, :force => true do |t|
    t.column :referrer_id, :integer
    t.column :referrer_type, :string
    t.column :user_id, :integer
    t.column :posts_counter, :integer, :default => 0
  end
  
  ActiveRecord::Base.connection.create_table :goals, :force => true do |t|
    t.column :name, :string
    t.column :title, :string
    t.column :referrer_type, :string    
    t.column :posts_counter, :integer
  end
  
  ActiveRecord::Base.connection.create_table :goal_referrals, :force => true do |t|
    t.column :goal_id, :integer
    t.column :referral_id, :integer
  end
  
  ActiveRecord::Base.connection.create_table :redirects, :force => true do |t|
    t.column :url, :string
    t.column :name, :string
  end
  ActiveRecord::Base.connection.create_table :users, :force => true do |t|
    t.column :name, :string
    t.column :login, :string
  end
  rebuild_classes
end

def rebuild_classes
  # ActiveRecord::Base.send(:include, YAACL::Model)

  rebuild_class("Keyword") do
    include MarketingFu::Referrers::Keyword
  end
  rebuild_class("HttpReferrer") do
    include MarketingFu::Referrers::HttpReferrer
  end
  rebuild_class("Campaign") do
    include MarketingFu::Referrers::Campaign
  end

  rebuild_class("Redirect") do
    include MarketingFu::Redirect
  end
  
  rebuild_class("User") do
    include MarketingFu::User
    include MarketingFu::Referrers::User
  end
  
  rebuild_class("Referral") do
    include MarketingFu::Referral
  end
  
  rebuild_class("Goal") do
    include MarketingFu::Goal
  end
  
  rebuild_class("GoalReferral") do
    include MarketingFu::GoalReferral
  end

end

def rebuild_class(name, &block)
  Object.send(:remove_const, name) rescue nil
  Object.const_set(name, Class.new(ActiveRecord::Base))
  name.constantize.class_eval(&block)
end


