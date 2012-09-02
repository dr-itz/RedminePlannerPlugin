class CreatePlanTasks < ActiveRecord::Migration
  def change
    create_table :plan_tasks do |t|
      t.integer :project_id,       :default => 0,     :null => false
      t.string  :name,                                :null => false
      t.boolean :is_open,          :default => true,  :null => false
      t.integer :task_type,        :default => 0,     :null => false
      t.integer :owner_id,         :default => 0,     :null => false
      t.string  :description
      t.string  :wbs
      t.integer :parent_task
    end

    add_index "plan_tasks", ["project_id"], :name => "plan_tasks_project_id"
    add_index "plan_tasks", ["owner_id"], :name => "plan_tasks_owner_id"
  end
end
