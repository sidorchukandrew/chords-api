class Subscription < ApplicationRecord
  belongs_to :team
  belongs_to :user

  def calendar_enabled?
    pro_plan?
  end

  def notes_enabled?
    pro_plan?
  end

  def files_enabled?
    pro_plan?
  end

  def pro_plan?
    stripe_price_id == ENV['PRO_PLAN_PRICE_ID']
  end

end
