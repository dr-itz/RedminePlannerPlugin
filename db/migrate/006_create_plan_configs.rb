class CreatePlanConfigs < ActiveRecord::Migration
  def change
    create_table :plan_configs do |t|
      t.integer :project_id,       :default => 0,     :null => false
      t.string  :config,                              :null => false
    end

    add_index "plan_configs", ["project_id"], :name => "plan_configs_project_id"
  end
end
