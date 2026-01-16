# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Nonschema Migrations is a Rails gem that separates data migrations from schema migrations. Data migrations live in `db/data_migrate/` and are tracked in a `data_migrations` table (similar to how schema migrations use `schema_migrations`).

**Version Policy:** Gem versions are locked to Rails versions (e.g., v6.9 for Rails 8.0, v6.8 for Rails 7.1+7.2).

## Common Commands

```bash
# Run tests
rake test

# Run a single test file
ruby -Ilib:test test/lib/nonschema_migrations/integration_test.rb

# Interactive console
rake console
```

## Architecture

### Core Components

- **`lib/nonschema_migrations.rb`** - Main entry point, sets `MIGRATIONS_PATH = 'db/data_migrate'`
- **`lib/active_record/data_tasks.rb`** - Core migration logic in `ActiveRecord::Tasks::DataTasks.migrate()` - reads migration files, checks `data_migrations` table for already-run versions, executes pending migrations
- **`lib/active_record/data_migration.rb`** - `ActiveRecord::DataMigration` model for the `data_migrations` table
- **`lib/nonschema_migrations/railtie.rb`** - Loads rake tasks into Rails

### Generators

- **`DataMigrations::InstallGenerator`** (`rails generate data_migrations:install`) - Creates the schema migration to add `data_migrations` table
- **`DataMigrationGenerator`** (`rails generate data_migration MyMigration`) - Creates a new data migration file in `db/data_migrate/`

### Rake Tasks (lib/tasks/data.rb)

- `data:migrate` - Run all pending data migrations
- `data:rollback` - Rollback last data migration
- `data:migrate:up VERSION=xxx` - Run specific migration up
- `data:migrate:down VERSION=xxx` - Run specific migration down

## Testing

Tests use Minitest with a dummy Rails app in `test/dummy_app/`. The test helper (`test/test_helper.rb`) sets up SimpleCov, loads the dummy app, and configures the load paths.
