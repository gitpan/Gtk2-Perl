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
 * $Id: Gdk.c,v 1.4 2002/11/28 11:55:38 ggc Exp $
 */

#include "gtk2-perl-gdk.h"


/** from gdk.h */

/* G_CONST_RETURN char *gdk_get_program_class (void) */
char* gdkperl_gdk_get_program_class(char* class)
{
    return gdk_get_program_class();
}

/* void gdk_set_program_class (const char *program_class) */
void gdkperl_gdk_set_program_class(char* class, gchar* program_class)
{
    gdk_set_program_class(program_class);
}

/* gchar* gdk_get_display (void) */
gchar* gdkperl_gdk_get_display(char* class)
{
    return gdk_get_display();
}

/* void gdk_flush (void) */
void gdkperl_gdk_flush(char* class)
{
    gdk_flush();
}

/* GdkGrabStatus gdk_pointer_grab (GdkWindow *window, gboolean owner_events,
                                   GdkEventMask event_mask, GdkWindow *confine_to,
                                   GdkCursor *cursor, guint32 time) */
SV* gdkperl_gdk_pointer_grab(char* class, SV* window, int owner_events,
			     SV* event_mask, SV* confine_to,
			     SV* cursor, int time)
{
    return newSVGdkGrabStatus(gdk_pointer_grab(SvGdkWindow(window), owner_events,
					       SvGdkEventMask(event_mask), SvGdkWindow_nullok(confine_to),
					       SvGdkCursor_nullok(cursor), time));
}

/* GdkGrabStatus gdk_keyboard_grab (GdkWindow *window, gboolean owner_events, guint32 time) */
SV* gdkperl_gdk_keyboard_grab(char* class, SV* window, int owner_events, int time)
{
    return newSVGdkGrabStatus(gdk_keyboard_grab(SvGdkWindow(window), owner_events, time));
}

#ifndef GDK_MULTIHEAD_SAFE

/* void gdk_pointer_ungrab (guint32 time) */
void gdkperl_gdk_pointer_ungrab(char* class, int time)
{
    gdk_pointer_ungrab(time);
}

/* void gdk_keyboard_ungrab (guint32 time) */
void gdkperl_gdk_keyboard_ungrab(char* class, int time)
{
    gdk_keyboard_ungrab(time);
}

/* gboolean gdk_pointer_is_grabbed (void) */
int gdkperl_gdk_pointer_is_grabbed(char* class)
{
    return gdk_pointer_is_grabbed();
}

/* gint gdk_screen_width (void) */
int gdkperl_gdk_screen_width(char* class)
{
    return gdk_screen_width();
}

/* gint gdk_screen_height (void) */
int gdkperl_gdk_screen_height(char* class)
{
    return gdk_screen_height();
}

/* gint gdk_screen_width_mm (void) */
int gdkperl_gdk_screen_width_mm(char* class)
{
    return gdk_screen_width_mm();
}

/* gint gdk_screen_height_mm (void) */
int gdkperl_gdk_screen_height_mm(char* class)
{
    return gdk_screen_height_mm();
}

/* void gdk_beep (void) */
void gdkperl_gdk_beep(char* class)
{
    gdk_beep();
}

#endif /* GDK_MULTIHEAD_SAFE */


/** from gdkx.h */

int gdkperl_gdk_ROOT_WINDOW(char* class)
{
    return GDK_ROOT_WINDOW();
}


/** from gdkkeys.h */

int gdkperl_gdk_keyval_from_name(char* class, gchar* keyval_name)
{
    return gdk_keyval_from_name(keyval_name);
}


/** from gdkevents.h */

/* void gdk_set_show_events (gboolean show_events) */
void gdkperl_gdk_set_show_events(char* class, int show_events)
{
    gdk_set_show_events(show_events);
}

/* gboolean gdk_get_show_events (void) */
int gdkperl_gdk_get_show_events(char* class)
{
    return gdk_get_show_events();
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
