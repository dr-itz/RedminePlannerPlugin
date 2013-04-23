class ModPlanTasksDescr < ActiveRecord::Migration
  def up
    change_table :plan_tasks do |t|
      t.change     :description, :text
      t.timestamps
    end
  end

  def down
    remove_column :plan_tasks, :created_at
    remove_column :plan_tasks, :updated_at
  end
end
