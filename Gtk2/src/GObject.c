/* $Id: GObject.c,v 1.16 2003/01/03 15:10:22 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

static void destroy_data_notifier(gpointer data)
{
    SvREFCNT_dec((SV*) data);
}

void gperl_object__set_data(SV* object, gchar* key, SV* data)
{
    SvREFCNT_inc(data);
    g_object_set_data_full(SvGObject(object), key, data, destroy_data_notifier);
}

SV* gperl_object__get_data(SV* object, gchar* key)
{
    SV* data = (SV*) g_object_get_data(SvGObject(object), key);
    SvREFCNT_inc(data);
    return data;
}

static void init_property_val(SV* object, gchar* property_name, GValue *val)
{
    GParamSpec *pspec;
    pspec = g_object_class_find_property(G_OBJECT_GET_CLASS(SvGObject(object)), property_name);
    if (!pspec)
	croak("FATAL: object %s doesn't have such property (%s)", get_class(SvGObject(object)), property_name);
    g_value_init(val, G_PARAM_SPEC_VALUE_TYPE(pspec));
}

void gperl_object_set_property(SV* object, gchar* property_name, SV* value)
{
    GValue val = { 0, };
    init_property_val(object, property_name, &val);
    if (gperl_value_from_object(&val, value))
	croak("FATAL: failed to convert value for property %s of type %s (of object %s)",
	      property_name, g_type_name(G_VALUE_TYPE(&val)), get_class(SvGObject(object)));
    g_object_set_property(SvGObject(object), property_name, &val);
}

SV* gperl_object_get_property(SV* object, gchar* property_name)
{
    GValue val = { 0, };
    SV* property;
    init_property_val(object, property_name, &val);
    g_object_get_property(SvGObject(object), property_name, &val);
    property = gperl_object_from_value(&val);
    if (!property)
	croak("FATAL: failed to convert back value of property %s of type %s (of object %s)",
	      property_name, g_type_name(G_VALUE_TYPE(&val)), get_class(SvGObject(object)));
    return property;
}

/* this flags type isn't hasn't type information as the others, I
 * suppose this is because it's too low level */
static SV* newSVGParamFlags(GParamFlags flags)
{
    AV* flags_av = newAV();
    if ((flags & G_PARAM_READABLE) != 0)
	av_push(flags_av, newSVpv("readable", 0));
    if ((flags & G_PARAM_WRITABLE) != 0)
	av_push(flags_av, newSVpv("writable", 0));
    if ((flags & G_PARAM_CONSTRUCT) != 0)
	av_push(flags_av, newSVpv("construct", 0));
    if ((flags & G_PARAM_CONSTRUCT_ONLY) != 0)
	av_push(flags_av, newSVpv("construct-only", 0));
    if ((flags & G_PARAM_LAX_VALIDATION) != 0)
	av_push(flags_av, newSVpv("lax-validation", 0));
    if ((flags & G_PARAM_PRIVATE) != 0)
	av_push(flags_av, newSVpv("private", 0));
    return newRV_noinc((SV*) flags_av);
}

SV* gperl_object__list_properties(SV* object)
{
    AV* properties = newAV();
    GParamSpec **props;
    guint n_props = 0, i;
    props = g_object_class_list_properties(G_OBJECT_GET_CLASS(SvGObject(object)), &n_props);
    for (i = 0; i < n_props; i++) {
	HV* property = newHV();
	hv_store(property, "name",  4, newSVpv(g_param_spec_get_name(props[i]), 0), 0);
	hv_store(property, "type",  4, newSVpv(g_type_name(props[i]->value_type), 0), 0);
	hv_store(property, "descr", 5, newSVpv(g_param_spec_get_blurb(props[i]), 0), 0);
	hv_store(property, "flags", 5, newSVGParamFlags(props[i]->flags), 0) ;
	av_push(properties, newRV_noinc((SV*) property));
    }
    g_free(props);
    return newRV_noinc((SV*) properties);
}

SV* gperl_object_ref_count(SV* object)
{
    return newSVuv(SvGObject(object)->ref_count);
}

void gperl_object_ref(SV* object)
{
    g_object_ref(SvGObject(object));
}

void gperl_object_unref(SV* object)
{
    g_object_unref(SvGObject(object));
}

gchar* gperl_object_DEBUG_get_perl_type(SV* object)
{ 
    return get_class(SvGObject(object));
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
/*
GtkObject*  gtk_object_new                  (GtkType type,
                                             const gchar *first_property_name,
                                             ...);
void        gtk_object_sink                 (GtkObject *object);
GtkObject*  gtk_object_ref                  (GtkObject *object);
void        gtk_object_unref                (GtkObject *object);
void        gtk_object_weakref              (GtkObject *object,
                                             GtkDestroyNotify notify,
                                             gpointer data);
void        gtk_object_weakunref            (GtkObject *object,
                                             GtkDestroyNotify notify,
                                             gpointer data);
void        gtk_object_destroy              (GtkObject *object);
void        gtk_object_get                  (GtkObject *object,
                                             const gchar *first_property_name,
                                             ...);
void        gtk_object_set                  (GtkObject *object,
                                             const gchar *first_property_name,
                                             ...);
void        gtk_object_set_data             (GtkObject *object,
                                             const gchar *key,
                                             gpointer data);
void        gtk_object_set_data_full        (GtkObject *object,
                                             const gchar *key,
                                             gpointer data,
                                             GtkDestroyNotify destroy);
void        gtk_object_remove_data          (GtkObject *object,
                                             const gchar *key);
gpointer    gtk_object_get_data             (GtkObject *object,
                                             const gchar *key);
void        gtk_object_remove_no_notify     (GtkObject *object,
                                             const gchar *key);
void        gtk_object_set_user_data        (GtkObject *object,
                                             gpointer data);
gpointer    gtk_object_get_user_data        (GtkObject *object);
void        gtk_object_add_arg_type         (const gchar *arg_name,
                                             GtkType arg_type,
                                             guint arg_flags,
                                             guint arg_id);
void        gtk_object_set_data_by_id       (GtkObject *object,
                                             GQuark data_id,
                                             gpointer data);
void        gtk_object_set_data_by_id_full  (GtkObject *object,
                                             GQuark data_id,
                                             gpointer data,
                                             GtkDestroyNotify destroy);
gpointer    gtk_object_get_data_by_id       (GtkObject *object,
                                             GQuark data_id);
void        gtk_object_remove_data_by_id    (GtkObject *object,
                                             GQuark data_id);
void        gtk_object_remove_no_notify_by_id
                                            (GtkObject *object,
                                             GQuark key_id);
#define     gtk_object_data_try_key
#define     gtk_object_data_force_id

*/

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
