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
 * $Id: _Helpers.c,v 1.28 2002/12/09 22:10:08 ggc Exp $
 */

#include "gtk2-perl.h"

typedef struct _ClassLevel ClassLevel;

struct _ClassLevel {
  char *prefix;
  char *translate;
  ClassLevel **sub;
};

ClassLevel gnomefont_level = {"Font", "Font", NULL};
ClassLevel gnomeprint_level = {"Print", "Print", NULL};
ClassLevel gnomecanvas_level = {"Canvas", "Canvas", NULL};

ClassLevel *gnome_levels[4] = {
  &gnomefont_level,
  &gnomeprint_level,
  &gnomecanvas_level,
  NULL
};

ClassLevel gtk_level       = {"Gtk", "Gtk2", NULL};
ClassLevel gnome_level     = {"Gnome", "Gnome2", gnome_levels};
ClassLevel pango_level     = {"Pango", "Gtk2::Pango", NULL};
ClassLevel gdk_event_level = {"GdkEvent", "Gtk2::Gdk::Event", NULL};   /* allows for GdkEventWhatever to work */
ClassLevel gdk_level       = {"Gdk", "Gtk2::Gdk", NULL};
ClassLevel glib_level      = {"G", "Gtk2", NULL};                      /* glib objects are Gtk2::GObject etc */

#define nb_levels 6
ClassLevel *levels[nb_levels] = {
  &gtk_level,
  &gnome_level,
  &pango_level,
  &gdk_event_level,
  &gdk_level,
  &glib_level,
};

/*
 * Return:
 *  0 = class conversion done
 * -1 = prefix does not match
 */
int build_class_name(char *name, char *class, int name_pos, int class_pos, ClassLevel *level)
{
  int i;  
  if(!strncmp(level->prefix, &name[name_pos], strlen(level->prefix)) && strlen(level->prefix) < strlen(&name[name_pos])) {
    strcpy(&class[class_pos], level->translate);
    name_pos += strlen(level->prefix);
    class_pos += strlen(level->translate);
    strcpy(&class[class_pos], "::");
    class_pos += 2;
    if (!strcmp(level->prefix, "G")) {  // glib object are called Gtk2::GSList for GSList etc
	strcpy(&class[class_pos], "G");
	class_pos++;
    }
    if(level->sub == NULL) {
      strcpy(&class[class_pos], &name[name_pos]);
      return 0;
    }
    else {
      int res = -1;
      for(i = 0; (level->sub[i] != NULL) && (res == -1); i++) {
        res = build_class_name(name, class, name_pos, class_pos, level->sub[i]);
      }
      if(res == -1) {
        strcpy(&class[class_pos], &name[name_pos]);
      }
      return 0;
    }
  }
  else {
    return -1;
  }
}

char *get_class_from_classname(char *name)
{
  char* class = NULL;
  if (name)
      {
	  int i, res = -1;
	  class = (char *) g_malloc(strlen(name)*2 + 4);  /* 4 is the glib case */
	  for (i = 0; (i < nb_levels) && (res == -1); i++)
	      res = build_class_name(name, class, 0, 0, levels[i]);
	  if (res == -1) {
	      /* themes include a derivative object of GtkStyle, e.g. BluecurveStyle or the like */
	      int l = strlen(name);
	      if (l > 5 && !strcmp(name + strlen(name) - 5, "Style"))
		  return g_strdup("Gtk2::Style");

	      croak("FATAL: gtk object type is unknown (name is %s)", name);
	  }
      }
  return class;
}

char *get_class(GObject *object)
{
  /*
   * if the object is NULL, consider it is
   * a Gtk2::GObject NULL object
   */
  if(object == NULL) {
    return g_strdup("Gtk2::GObject");
  }

  return get_class_from_classname(g_type_name(object->g_type_instance.g_class->g_type));
}

GType get_class_id(GObject *object) {
  return object->g_type_instance.g_class->g_type;
}


SV *gtk2_perl_check_type(SV *object, char* type)
{
    char *real_type = get_class_from_classname(type);
//    fprintf(stderr, "D: tested type of variable %s / %s / %s\n", SvPV_nolen(object), real_type, type);
    if (!sv_derived_from(object, real_type))
	croak("FATAL: variable %s is not of type %s (infered from gtk type %s)", SvPV_nolen(object), real_type, type);
    g_free(real_type);
    return object;
}


static int streq_gtkenums(register char* a, register char *b) {
    while (*a && *b) {
	if (*a == *b || ((*a == '-' || *a == '_') && (*b == '-' || *b == '_'))) {
	    a++;
	    b++;
	} else
	    return 0;
    }
    return *a == *b;
}


gint gtk2_perl_convert_enum(GType type, SV* val)
{
    SV *r;
    char *val_p = SvPV_nolen(val);
    GEnumValue * vals = gtk_type_enum_get_values(type);
    // fprintf(stderr, "VAL: %x (%s), %d\n", val_p, val_p, SvIV(val));
    while (vals && vals->value_nick && vals->value_name) {
	if (streq_gtkenums(val_p, vals->value_name) || 
	    streq_gtkenums(val_p, vals->value_nick))
	    return vals->value;
	vals++;
    }

    /* This is an error, val should be included in the enum type, die */
    vals = gtk_type_enum_get_values(type);
    r = newSVpv("", 0);
    while (vals && vals->value_nick) {
	sv_catpv(r, vals->value_nick);
	if (vals->value_name) {
	    sv_catpv(r, " / ");
	    sv_catpv(r, vals->value_name);
	}
	if (++vals && vals->value_nick)
	    sv_catpv(r, ", ");
    }
    croak("FATAL: invalid enum %s value %s, expecting: %s", g_type_name(type), val_p, SvPV_nolen(r));
}

SV* gtk2_perl_convert_back_enum(GType type, gint val)
{
    GEnumValue * vals = gtk_type_enum_get_values(type);
    while (vals && vals->value_nick && vals->value_name) {
	if (vals->value == val)
	    return newSVpv(vals->value_nick, 0);
	vals++;
    }
    croak("FATAL: could not convert back enum type %s of value %d", g_type_name(type), val);
}

gint gtk2_perl_convert_flag_one(GType type, char* val_p)
{
    SV *r;
    GFlagsValue * vals = gtk_type_flags_get_values(type);
//    fprintf(stderr, "%s: type<%s> val_p<%s>\n", __FUNCTION__, g_type_name(type), val_p);
    while (vals && vals->value_nick && vals->value_name) {
	if (streq_gtkenums(val_p, vals->value_name) || 
	    streq_gtkenums(val_p, vals->value_nick)) {
	    return vals->value;
	}
	vals++;
    }

    /* This is an error, val should be included in the flags type, die */
    vals = gtk_type_flags_get_values(type);
    r = newSVpv("", 0);
    while (vals && vals->value_nick) {
	sv_catpv(r, vals->value_nick);
	if (vals->value_name) {
	    sv_catpv(r, " / ");
	    sv_catpv(r, vals->value_name);
	}
	if (++vals && vals->value_nick)
	    sv_catpv(r, ", ");
    }
    croak("FATAL: invalid flags %s value %s, expecting: %s", g_type_name(type), val_p, SvPV_nolen(r));
}


gint gtk2_perl_convert_flags(GType type, SV* val)
{
    if (SvTYPE(val) == SVt_PV)
	return gtk2_perl_convert_flag_one(type, SvPV_nolen(val));
    if (SvROK(val) && SvTYPE(SvRV(val)) == SVt_PVAV) {
	AV* vals = (AV*) SvRV(val);
	gint value = 0;
	int i;
	for (i=0; i<=av_len(vals); i++)
	    value |= gtk2_perl_convert_flag_one(type, SvPV_nolen(*av_fetch(vals, i, 0)));
	return value;
    }
    croak("FATAL: invalid flags %s value %s, expecting a string scalar or an arrayref of strings", g_type_name(type), SvPV_nolen(val));
}

SV* gtk2_perl_convert_back_flags(GType type, gint val)
{
    GFlagsValue * vals = gtk_type_flags_get_values(type);
    AV* flags = newAV();
    while (vals && vals->value_nick && vals->value_name) {
	if ((vals->value & val) != 0)
	    av_push(flags, newSVpv(vals->value_nick, 0));
	vals++;
    }
    return newRV_noinc((SV*) flags);
}

static HV* already_loaded = NULL;
void gtk2_perl_load_class(char *type)
{
    char *require_path, *ptr1, *ptr2;
    if (!already_loaded)
	already_loaded = newHV();
    if (hv_exists(already_loaded, type, strlen(type)))
	return;
    hv_store(already_loaded, type, strlen(type), newSViv(1), 0);

    require_path = g_malloc0(strlen(type)+4);
    ptr1 = type;
    while (1) {
	ptr2 = strchr(ptr1, ':');
	if (ptr2) {
	    strncat(require_path, ptr1, ptr2-ptr1);
	    strcat(require_path, "/");
	} else {
	    strcat(require_path, ptr1);
	    strcat(require_path, ".pm");
	    goto path_ok;
	}
	ptr1 = ptr2 + 2;
    }
 path_ok:
    require_pv(require_path);
    g_free(require_path);
}

SV* gtk2_perl_new_object_from_pointer(void *pointer, char *type)
{
    SV *obj_ref, *obj;
    obj_ref = newSViv(0);
    obj = newSVrv(obj_ref, type);
    sv_setiv(obj, (IV) pointer);
    SvREADONLY_on(obj);
    gtk2_perl_load_class(type);
    return obj_ref;
}

SV* gtk2_perl_new_object_from_pointer_nullok(void *pointer, char *type)
{
    if (pointer)
	return gtk2_perl_new_object_from_pointer(pointer, type);
    else
	return &PL_sv_undef;
}

SV* gtk2_perl_new_object(void *g_object)
{
    char *class = get_class(g_object);
    SV *obj_ref = gtk2_perl_new_object_from_pointer(g_object, class);
    g_free(class);
    return obj_ref;
}

SV* gtk2_perl_new_object_nullok(void *g_object)
{
    if (g_object)
	return gtk2_perl_new_object(g_object);
    else
	return &PL_sv_undef;
}

SV* newSVgchar_nofree(gchar * string)
{
    SV* string_sv = newSVpv(string, 0);
    SvUTF8_on(string_sv);
    return string_sv;
}

SV* newSVgchar(gchar * string)
{
    SV* results = newSVgchar_nofree(string);
    g_free(string);
    return results;
}

GList* SvGList_of_strings(SV* strings)
{
    GList *list = NULL;
    AV    *table = (AV*) SvRV(strings);
    int   i;
    int   len = av_len(table) + 1;

    for (i = 0; i < len; i++)
        list = g_list_append(list, SvPV_nolen(*av_fetch(table, i, 0)));

    return list;
}

SV* gtk2_perl_objects_of_GList(GList* list, char* object_type)
{
    AV* values = newAV();
    if (list) {
	GList* item = g_list_first(list);
	do {
	    av_push(values, gtk2_perl_new_object_from_pointer_nullok(item->data, object_type));
	} while ((item = g_list_next(item)));
    }
    return newRV_noinc((SV*) values);
}

void gtk2_perl_destroy_notify(gpointer user_data)
{
    struct callback_data * cb_data = user_data;
    SvREFCNT_dec(cb_data->pl_func);
    SvREFCNT_dec(cb_data->data);
    g_free(cb_data);
}

void gtk2_perl_marshal_GtkCallback(GtkWidget *widget, gpointer data)
{
    struct callback_data * cb_data = data;
    dSP;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    XPUSHs(sv_2mortal(gtk2_perl_new_object_from_pointer_nullok(widget, "Gtk2::Widget")));
    XPUSHs(cb_data->data);
    PUTBACK;
    perl_call_sv(cb_data->pl_func, G_DISCARD);
    FREETMPS;
    LEAVE;
}


/* this is a special feature used to not segfault when gtk2-perl
 * callbacks call "die"; e.g. we can't just let the exception
 * propagate as usual, else it will mess up the gtk C stack call
 */
int gtk2_perl_trap_exceptions_in_callbacks = 0;
int gtk2_perl_trap_exceptions_trapped = 0;



/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
