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
 * $Id: Rectangle.c,v 1.1 2002/11/08 18:02:50 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_rectangle_new(char* class, int x, int y, int width, int height)
{
    GdkRectangle* rect = g_malloc0(sizeof(GdkRectangle));
    rect->x = x;
    rect->y = y;
    rect->width = width;
    rect->height = height;
    return gtk2_perl_new_object_from_pointer(rect, class);
}

SV* gdkperl_rectangle__values(SV* rectangle)
{
    AV* values = newAV();
    av_push(values, newSViv(SvGdkRectangle(rectangle)->x));
    av_push(values, newSViv(SvGdkRectangle(rectangle)->y));
    av_push(values, newSViv(SvGdkRectangle(rectangle)->width));
    av_push(values, newSViv(SvGdkRectangle(rectangle)->height));
    return newRV_noinc((SV*) values);
}

int gdkperl_rectangle_x(SV* rectangle)
{
    return SvGdkRectangle(rectangle)->x;
}

int gdkperl_rectangle_y(SV* rectangle)
{
    return SvGdkRectangle(rectangle)->y;
}

int gdkperl_rectangle_width(SV* rectangle)
{
    return SvGdkRectangle(rectangle)->width;
}

int gdkperl_rectangle_height(SV* rectangle)
{
    return SvGdkRectangle(rectangle)->height;
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
