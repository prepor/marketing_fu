require 'searcher'

module MarketingFu
  module Controller
    def referral?
      =begin
        TODO :referral to options
      =end
      unless cookies[:referral] 
        cookies[:referral] = MarketingFu::Referrers.create_referral(:params => params)
      end
    end
  end
end