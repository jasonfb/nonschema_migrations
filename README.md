



_Please use the version number of this gem in lockstep with your Rails version._

| Rails Version         |   | Use Version of This Gem          |     |           
|-----------------------|------------------|----------------------------------|-----|
| Rails 4.x, 4.1.x, 4.2 |   | v1.0.1  (Released Jun 1, 2019)   |     |
| Rails 5.0             |    | v2.0.1 (Released Jun 1, 2019)    |     |
| Rails 5.1             |    | v3.0.1 (Released Jun 1, 2019)    |     | 
| Rails 5.2             |    | v4.0.2 (Released Jun 2, 2019)    |     |
| Rails 6.0             |    | v5.1.2.1 (Released Nov 17, 2021) |    |
| Rails 7.0             |    |  v6.5.1 (Released Jan 4, 2024), ~v6.5.0 (Released Jan 11, 2022)~   |    |
| Rails 7.1             |    | not yet compatible               |    |

Note: yanked version 6.5 was not compatible with Rails 7.1. For Rails 7.0 please bump this gem to 6.5.1. 

## Introduction

Nonschema migrations, also known as data migrations, are a alternative kind of Rails migration. The data migrations operate exactly like schema migrations, except instead of running migrations to make changes to your schema (adding fields, dropping fields, adding tables, etc), you run data migrations to manipulate data in your app, enqueue or execute Resque jobs that require long-running processes. This happens in a Rails app for different reasons, usually to clean up or supplement data or architectural changes.

Splitting your data migrations from your schema migrations has a particular benefit of achieving the most consistent zero-downtime deploys you can. I recommend you switch your deployment script to allow you to do two
types of deploys: a Zero-downtime deploy (no schema migrations) and Schema Migration deploy.

You can think of data migrations like seed data for production, staging, and dev environments. It is for people who don't like using seed data in dev, and want to have 'seed-parity' between dev + prod. (For example, for a basic set of setup records.)

This way, you can deploy any non-destructive (data-only) migration with a Zero-downtime strategy, and opt to make destructive (schema) migrations in a normal deployment (maintenance on, run schema changes, boot up new app,  maintenance off).  Data-only migrations can be run while the app is actually running, augmenting what you can achieve with the migration-style shortcuts provided by Rails.

A word of caution: If you find yourself making a lot of data migrations, you might consider if your product/development/business process is too reliant on one-off data importing. It may be that data management tools will help you in the long run. Nonetheless, separating your schema migrations from your data migrations can be a great strategy for modern Rails development.

Data migrations functional EXACTLY like schema migrations except:

1) They live in db/data_migrate instead of db/migrate

2) The timestamps used to record which ones have been run are in a table called data_migrations instead of the normal schema_migrations table

3) You run them using `rails data:migrate` instead of `rails db:migrate`

## Installation
To add to your Rails project, follow these steps.

1) Add this to your gemfile.
```ruby
gem 'nonschema_migrations'
```

2) Run `bundle install`

3) Run the setup script:
```
rails generate data_migrations:install
```
This will create a *schema* migration that will create the data_migrations table itself. (There will be a table in your database called data_migrations which will have two columns: id, version. It works exactly like the schema_migrations table.) Now execute that schema migration (and, in turn, be sure to run this on Production):

```
rails db:migrate
```

You are now set up and ready to start making data migrations. To create your first migration, create it with a generating using a camel-case description of what your data migration does. 

```
rails generate data_migration UpdatePhoneNumbers
```

Look for a file called (something like) `db/data_migrate/20140831020834_update_phone_numbers.rb`. It will have been automatically written with an empty up and down method. Add whatever operations you want to do in your **up** method, like large data manipulation jobs, running rake tasks, or enqueuing batch process jobs. 

You probably want to put `ActiveRecord::IrreversibleMigration` into the **down** method your data migration:

```ruby
class UpdatePhoneNumbers < ActiveRecord::Migration
  def up
    # do stuff here
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
```

To actually tell your app to run the data migration, use:

```
rails data:migrate
```


You get three additional rake tasks that operate and have the same syntax as the schema migrations, but operate only on the data migrations. 

## rails data:migrate
Migrate all data migrations that haven't been migrated.

## rails data:migrate:down VERSION=xxxxxxxxxxx
Migrate down the specified version

## rails data:migrate:up VERSION=xxxxxxxxxxx
Migrate up the specified versions.

## rails data:rollback
Rollback the last version. Generally data migrations don't have any "down" associated with them so use this only under extreme circumstances. 

By default your data migration will run in a single transaction (just like a schema migration).

To turn this off, add `disable_ddl_transaction!` to the top of your migration, like so:

```ruby
class UpdatePhoneNumbers < ActiveRecord::Migration
  disable_ddl_transaction!
  def up
    # do stuff here
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
```

## Schema-Change Deploys with Heroku

1. Switch OFF preboot feature
2. Deploy to Heroku
3. Enable maintenance-mode
4. Run schema migrations  (app reboots)
5. Disable maintenance mode
6. Run the data migrations
7. Switch preboot feature back ON

advantage: your app is down only for schema migrations and you can let the data migrations take more time while your app is back online.


## Zero-Downtime deploys with Heroku (no schema migrations)

(assuming preboot is already on)
1. Deploy to heroku with preboot on
2. Heroku switches the incoming requests to use the new app
3. Run data migrations (while new app is up & running)
advantage: your app is never down and you can run data migrations in the background

## Heroku Pipeline
To use data migrations on the pipeline, the `release-tasks.sh` file should contain only the db:migrate
``` 
# Step to execute
bundle exec rails db:migrate 
# check for a good exit
if [ 0 -ne 0 ]
then
  puts '*** RELEASE COMMAND FAILED'
  # something went wrong; convey that and exit
  exit 1
fi
```


The postdeply task should be **data:migrate**
in `app.json`
```
"scripts":  {
   "postdeploy": "bundle exec rails data:migrate"
}
```
The above setup will run data migtrations only for REVIEW APPS. 
You will still need to manually run the data migration for staging + production. 

If you want to use the data migrations for staging + production, remove the postdeploy script from `app.json` and change release-tasks.sh to :
```
bundle exec rails db:migrate data:migrate
```

