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
 * $Id: gtk2-perl-common.h,v 1.15 2002/12/16 14:29:24 ggc Exp $
 *
 */

#ifndef GTK2_PERL_COMMON_H
#define GTK2_PERL_COMMON_H

#include <gtk/gtkversion.h>
#include "gtk2-perl-helpers-common-autogen.h"

/* check that <object> is of type <type> */
SV *gtk2_perl_check_type(SV *object, char *type);

/* creates a new perl object out of the <g_object> */
SV* gtk2_perl_new_object(void *g_object);

/* same as upper, but if <g_object> is NULL, return &PL_sv_undef rather than croaking */
SV* gtk2_perl_new_object_nullok(void *g_object);

/* creates a new perl object of type <type> out of the <pointer> (usually <pointer> would not be a GObject, that's why) */
SV* gtk2_perl_new_object_from_pointer(void *pointer, char *type);

/* same as upper, but if <pointer> is NULL, return &PL_sv_undef rather than croaking */
SV* gtk2_perl_new_object_from_pointer_nullok(void *pointer, char *type);

/* verifies that <val> is a string being a member of <type> (by their value_nick or
   value_name), returns the associated gint value for that type, dies if failure */
gint gtk2_perl_convert_enum(GType type, SV* val);

/* return the "value_nick" of type <type> corresponding to value <val>, dies if not found */
SV* gtk2_perl_convert_back_enum(GType type, gint val);

/* same as above but <val> car be a string (SV) or an arrayref because these are flags, not enum*/
gint gtk2_perl_convert_flags(GType type, SV* val);

/* return the "value_nick" of type <type> corresponding to value <val>, dies if not found */
SV* gtk2_perl_convert_back_flags(GType type, gint val);

/* convert <string> into an SV* and g_free the string before returning */
SV* newSVgchar(gchar * string);

/* convert <string> into an SV* but doesn't g_free the string before returning */
SV* newSVgchar_nofree(gchar * string);

/* returns the Perl object class of <object> */
char *get_class(GObject *object);

/* returns the Perl object class corresponding to the gtk <class> */
char *get_class_from_classname(char *class);

/* convert the SvPV values of an arrayref to a GList (you'll need to g_list_free after use) */
GList* SvGList_of_strings(SV* strings);

/* convert a GList containing objects of type <object_type> into an arrayref of perl objects */
SV* gtk2_perl_objects_of_GList(GList* list, char* object_type);

/* for callbacks (use genscripts/castmacros-autogen.pl CallBackFunc to auto generate the marshaller for your function) */
/* data structure passed as the user_data to call the real perl callback function */
struct callback_data {
    SV* pl_func;
    SV* data;
};

#endif
