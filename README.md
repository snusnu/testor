Setting up a DataMapper development environment
-----------------------------------------------

Contributing to DataMapper might seem intimidating at first. The variety
of available gems and github repositories might appear to be an
impenetrable jungle. Fear not! The following tasks actually make it
pretty easy to solidly test any kind of patch for DataMapper.

The following steps will guide you through the process of fetching the
source and running the specs on multiple rubies (using rvm). The
provided tasks also make sure that you're always running the specs
against your local DataMapper source codes. This is very important once
you're working on a patch that affects multiple DataMapper gems.

Prerequisites
-------------

You need a few things before you can start working on DataMapper itself.
Namely [rvm](http://rvm.beginrescueend.com/) and
[thor](http://github.com/wycats/thor). Once you have those, you need to
install the thor tasks and you're ready to go.

Installing rvm
--------------

The awesome rvm comes as a gem and makes installing and using different
rubies a breeze. Be aware that the following commands may take quite
some time, depending on your machine.

    gem install rvm   # Please follow the instructions
    rvm install 1.8.7 # You need to run specs on 1.8.7
    rvm install 1.9.2 # You need to run specs on 1.9.2
    rvm install jruby # Bonus points for running on jruby
    rvm install rbx   # Bonus points for running on rbx

Reading through rvm's detailed [documentation]((http://rvm.beginrescueend.com/)
is definitely time well spent too.

Installing thor and the DataMapper tasks
----------------------------------------

Thor is yet another rubygem, providing a nice framework for writing
system wide thor tasks or ruby executables. Install it like you would
with any other rubygem, then clone the DataMapper tasks and install them
systemwide.

    gem install thor
    git clone git://github.com/datamapper/dm-dev.git
    cd dm-dev
    thor install dev_tasks.rb

After showing you the content of dev_tasks.rb, thor will ask you for a
namespace for those new tasks.

    Please specify a name for dev_tasks.rb in the system repository [dev_tasks.rb]:

You can choose any name at that prompt, or you can just hit enter to
accept the default. The provided thor tasks explicitly define their
namespace to be 'dm'.


## dm-dev

The following describes the new DM development tasks and shows how you can use them. These tasks greatly simplify the management of DM related source code and hopefully also help interested contributors to get a fully functional DM development up and running fast. By invoking very few commands, contributors can verify if their patch(es) meet the DM quality guidelines, aka, do specs pass on all supported platforms?

## Totally isolated

The following tasks don't affect the system gems *at all*. Nor do they mess with any rvm ruby specific (system)gem(set). By default, *everything* will be bundled below `"#{Dir.pwd}/BUNDLE_ROOT"`, you can alter the install location by passing the `BUNDLE_ROOT=/path/to/bundle/root` ENV var. `BUNDLE_ROOT` contains separate folders for every ruby in use.

This means that once all dependencies are bundled for any given ruby, there's no need to clean anything between spec runs. Also, no re-bundling needs to happen before spec runs since everything is already bundled. Of course, the bundles can be updated manually, to ensure that the code under test is up to date. In the near future, a command that tells you exactly which repos need updating, will be included.

The tasks make sure that you're always testing against local sources. This is very important if you're developing patches that touch multiple DM repositories. Testing against local sources only, will make sure that the code still works with all your modifications to potentially more than one DM repository.

To achieve this, the bundle tasks first create a `Gemfile.local` for every repository that includes a Gemfile (or isn't otherwise ignored), and then copies that file to `Gemfile.ruby_version.local` where *ruby_version* is any of the specified rubies to use. This is done because bundler automatically creates a `Gemfile.lock` after `bundle install`. In our case that leaves us with files like `Gemfile.1.9.2.local` and `Gemfile.1.9.2.local.lock`. That's necessary, because otherwise bundler confuses the the `BUNDLE_PATH` to use. Every command executed by the bundle tasks explicitly passes `BUNDLE_PATH=/path/to/BUNDLE_ROOT/ruby_version` and `BUNDLE_GEMFILE=/path/to/Gemfile.ruby_version.local` as environment variables, to make sure that the right (local) bundle is used.

## Running specs

The spec task uses the bundled DM sources to run the specs for all specified gems against all specified rubies and adapters. While running, it prints out a matrix, that shows for every ruby and every adapter if the specs `pass` or `fail`.

## Common options

Every task can be configured with a few environment variables. The rubies to use can be altered by passing something like `RUBIES=1.8.7,1.9.2,rbx`. When given, `INCLUDE=dm-core,dm-validations` will make sure that only these two gems are used. When `INCLUDE` is left out, *all* (not ignored) gems will be used. Passing `EXCLUDE=dm-tags,dm-is-tree` will use all but those two gems.


## The available ruby API

Currently, environment variables are the only way to configure these API
calls. It's planned to map those environment variables to a regular ruby
option hash in the future.

    DM.sync           # :verbose => false
    DM.bundle_install # :verbose => false
    DM.bundle_update  # :verbose => false
    DM.spec           # :verbose => false
    DM.implode        # :verbose => false

## The available thor tasks

    thor dm:sync
    thor dm:bundle:install
    thor dm:bundle:update
    thor dm:spec
    thor dm:implode

## IRB session

The following IRB session demonstrate a typical workflow. The API used in this session can also be invoked via system wide thor tasks.

    ree-1.8.7-2010.02@datamapper mungo:dm-dev snusnu$ irb -r dev_tasks.rb
    ree > DM.sync
    <GitHub::User name="DataMapper">
    [01/38] Pulling dm-core
    [02/38] Pulling do
    [03/38] Pulling extlib
    [04/38] Pulling datamapper.github.com
    [05/38] Pulling data_mapper
    [06/38] Pulling dm-rails
    [07/38] Pulling dm-active_model
    [08/38] Pulling dm-transactions
    [09/38] Pulling dm-mysql-adapter
    [10/38] Pulling dm-postgres-adapter
    [11/38] Pulling dm-sqlite-adapter
    [12/38] Pulling dm-do-adapter
    [13/38] Pulling dm-yaml-adapter
    [14/38] Pulling dm-adjust
    [15/38] Pulling dm-aggregates
    [16/38] Pulling dm-ar-finders
    [17/38] Pulling dm-cli
    [18/38] Pulling dm-constraints
    [19/38] Pulling dm-is-list
    [20/38] Pulling dm-is-nested_set
    [21/38] Pulling dm-is-remixable
    [22/38] Pulling dm-is-searchable
    [23/38] Pulling dm-is-state_machine
    [24/38] Pulling dm-is-tree
    [25/38] Pulling dm-is-versioned
    [26/38] Pulling dm-migrations
    [27/38] Pulling dm-observer
    [28/38] Pulling dm-serializer
    [29/38] Pulling dm-sweatshop
    [30/38] Pulling dm-tags
    [31/38] Pulling dm-timestamps
    [32/38] Pulling dm-types
    [33/38] Pulling dm-validations
    [34/38] Pulling dm-models
    [35/38] Pulling dm-ferret-adapter
    [36/38] Pulling dm-rest-adapter
    [37/38] Pulling rails_datamapper
    [38/38] Pulling dm-dev
     => nil
    ree > DM.bundle_install
    <GitHub::User name="DataMapper">
    [01/38] [1.8.7] bundle install dm-core
    [01/38] [1.9.2] bundle install dm-core
    [02/38] [1.8.7] bundle install do SKIPPED - because it's missing a Gemfile
    [02/38] [1.9.2] bundle install do SKIPPED - because it's missing a Gemfile
    [03/38] [1.8.7] bundle install extlib SKIPPED - because it's missing a Gemfile
    [03/38] [1.9.2] bundle install extlib SKIPPED - because it's missing a Gemfile
    [04/38] [1.8.7] bundle install datamapper.github.com SKIPPED - because it's ignored
    [04/38] [1.9.2] bundle install datamapper.github.com SKIPPED - because it's ignored
    [05/38] [1.8.7] bundle install data_mapper SKIPPED - because it's ignored
    [05/38] [1.9.2] bundle install data_mapper SKIPPED - because it's ignored
    [06/38] [1.8.7] bundle install dm-rails
    [06/38] [1.9.2] bundle install dm-rails
    [07/38] [1.8.7] bundle install dm-active_model
    [07/38] [1.9.2] bundle install dm-active_model
    [08/38] [1.8.7] bundle install dm-transactions
    [08/38] [1.9.2] bundle install dm-transactions
    [09/38] [1.8.7] bundle install dm-mysql-adapter
    [09/38] [1.9.2] bundle install dm-mysql-adapter
    [10/38] [1.8.7] bundle install dm-postgres-adapter
    [10/38] [1.9.2] bundle install dm-postgres-adapter
    [11/38] [1.8.7] bundle install dm-sqlite-adapter
    [11/38] [1.9.2] bundle install dm-sqlite-adapter
    [12/38] [1.8.7] bundle install dm-do-adapter
    [12/38] [1.9.2] bundle install dm-do-adapter
    [13/38] [1.8.7] bundle install dm-yaml-adapter
    [13/38] [1.9.2] bundle install dm-yaml-adapter
    [14/38] [1.8.7] bundle install dm-adjust
    [14/38] [1.9.2] bundle install dm-adjust
    [15/38] [1.8.7] bundle install dm-aggregates
    [15/38] [1.9.2] bundle install dm-aggregates
    [16/38] [1.8.7] bundle install dm-ar-finders
    [16/38] [1.9.2] bundle install dm-ar-finders
    [17/38] [1.8.7] bundle install dm-cli
    [17/38] [1.9.2] bundle install dm-cli
    [18/38] [1.8.7] bundle install dm-constraints
    [18/38] [1.9.2] bundle install dm-constraints
    [19/38] [1.8.7] bundle install dm-is-list
    [19/38] [1.9.2] bundle install dm-is-list
    [20/38] [1.8.7] bundle install dm-is-nested_set
    [20/38] [1.9.2] bundle install dm-is-nested_set
    [21/38] [1.8.7] bundle install dm-is-remixable
    [21/38] [1.9.2] bundle install dm-is-remixable
    [22/38] [1.8.7] bundle install dm-is-searchable
    [22/38] [1.9.2] bundle install dm-is-searchable
    [23/38] [1.8.7] bundle install dm-is-state_machine
    [23/38] [1.9.2] bundle install dm-is-state_machine
    [24/38] [1.8.7] bundle install dm-is-tree
    [24/38] [1.9.2] bundle install dm-is-tree
    [25/38] [1.8.7] bundle install dm-is-versioned
    [25/38] [1.9.2] bundle install dm-is-versioned
    [26/38] [1.8.7] bundle install dm-migrations
    [26/38] [1.9.2] bundle install dm-migrations
    [27/38] [1.8.7] bundle install dm-observer
    [27/38] [1.9.2] bundle install dm-observer
    [28/38] [1.8.7] bundle install dm-serializer
    [28/38] [1.9.2] bundle install dm-serializer
    [29/38] [1.8.7] bundle install dm-sweatshop
    [29/38] [1.9.2] bundle install dm-sweatshop
    [30/38] [1.8.7] bundle install dm-tags
    [30/38] [1.9.2] bundle install dm-tags
    [31/38] [1.8.7] bundle install dm-timestamps
    [31/38] [1.9.2] bundle install dm-timestamps
    [32/38] [1.8.7] bundle install dm-types
    [32/38] [1.9.2] bundle install dm-types
    [33/38] [1.8.7] bundle install dm-validations
    [33/38] [1.9.2] bundle install dm-validations
    [34/38] [1.8.7] bundle install dm-models SKIPPED - because it's missing a Gemfile
    [34/38] [1.9.2] bundle install dm-models SKIPPED - because it's missing a Gemfile
    [35/38] [1.8.7] bundle install dm-ferret-adapter SKIPPED - because it's ignored
    [35/38] [1.9.2] bundle install dm-ferret-adapter SKIPPED - because it's ignored
    [36/38] [1.8.7] bundle install dm-rest-adapter
    [36/38] [1.9.2] bundle install dm-rest-adapter
    [37/38] [1.8.7] bundle install rails_datamapper SKIPPED - because it's ignored
    [37/38] [1.9.2] bundle install rails_datamapper SKIPPED - because it's ignored
    [38/38] [1.8.7] bundle install dm-dev SKIPPED - because it's ignored
    [38/38] [1.9.2] bundle install dm-dev SKIPPED - because it's ignored
     => nil
    ree > exit
    ree-1.8.7-2010.02@datamapper mungo:dm-dev snusnu$ RUBIES=1.8.7,1.9.2 INCLUDE=dm-validations ADAPTERS=sqlite,postgres,mysql irb -r dev_tasks.rb
    ree > DM.sync
    <GitHub::User name="DataMapper">
    [1/1] Pulling dm-validations
     => nil
    ree > DM.implode
    <GitHub::User name="DataMapper">
    [1/1] Deleting dm-validations
     => nil
    ree > DM.sync
    <GitHub::User name="DataMapper">
    [1/1] Cloning dm-validations
     => nil
    ree > DM.bundle_install
    <GitHub::User name="DataMapper">
    [1/1] [1.8.7] bundle install dm-validations
    [1/1] [1.9.2] bundle install dm-validations
     => nil
    ree > DM.bundle_update
    <GitHub::User name="DataMapper">
    [1/1] [1.8.7] bundle update dm-validations
    [1/1] [1.9.2] bundle update dm-validations
     => nil
    ree > DM.spec
    <GitHub::User name="DataMapper">

    h2. dm-validations

    | RUBY  | sqlite | postgres | mysql |
    | 1.8.7 | pass | pass | pass |
    | 1.9.2 | pass | pass | pass |
     => nil
    ree >
