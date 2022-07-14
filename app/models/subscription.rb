class Subscription < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true
  
  def calendar_enabled?
    pro_plan?
  end

  def notes_enabled?
    pro_plan?
  end

  def files_enabled?
    pro_plan?
  end

  def tracks_enabled?
    pro_plan?
  end

  def sessions_enabled?
    pro_plan?
  end

  def pro_plan?
    stripe_price_id == ENV['PRO_PLAN_PRICE_ID']
  end

  def billing_managers
    manage_billing = Permission.find_by_name("Manage billing")
    roles_with_manage_billing = team.roles.filter { |role| manage_billing.in?(role.permissions) }
    managers = []
    roles_with_manage_billing.each do |role|
      role.memberships.each do |membership|
        managers << membership.user
      end
    end

    managers
  end

end
