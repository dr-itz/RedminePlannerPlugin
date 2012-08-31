class CreatePlanGroups < ActiveRecord::Migration
  def change
    create_table :plan_groups do |t|
      t.integer :project_id,       :default => 0,     :null => false
      t.string  :name,                                :null => false

      t.integer :group_type,                          :null => false
      t.integer :leader_id
      t.integer :parent_group
    end

    add_index "plan_groups", ["project_id"], :name => "plan_groups_project_id"
  end
end
