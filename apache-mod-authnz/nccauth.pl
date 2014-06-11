#!/usr/bin/perl

#
# SKIF NCC authenticator for mod_authnz_external
# made on the knee of /dragon <dragon@code.org.ua>
# mod depends: www/mod_authnz_external
# port depends: databases/p5-DBD-Pg sysutils/p5-Sys-Syslog
#


use DBI;
use Sys::Syslog;
use Switch;

my $ret = 5;
my $res = "";
my $i = 0;
my $errstr = "";

openlog('nccauth','cons,pid',LOG_AUTH);

while(<STDIN>){ $username = ($i==0)?$_:$username; $password = ($i==1)?$_:$password; if($i>0){ last; }else{ $i++;chop; }}
if($i != 1) { $errstr .= "RTERR: to fiew input parameters"; goto BYE; }
if(defined($ENV{'CONTEXT'})) 	{ $context = $ENV{'CONTEXT'}; } else { $errstr .= "RTERR: no context envar"; 	goto BYE; }
if(defined($ENV{'IP'})) 		{ $ip = $ENV{'IP'}; }	 		else { $errstr .= "RTERR: no ip envar"; 		goto BYE; }

$username 	=~ s/[\n\r]+//g;
$password 	=~ s/[\n\r]+//g;
$context 	=~ s/[\n\r]+//g;
$ip 		=~ s/[\n\r]+//g;

my @drivers = DBI->available_drivers();
if( !grep(/Pg/,@drivers) ){
	$errstr .= "RTERR: no DBD::Pg driver installed";
	goto BYE;
}

$dbh = DBI->connect("dbi:Pg:dbname=ncc", "ncc", "ywwvfcnth");
my $sth = $dbh->prepare("select ncc_auth(trim(E'$username'),trim(E'$password'),trim(E'$context'),trim('$ip')::inet);");
$sth->execute();
if($sth->rows() != 1){
	$errstr .= "RTERR: auth request failed";
	goto BYE;
}
($res) = $sth->fetchrow_array();

switch ($res) {
	case "OK" 		{ $errstr .= "AUTH: succeed for $username @ $ip to $context";	$ret = 0;	}
	case "NOUSER"	{ $errstr .= "AUTH: failed for no such user [$username]";  $ret = 1;	}
	case "NOAUTH"	{ $errstr .= "AUTH: failed for wrong password of [$username]";  $ret = 2;	}
	case "NOACCESS"	{ $errstr .= "AUTH: failed for no access $username @ $ip to $context";  $ret = 3;	}
	else			{ $errstr .= "AUTH: failed for unknown error";  $ret = 4;	}
}


BYE:
if( length($errstr) > 0 ){ syslog('info',"$errstr"); }
closelog();
exit $ret;

