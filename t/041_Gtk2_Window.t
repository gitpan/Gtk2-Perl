#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::Window that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/041_Gtk2_Window.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 041_Gtk2_Window.t,v 1.7 2002/11/14 05:38:40 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$USE, 'Gtk2'],
            ['init'],
        [$USE, 'Gtk2::Window'],
            ["new('toplevel')"],
            ["set_title('Title')"],
            ["get_title()", "eq 'Title'"],
            ["get_title()", "eq 'Title'"],
            ["get_title()", "eq 'Title'"],
            ["get_title()", "eq 'Title'"],
            ["get_title()", "eq 'Title'"],
            ["get_title()", "eq 'Title'"],
            ["get_resizable",                   "== $TRUE"],
            ["set_resizable($FALSE)"],
            ["get_resizable",                   "== $FALSE"],
            ["resizable",                       "== $FALSE"],
            ["resizable($TRUE)"],
            ["resizable",                       "== $TRUE"],
            [$GET_SET, 'resizable', $TRUE, $FALSE],
        [$USE, "Gtk2::Button"],
            ["new_with_label('Quit')"],

            [$C_EVAL, "\$w->{'Window'}[-1]->add(\$w->{'Button'}[-1])"],
            ["signal_connect('clicked', sub{Gtk2->quit})"],
            [$C_EVAL, "\$w->{'Window'}[-1]->show_all"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
