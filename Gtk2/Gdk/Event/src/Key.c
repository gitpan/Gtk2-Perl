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
 * $Id: Key.c,v 1.2 2002/11/07 12:06:07 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

/* access functions */

/* Note: type, window, send_event are gratuitous from Gtk2::Gdk::Event */

int gdkperl_event_key_time(SV* event)
{
    return SvGdkEventKey(event)->time;
}

SV* gdkperl_event_key_state(SV* event)
{
    return newSVGdkModifierType(SvGdkEventKey(event)->state);
}

int gdkperl_event_key_keyval(SV* event)
{
    return SvGdkEventKey(event)->keyval;
}

int gdkperl_event_key_length(SV* event)
{
    return SvGdkEventKey(event)->length;
}

gchar* gdkperl_event_key_string(SV* event)
{
    return SvGdkEventKey(event)->string;
}

int gdkperl_event_key_hardware_keycode(SV* event)
{
    return SvGdkEventKey(event)->hardware_keycode;
}

int gdkperl_event_key_group(SV* event)
{
    return SvGdkEventKey(event)->group;
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
