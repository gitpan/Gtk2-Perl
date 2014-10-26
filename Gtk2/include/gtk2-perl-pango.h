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
 * $Id: gtk2-perl-pango.h,v 1.3 2002/10/28 12:49:55 ggc Exp $
 *
 */

#ifndef GTK2_PERL_PANGO_H
#define GTK2_PERL_PANGO_H

/* (ggc) according to glib-2.0/glib/gmacros.h the const return is not adviceable
   for functions with C++ linkage, so I suppose my trouble with them is also best
   fixed with perl by disabling it as well - anyway perl will copy the values
   when the c functions return back to perl, hopefully */
#define G_DISABLE_CONST_RETURNS
#include <pango/pango.h>
#include "gtk2-perl-common.h"
#include "gtk2-perl-helpers-glib-autogen.h"
#include "gtk2-perl-helpers-pango-autogen.h"

#endif
