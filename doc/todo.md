# Planned Features / TODO

Planner is a plugin in it's early stages. A lot of the planned features are not
yet implemented. This list gives a rough overview of what's planned.


## Improve resource request planning

Resource request planning should display a warning when the free capacities are
exceeded on a weekly basis to lower the effort of team leaders.

HIGH PRIO.


## Better task management

The current task management is only very basic. It will be extended with search
functionalities, sorting, etc.  Tasks should have a property "category" to
classify them a bit.

HIGH PRIO.


## Weekly view

Currently it's possible to specify on which week days a task should/can be
executed. This is the first step towards planning of part time workers, holiday
planning and absences. Visualize it.

MEDIUM PRIO.


## Hierarchical tasks

An idea is to have a hierarchy in tasks to ease the planning of project from
coarse to fine and view the workload on different levels.

LOW PRIO.


## Planning of part-time workers

Part time workers can be planned with their work time less than 100%.

MEDIUM PRIO.


# Holiday planning

People should be able to plan their holidays within Planner.

HIGH PRIO.


# Unplanned absences

Unplanned absences like sickness affects projects. Planner should allow a team
leader to enter these unplanned absences to display and notify resource
requesters of problems in their projects.

MEDIUM PRIO.


# Bank holidays

There should be an interface to somehow load bank holidays into Planner.

LOW PRIO.


## On-call planning

Planner will implement the planning of on-call duty. This will include multiple
on-call plans with different configuration:

* Configurable weekdays
* Required number of people on call for one day
* Planning of different shifts
* Include or exclude bank holidays

Planner will give an overview what is already planned, where planning is lacking
and where more people than required are planned.

HIGH PRIO.


## Planning of the target workload for tasks

For project leaders, it should be possible to plan the target workload of tasks
before requesting resources. A chart will show target vs actual planning for a
task.

MEDIUM PRIO.


## D3.js

Switch the charts to a solution based on d3.js.

VERY LOW PRIO.
