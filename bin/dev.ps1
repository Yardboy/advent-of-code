param (
  [string]$cmd
)

$composefile='docker/docker-compose.yml'
$service='advent'

If ($cmd -eq 'bash') {
  docker-compose -f $composefile run --rm $service /bin/bash
} elseif ($cmd -eq 'build') {
  docker-compose -f $composefile build
} elseif ($cmd -eq 'up') {
  docker-compose -f $composefile up
} elseif ($cmd -eq 'down') {
  docker-compose -f $composefile down
# } elseif ($cmd -eq 'test') {
#     docker-compose -f $composefile run -e RAILS_ENV=test --rm $service /bin/bash -c "bundle install && bundle exec rake db:migrate && bundle exec rspec"
} elseif ($cmd -eq 'enter') {
  $id=((docker ps | Select-String -Pattern "docker_$service") -split('\s+'))[0]
  docker exec -it $id /bin/bash
# these are for middleman deployments 
# } elseif ($cmd -eq 'deploy') {
#   docker-compose -f $composefile run -p 4567:4567 --rm $service middleman build --clean
}
