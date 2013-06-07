Added:
 - snmp.php - for displaying SNMP info about IF-MIB::ifHCInOctets etc counters from switches and routers.
 - openvpn.php - for displaying traffic usage by openvpn connections.

All two plugins are modified interfaces.php plugin.
For using snmp.php you need to edit cgp/inc/collectd.inc.php:
old value:
if ($CONFIG['version'] >= 5 || !preg_match('/^(df|interface)$/', $item['p']))
new value:
if ($CONFIG['version'] >= 5 || !preg_match('/^(df|interface|snmp)$/', $item['p']))

Modified:
 - nut.php:
 
 diff cgp.orig/plugin/nut.php cgp/plugin/nut.php master
 20c20
 < $obj->data_sources = array(‘value’);
 —
 > $obj->data_sources = array(‘frequency’);
