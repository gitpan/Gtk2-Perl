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
 * $Id: Pixbuf.c,v 1.2 2002/12/12 16:41:53 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_pixbuf_new(char* class, SV* colorspace, int has_alpha, int bits_per_sample, int width, int height)
{
    return gtk2_perl_new_object(gdk_pixbuf_new(SvGdkColorspace(colorspace), has_alpha, bits_per_sample, width, height));
}

SV* gdkperl_pixbuf_copy(SV* pixbuf)
{
    return gtk2_perl_new_object(gdk_pixbuf_copy(SvGdkPixbuf(pixbuf)));
}

SV* gdkperl_pixbuf_new_subpixbuf(SV* src_pixbuf, int src_x, int src_y, int width, int height)
{
    return gtk2_perl_new_object(gdk_pixbuf_new_subpixbuf(SvGdkPixbuf(src_pixbuf), src_x, src_y, width, height));
}

SV* gdkperl_pixbuf_new_from_file(char* class, char* filename)
{
    GError* error = NULL;
    GdkPixbuf* g_pixbuf = gdk_pixbuf_new_from_file(filename, &error);
    if (!g_pixbuf) {
	SV* msg = newSVpv(error->message, 0);
	g_error_free(error);
	croak("FATAL: error loading image: %s", SvPV_nolen(msg));
    }
    return gtk2_perl_new_object(g_pixbuf);
}


SV* gdkperl_pixbuf_get_colorspace(SV* pixbuf)
{
    return newSVGdkColorspace(gdk_pixbuf_get_colorspace(SvGdkPixbuf(pixbuf)));
}

int gdkperl_pixbuf_get_n_channels(SV* pixbuf)
{
    return gdk_pixbuf_get_n_channels(SvGdkPixbuf(pixbuf));
}

int gdkperl_pixbuf_get_has_alpha(SV* pixbuf)
{
    return gdk_pixbuf_get_has_alpha(SvGdkPixbuf(pixbuf));
}

int gdkperl_pixbuf_get_bits_per_sample(SV* pixbuf)
{
    return gdk_pixbuf_get_bits_per_sample(SvGdkPixbuf(pixbuf));
}

/* guchar       *gdk_pixbuf_get_pixels          (const GdkPixbuf *pixbuf); */

int gdkperl_pixbuf_get_width(SV* pixbuf)
{
    return gdk_pixbuf_get_width(SvGdkPixbuf(pixbuf));
}

int gdkperl_pixbuf_get_height(SV* pixbuf)
{
    return gdk_pixbuf_get_height(SvGdkPixbuf(pixbuf));
}

int gdkperl_pixbuf_get_rowstride(SV* pixbuf)
{
    return gdk_pixbuf_get_rowstride(SvGdkPixbuf(pixbuf));
}


void gdkperl_pixbuf_render_threshold_alpha(SV* pixbuf, SV* bitmap,
					   int src_x, int src_y, int dest_x, int dest_y, int width, int height,
					   int alpha_threshold)
{
    gdk_pixbuf_render_threshold_alpha(SvGdkPixbuf(pixbuf), SvGdkBitmap(bitmap),
				      src_x, src_y, dest_x, dest_y, width, height,
				      alpha_threshold);
}

void gdkperl_pixbuf_render_to_drawable(SV* pixbuf, SV* drawable, SV* gc,
				       int src_x, int src_y, int dest_x, int dest_y, int width, int height,
				       SV* dither, int x_dither, int y_dither)
{
    gdk_pixbuf_render_to_drawable(SvGdkPixbuf(pixbuf), SvGdkDrawable(drawable), SvGdkGC(gc),
				  src_x, src_y, dest_x, dest_y, width, height,
				  SvGdkRgbDither(dither), x_dither, y_dither);
}

void gdkperl_pixbuf_render_to_drawable_alpha(SV* pixbuf, SV* drawable,
					     int src_x, int src_y, int dest_x, int dest_y, int width, int height,
					     SV* alpha_mode, int alpha_threshold,
					     SV* dither, int x_dither, int y_dither)
{
    gdk_pixbuf_render_to_drawable_alpha(SvGdkPixbuf(pixbuf), SvGdkDrawable(drawable),
					src_x, src_y, dest_x, dest_y, width, height,
					SvGdkPixbufAlphaMode(alpha_mode), alpha_threshold,
					SvGdkRgbDither(dither), x_dither, y_dither);
}


void gdkperl_pixbuf_scale(SV* src, SV* dest,
			  int dest_x, int dest_y, int dest_width, int dest_height,
			  double offset_x, double offset_y, double scale_x, double scale_y,
			  SV* interp_type)
{
    gdk_pixbuf_scale(SvGdkPixbuf(src), SvGdkPixbuf(dest),
		     dest_x, dest_y, dest_width, dest_height,
		     offset_x, offset_y, scale_x, scale_y,
		     SvGdkInterpType(interp_type));
}

void gdkperl_pixbuf_composite(SV* src, SV* dest,
			      int dest_x, int dest_y, int dest_width, int dest_height,
			      double offset_x, double offset_y, double scale_x, double scale_y,
			      SV* interp_type, int overall_alpha)
{
    gdk_pixbuf_composite(SvGdkPixbuf(src), SvGdkPixbuf(dest),
			 dest_x, dest_y, dest_width, dest_height,
			 offset_x, offset_y, scale_x, scale_y,
			 SvGdkInterpType(interp_type), overall_alpha);
}

void gdkperl_pixbuf_composite_color(SV* src, SV* dest,
				    int dest_x, int dest_y, int dest_width, int dest_height,
				    double offset_x, double offset_y, double scale_x, double scale_y,
				    SV* interp_type, int overall_alpha,
				    int check_x, int check_y, int check_size, I32 color1, I32 color2)
{
    gdk_pixbuf_composite_color(SvGdkPixbuf(src), SvGdkPixbuf(dest),
			       dest_x, dest_y, dest_width, dest_height,
			       offset_x, offset_y, scale_x, scale_y,
			       SvGdkInterpType(interp_type), overall_alpha,
			       check_x, check_y, check_size, color1, color2);
}

SV* gdkperl_pixbuf_scale_simple(SV* src, int dest_width, int dest_height, SV* interp_type)
{
    return gtk2_perl_new_object(gdk_pixbuf_scale_simple(SvGdkPixbuf(src),
							dest_width, dest_height,
							SvGdkInterpType(interp_type)));
}

SV* gdkperl_pixbuf_composite_color_simple(SV* src,
					  int dest_width, int dest_height,
					  SV* interp_type, int overall_alpha,
					  int check_size, I32 color1, I32 color2)
{
    return gtk2_perl_new_object(gdk_pixbuf_composite_color_simple(SvGdkPixbuf(src),
								  dest_width, dest_height,
								  SvGdkInterpType(interp_type), overall_alpha,
								  check_size, color1, color2));
}


/** Utilities */

/* void gdk_pixbuf_fill (GdkPixbuf *pixbuf, guint32 pixel) */
void gdkperl_pixbuf_fill(SV* pixbuf, int pixel)
{
    gdk_pixbuf_fill(SvGdkPixbuf(pixbuf), pixel);
}

/* GdkPixbuf *gdk_pixbuf_add_alpha (const GdkPixbuf *pixbuf, gboolean substitute_color,
                                    guchar r, guchar g, guchar b) */
SV* gdkperl_pixbuf_add_alpha(SV* pixbuf, int substitute_color,
			     int r, int g, int b)
{
    return gtk2_perl_new_object(gdk_pixbuf_add_alpha(SvGdkPixbuf(pixbuf), substitute_color,
						     r, g, b));
}

/* void gdk_pixbuf_copy_area (const GdkPixbuf *src_pixbuf, int src_x, int src_y, int width, int height,
                              GdkPixbuf *dest_pixbuf, int dest_x, int dest_y) */
void gdkperl_pixbuf_copy_area(SV* src_pixbuf, int src_x, int src_y, int width, int height,
			      SV* dest_pixbuf, int dest_x, int dest_y)
{
    gdk_pixbuf_copy_area(SvGdkPixbuf(src_pixbuf), src_x, src_y, width, height,
			 SvGdkPixbuf(dest_pixbuf), dest_x, dest_y);
}

/* void gdk_pixbuf_saturate_and_pixelate (const GdkPixbuf *src, GdkPixbuf *dest, gfloat saturation, gboolean pixelate) */
void gdkperl_pixbuf_saturate_and_pixelate(SV* src, SV* dest, double saturation, int pixelate)
{
    gdk_pixbuf_saturate_and_pixelate(SvGdkPixbuf(src), SvGdkPixbuf(dest), saturation, pixelate);
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
