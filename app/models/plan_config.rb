class PlanConfig < ActiveRecord::Base
  unloadable

  DEFAULT_CONFIG = {
    'workload_target'             => '100',
    'workload_threshold_ok'       =>  '80',
    'workload_threshold_overload' => '110',

    'graph_weeks'      => '8',
    'graph_weeks_past' => '1'
  }

  serialize :config, Hash
  belongs_to :project

  validates_uniqueness_of :project_id
  validates :project_id, :presence => true

  def self.project_config(project)
    project_id = project.is_a?(Project) ? project.id : project

    prj_config = self.find_by_project_id(project_id)
    unless prj_config
      prj_config = PlanConfig.new
      prj_config.project_id = project_id
      prj_config.config = DEFAULT_CONFIG
      prj_config.save
    else
      prj_config.config = prj_config.config.reverse_merge DEFAULT_CONFIG
    end
    prj_config
  end

  def [](name)
    self.config[name.to_s]
  end

  def []=(name, val)
    self.config[name.to_s] = val
  end

  def update_config(hash)
    self.config = self.config.merge(hash.with_indifferent_access)
    save
  end
end
