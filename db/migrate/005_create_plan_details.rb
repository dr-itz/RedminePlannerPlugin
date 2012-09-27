class CreatePlanDetails < ActiveRecord::Migration
  def change
    create_table :plan_details do |t|
      t.integer   :request_id,       :default => 0,     :null => false
      t.integer   :year,                                :null => false
      t.integer   :week,                                :null => false
      t.integer   :percentage,       :default => 0,     :null => false
      t.boolean   :ok_mon,           :default => true,  :null => false
      t.boolean   :ok_tue,           :default => true,  :null => false
      t.boolean   :ok_wed,           :default => true,  :null => false
      t.boolean   :ok_thu,           :default => true,  :null => false
      t.boolean   :ok_fri,           :default => true,  :null => false
      t.boolean   :ok_sat,           :default => false, :null => false
      t.boolean   :ok_sun,           :default => false, :null => false
    end

    add_index "plan_details", ["request_id"],   :name => "plan_details_request_id"
    add_index "plan_details", ["year"],         :name => "plan_details_year"
    add_index "plan_details", ["week"],         :name => "plan_details_week"
  end
end
