#! /bin/bash     
base_dir="/vagrant"

. "$base_dir/utils.sh"

  echo $(getProperty bench.password bench) | sudo -S pip install -e bench-repo
  . ~/.profile
  . ~/.bashrc
  cd $(getProperty bench.dir frappe-bench) && echo $(getProperty bench.password bench) | sudo -S bench setup production bench
  cd $(getProperty bench.dir frappe-bench) && bench --site $(getProperty site.name erpnext) migrate
  echo $(getProperty bench.password bench) | sudo -S supervisorctl restart all
  echo $(getProperty bench.password bench) | sudo -S service nginx restart

