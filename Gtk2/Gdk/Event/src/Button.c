/* $Id: Button.c,v 1.4 2002/11/07 12:06:07 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"

/* access functions */

/* Note: type, window, send_event are gratuitous from Gtk2::Gdk::Event */

int gdkperl_event_button_time(SV* event)
{
    return SvGdkEventButton(event)->time;
}

double gdkperl_event_button_x(SV* event)
{
    return SvGdkEventButton(event)->x;
}

double gdkperl_event_button_y(SV* event)
{
    return SvGdkEventButton(event)->y;
}

// MISSING axes

SV* gdkperl_event_button_state(SV* event)
{
    return newSVGdkModifierType(SvGdkEventButton(event)->state);
}

int gdkperl_event_button_button(SV* event)
{
    return SvGdkEventButton(event)->button;
}

// MISSING device

double gdkperl_event_button_x_root(SV* event)
{
    return SvGdkEventButton(event)->x_root;
}

double gdkperl_event_button_y_root(SV* event)
{
    return SvGdkEventButton(event)->y_root;
}




/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
