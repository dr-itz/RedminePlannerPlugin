# Redmine Planner Plugin

Thanks to dr-itz & planio-gmbh for their contributions!

A Redmine plugin for resource planning with a request/confirm scheme.

This software is licensed under the terms of the GNU General Public License (GPL) v2.
See COPYRIGHT and COPYING for details.

For more information about the plugin, see:

  * [Concepts](doc/concept.md)
  * [Getting Started](doc/gettingstarted.md)


Requirements:

  * Redmine 2.2 or higher
  * Ruby 1.9.3 or higher
  * PostgreSQL or MySQL. Other DBs might work as well but are untested.


## Installation

Installing Planner requires a running Redmine v2.2.x or higher. Once Redmine is
up and running, the standard procedure for plugin installation applies. Three
easy steps are enough to get the plugin going:

 1. **Getting the source**

	Download the source tarball or use Git to directly clone the repository into
	Redmine's `plugin/` directory.

	Extracting the tarball can be achieved with the following commands from within
	the Redmine root directory. The tarball already contains the required
	directory structure.

	```
	cd plugins
	tar zxf planner-v0.4.tar.gz
	mv RedminePlanner* planner
	```

	Alternatively, Git can be used to clone the source repository. Using this
	method makes updates far easier.

	```
	cd plugins
	git clone git://github.com/fschupp/RedminePlannerPlugin.git planner
	cd planner
	```

 2. **Install Gems**

	Planner also comes with a Gemfile. To install the required Gems, assuming the
	current directory is still `plugins/planner`:

	```
	bundle install --without development test
	```

	If you're planning on hacking on Planner, install with development and test
	Gems:

	```
	bundle install
	```

 3. **Run DB migrations**

	Once the plugin is in place, the necessary database structures must be
	created. This works through normal Rails migrations. Redmine offers a special
	Rake task to execute plugin migrations. Again, execute from within the Redmine
	root directory.

	  * For production

		```
		RAILS_ENV=production rake redmine:plugins:migrate NAME=planner
		```
	  * For development

		```
		RAILS_ENV=development rake redmine:plugins:migrate NAME=planner
		```

 4. **Restart Redmine**

	The last step is to restart Redmine. How this is done depends on how Redmine is
	setup. After the restart, configuration of the plugin can begin.


## Uninstallation

Uninstalling the plugin is easy as well. Basically it means dropping all the
tables and removing the plugin directory. Again, execute from withing the
Redmine root directory.

 1. **Dropping the database tables**

	```
	rake redmine:plugins:migrate NAME=planner VERSION=0 RAILS_ENV=production
	```

 2. **Removing the plugin directory**

	```
	rm -r plugins/planner
	```

 3. **Restart Redmine**

	The last step is to restart Redmine. Once restarted, the plugin will be gone.


