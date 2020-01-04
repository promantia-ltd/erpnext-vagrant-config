#! /bin/bash     
base_dir="/vagrant"

. "$base_dir/utils.sh"

git clone https://github.com/frappe/bench bench-repo
pip3 install -e bench-repo
. ~/.profile
bench init --frappe-branch $(getProperty frappe.version master ) --python python3  $(getProperty bench.dir frappe-bench) 
cd $(getProperty bench.dir frappe-bench)
bench get-app erpnext https://github.com/frappe/erpnext --branch $(getProperty erpnext.version master)
bench new-site $(getProperty site.name erpnext) --db-name $(getProperty db.name promantia) --mariadb-root-password $(getProperty mariadb.password rand0m123) --admin-password $(getProperty admin.password rand0m000 ) --install-app erpnext

