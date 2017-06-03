#!/bin/bash

set -e

# install deps
apt-get update
apt-get install -y libffi-dev g++ libssl-dev python-pip python-dev git
pip install --upgrade awscli ansible setuptools

PULL_LOG_FILE='/var/log/ansible-pull.log'
PULL_LOG_ROTATE='/etc/logrotate.d/ansible-pull'
CRON_SCHEDULE='*/5 * * * *'
CRON_FILE='/etc/cron.d/ansible-pull'
CRON_USER='root'
# we have to use `su - root -c "..."` so we get the full shell env including bin paths
# (yes, we could have set the paths explicitly in cron script, but who can be bothered...)
PULL_COMMAND="su - root -c \"ansible-pull \
'./${web_cv_ansible_playbook}' \
--only-if-changed \
--directory '${web_cv_ansible_checkout_dir}' \
--url '${web_cv_ansible_repo}' \
--checkout '${web_cv_ansible_branch}'\""

# write the log rotation for ansible pull logs
cat > $PULL_LOG_ROTATE <<- EOM
$PULL_LOG_FILE {
  rotate 3
  daily
  compress
  missingok
  notifempty
}
EOM

#add ansible pull command to cron to run every 5 mins
echo "$CRON_SCHEDULE $CRON_USER $PULL_COMMAND >>'$PULL_LOG_FILE' 2>&1" > "$CRON_FILE"

# TODO: use aws tags to dynamically define which playbook/repo/branch to use so this could be a generic bootstrap user data script
# TODO: can't use ansible galaxy (ansible-pull doesn't install) and ideally we would have used contributed nginx role
#  possible solution:
#   1. use ansible-pull to do the checkout and run a bootstrap playbook
#   1. that bootstrap playbook will have to know the location of the checkout to install galaxy deps
#   1. it can then install galaxy deps and install a cron for subsequent pull runs against a different playbook
#      (this is the 'real' playbook to install the app).
#      e.g. https://github.com/ansible/ansible-examples/blob/master/language_features/ansible_pull.yml
#
