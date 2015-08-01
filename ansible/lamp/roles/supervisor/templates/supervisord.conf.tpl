[program:{{ servername }}_job_queue_runner]
command=php /vagrant/app/console jms-job-queue:run --env={{ enviroment }} --verbose
process_name=%(program_name)s
numprocs=1
directory=/tmp
autostart=true
autorestart=true
startsecs=5
startretries=10
user=vagrant
redirect_stderr=false