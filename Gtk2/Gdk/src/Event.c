/* $Id: Event.c,v 1.9 2002/11/19 16:46:55 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"


/* common fields between all types of events */

SV* gdkperl_event_type(SV* event)
{
    return newSVGdkEventType(((GdkEventAny*)SvGdkEvent(event))->type);
}

SV* gdkperl_event_window(SV* event)
{
    return gtk2_perl_new_object(((GdkEventAny*)SvGdkEvent(event))->window);
}

int gdkperl_event_send_event(SV* event)
{
    return ((GdkEventAny*)SvGdkEvent(event))->send_event;
}


/* guint32 gdk_event_get_time (GdkEvent *event) */
int gdkperl_event_get_time(SV* event)
{
    return gdk_event_get_time(SvGdkEvent(event));
}

/* gboolean gdk_event_get_coords (GdkEvent *event, gdouble *x_win, gdouble *y_win) */
SV* gdkperl_event__get_coords(SV* event)
{
    double x, y;
    AV* values;
    if (gdk_event_get_coords(SvGdkEvent(event), &x, &y)) {
	values = newAV();
	av_push(values, newSVnv(x));
	av_push(values, newSVnv(y));
	return newRV_noinc((SV*) values);
    } else
	return &PL_sv_undef;
}

/* gboolean gdk_event_get_root_coords (GdkEvent *event, gdouble *x_root, gdouble *y_root) */
SV* gdkperl_event__get_root_coords(SV* event)
{
    double x, y;
    AV* values;
    if (gdk_event_get_root_coords(SvGdkEvent(event), &x, &y)) {
	values = newAV();
	av_push(values, newSVnv(x));
	av_push(values, newSVnv(y));
	return newRV_noinc((SV*) values);
    } else
	return &PL_sv_undef;
}


/* utility functions */

SV* gdkperl_event_make(GdkEvent* event)
{
    char* class = "Gtk2::Gdk::Event"; // default event structure
    switch(event->type) {
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
	class = "Gtk2::Gdk::Event::Button";
	break;
    case GDK_SCROLL:
	class = "Gtk2::Gdk::Event::Scroll";
	break;
    case 0:
    case GDK_MOTION_NOTIFY:
	class = "Gtk2::Gdk::Event::Motion";
	break;
    case GDK_EXPOSE:
	class = "Gtk2::Gdk::Event::Expose";
	break;
    case GDK_VISIBILITY_NOTIFY:
	class = "Gtk2::Gdk::Event::Visibility";
	break;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
	class = "Gtk2::Gdk::Event::Crossing";
	break;
    case GDK_FOCUS_CHANGE:
	class = "Gtk2::Gdk::Event::Focus";
	break;
    case GDK_CONFIGURE:
	class = "Gtk2::Gdk::Event::Configure";
	break;
    case GDK_PROPERTY_NOTIFY:
	class = "Gtk2::Gdk::Event::Property";
	break;
    case GDK_SELECTION_CLEAR:
    case GDK_SELECTION_REQUEST:
    case GDK_SELECTION_NOTIFY:
	class = "Gtk2::Gdk::Event::Selection";
	break;
    case GDK_DRAG_ENTER:
    case GDK_DRAG_LEAVE:
    case GDK_DRAG_MOTION:
    case GDK_DRAG_STATUS:
    case GDK_DROP_START:
    case GDK_DROP_FINISHED:
	class = "Gtk2::Gdk::Event::DND";
	break;
    case GDK_PROXIMITY_IN:
    case GDK_PROXIMITY_OUT:
	class = "Gtk2::Gdk::Event::Proximity";
	break;
    case GDK_CLIENT_EVENT:
	class = "Gtk2::Gdk::Event::Client";
	break;
    case GDK_NO_EXPOSE:
	class = "Gtk2::Gdk::Event::NoExpose";
	break;
    case GDK_WINDOW_STATE:
	class = "Gtk2::Gdk::Event::WindowState";
	break;
    case GDK_SETTING:
	class = "Gtk2::Gdk::Event::Setting";
	break;
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
	class = "Gtk2::Gdk::Event::Key";
	break;
    default:
	/*	
	  GDK_NOTHING		= -1,
	  GDK_DELETE		= 0,
	  GDK_DESTROY		= 1,
	  GDK_MAP		= 14,
	  GDK_UNMAP		= 15,
	  GDK_SCROLL            = 31,
	*/
	break; // return gtk2_perl_new_object_from_pointer(event, "Gtk2::Gdk::Event");
    }
    return gtk2_perl_new_object_from_pointer(event, class);
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
