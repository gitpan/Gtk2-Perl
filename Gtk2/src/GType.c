
#include "glib2-perl.h"

int gperl_value_from_object(GValue* value, SV* obj)
{
    char* tmp;
    int typ = G_TYPE_FUNDAMENTAL(G_VALUE_TYPE(value)); 
    // printf("TYPE: %d, S: %s\n", typ, g_strdup(SvPV_nolen(obj)));
    switch (typ)
	{
	case G_TYPE_INTERFACE:
	    g_value_set_object(value, SvGObject(obj));
	    break;
	case G_TYPE_CHAR:
	    if ((tmp = SvPV_nolen(obj)))
		g_value_set_char(value, tmp[0]);
	    else
		return -1;
	    break;
	case G_TYPE_UCHAR:
	    if ((tmp = SvPV_nolen(obj)))
		g_value_set_char(value, tmp[0]);
	    else
		return -1;
	    break;
	case G_TYPE_BOOLEAN:
	    g_value_set_boolean(value, SvIV(obj));
	    break;
	case G_TYPE_INT:
	    g_value_set_int(value, SvIV(obj));
	    break;
	case G_TYPE_UINT:
	    g_value_set_uint(value, SvIV(obj));
	    break;
	case G_TYPE_LONG:
	    g_value_set_long(value, SvIV(obj));
	    break;
	case G_TYPE_ULONG:
	    g_value_set_ulong(value, SvIV(obj));
	    break;
	case G_TYPE_INT64:
	    g_value_set_int64(value, SvIV(obj));
	    break;
	case G_TYPE_UINT64:
	    g_value_set_uint64(value, SvIV(obj));
	    break;
	case G_TYPE_FLOAT:
	    g_value_set_float(value, SvNV(obj));
	    break;
	case G_TYPE_DOUBLE:
	    g_value_set_double(value, SvNV(obj));
	    break;
	case G_TYPE_STRING:
	    g_value_set_string(value, g_strdup(SvPV_nolen(obj)));
	    break;
	case G_TYPE_POINTER:
	    g_value_set_pointer(value, (gpointer) SvIV(obj));
	    break;
	case G_TYPE_PARAM:
	    g_value_set_param(value, (gpointer) SvIV(obj));
	    break;
	case G_TYPE_OBJECT:
	    g_value_set_object(value, (gpointer) SvIV(SvRV(gtk2_perl_check_type(obj, g_type_name(G_VALUE_TYPE(value))))));
	    break;
	case G_TYPE_ENUM:
	    g_value_set_enum(value, gtk2_perl_convert_enum(G_VALUE_TYPE(value), obj));
	    break;
	case G_TYPE_FLAGS:
	    g_value_set_flags(value, gtk2_perl_convert_flags(G_VALUE_TYPE(value), obj));
	    break;
	case G_TYPE_BOXED:
	    g_value_set_boxed(value, (gpointer) SvIV(SvRV(gtk2_perl_check_type(obj, g_type_name(G_VALUE_TYPE(value))))));
	    break;

	default:
	    fprintf(stderr, "[gperl_value_from_object] FIXME: unhandled type - %d (%s fundamental for %s)\n",
		    typ, g_type_name(G_TYPE_FUNDAMENTAL(G_VALUE_TYPE(value))), g_type_name(G_VALUE_TYPE(value)));
	    break;
	}
    return 0;
}


SV* gperl_object_from_value(GValue* value)
{
    SV* tmp;
    int typ = G_TYPE_FUNDAMENTAL(G_VALUE_TYPE(value)); 

    switch (typ)
	{
	case G_TYPE_BOOLEAN:
	    return newSViv(g_value_get_boolean(value));

	case G_TYPE_INT:
	    return newSViv(g_value_get_int(value));

	case G_TYPE_UINT:
	    return newSVuv(g_value_get_uint(value));

	case G_TYPE_LONG:
	    return newSViv(g_value_get_long(value));

	case G_TYPE_ULONG:
	    return newSVuv(g_value_get_ulong(value));

	case G_TYPE_INT64:
	    return newSViv(g_value_get_int64(value));

	case G_TYPE_UINT64:
	    return newSVuv(g_value_get_uint64(value));

	case G_TYPE_FLOAT:
	    return newSVnv(g_value_get_float(value));

	case G_TYPE_DOUBLE:
	    return newSVnv(g_value_get_double(value));

        case G_TYPE_STRING:
	    tmp = newSVpv(g_value_get_string(value), 0);
	    SvUTF8_on(tmp);
	    return tmp;

	case G_TYPE_POINTER:
	    return newSViv((IV) g_value_get_pointer(value));

        case G_TYPE_BOXED:
	    return gtk2_perl_new_object_from_pointer(g_value_get_boxed(value),
						     get_class_from_classname(g_type_name(G_VALUE_TYPE(value))));
	case G_TYPE_OBJECT:
	    return gtk2_perl_new_object_from_pointer(g_value_get_object(value),
						     get_class_from_classname(g_type_name(G_VALUE_TYPE(value))));
	    
	case G_TYPE_ENUM:
	    return gtk2_perl_convert_back_enum(G_VALUE_TYPE(value), g_value_get_enum(value));

	case G_TYPE_FLAGS:
	    return gtk2_perl_convert_back_flags(G_VALUE_TYPE(value), g_value_get_flags(value));

	default:
	    fprintf(stderr, "[gperl_object_from_value] FIXME: unhandled type - %d (%s fundamental for %s)\n",
		    typ, g_type_name(G_TYPE_FUNDAMENTAL(G_VALUE_TYPE(value))), g_type_name(G_VALUE_TYPE(value)));
	}

    return NULL;
}



/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
