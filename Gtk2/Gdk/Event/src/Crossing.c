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
 * $Id: Crossing.c,v 1.2 2002/12/13 15:22:44 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

/* access functions */

/* Note: type, window, send_event are gratuitous from Gtk2::Gdk::Event */

SV* gdkperl_event_crossing_subwindow(SV* event)
{
    return gtk2_perl_new_object(SvGdkEventCrossing(event)->subwindow);
}

int gdkperl_event_crossing_time(SV* event)
{
    return SvGdkEventCrossing(event)->time;
}

double gdkperl_event_crossing_x(SV* event)
{
    return SvGdkEventCrossing(event)->x;
}

double gdkperl_event_crossing_y(SV* event)
{
    return SvGdkEventCrossing(event)->y;
}

double gdkperl_event_crossing_x_root(SV* event)
{
    return SvGdkEventCrossing(event)->x_root;
}

double gdkperl_event_crossing_y_root(SV* event)
{
    return SvGdkEventCrossing(event)->y_root;
}

SV* gdkperl_event_crossing_mode(SV* event)
{
    return newSVGdkCrossingMode(SvGdkEventCrossing(event)->mode);
}

SV* gdkperl_event_crossing_detail(SV* event)
{
    return newSVGdkNotifyType(SvGdkEventCrossing(event)->detail);
}

int gdkperl_event_crossing_focus(SV* event)
{
    return SvGdkEventCrossing(event)->focus;
}

SV* gdkperl_event_crossing_state(SV* event)
{
    return newSVGdkModifierType(SvGdkEventCrossing(event)->state);
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
