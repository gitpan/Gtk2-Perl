/* $Id: Color.c,v 1.6 2002/11/15 11:38:42 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"

static GdkColor* make_gdkcolor(int red, int green, int blue)
{
    GdkColor* p = g_malloc0(sizeof(GdkColor));
    p->red = red;
    p->green = green;
    p->blue = blue;
    return p;
}

SV* gdkperl_color_new(char* class, int red, int green, int blue)
{
    return gtk2_perl_new_object_from_pointer(make_gdkcolor(red, green, blue), class);
}

SV* gdkperl_color_new0(char* class)
{
    return gtk2_perl_new_object_from_pointer(make_gdkcolor(0, 0, 0), class);
}

int  gdkperl_color_get_red(SV* gc) { return (SvGdkColor(gc))->red; }
void gdkperl_color_set_red(SV* gc, int v) { (SvGdkColor(gc))->red = v; }
int  gdkperl_color_get_green(SV* gc) { return (SvGdkColor(gc))->green; }
void gdkperl_color_set_green(SV* gc, int v) { (SvGdkColor(gc))->green = v; }
int  gdkperl_color_get_blue(SV* gc) { return (SvGdkColor(gc))->blue; }
void gdkperl_color_set_blue(SV* gc, int v) { (SvGdkColor(gc))->blue = v; }

void gdkperl_color_set_rgb(SV* gc, int red, int green, int blue)
{
    GdkColor* color = SvGdkColor(gc);
    color->red = red;
    color->green = green;
    color->blue = blue;
}

SV* gdkperl_color_parse(char* class, char* spec)
{
    GdkColor* c = g_malloc0(sizeof(GdkColor));
    if (gdk_color_parse(spec, c))
	return gtk2_perl_new_object_from_pointer_nullok(c, "Gtk2::Gdk::Color");
    else {
	g_free(c);
	return &PL_sv_undef;
    }
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
