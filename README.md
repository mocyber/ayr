# Alternate Yum Repository
Used to create a local mirror for redistribution on a local network. If you live in the sticks like I do, bandwidth is precious so reaching out repeatedly to get the same stuff sucks. I have forked the original and simplified it a little. The big difference is that you will have to register your RHEL stuff prior to firing things off instead of adding creds to the script. I don't like keeping my RHEL creds in a clear text file. This also makes it easier to deploy on centos. The TL;DR if you have it enabled as a repo in the etc/yum/repos.d/* then it will make a local copy of it.


## Prep Work
- Update things ` sudo yum update`
- add the epel repo
`sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`
- then install the ansible and git `sudo yum install ansible git`
- Clone this playbook
- Add the repos you with to have loaded on you system like:
  - EPEL (should have this if you installed ansible already)
  `sudo yum install epel-release`
  - Custom Yum Repository Like "ROCK NSM"
  `sudo yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/g/rocknsm/rocknsm-2.1/repo/epel-7/group_rocknsm-rocknsm-2.1-epel-7.repo`

:warning:This a bandwidth intensive operation, grab a cup of coffee or go to lunch. This will take a while! Disable or move any repos that you do not want to be syncd :warning:

One you have repos that you wish to have replicated, fire off the ansible script with `sudo ansible-playbook -vv site.yml -i hosts.ini`

> Note I run this verbose because this usually takes a while and I want to make sure that nothing has died.

## Repo synchronization

Regular syncs of the repo are required in order to keep it up to date. Rerunning the playbook should achieve the required result. If you wish to automate it you can add a cron job to update it.  
The cronjob that will automatically trigger the repository
synchronization on the schedule you decide. To enable it, you need to set the
``repo_autosync`` var to True. To define the schedule for the cronjob,
the following vars can be set:
* crontab_day
* crontab_hour
* crontab_minute
* crontab_month
* crontab_weekday

When setting ``repo_autosync`` var to False, the cronjob will be removed.
In order to just setup the cronjob, you can execute the playbook with the
``prepare_cron`` tag.


TODO:
 - Add script to keep the last 2 versions to the cron job
 - add back the dynamically built *.repo file
