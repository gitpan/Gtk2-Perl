#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::FontSelectionDialog that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/045_Gtk2_FontSelectionDialog.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 045_Gtk2_FontSelectionDialog.t,v 1.6 2003/01/21 18:57:50 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$USE, 'Gtk2'],
            ["init()"],
        [$USE, 'Gtk2::FontSelectionDialog'],
            ["new('Test Title')"],
            [$GET_SET, 'preview_text', "'abcdefghijk ABCDEFGHIJK'", "'New preview text'"],
            ["set_font_name('serif 12')", "== $TRUE"],
            [$GET_SET, 'font_name', "'Serif 12'", "'Sans 12'"],
            ["signal_connect('delete_event', 'quit')"],
            ["signal_connect('destroy', 'quit')"],

        [$USE, 'Gtk2::Button'],
            [$C_EVAL, "\$w->{'FontSelectionDialog'}[-1]->ok_button"],

            [$C_EVAL, "\$w->{'FontSelectionDialog'}[-1]->ok_button->signal_connect('clicked', 'print_widget_tree')"],
            [$C_EVAL, "\$w->{'FontSelectionDialog'}[-1]->cancel_button->signal_connect('clicked', 'quit')"],
            [$C_EVAL, "\$w->{'FontSelectionDialog'}[-1]->apply_button->signal_connect('clicked', 'print_handler_args')"],

            [$C_EVAL, "\$w->{'FontSelectionDialog'}[-1]->show_all"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
