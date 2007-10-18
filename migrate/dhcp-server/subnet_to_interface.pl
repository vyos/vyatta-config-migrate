#!/usr/bin/perl

use strict;


use Getopt::Long;
my $subnet;
GetOptions("subnet=s" => \$subnet );


my $ifconfig_out = `ifconfig`;
my @ifconfig_out_lines = split /\n/, $ifconfig_out;

my @interfaces;
{
  my $line;
  foreach $line (@ifconfig_out_lines) {
    $line =~ /()/;;
    $line =~ /(.{10})Link encap:Ethernet/;
    my $interface = $1;
    if ($interface ne '') {
      push(@interfaces, $interface);
    }
  }
}


use VyattaMisc;
my $vm = new VyattaMisc();

use NetAddr::IP;  # This library is available via libnetaddr-ip-perl.deb

my $interface;
foreach $interface (@interfaces) {
  my $naip = $vm->getNetAddrIP($interface);
  if (!defined($naip)) {
    print STDERR "Error:  Unable to determine IP subnet / netmask information.\n";
    exit(1);
  }
  my $subnet_here = $naip->network()->addr();
  if ($subnet_here eq $subnet) { 
    print "$interface\n";
  }
}


