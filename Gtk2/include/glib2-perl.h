/*
 * Copyright (c) 2002 Göran Thyni
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
 * $Id: glib2-perl.h,v 1.7 2002/11/08 15:46:22 ggc Exp $
 *
 */

#ifndef GLIB2_PERL_H
#define GLIB2_PERL_H

#define G_DISABLE_CONST_RETURNS
#include <glib-object.h>

#include "gtk2-perl-common.h"
#include "gtk2-perl-helpers-glib-autogen.h"

/* prototypes */
// from Gtk2::GType
extern int gperl_value_from_object(GValue* value, SV* obj);
extern SV* gperl_object_from_value(GValue* value);

// from GClosure
typedef struct _perlClosure {
    GClosure closure;
    SV* target;
    SV* callback;
    SV* extra_args; /* tuple of extra args to pass to callback */
    SV* swap_data; /* other object for gtk_signal_connect_object */
    gchar* name;
    int id;
} perlClosure;

SV* gtkperl_gclosure_new(gchar* name, SV* target, SV *callback, 
			 SV *extra_args, SV *swap_data);
void gtkperl_gclosure_destroy(SV* closure);

// this is a bit special castingwise
#define SvGClosure(o) ((perlClosure*) SvIV(SvRV(gtk2_perl_check_type(o, "GClosure"))))

#endif
