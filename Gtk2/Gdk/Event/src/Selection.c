/*
 * Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: Selection.c,v 1.1 2002/12/13 15:48:16 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

/* access functions */

/* Note: type, window, send_event are gratuitous from Gtk2::Gdk::Event */

SV* gdkperl_event_selection_selection(SV* event)
{
    return gtk2_perl_new_object_from_pointer(&(SvGdkEventSelection(event)->selection), "Gtk2::Gdk::Atom");
}

SV* gdkperl_event_selection_target(SV* event)
{
    return gtk2_perl_new_object_from_pointer(&(SvGdkEventSelection(event)->target), "Gtk2::Gdk::Atom");
}

SV* gdkperl_event_selection_property(SV* event)
{
    return gtk2_perl_new_object_from_pointer(&(SvGdkEventSelection(event)->property), "Gtk2::Gdk::Atom");
}

int gdkperl_event_selection_time(SV* event)
{
    return SvGdkEventSelection(event)->time;
}

int gdkperl_event_selection_requestor(SV* event)
{
    return SvGdkEventSelection(event)->requestor;
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
