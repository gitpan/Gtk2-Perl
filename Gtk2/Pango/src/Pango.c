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
 * $Id: Pango.c,v 1.4 2002/12/16 17:56:05 ggc Exp $
 */

#include "gtk2-perl-pango.h"

int pangoperl_pango_PANGO_PIXELS(char* class, int value)
{
    return PANGO_PIXELS(value);
}

double pangoperl_pango_PANGO_SCALE_XX_SMALL(char* class)
{
    return PANGO_SCALE_XX_SMALL;
}

double pangoperl_pango_PANGO_SCALE_X_SMALL(char* class)
{
    return PANGO_SCALE_X_SMALL ;
}

double pangoperl_pango_PANGO_SCALE_SMALL(char* class)
{
    return PANGO_SCALE_SMALL   ;
}

double pangoperl_pango_PANGO_SCALE_MEDIUM(char* class)
{
    return PANGO_SCALE_MEDIUM  ;
}

double pangoperl_pango_PANGO_SCALE_LARGE(char* class)
{
    return PANGO_SCALE_LARGE   ;
}

double pangoperl_pango_PANGO_SCALE_X_LARGE(char* class)
{
    return PANGO_SCALE_X_LARGE ;
}

double pangoperl_pango_PANGO_SCALE_XX_LARGE(char* class)
{
    return PANGO_SCALE_XX_LARGE;
}


