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
 * $Id: Drawable.c,v 1.9 2002/12/02 21:44:00 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_drawable__get_size(SV* window)
{
    gint w, h;
    AV* size = newAV();
    gdk_drawable_get_size(SvGdkDrawable(window), &w, &h);
    av_push(size, newSViv(w));
    av_push(size, newSViv(h));
    return newRV_noinc((SV*) size);
}

/* void gdk_drawable_set_colormap (GdkDrawable *drawable, GdkColormap *colormap) */
void gdkperl_drawable_set_colormap(SV* drawable, SV* colormap)
{
    gdk_drawable_set_colormap(SvGdkDrawable(drawable), SvGdkColormap(colormap));
}

/* GdkColormap* gdk_drawable_get_colormap (GdkDrawable *drawable) */
SV* gdkperl_drawable_get_colormap(SV* drawable)
{
    return gtk2_perl_new_object_from_pointer_nullok(gdk_drawable_get_colormap(SvGdkDrawable(drawable)),
						    "Gtk2::Gdk::Colormap");
}

/* gint gdk_drawable_get_depth (GdkDrawable *drawable) */
int gdkperl_drawable_get_depth(SV* drawable)
{
    return gdk_drawable_get_depth(SvGdkDrawable(drawable));
}

/* void gdk_draw_point (GdkDrawable *drawable, GdkGC *gc, gint x, gint y) */
void gdkperl_drawable_draw_point(SV* drawable, SV* gc, int x, int y)
{
    gdk_draw_point(SvGdkDrawable(drawable), SvGdkGC(gc), x, y);
}

/* void gdk_draw_line (GdkDrawable *drawable, GdkGC *gc, gint x1, gint y1, gint x2, gint y2) */
void gdkperl_drawable_draw_line(SV* drawable, SV* gc, int x1, int y1, int x2, int y2)
{
    gdk_draw_line(SvGdkDrawable(drawable), SvGdkGC(gc), x1, y1, x2, y2);
}

void gdkperl_drawable_draw_rectangle(SV* drawable, SV* gc, int filled, int x, int y, int width, int height)
{
    gdk_draw_rectangle(SvGdkDrawable(drawable), SvGdkGC(gc), filled, x, y, width, height);
}

/* void gdk_draw_arc (GdkDrawable *drawable, GdkGC *gc, gint filled, gint x, gint y, gint width, gint height, gint angle1, gint angle2) */
void gdkperl_drawable_draw_arc(SV* drawable, SV* gc, int filled, int x, int y, int width, int height, int angle1, int angle2)
{
    gdk_draw_arc(SvGdkDrawable(drawable), SvGdkGC(gc), filled, x, y, width, height, angle1, angle2);
}

/* let's be clever and factorize a bit the drawing functions that take an array of boxed types */
#define draw_array_of_boxed_types(array, type, func)                               \
{                                                                                  \
    AV* values = (AV*) SvRV(array);						   \
    int n_values = av_len(values) + 1;						   \
    type* g_values = g_malloc0(sizeof(type) * n_values);			   \
    int i;									   \
    for (i=0; i<n_values; i++)							   \
	memcpy(&g_values[i], Sv##type(*av_fetch(values, i, 0)), sizeof(type));     \
    func;									   \
    g_free(g_values);                                                              \
}

/* void gdk_draw_polygon (GdkDrawable *drawable, GdkGC *gc, gint filled, GdkPoint *points, gint npoints) */
void gdkperl_drawable__draw_polygon(SV* drawable, SV* gc, int filled, SV* points)
{
    draw_array_of_boxed_types(points, GdkPoint,
			      gdk_draw_polygon(SvGdkDrawable(drawable), SvGdkGC(gc), filled, g_values, n_values));
}

void gdkperl_drawable_draw_drawable(SV* drawable, SV* gc, SV* src, int xsrc, int ysrc, int xdest, int ydest, int width, int height)
{
    gdk_draw_drawable(SvGdkDrawable(drawable), SvGdkGC(gc), SvGdkDrawable(src), xsrc, ysrc, xdest, ydest, width, height);
}

void gdkperl_drawable_draw_image(SV* drawable, SV* gc, SV* image, int xsrc, int ysrc, int xdest, int ydest, int width, int height)
{
    gdk_draw_image(SvGdkDrawable(drawable), SvGdkGC(gc), SvGdkImage(image), xsrc, ysrc, xdest, ydest, width, height);
}

/* void gdk_draw_points (GdkDrawable *drawable, GdkGC *gc, GdkPoint *points, gint npoints) */
void gdkperl_drawable__draw_points(SV* drawable, SV* gc, SV* points)
{
    draw_array_of_boxed_types(points, GdkPoint,
			      gdk_draw_points(SvGdkDrawable(drawable), SvGdkGC(gc), g_values, n_values));
}

/* void gdk_draw_segments (GdkDrawable *drawable, GdkGC *gc, GdkSegment *segs, gint nsegs) */
void gdkperl_drawable__draw_segments(SV* drawable, SV* gc, SV* segs)
{
    draw_array_of_boxed_types(segs, GdkSegment,
			      gdk_draw_segments(SvGdkDrawable(drawable), SvGdkGC(gc), g_values, n_values));
}

/* void gdk_draw_lines (GdkDrawable *drawable, GdkGC *gc, GdkPoint *points, gint npoints) */
void gdkperl_drawable__draw_lines(SV* drawable, SV* gc, SV* points)
{
    draw_array_of_boxed_types(points, GdkPoint,
			      gdk_draw_lines(SvGdkDrawable(drawable), SvGdkGC(gc), g_values, n_values));
}

void gdkperl_drawable_draw_layout(SV* drawable, SV* gc, int x, int y, SV* layout)
{
    gdk_draw_layout(SvGdkDrawable(drawable), SvGdkGC(gc), x, y, SvPangoLayout(layout));
}

/* #define GDK_DRAWABLE_XID(win)           (gdk_x11_drawable_get_xid (win)) */
int gdkperl_drawable_XID(SV* drawable)
{
    return GDK_DRAWABLE_XID(SvGdkDrawable(drawable));
}

/* #define GDK_WINDOW_XWINDOW(win)       (gdk_x11_drawable_get_xid (win)) */
int gdkperl_drawable_XWINDOW(SV* drawable)
{
    return GDK_WINDOW_XWINDOW(SvGdkDrawable(drawable));
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
