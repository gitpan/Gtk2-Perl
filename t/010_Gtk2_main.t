#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::main
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

# $Id: 010_Gtk2_main.t,v 1.8 2002/11/16 03:45:08 glade-perl Exp $

our $rcsid = '$Id: 010_Gtk2_main.t,v 1.8 2002/11/16 03:45:08 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$USE, 'Gtk2'],
            ["init()"],
#            ["init_check()"],
            ["idle_add('print_widget_tree', 'data')"],
            ["idle_remove(\$prev_ret)"],
            ["timeout_add(100, sub{Gtk2->main_quit}, 'data')"],
            ["timeout_remove(\$prev_ret)"],
#            ["disable_set_locale"],
#            ["get_default_language"],
            ["set_locale"],
            ["events_pending", "== 0"],
            ["timeout_add(2000, 'quit')"],
            ["main"],
#            ["main_level", "== 0"],
            ["events_pending", "== 0"],
#            ["main_iteration"],
            ["main_iteration_do($FALSE)"],
#            ["true", "== $TRUE"],
#            ["false", "== $FALSE"],
            ["update_ui"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
