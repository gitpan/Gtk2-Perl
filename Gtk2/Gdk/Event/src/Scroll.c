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
 * $Id: Scroll.c,v 1.1 2002/12/13 15:29:22 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

/* access functions */

/* Note: type, window, send_event are gratuitous from Gtk2::Gdk::Event */

int gdkperl_event_scroll_time(SV* event)
{
    return SvGdkEventScroll(event)->time;
}

double gdkperl_event_scroll_x(SV* event)
{
    return SvGdkEventScroll(event)->x;
}

double gdkperl_event_scroll_y(SV* event)
{
    return SvGdkEventScroll(event)->y;
}

SV* gdkperl_event_scroll_state(SV* event)
{
    return newSVGdkModifierType(SvGdkEventScroll(event)->state);
}

SV* gdkperl_event_scroll_direction(SV* event)
{
    return newSVGdkScrollDirection(SvGdkEventScroll(event)->direction);
}

// MISSING device

double gdkperl_event_scroll_x_root(SV* event)
{
    return SvGdkEventScroll(event)->x_root;
}

double gdkperl_event_scroll_y_root(SV* event)
{
    return SvGdkEventScroll(event)->y_root;
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
