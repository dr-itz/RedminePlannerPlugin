class ModPlanTasksDescr < ActiveRecord::Migration
  def change
    change_table :plan_tasks do |t|
      t.change     :description, :text
      t.timestamps
    end
  end
end
