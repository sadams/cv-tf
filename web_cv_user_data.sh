#!/bin/bash

apt-get update
apt-get install -y libffi-dev g++ libssl-dev python-pip python-dev git
pip install --upgrade awscli ansible setuptools

# To use ansible-galaxy for the nginx role we need must stop using ansible-pull
# (we would have to use ansible-playbook and write our own script to run on cron to update the repo and run if changed... boring.)
# So instead we write the nginx ansible ourselves (see repo).. like chumps who don't share code.

ansible-pull \
"./${web_cv_ansible_playbook}" \
--only-if-changed \
--directory "${web_cv_ansible_checkout_dir}" \
--url "${web_cv_ansible_repo}" \
--checkout "${web_cv_ansible_branch}"

# TODO use aws tags to dynamically define which playbook/repo/branch to use so this could be a generic bootstrap user data script
# TODO: possible solution to galaxy problem:
#  - use ansible pull twice on same repo: once to run a playbook that installs galaxy components and once to install the app
# TODO: Log rotate? maybe also something to do on first pull... https://www.stavros.io/posts/automated-large-scale-deployments-ansibles-pull-mo/
# TODO: use ansible to bootstrap ansible-pull: add a single, isolated playbook for setting up `ansible-pull` on this machine which can be directly downloaded (wget) and run instead of setting up cron using bash:
# https://github.com/ansible/ansible-examples/blob/master/language_features/ansible_pull.yml
# Would also make it easier to setup logrotation etc
