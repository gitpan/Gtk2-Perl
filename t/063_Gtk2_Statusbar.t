#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::Statusbar that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/063_Gtk2_Statusbar.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 063_Gtk2_Statusbar.t,v 1.1 2002/11/16 07:33:49 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$MAKE_TEST_BOX, "Gtk2::Statusbar"],
            ["new()"],
            [$ADD_TO_TEST_BOX],
            ["signal_connect('text-pushed', sub{print \"'\$_[3]' was pushed \" if \$DEBUG})"],
            ["signal_connect('text-popped', sub{print \"'\$_[3]' was popped \" if \$DEBUG})"],
            [$EVAL, "\$w->{context_id} = \$o->get_context_id('Statusbar test')"],
            [$EVAL, "\$w->{message_id1} = \$o->push(\$w->{context_id}, 'New value1')"],
            [$EVAL, "\$w->{message_id2} = \$o->push(\$w->{context_id}, 'New value2')"],
            [$EVAL, "\$w->{message_id3} = \$o->push(\$w->{context_id}, 'New value3')"],
            ["pop(\$w->{context_id})"],
            ["pop(\$w->{context_id})"],
            ["remove(\$w->{context_id}, \$w->{message_id3})"],
            [$GET_SET, 'has_resize_grip', $TRUE, $FALSE],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
