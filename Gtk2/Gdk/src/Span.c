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
 * $Id: Span.c,v 1.1 2002/11/08 18:02:51 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_span_new(char* class, int x, int y, int width)
{
    GdkSpan* span = g_malloc0(sizeof(GdkSpan));
    span->x = x;
    span->y = y;
    span->width = width;
    return gtk2_perl_new_object_from_pointer(span, class);
}

SV* gdkperl_span__values(SV* span)
{
    AV* values = newAV();
    av_push(values, newSViv(SvGdkSpan(span)->x));
    av_push(values, newSViv(SvGdkSpan(span)->y));
    av_push(values, newSViv(SvGdkSpan(span)->width));
    return newRV_noinc((SV*) values);
}

int gdkperl_span_x(SV* span)
{
    return SvGdkSpan(span)->x;
}

int gdkperl_span_y(SV* span)
{
    return SvGdkSpan(span)->y;
}

int gdkperl_span_width(SV* span)
{
    return SvGdkSpan(span)->width;
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
