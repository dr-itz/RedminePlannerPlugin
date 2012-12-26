# Getting started

This section describes the steps necessary to start using Planner.


## Installation

First of all Redmine needs to be up and running with Planner installed. The
installation procedure is described in detail in README.md.


## Planner and Redmine projects

Planner is implemented as project module in Redmine. Resource planning is
something that is not specific to a single project, but has a larger scope. The
reason Planner is a project module is simple. It allows fine grained access
control and makes it possible to use it for different departments that have no
direct connection.

The basic idea is to set up "resource planning" projects in Redmine. This
projects are only meant for resource planning, nothing else. Such a project only
has the "Planner" module and perhaps the "Wiki" module activated, everything
else is disabled. The Wiki can contain instructions on how to use Planner, how
to name tasks, use descriptions etc.


## Setting up Roles

Planner defines different permissions:

  * **View Resource Plan**

	This permissions allows viewing of the resource planning. It is required for
	anyone who should be able to view things. It must be set for all roles that
	allow interaction with Planner.

  * **Create Requests**

	Anyone with this permission is allowed to create resource requests.

  * **Create Tasks**

	This permission allows users to create Tasks. Typically, not everyone
	allowed to create resource requests should be allowed to create tasks to
	avoid a mess with too many tasks.

  * **Administer Resource Plan**

	This permission is for the planner administrator and includes all
	permissions. Unlike any other permissions, this allows creating teams and
	groups. Once a team or groups is created, the "leader" of the team can
	manage the members.


These permissions need to be mapped to roles first. A good start might be to
define roles like this:

  * **Planner Admin**

	This role is for the administrator that needs to be able to create teams and
	groups and includes the permission *Administer Resource Plan*.

  * **Planner Manager**

	This role is for project managers and team leaders. It includes the
	permissions *View Resource Plan*, *Create Tasks*, *Create Requests*.

  * **Planner User**

	This role is meant for all the team members. It allows creating resource
	requests for existing tasks. Permissions: *View Resource Plan*, *Create Requests*.

  * **Planner Viewer**

	This is meant for people that are not part of the teams but are allowed to
	view the current planning. It includes only the role *View Resource Plan*.


## Setting up a resource Planning project

Once the roles are set up, it's time to define a resource planning project. For
this just create a normal Redmine project and enable the Planner module and
maybe the Wiki module, disable everything else.

Once the project is created, users have to be added. Add all the users in the
department and give them one of the roles defined above.


## Creating the teams and groups

For the resource requests to work, each person that can be planned as a resource
needs to be assigned to a team with a team leader that approves or denies
resource requests.

Select "Teams and Groups" in the "Resource Planner" tab of the previously
defined Redmine project. Create the teams with the team leader and assign
members to them.

Once teams are defined, groups can be defined too. If a group has a "leader"
assigned, it's possible for this person to manage the members of the group.

![Group management](https://github.com/dr-itz/RedminePlannerPlugin/raw/master/doc/img/scr-planner-groups.png)
![Edit group members](https://github.com/dr-itz/RedminePlannerPlugin/raw/master/doc/img/scr-planner-group-edit.png)


## Create some tasks

Before any resource request can be made, at least one task needs to be defined.
Defining tasks is easily achieved under "Tasks" in the resource planner. A task
also has an owner. The owner can close a task which means it can no longer be
used in new resource requests. This allows project leaders to control the tasks
belonging to their projects.

![Task management](https://github.com/dr-itz/RedminePlannerPlugin/raw/master/doc/img/scr-planner-tasks.png)


## Make a first resource request

With everything set up, it's possible to create a first resource requests.
Creating a request can be done in "Resource requests" using the "New Resource
Request" link. The first step is to define which person (the resource) and which
task.

Once the request is created, it needs some planning. Planning is done on a
weekly basic in workload. Planning can be created using the form, deleted using
the delete links. To change existing planning, just enter new values in the form
to overwrite the existing entries.

Once the planning is complete, the request can be "Sent" to the approver by
using the "Send request" form in top right part of the planning. The approver
and the resource should get notified by email about the request.

![A resource request](https://github.com/dr-itz/RedminePlannerPlugin/raw/master/doc/img/scr-planner-resource-request.png)

## Tweak the visualization

The generated charts can be tweaked. Planner has some settings in the project
configuration. Within a planning project, select "Settings -> Resource Planner".

![Planner settings](https://github.com/dr-itz/RedminePlannerPlugin/raw/master/doc/img/scr-planner-settings.png)
