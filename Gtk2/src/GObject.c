/* $Id: GObject.c,v 1.17 2003/02/08 15:43:25 ggc Exp $
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

int gperl_object_ref_count(SV* object)
{
    return SvGObject(object)->ref_count;
}

/* gpointer g_object_ref (gpointer object) */
void gperl_object_ref(SV* object)
{
    g_object_ref(SvGObject(object));
}

/* void g_object_unref (gpointer object) */
void gperl_object_unref(SV* object)
{
    g_object_unref(SvGObject(object));
}

/* auto generated marshal for GWeakNotify (using genscripts/castmacros-autogen.pl GWeakNotify) */
static void marshal_GWeakNotify(gpointer data, GObject *where_the_object_was)
{
    struct callback_data * cb_data = data;
    dSP;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    XPUSHs(cb_data->data);
    XPUSHs(sv_2mortal(newSViv((IV)where_the_object_was)));
    PUTBACK;
    perl_call_sv(cb_data->pl_func, G_DISCARD);
    FREETMPS;
    LEAVE;
}

/* void g_object_weak_ref (GObject *object, GWeakNotify notify, gpointer data) */
void gperl_object_weak_ref(SV* object, SV* notify, SV* data)
{
    /* the real call of that callback is of course deferred, hence we
       need to allocate the cb_data, incref the stuff inside it, and
       use an additional weak_ref with gtk2_perl_destroy_notify that will
       decref and g_free */
    struct callback_data * cb_data = g_malloc0(sizeof(struct callback_data));
    cb_data->pl_func = notify;
    cb_data->data = data;
    SvREFCNT_inc(cb_data->pl_func);
    SvREFCNT_inc(cb_data->data);
    g_object_weak_ref(SvGObject(object), marshal_GWeakNotify, cb_data);
    g_object_weak_ref(SvGObject(object), (GWeakNotify)gtk2_perl_destroy_notify, cb_data);
}

/* weak_unref would be rather complicated :) */


gchar* gperl_object_DEBUG_get_perl_type(SV* object)
{ 
    return get_class(SvGObject(object));
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
