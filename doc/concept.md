# Concept and ideas behind Planner

Planner is designed to solve the problem of resource planning, mainly in
companies with matrix organization.

## Problems, needs

People with different roles in a company have very different use cases and need
different views to data. This section describes possible roles and use cases.

  *  **Team leader**

	Team leaders are interested in the work load of their teams. Overload should
	be avoided, free capacities used efficiently. It is important for them to
	know who does what, for which project, etc. For effective planning of their
	resources they need to be informed about project changes, needs from sales,
	etc.

  * **Project leaders**

	Project leaders need efficient control of their project. They need to know
	where to find free capacities in a certain area of expertise. Team
	membership is not so important. Also, a project leader needs to know the
	planned load on project specific tasks, also to compare it with reported
	hours later. In case of resource conflicts an efficient solution with the
	team leaders is desirable for which skill based views are important. Also,
	once they have their planning approved from the team leaders they need to be
	sure no one changes the planning without their knowledge.

  * **Team members**

	Team members, the people doing the planned work, need to have an overview of
	what they're planned to do. This is even more important if a person is
	involved in more than one project. For some tasks, help of people of
	different skills is required. For this to work, a team member needs to know
	free capacities based on skills or products or whatever. To save the
	overhead of asking additional resources via a project leader which in turn
	has to approve from a team leader, a direct request should be possible. Team
	members need to be informed when they are requested.

  * **Sales**

	Sales need, similar to project leaders, an overview of free capacities based
	on skills or product knowledge, etc. This is important one one side to work
	out good offers that actually work and on the other hand it's important to
	agree on delivery dates and what's possible to promise a customer and
	actually meet deadlines.


## Terms

### Task

A task is basically work to do. This can be general stuff or specific to a
project. For project specific tasks, a WBS number can be specified so the people
know where to report hours to.


### Resource request

A resource request assigns a task to a person and adds the planning for it. The
planning is specified in weekly workload in percent. This is intentionally kept
fuzzy.

A resource request can be made by anyone who needs somebody else to do work.
It also requires the permission to create a resource request.


### Team

A teams is part of a reporting hierarchy. It consists of members and a team
leader. Each user that can be requested as a resource needs to be in exactly one
team (for now). The team leader is the person that is responsible for the
planning of his team and needs to approve resource requests.


### Group

A group is similar to a team but serves a different purpose. It consists of a
list of members. It can have a leader, but this information is for displaying
purposes only. Groups allow the grouping of people regardless in which team they
are. This is for example useful for grouping people by product knowledge, by
customer, by skills or whatever makes sense. Each person can be member of any
number of groups.


## Work flow

The basic work flow is very simple. Resources need to be requested, each request
is then checked by the team leader of the requested person. After checking, the
request is either approved or denied. To always keep all the people involved up
to date, email notifications are sent by the system.

Resource requests have different states and a work flow. Initially, in the state
'New' it allows the requester to plan the workload. Once the planning is done,
the request needs to be sent to the team leader of the requester resource
(person) for approval. This state is called 'Ready'. The team leader then has to
review the request and either 'Approve' it or 'Deny' it.


## Main page

The main page consists of three areas:

  * **Teams**

	Shows all teams. When the header of a team is clicked, outside of the name,
	it expands and shows the members of the team. Each link shows a workload
	chart.

  * **Groups**

	The same thing as the team view, but for groups

  * **Manage**

	Allows managing everything. Tasks, Resource requests, teams and groups. The
	actual possibilities depend of the permissions of the user.


## Resource requests

The resource requests page is divided in three areas:

  * **My open requests**

	Shows all open resource requests, that is not approved, that are created by
	the user logged in. This category only shows if there are any open request.

  * **My open approvals**

	Shows a list of resource requests that need approval by the user logged in.
	So category is for team leaders to approve or deny requests. This category
	again only shows if there are requests to approve or deny.

  * **Open resource requests for me**

	Shows a list of open resource requests, again not showing the approved ones,
	for where the current user is the requested resource.

Resource requests can be created, viewed, edited here. Planning is possible as
long as request is still in the status new.


## Charts

The different needs of various people require different views to the data.
Planner visualizes workload in charts. These charts are supported:

  * **Person view**

	Shows the workload of a single person over the specified amount of weeks.
	Each resource request within the displayed range is visible.

  * **Team view**

	Shows the workload of team with all members. The workload of the individual
	members is shows as total, without showing the resource request.

  * **Group view**

	Exactly the same as the team view, but for groups (which are internally the
	same thing except for one flag)

  * **Task view**

	Shows the weekly booking of a task. Shows each resource request for a task
	in the specified range.
