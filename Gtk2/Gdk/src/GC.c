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
 * $Id: GC.c,v 1.1 2002/10/21 18:30:14 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_gc_new(char* class, SV* drawable)
{
    /* I need to specify the class, if not I get Gtk2::Gdk::GCX11 :) */
    return gtk2_perl_new_object_from_pointer(gdk_gc_new(SvGdkDrawable(drawable)), class);
}

void gdkperl_gc_set_rgb_bg_color(SV* gc, SV* color)
{
    gdk_gc_set_rgb_bg_color(SvGdkGC(gc), SvGdkColor(color));
}

void gdkperl_gc_set_rgb_fg_color(SV* gc, SV* color)
{
    gdk_gc_set_rgb_fg_color(SvGdkGC(gc), SvGdkColor(color));
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
