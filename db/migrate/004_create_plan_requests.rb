class CreatePlanRequests < ActiveRecord::Migration
  def change
    create_table :plan_requests do |t|
      t.integer   :requester_id,     :default => 0,     :null => false
      t.integer   :resource_id ,     :default => 0,     :null => false
      t.integer   :approver_id ,     :default => 0
      t.integer   :task_id,          :default => 0,     :null => false
      t.integer   :req_type,         :default => 0,     :null => false
      t.integer   :priority,         :default => 3,     :null => false
      t.text      :description
      t.integer   :status,           :default => 0,     :null => false
      t.timestamp :requested_on
      t.timestamp :approved_on
      t.text      :approver_notes
    end

    add_index "plan_requests", ["resource_id"],  :name => "plan_requests_resource_id"
    add_index "plan_requests", ["requester_id"], :name => "plan_requests_requester_id"
    add_index "plan_requests", ["approver_id"],  :name => "plan_requests_approver_id"
    add_index "plan_requests", ["task_id"],      :name => "plan_requests_task_id"
  end
end
