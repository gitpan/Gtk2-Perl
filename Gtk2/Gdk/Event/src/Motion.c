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
 * $Id: Motion.c,v 1.1 2002/11/07 12:06:07 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

/* access functions */

/* Note: type, window, send_event are gratuitous from Gtk2::Gdk::Event */

int gdkperl_event_motion_time(SV* event)
{
    return SvGdkEventMotion(event)->time;
}

double gdkperl_event_motion_x(SV* event)
{
    return SvGdkEventMotion(event)->x;
}

double gdkperl_event_motion_y(SV* event)
{
    return SvGdkEventMotion(event)->y;
}

// MISSING axes

SV* gdkperl_event_motion_state(SV* event)
{
    return newSVGdkModifierType(SvGdkEventMotion(event)->state);
}

int gdkperl_event_motion_is_hint(SV* event)
{
    return SvGdkEventMotion(event)->is_hint;
}

// MISSING device

double gdkperl_event_motion_x_root(SV* event)
{
    return SvGdkEventMotion(event)->x_root;
}

double gdkperl_event_motion_y_root(SV* event)
{
    return SvGdkEventMotion(event)->y_root;
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
