class AddSenderToInvitation < ActiveRecord::Migration[6.1]
  def change
    add_reference(:invitations, :user)
  end
end
