# Alternate Yum Repository

## Prep Work
```
sudo yum install -y epel-release
sudo yum install -y ansible git yum-utils
sudo yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/g/rocknsm/rocknsm-2.1/repo/epel-7/group_rocknsm-rocknsm-2.1-epel-7.repo
git clone https://github.com/mocyber/ayr.git
```
>NOTE: You dont have to clone all the repos in your `/etc/yum.repos.d/` directory. but if you are going to clone it you need to have it there. Edit the list in `ayr/vars/main.yml` only for the repos you wish to replicate locally. As it sits, `main.yml` is already configured with Epel, Base, and ROCK. You shouldn't need anything else unless you have a specific need.

:warning:***This a bandwidth intensive operation, grab a cup of coffee or go to lunch. This will take a while! Disable or move any repos that you do not want to be syncd*** :warning:

One you have repos that you wish to have replicated, fire off the Ansible script with `sudo ansible-playbook -vv site.yml -i hosts.ini`

>NOTE: I run this verbose because this usually takes a while and I want to make sure that nothing has died.

## Repo synchronization

Regular syncs of the repo are required in order to keep it up to date. Rerunning the playbook should achieve the required result. If you wish to automate it you can add a cron job to update it.  

The cronjob that will automatically trigger the repository synchronization on the schedule you decide. To enable it, you need to set the `repo_autosync` var to True in `ayr/vars/main.yml`. To define the schedule for the cronjob, the following vars can be set:
* crontab_day
* crontab_hour
* crontab_minute
* crontab_month
* crontab_weekday

When setting `repo_autosync` var to False, the cronjob will be removed. In order to just setup the cronjob, you can execute the playbook with the `prepare_cron` tag with `sudo ansible-playbook site.yml --tags=prepare_cron -i hosts.ini`.
