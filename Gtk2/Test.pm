#!/usr/bin/perl
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: Test.pm,v 1.17 2002/12/16 14:40:06 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

# Copyright (c) 2002 Dermot Musgrove <dermot.musgrove@virgin.net>
#
# This library is released under the same conditions as Perl, that
# is, either of the following:
#
# a) the GNU General Public License as published by the Free
# Software Foundation; either version 1, or (at your option) any
# later version.
#
# b) the Artistic License.
#
# If you use this library in a commercial enterprise, you are invited,
# but not required, to pay what you feel is a reasonable fee to perl.org
# to ensure that useful software is available now and in the future. 
#
# (visit http://www.perl.org/ or email donors@perlmongers.org for details)

#==============================================================================
#=== This is common code for test scripts
#==============================================================================

BEGIN {
    use Test;
    use Data::Dumper;
    use UNIVERSAL qw(can isa);
    use Exporter qw ();
    
    use vars qw( 
        @ISA @EXPORT 
        @test_plan 

        $PACKAGE $AUTHOR $DATE
        $FAILURES
        $MAKE_TEST_BOX $ADD_TO_TEST_BOX
        $DEBUG $USE $GET_SET $EXPECT_ERROR $EVAL $C_EVAL $C_OK
        $OK $FAIL $NOARGS $NOCHECK $NULL $ZERO $TRUE $FALSE 

        $class $err $ret $o $w $prev_ret
        $seq $current_test
        );

    $PACKAGE      = __PACKAGE__;
#    $VERSION      = q(0.03);
    $AUTHOR       = q(Dermot Musgrove <dermot.musgrove@virgin.net>);
    $DATE         = q(Tue Oct 22 02:24:39 BST 2002);

    $DEBUG = 0;
    $FAIL    = '__FAIL';
    $OK = '__OK';
    $C_OK = "''",
    $NOARGS = undef;
    $NOCHECK = undef;
    $USE = '__USE';
    $GET_SET = '__GET_SET';
    $EXPECT_ERROR = '__EXPECT_ERROR';
    $EVAL = '__EVAL';
    $C_EVAL = '__C_EVAL';
    $MAKE_TEST_BOX = '__MAKE_TEST_BOX';
    $ADD_TO_TEST_BOX = '__ADD_TO_TEST_BOX';
    $NULL = '';
    $ZERO = "'0'";
    $TRUE = 1;
    $FALSE = $ZERO;
    $seq = 0;
    @ISA = qw(Test);
    # These symbols (globals and functions) are always exported
    @EXPORT = qw(
        $PACKAGE $VERSION $AUTHOR $DATE
        @test_plan 

        $FAILURES $TESTOUT
        $WINDOW_AND_BOX $ADD_TO_BOX
        $DEBUG $USE $GET_SET $EXPECT_ERROR $EVAL $C_EVAL $C_OK
        $OK $FAIL $NOARGS $NOCHECK $NULL $ZERO $TRUE $FALSE 

        $class $err $ret $o $w $prev_ret
    );
#    print $Test::TESTOUT "Gtk2::Test engine running tests ";
#    print $Test::TESTOUT "This might take a while if widgets have not yet been compiled ";
}

=pod

=head1 NAME

Gtk2::Test - Utility methods for testing Gtk2-Perl

=head1 SYNOPSIS

 BEGIN {
    use Gtk2::Test;
    @test_plan = (
        [$MAKE_TEST_BOX, 'Gtk2::Window'],
            ["new()", $EXPECT_ERROR, "=~ /Usage:/"],
            ["new('toplevel')"],
            ["new('topleel')", $EXPECT_ERROR,   "=~ /FATAL: invalid GtkWindowType value topleel/"],
            ["set_position('xcenter')", $EXPECT_ERROR],
            ["set_position('mouse')"],
            ["set_title()", $EXPECT_ERROR, "=~ /Usage:/"],
            ["set_title('Title')"],
            ["get_resizable",                   "== $TRUE"],
            ["set_resizable($FALSE)"],
            ["get_resizable",                   "== $FALSE"],
            [$GET_SET, 'resizable', $FALSE, $TRUE],
            ["realize"],

        [$USE, 'Gtk2::HBox'],
            ["new(1, 1)"],
            [$EVAL, "\$o->isa('Gtk2::HBox')"],
            [$EVAL, "!(\$o->isa('xGtk2::HBox'))"],
            [$EVAL, "\$xo->isa('Gtk2::HBox')", 
                $EXPECT_ERROR, '=~ /Global symbol "\$xo" requires explicit package name/'],
            [$EVAL, "\$w->{'xButton'}[0]->xisa('Gtk2::Button')", 
                $EXPECT_ERROR, '=~ /Can\'t call method "xisa" on an undefined value/'],
            [$C_EVAL, "\$w->{'Window'}[-1]->add(\$w->{'HBox'}[-1])"],

        [$USE, "Gtk2::Button"],
            ["new"],
            ["set_label('Test label')"],
            [$GET_SET, 'label', "'Test label'", "'Print handler args'"],
            ["signal_connect('button_press_event', 'print_handler_args', 'test data')"],

            [$ADD_TO_TEST_BOX],
    );
    plan tests => scalar @test_plan;
 }

 $DEBUG = $ARGV[0] || 0;

 &do_tests;

=head1 DESCRIPTION

Gtk2::Test provides some utility methods that are used to test Gtk2-Perl 
directly or during 'make test'. There are several exported variables that
can be used to work with - such as the current class, value returned by a
method, error string and current object. 
The methods carry out the tests and report all actions requested.

The methods can be called directly or indirectly but the simplest way is
to specify a test_plan and run it automatically. There is a script ./t/i_test.pl
that will run the test with a C<Gtk2->main> call so that you can see the
fruits of all your labours.

=head1 THE TEST PLAN

=head2 C<@test_plan>

This is the real user interface. All the tests are defined in an array that
is exported from Gtk2::Test. 

The array holds all the tests in the order that they should be run.

Each test is defined as an anonymous array of up to 4 elements and
there are several possible test specifications:

=over 4

=item C<[$MAKE_TEST_BOX, 'Classname']>

This will try to 'C<use Classname;>' and build a basic window/vbox/hbox/button
testing display to add your widget to. This is just a convenient way to
avoid repetitious code. Use C<$ADD_TO_TEST_BOX> to add any widgets to
the top space in the HBox. This will not be constructed if the test is part
of the Test::Harness run during a 'make test'
  _______________________________
 |                               |
 |     HBox for your widgets     |
 |-------------------------------|
 | Print widgets |    Quit       |
 |    button     |   button      |
 |_______________|_______________|

I<BYPRODUCT> - C<$class> is set to 'Classname' and C<$w->{'Test'}{'Window'}>

=item C<[$USE, 'Classname']>

This will try to 'use Classname;' and report any failures.

I<BYPRODUCT> - C<$class> is set to 'Classname'

=item C<['new()']>

This will construct an object $o in the current $class with the args 
supplied (none in this case)
The actual call will be C<$o = new Classname()>

I<BYPRODUCT> - C<$o> is set to the object returned from the method call
which is also pushed onto @{$w->{$class}} for later use 
eg. add(\$w->{'HBox'}[-1])

=item C<['method()']>

This will call this method with the args supplied (none in this case)
The actual call will be C<$o-E<gt>method()>

I<BYPRODUCT> - C<$ret> is set to the value returned from the method call

=item C<["method('arg1', 'arg2')", '== 1']>

This will call this method with the args supplied and check that the
returned value (stored in C<$ret>) is numerically equal to 1
The actual call will be C<$o-E<gt>method('arg1', 'arg2')>

I<BYPRODUCT> - C<$ret> is set to the value returned from the method call

=item C<["method('arg1', 'arg2')", $EXPECT_ERROR, '=~ /error21/']>

This will call this method with the args supplied and expect failure.
It will check that the
error string (stored in C<$err>) contains the string 'error21'
The actual call will be C<$o-E<gt>method('arg1', 'arg2')>

I<BYPRODUCT> - C<$ret> is set to the value returned from the method call

=item C<[$GET_SET, 'method', "'Expected'", "'New value'"]>

This will call C<get_method()> and check that it returns 'Expected'

Then it calls C<set_method('New value')>

Finally calls C<get_method()> again and checks that it returns 'New value'

The comparison depends on the first expected value - if it is digits the
checks are C<($ret == $expected)> otherwise C<($ret eq $expected)>

=item C<[$EVAL, 'string to eval', "=~ /success/"]>

Eval the supplied string and check that C<$expect> is returned if specified.
This is really just a simple interface to ok() that can be used in a test_plan.
C<$OK> is returned if the call succeeds (in a perl sense) else C<$FAIL>.

I<BYPRODUCT> - C<$ret> is set to the value returned from the eval

=item C<[$C_EVAL, 'string to eval']>

Eval the supplied string and check that C<$expect> is returned if specified.
This is really just a simple interface to ok() that can be used in a test_plan.
C<$OK> is returned if the call succeeds (in a C sense) else C<$FAIL>.

I<BYPRODUCT> - C<$ret> is set to the value returned from the eval

=item C<[$ADD_TO_TEST_BOX, $widget]>

The widget specified or the last constructed is added to the test HBox in the
test window.

I<BYPRODUCT> - The widget has C<$widget->show> called for it.

=back

BYPRODUCT - In all cases C<$err> is set to '' or the last error reported
with some explanatory messages.

=head2 Checks

Normally, the returned value (stored in C<$ret>) is compared as specified 
in the second arg. Any code supplied is C<eval()>ed and failures passed back.

If you specify C<$EXPECT_ERROR> as the second argument, the error (stored in 
C<$err>) is compared as specified in the third arg. 
Any code supplied is C<eval()>ed and failures passed back. If the error
checks successfully C<$OK> is returned otherwise C<$FAIL>.
In both cases, C<$err> will hold explanatory messages and the original
error.

=cut

=head1 METHODS

This is usually all you need to call to process your C<@test_plan>

=over 4

=cut

=item C<&do_tests()>

Run all the tests in the test_plan

e.g. C<&do_tests;>

=cut
sub do_tests {
    my ($t, $method, $args, $call);
    foreach $t (@test_plan) {
        $seq++;
#        undef $ret;
#        undef $err;
        $current_test = "['".join("', '", @{$t})."']";
        print $Test::TESTOUT "$seq - $current_test - " if $DEBUG;
        $call = $t->[0];
        if (" $USE use " =~ / $call /) {
            ok(&try_use($t->[1]), $OK, $err);
        } elsif (" $EVAL eval " =~ / $call /) {
            ok(&try_eval($t->[1], $t->[2], $t->[3]), $OK, $err);
        } elsif (" $C_EVAL c_eval " =~ / $call /) {
            ok(&try_eval($t->[1], ($t->[2] || "== $C_OK"), $t->[3]), $OK, $err);
        } elsif (" $MAKE_TEST_BOX " =~ / $call /) {
            ok(&make_test_box($t->[1]), $OK, $err);
        } elsif (" $ADD_TO_TEST_BOX " =~ / $call /) {
            ok(&add_to_test_box($t->[1]), $OK, $err);
        } else {
            my $times = 1;
            if ($call =~ /^\d+$/) {
                # We need to run this call in a loop
                $times = shift @{$t};
                $call = $t->[0];
            }
            if (" $USE use $C_EVAL c_eval $EVAL eval " =~ / $call /) {
                ok("Cannot loop $call type calls", $OK, $err);
            } else {
                $call =~ /\(/ or $call .= "()";
                $call =~ /\)/ or $call .= ")";
                $call =~ /(.+)\((.*)\)$/;
                $method = $1; $args = $2;
            
                for (my $i = 0; $i < $times; $i++) {
                    if ($method =~ '^new') {
                        ok(&try_new($method, $args, $t->[1], $t->[2]), $OK, $err);
                    } elsif (" $GET_SET get_set " =~ / $method /) {
                        ok(&try_get_set($t->[1], $t->[2], $t->[3]), $OK, $err);
                    } else {
                        ok(&try_method($method, $args, $t->[1], $t->[2]), $OK, $err);
                    }
                }
            }
        }
    }
    print $Test::TESTOUT "These were the failures logged ", Dumper($FAILURES) 
        if keys %{$FAILURES} and $DEBUG;
}

=back

There are several internal manual tests that you can use to extend your test
scripts but do remember to add 1 to the 'C<plan tests>' line in C<BEGIN>
for each manual test that you add.

=over 4

=item C<&try_eval($method, $args, $expect, $check)>

Eval the supplied string and check that C<$expect> is returned if specified.
This is really just a simple interface to ok() that can be used in a test_plan.

Returns either C<$OK> or C<$FAIL> (error details in C<$err>)

I<BYPRODUCT> - C<$ret> will hold the value returned by the eval

e.g. C<ok(&try_eval('', '== 2'), $OK, $err);>


=cut
sub try_eval {
    my ($eval, $expect, $check) = @_;
    my $res;
    my $expr;
    undef $ret;
    $err = '';
    print $Test::TESTOUT "$eval - " if $DEBUG > 0;
    eval "\$ret = $eval";
    $prev_ret = $ret;
    
    if (&_do_checks($eval, $expect, $check) eq $FAIL) {
#        &log_fail($eval, $err);
        return $FAIL;
    } else {
        return $OK;
    }
}

=item C<&try_method($method, $args, $expect, $check)>

Run the method in the current class with the supplied arg string and check
that C<$expect> is returned if specified.

Returns either C<$OK> or C<$FAIL> (error details in C<$err>)

I<BYPRODUCT> - C<$ret> will hold the value returned by the method

e.g. C<ok(&try_method('get_border_width', '== 2'), $OK, $err);>

e.g. C<ok(&try_method('get_border_width', $EXPECT_ERROR, '=~ /error21/'), $OK, $err);>

=cut
sub try_method {
    my ($method, $args, $expect, $check) = @_;
    $args ||= '';
    my $res;
    $err = '';
    undef $ret;

    unless ($o->can($method)) {
        $err = "$class\->$method - no such method";
        &log_fail($method, $err);
        return $FAIL;
    }
    my $expr = "\$ret = \$o->$method($args)";
    print $Test::TESTOUT "$expr - " if $DEBUG > 0;
    eval $expr;
    $prev_ret = $ret;
    
    $expect ||= "== '$ret'";
    if (&_do_checks("$class\->$method($args)", $expect, $check) eq $FAIL) {
#        &log_fail($eval, $err);
        return $FAIL;
    } else {
        return $OK;
    }
#    return &_do_checks("$class\->$method($args)", $expect, $check);
    
}

=item C<&try_get_set($method, $old, $new)>

Run the C<get_method()> in the current class and check it equals C<$old>
Then run C<set_method($new)> and finally run C<get_method> again to check
that C<$new> is returned.

Returns either C<$OK> or C<$FAIL>

I<BYPRODUCT> - C<$ret> will hold the value returned by the last get_method

e.g. C<ok(&try_get_set('resizable', $TRUE, $FALSE), $OK, $err);>

=cut
sub try_get_set {
    my ($method, $old, $new) = @_;
    if ($old =~ /^\d+$/) {
        (&try_method("get_$method", $NOARGS, "== $old") eq $OK) or return $FAIL;
        (&try_method("set_$method", $new) eq $OK) or return $FAIL;
        (&try_method("get_$method", $NOARGS, "== $new") eq $OK) or return $FAIL;
    } else {
        (&try_method("get_$method", $NOARGS, "eq $old") eq $OK) or return $FAIL;
        (&try_method("set_$method", $new) eq $OK) or return $FAIL;
        (&try_method("get_$method", $NOARGS, "eq $new") eq $OK) or return $FAIL;
    }
    return $OK;
}

=item C<&try_use($class)>

Tries to C<use $class;>.

Returns either C<$OK> or C<$FAIL>

I<BYPRODUCT> - C<$class> will hold the class name

e.g. C<ok(&try_use('Classname'), $OK, $err);>

=cut
sub try_use {
    $class = shift;
    $o = $class;
    $err = '';
    undef $ret;
    my $expr = "use $class";
    print $Test::TESTOUT "--------------------------- $class - " if $DEBUG > 1;
    print $Test::TESTOUT "$expr - " if $DEBUG > 0;
    eval $expr;
    if ($@) {
        $err = "Could not use $class: ".$@;
        &log_fail($expr, $err);
        return $FAIL;
    }
    return $OK;
}

=item C<&try_new($method, $args)>

Tries to call C<$o = $class->$method($args);>.

Returns either C<$OK> or C<$FAIL>

I<BYPRODUCT> - C<$o> will be a ref to the constructed object which is also
pushed onto @{$w->{$class'}} for use later eg. add(\$w->{'HBox'}[-1])

e.g. C<ok(&try_new('new_with_label', 'Label text'), $OK, $err);>

e.g. C<ok(&try_method('new', $EXPECT_ERROR, 
'=~ /FATAL: invalid GtkWindowType value topleel/'), $OK, $err);>

=cut
sub try_new {
    my ($method, $args, $expect, $check) = @_;
    my $expr = "\$o = $method ${class}($args)";
    my $res;
    print $Test::TESTOUT "$expr - " if $DEBUG > 0;

    $err = '';
    undef $ret;

    unless ($o->can($method)) {
        $err = "$class\->$method - no such method";
        &log_fail($method, $err);
        return $FAIL;
    }
    eval $expr;

    $expect ||= "== \$ret";
    if (&_do_checks("$class\->$method($args)", $expect, $check) eq $FAIL) {
        return $FAIL;

    } elsif (defined $expect && ($expect eq $EXPECT_ERROR)) {
        return $OK;
    }
    if ($o->isa($class)) {
        my $key = $class;
        $key =~ s/^Gtk2:://;
        push @{$w->{$key}}, $o;
        print $Test::TESTOUT "widget stored in \$w->{'$key'}[".$#{$w->{$key}}."] - " if $DEBUG > 0;
        return $OK;

    } else {
        $err = " Widget constructed by $class\->$method($args) is not a $class";
        &log_fail($method, $err);
        return $FAIL;
    }
}

=item C<&test_string($class)>

Returns a skeleton test script for specified widget

e.g. C<print(&test_string("Gtk2::Gdk::Pixmap"));>

=cut
sub test_string {
    my ($class, $file) = @_;
return
"#!/usr/bin/perl
#==============================================================================
#=== This is a script to test $class that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl $file
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our \$rcsid = '\$I"."d\$';
our \$VER"."SION = \$1 if \$rcsid =~ /(\\d+\\.[\\d\\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    \@test_plan = (
        [\$MAKE_TEST_BOX, \"$class\"],
            [\"new()\"],
            [\$ADD_TO_TEST_BOX],
#            [\"method('args')\", \"eq 'Expected'\"],
#            [\$GET_SET, 'method', \"'Expected'\", \"'New value'\"],
    );
    plan tests => scalar \@test_plan;
}

\$DEBUG = \$ARGV[0] || 0;

\&do_tests;
";
}

=item C<&log_fail($call, $err)>

Logs an error for later analysis

e.g. C<print(&log_fail('new()', 'method unavailable');>

=cut
sub log_fail {
    my ($call, $err) = @_;
    push @{$FAILURES}, {
            "$seq" => {
            'test'  => $current_test,
            'class' => $class,
            'call'  => $call, 
            'err'   => $err, 
            'ret'   => $ret,
            'eval_error' => $@,
        }
    };
}

sub _debug_print {
    my ($expr, $expect, $check, $eval_error) = @_;
    $eval_error ||= $@;
    print 
"
    -----------------------------------------------------------------
    Test number     $seq
    Test specified  $current_test
    expression      $expr
    ret             $ret
    expect          $expect
    eval error      $eval_error
    eval err check  $check
    err             $err
";
}

#
# An internal utility to make all the checks
#
sub _do_checks {
    my ($eval, $expect, $check) = @_;
    my ($res, $expr, $eval_error);
    my $me = __PACKAGE__."::_do_checks";
    chomp($eval_error = $@);
    
    $eval_error =~ s/ \(\@INC contains.*/ .../;

    _debug_print($eval, $expect, $check, $eval_error) if $DEBUG > 4;

    # Do checks
    if (defined $expect && ($expect eq $EXPECT_ERROR)) {
        # We are expecting an error so see if it checks out
        print $Test::TESTOUT "Checking if '$eval_error' $check " if $DEBUG > 2;
        unless (eval "\$eval_error $check") {
            # We have an error but not what we expected :(
            $err = "Unexpected error returned by $eval ".
                "was '$eval_error' which fails check '$check'";
            &log_fail($eval, $err);
            return $FAIL;
        } else {
            # We have an eval_error that was expected :)
            $err = "Expected error returned by $eval: was $eval_error ";
            print $Test::TESTOUT $eval_error if $DEBUG > 2;
            print $Test::TESTOUT "call returned '$ret' - " if $DEBUG > 2;
            return $OK;
        }

    # We have an unexpected error :(
    } elsif ($eval_error) {
        $err = "$eval failed: ".$eval_error;
        &log_fail($eval, $err);
        return $FAIL;

    # No eval errors so we check the returned value
    } elsif (defined $expect) {
        print $Test::TESTOUT "call returned '$ret' - " if $DEBUG > 2;
        print $Test::TESTOUT "Checking if $expect - " if $DEBUG > 2;
        $expr = "'$ret' $expect";
        unless (eval $expr) {
            # The call returned the wrong thing :(
            $err = "Value returned by $eval ".
                "was '$ret' which fails check '$expect'";
            &log_fail($eval, $err);
            return $FAIL;
        } else {
            # The call returned what we were expecting :)
            print $Test::TESTOUT "all OK so far - " if $DEBUG > 2;
            return $OK;
        }

    } elsif (!$ret) {
        # The expression returned false when we were expecting something 'true' :(
        $err = "$eval - Returned false when we were expecting something 'true'";
        &log_fail($eval, $err);
        return $FAIL;

    } else {
        # The call returned something 'true' :)
        print $Test::TESTOUT "Returned '$ret' - " if $DEBUG > 2;
        return $OK;
    }
    # We should never get here
    $err = "Failure in $me - test engine is broken";
    &log_fail($eval, $err);
    return $FAIL;
}

=item C<&quit>

Quits any Gtk2->main event loop. You can use it in any signal_connect
calls in tests to quit the event loop.

e.g. C<>

=cut
sub quit {Gtk2->quit}

=item C<&print_handler_args($class)>

A utility signal handler that will print all args passed from the widget.
Use it in any signal_connect calls in tests to see what is passed.
e.g. C<>

=cut
sub print_handler_args {
    my ($test, $data) = @_;
    my $me = __PACKAGE__."->test_handler";

    print $Test::TESTOUT "Test handler received args \n", Dumper(\@_);
    
}

=item C<&print_widget_tree($class)>

A utility signal handler that will print all the widgets that have been
constructed so far.
Use it in any signal_connect calls in tests to see what is constructed.
e.g. C<>

=cut
sub print_widget_tree {
    my $me = __PACKAGE__."->print_widget_tree";

    print $Test::TESTOUT "Widget tree \$w is: ", Dumper($w);
    
}

sub make_test_box {
    my ($class) = @_;
    my $me = __PACKAGE__."->make_test_box";
    use Gtk2;
    Gtk2->init;
    my $use_ret = &try_use($class);
    return $use_ret if ($ENV{HARNESS_ACTIVE}) or $use_ret ne $OK;
    use Gtk2::Window;
    $w->{'Test'}{'Window'}[0] = new Gtk2::Window('toplevel');
    $w->{'Test'}{'Window'}[0]->set_position('center');
    $w->{'Test'}{'Window'}[0]->set_resizable($TRUE);
    $w->{'Test'}{'Window'}[0]->set_title("$class - interactive");
    $w->{'Test'}{'Window'}[0]->signal_connect('delete_event', sub{Gtk2->quit});
    $w->{'Test'}{'Window'}[0]->signal_connect('destroy', sub{Gtk2->quit});
    use Gtk2::VBox;
    $w->{'Test'}{'VBox'}[0] = new Gtk2::VBox(1, 1);
#    $w->{'Test'}{'VBox'}[0]->set_homogenous($FALSE);
    $w->{'Test'}{'Window'}[0]->add($w->{'Test'}{'VBox'}[0]);
    use Gtk2::HBox;
    $w->{'Test'}{'HBox'}[0] = new Gtk2::HBox(1, 1);
#    $w->{'Test'}{'HBox'}[0]->set_default_size(-1, -1);
    $w->{'Test'}{'VBox'}[0]->pack_end($w->{'Test'}{'HBox'}[0], 0, 0, 0);
    use Gtk2::Button;
    $w->{'Test'}{'Button'}[0] = Gtk2::Button->new_with_label('Print Widgets');
    $w->{'Test'}{'Button'}[0]->signal_connect('clicked', 'print_widget_tree');
    $w->{'Test'}{'Button'}[1] = Gtk2::Button->new_with_label('Quit');
    $w->{'Test'}{'Button'}[1]->signal_connect('clicked', sub{Gtk2->quit});
    $w->{'Test'}{'HBox'}[0]->add($w->{'Test'}{'Button'}[0]);
#    $w->{'Test'}{'HBox'}[0]->set_child_packing($w->{'Test'}{'Button'}[0], 0, 1, 0, 'start');
    $w->{'Test'}{'HBox'}[0]->add($w->{'Test'}{'Button'}[1]);
#    $w->{'Test'}{'HBox'}[0]->set_child_packing($w->{'Test'}{'Button'}[1], 0, 1, 0, 'start');
    $w->{'Test'}{'Button'}[1]->grab_focus;
    $w->{'Test'}{'Window'}[0]->show_all;
    return $OK;
}

sub add_to_test_box {
    my ($widget) = @_;
    return $OK if ($ENV{HARNESS_ACTIVE});
    $widget ||= $o;

    $widget->show;
    $w->{'Test'}{'VBox'}[0]->add($widget);
    return $OK;
}

=back

=head1 VARIABLES

=over 4

=item C<$o>

This is the widget instance that was constructed and is used for all
subsequent tests.

=item C<$w>

A hash of arrays where all constructed widgets instances are stored for use 
later - ie $o->add($w->{'Button'}[-1]);

=item C<$err>

The error string returned by the latest test.

=item C<$ret>

The value that was returned by the latest method call

=item C<$DEBUG>

Setting $DEBUG to a number > 0 will cause debugging messages to be printed

 Level  Output
 1      Method calls that will be tested
 2      Failed check on expected value
 3      new() calls
 4      All checks made on expected value
 5      A Data::Dumper print of $o on failure

=back

=cut

=head1 CONSTANTS

=over 4

=item C<$USE>   

This is a request to use() a class

=item C<$EVAL>   

This is a request to eval a string

=item C<$C_EVAL>   

This is a request to eval a C call (like Gtk2 methods)

=item C<$GET_SET>

This is a request to get/set/get a widget property

=item C<$EXPECT_ERROR>

We are expecting this call to fail and will apply the check to C<$err>
instead of C<$ret>.

=item Values to use in C<@test_plan>

These values can be used in the testplan to avoid escaping strings and to
make sure that the values get through to the test evals

 $NULL  Null string ('')
 $ZERO  Zero (0)
 $TRUE
 $FALSE
 $C_OK ''

=item Placeholder args

 $NOARGS
 $NOCHECK

=item C<$FAIL>

Returned in the event of failure.

=item C<$OK>

Returned if test succeeded

=item C<$PACKAGE> C<$VERSION> C<$AUTHOR> C<$DATE>

Details of the Gtk2::Test module

=back

=cut

=head1 SEE ALSO

The Test(3) manpage

=head1 AUTHOR

Dermot Musgrove <dermot.musgrove@virgin.net>

=head1 COPYRIGHT

Copyright (c) 2002. Dermot Musgrove. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut

1;
