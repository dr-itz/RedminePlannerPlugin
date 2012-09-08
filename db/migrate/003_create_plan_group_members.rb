class CreatePlanGroupMembers < ActiveRecord::Migration
  def change
    create_table :plan_group_members do |t|
      t.integer :plan_group_id,       :default => 0,     :null => false
      t.integer :user_id,             :default => 0,     :null => false
    end

    add_index "plan_group_members", ["plan_group_id"], :name => "plan_group_member_group"
    add_index "plan_group_members", ["user_id"], :name => "plan_group_member_user"
  end
end
