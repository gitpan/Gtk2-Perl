/* $Id: Configure.c,v 1.1 2002/12/13 15:39:03 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"

/* access functions */

/* Note: type, window, send_event are gratuitous from Gtk2::Gdk::Event */

int gdkperl_event_configure_x(SV* event)
{
    return SvGdkEventConfigure(event)->x;
}

int gdkperl_event_configure_y(SV* event)
{
    return SvGdkEventConfigure(event)->y;
}

int gdkperl_event_configure_width(SV* event)
{
    return SvGdkEventConfigure(event)->width;
}

int gdkperl_event_configure_height(SV* event)
{
    return SvGdkEventConfigure(event)->height;
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
