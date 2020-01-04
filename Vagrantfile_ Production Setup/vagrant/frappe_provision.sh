#! /bin/bash     
set -x
base_dir="$(dirname "$0")"

. "$base_dir/utils.sh"

bench init --frappe-branch $(getProperty frappe.version master ) --python python3  $(getProperty bench.dir frappe-bench) 
cd $(getProperty bench.dir frappe-bench)
. ~/.bashrc
bench get-app erpnext https://github.com/frappe/erpnext --branch $(getProperty erpnext.version master)
bench new-site promantia.local --db-name $(getProperty db.name promantia) --mariadb-root-password $(getProperty mariadb.password rand0m123) --admin-password $(getProperty admin.password rand0m000 ) --install-app erpnext

