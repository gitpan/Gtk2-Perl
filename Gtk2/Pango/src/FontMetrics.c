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
 * $Id: FontMetrics.c,v 1.1 2002/10/28 12:49:55 ggc Exp $
 */

#include "gtk2-perl-pango.h"

SV* pangoperl_font_metrics_ref(SV* metrics)
{
    return gtk2_perl_new_object_from_pointer(pango_font_metrics_ref(SvPangoFontMetrics(metrics)),
					     "Gtk2::Pango::FontMetrics");
}

void pangoperl_font_metrics_unref(SV* metrics)
{
    pango_font_metrics_unref(SvPangoFontMetrics(metrics));
}

int pangoperl_font_metrics_get_ascent(SV* metrics)
{
    return pango_font_metrics_get_ascent(SvPangoFontMetrics(metrics));
}

int pangoperl_font_metrics_get_descent(SV* metrics)
{
    return pango_font_metrics_get_descent(SvPangoFontMetrics(metrics));
}

int pangoperl_font_metrics_get_approximate_char_width(SV* metrics)
{
    return pango_font_metrics_get_approximate_char_width(SvPangoFontMetrics(metrics));
}

int pangoperl_font_metrics_get_approximate_digit_width(SV* metrics)
{
    return pango_font_metrics_get_approximate_digit_width(SvPangoFontMetrics(metrics));
}

