#!/usr/bin/perl 
#==============================================================================
#=== This is a script to run an automatic test interactively
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: i_test.pl,v 1.2 2002/11/13 04:22:41 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

    do $ARGV[0];

Gtk2->main;
