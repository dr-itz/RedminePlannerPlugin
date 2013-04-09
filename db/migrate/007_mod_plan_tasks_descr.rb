class ModPlanTasksDescr < ActiveRecord::Migration
  def up
    change_table :plan_tasks do |t|
      t.change     :description, :text
      t.timestamps
    end
  end

  def down
    remove_column :created_at
    remove_column :updated_at
  end
end
