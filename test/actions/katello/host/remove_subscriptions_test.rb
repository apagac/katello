require 'katello_test_helper'

module Katello::Host
  class AttachSubscriptionsTest < ActiveSupport::TestCase
    include Dynflow::Testing
    include Support::Actions::Fixtures
    include FactoryGirl::Syntax::Methods

    before :all do
      User.current = users(:admin)
      @host = FactoryGirl.create(:host, :with_subscription)
    end

    describe 'auto attach subscriptions' do
      let(:action_class) { ::Actions::Katello::Host::RemoveSubscriptions }

      it 'plans' do
        action = create_action action_class
        action.expects(:action_subject).with(@host)

        entitlements = [{'id' => 3}, {'id' => 4}]

        plan_action action, @host, entitlements

        assert_action_planed_with action, Actions::Candlepin::Consumer::RemoveSubscription, :uuid => @host.subscription_facet.uuid,
                                  :entitlement_id => 3
        assert_action_planed_with action, Actions::Candlepin::Consumer::RemoveSubscription, :uuid => @host.subscription_facet.uuid,
                                          :entitlement_id => 4
      end
    end
  end
end
