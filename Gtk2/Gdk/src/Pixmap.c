/* $Id: Pixmap.c,v 1.4 2002/11/27 13:18:21 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"

/* GdkPixmap* gdk_pixmap_new (GdkWindow *window, gint width, gint height, gint depth) */
SV* gdkperl_pixmap_new(char* class, SV* window, int width, int height, int depth)
{
    return gtk2_perl_new_object(gdk_pixmap_new(SvGdkWindow(window), width, height, depth));
}

/* GdkPixmap* gdk_pixmap_create_from_data (GdkWindow *window, const gchar *data, gint width, gint height, gint depth,
                                           GdkColor *fg, GdkColor *bg) */
SV* gdkperl_pixmap_create_from_data(char* class, SV* window, char* data, int width, int height, int depth, SV* fg, SV* bg)
{
    return gtk2_perl_new_object(gdk_pixmap_create_from_data(SvGdkWindow(window), data, width, height, depth, SvGdkColor(fg), SvGdkColor(bg)));
}

/* NOT IMPLEMENTED YET
GdkPixmap*  gdk_pixmap_create_from_xpm      (GdkWindow *window,
                                             GdkBitmap **mask,
                                             GdkColor *transparent_color,
                                             const gchar *filename);
GdkPixmap*  gdk_pixmap_colormap_create_from_xpm
                                            (GdkWindow *window,
                                             GdkColormap *colormap,
                                             GdkBitmap **mask,
                                             GdkColor *transparent_color,
                                             const gchar *filename);
*/

SV* gdkperl_pixmap__create_from_xpm_d(char* class, SV *window,
				       SV* xparent_color, SV *data, int wantmask)
{
    int i, len;
    char** cdata;
    SV* pixmap;
    GdkBitmap* mask;
    AV* ret;
    AV* avdata = (AV*) SvRV(data);
    len = av_len(avdata);
    cdata = g_malloc(len * sizeof(char*));
    for (i = 0; i < len; i++) {
	SV** sv = av_fetch(avdata, i, 0);
	// fprintf(stderr, "%s\n", SvPV_nolen(*sv));
	cdata[i] = strdup(SvPV_nolen(*sv));
    }
    pixmap = 
	gtk2_perl_new_object_from_pointer(gdk_pixmap_create_from_xpm_d(SvGdkWindow(window), 
								       wantmask ? &mask : NULL,
								       SvGdkColor(xparent_color),
								       cdata),
					  class);
    ret = newAV();
    av_push(ret,pixmap);
    if (wantmask)
	av_push(ret,gtk2_perl_new_object_from_pointer(mask, "Gtk2::Gdk::Bitmap"));
    // FIXME: should we free or not?
    for (i = 0; i < len; i++) { g_free(cdata[i]); }
    return newRV_noinc((SV*) ret);
}

/*
GdkPixmap*  gdk_pixmap_colormap_create_from_xpm_d
                                            (GdkWindow *window,
                                             GdkColormap *colormap,
                                             GdkBitmap **mask,
                                             GdkColor *transparent_color,
                                             gchar **data);
#define     gdk_pixmap_ref
#define     gdk_pixmap_unref
*/
