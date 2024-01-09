### Tests

Some ways to invoke tests:
```sh
bundle exec appraisal rails-7-0 bundle install
bundle exec appraisal rails-7-0 rake test
BACKTRACE=blegga bundle exec appraisal rails-7-0 rake test TEST=test/lib/nonschema_migrations/railties_test.rb
BUNDLE_GEMFILE=gemfiles/rails_7_0.gemfile bundle exec rake test
BUNDLE_GEMFILE=gemfiles/rails_7_1.gemfile bundle exec ruby test/lib/nonschema_migrations/railties_test.rb
BUNDLE_GEMFILE=gemfiles/rails_7_1.gemfile bundle exec ruby test/lib/nonschema_migrations/railties_test.rb -n test_that_the_up_task_can_run
```
