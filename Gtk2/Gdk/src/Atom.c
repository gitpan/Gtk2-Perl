/* $Id: Atom.c,v 1.6 2002/11/05 17:01:59 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_atom_new(GdkAtom atom) 
{
    return gtk2_perl_new_object_from_pointer(atom, "Gtk2::Gdk::Atom");
}

SV* gdkperl_atom__intern(char* class, char* atom_name, int only_if_exists)
{
    return gdkperl_atom_new(gdk_atom_intern(atom_name, only_if_exists));
}


char* gdkperl_atom_name(SV* atom)
{
    return gdk_atom_name((GdkAtom) SvIV(SvRV(atom)));
}


