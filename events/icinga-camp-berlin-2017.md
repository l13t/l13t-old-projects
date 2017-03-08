https://www.slideshare.net/icinga/monitoring-as-code-71858829

# thruk

business process module
reports module:
- allow to generate sla report excluding downtimes
allows to run local commands

# hardware monitoring

redfish, cat - new replacement of ipmi

check_smart_attributes - allow to check smart values inside raid array

# writing modules for icingaweb2

- monitoring action bar
- announce banners (patching etc)
- xml /bin/rm

icingacli == icingaweb2

  --trace попробовать с плагинами из консоли

# How to write checks that don’t suck

cobol won't work for plugins ((:

- think about ways how to take info (multiple ways to get info)

### rules

- make readable (formatting)
  - use newline
  - use some html tags
  - html tables where it's useful
- translate to human readable way:
  raid_status=1
  better to write:
  raid_status=DEGRADED
- useless information
  - for example don't show serial numbers of hard drives
  - don't show what is OK
- don't put perfdata inside check result output
- group similar things together
- let the check do work for you:
  - think if we need to fix it
  - aggregate information into the check output

### howto
- gather info
- parse info
- internal logic
- translate to human

### best practice

- show less output
- unreadable mess (our disk space check)
  - difficult to skup between values
  - easy to get lost

### own check_load plugin to show process cpu usage

if check fails - use unknown and trace of crash

https://github.com/c-store/icinga2checks

always think "you are employee at 3am"

# icinga director

icinga configs allow to use functions (???)

https://docs.icinga.com/latest/en/volatileservices.html

- stored in database
- allow to see diff in git way
- history of changes per host/service

look for virtual hosts, domains and dependencies

import of existing conf possible only partly through api

introduced acl to manage configuration

# Alyvix: End User Experience Monitoring in Icinga

http://www.alyvix.com/

# Train IT platform monitoring

Note:
  more about how the configure icinga for their needs

siemens mobility services - velaro e

also use ELK stack

OBB (austria)
collect info about speed, engine temperature etc

most checks - queries to ES with python plugin.
lots of 20-30 year old apps. collect logs from them to ELK.
use dynamical reassigns of notifications with icinga2 language
vars += config /// this 'll overwrite prev 2 lines with config from host definition

  vars.host.filecount_warning = 500
  vars.host.filecount_critical = 1000

jolokia - bridge for java monitoring. allows to query jmx over http

dummy checks/service ???

vars.dummy_state = {{
....
  }}
vars.dummy_text = {{
  ....
  }}

dummy check logic:
- have check always green with perfdata
- dummy check to evaluate data from this check
- write dependency for dummy checks

for example - collect all data from tomcat. and then one-by-one create dummy checks for connection, memory useage etc.

// find icinga2 hosts state calculation from 2016

# Integrations all the way

agenda

check ansible repo to adopt it for saltstack

check readme for dashing/dashing2 for debug info

mikesch-mp icingaweb2-module-globe

module-dev-doc located in monitoring-portal.org

enhanced notifications for icinga2 - check monitoring-portal (https://github.com/mmarodin/icinga2-plugins)

icinga2 elastic beat
