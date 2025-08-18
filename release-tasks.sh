# Step to execute
bundle exec rails db:migrate data:migrate
# check for a good exit
if [ 0 -ne 0 ]
then
  puts '*** RELEASE COMMAND FAILED'
  # something went wrong; convey that and exit
  exit 1
fi