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
 * $Id: Ruler.c,v 1.4 2002/10/21 11:41:23 ggc Exp $
 */

#include "gtk2-perl.h"

void gtkperl_ruler_set_metric(SV* ruler, SV* metric)
{
    gtk_ruler_set_metric(SvGtkRuler(ruler), SvGtkMetricType(metric));
}

void gtkperl_ruler_set_range(SV* ruler, double lower, double upper, double position, double max_size)
{
    gtk_ruler_set_range(SvGtkRuler(ruler), lower, upper, position, max_size);
}

int gtkperl_ruler_get_metric(SV* ruler)
{
    return gtk_ruler_get_metric(SvGtkRuler(ruler));
}

//void gtk_ruler_get_range(GtkRuler *ruler, double *lower, double *upper, double *position, double *max_size);


