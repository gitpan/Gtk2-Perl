#
# Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License
# version 2, as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# $Id: _Helpers.pm,v 1.10 2002/11/11 17:49:44 ggc Exp $
#

package Gtk2::_Helpers;


our $rcsid = '$Id: _Helpers.pm,v 1.10 2002/11/11 17:49:44 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }


# ``Gtk2::_Helpers::deprecated('new_func_name', @_)''
# in a deprecated function
sub deprecated {
    my ($func, @args) = @_;
    my $deprecated_func = (caller(1))[3];
    printf STDERR "%s: this function is deprecated, please use `%s'\n", $deprecated_func, $func;
    $deprecated_func =~ /^(.*::)[^:]+$/ or die "Could not guess in which module to call the function.";
    "$1$func"->(@args);
}

# ``Gtk2::_Helpers::check_usage(\@_, [], [ 'string label' ], ..)''
# each arrayref specifies a number of arguments with their types
# with which the calling function may be called by the user
sub check_usage {
    my ($args, @possible_usages) = @_;
    foreach (@possible_usages) {
	return if (@$args-1 == @$_);
    }
    my $caller = (caller(1))[3];
    die "Usage: ".join(' or ', map { "$caller(".join(', ', @$_).")" } @possible_usages);
}

1;
