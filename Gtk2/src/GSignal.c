/* $Id: GSignal.c,v 1.32 2003/03/11 16:39:07 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* inspiration much taken from pygtk's pyobject.c::pygobject_emit */
SV* gperl_signal__emit(char* class, SV* objref, gchar* name, SV* args)
{
    guint signal_id, i;
    GQuark detail;
    GSignalQuery query;
    AV* p_args = (AV *) SvRV(args);
    GValue *params, ret = { 0, };
    SV* retval = &PL_sv_undef;

    if (!g_signal_parse_name(name, G_OBJECT_TYPE(SvGObject(objref)), &signal_id, &detail, TRUE)) {
	fprintf(stderr, "\tGtk2-Perl: unknown signal %s for instance %s\n", name, SvPV_nolen(objref));
	return &PL_sv_undef;
    }
    g_signal_query(signal_id, &query);
    if (av_len(p_args) + 1 != query.n_params) {
	fprintf(stderr, "\tGtk2-Perl: %d parameters needed for signal %s (%d given)\n", query.n_params, name, (int)av_len(p_args) + 1);
	return &PL_sv_undef;
    }
    params = g_new0(GValue, query.n_params + 1);
    g_value_init(&params[0], G_OBJECT_TYPE(SvGObject(objref)));
    g_value_set_object(&params[0], G_OBJECT(SvGObject(objref)));

    for (i = 0; i < query.n_params; i++) {
	SV* item = *av_fetch(p_args, i, 0);
	g_value_init(&params[i+1], query.param_types[i] & ~G_SIGNAL_TYPE_STATIC_SCOPE);

	if (gperl_value_from_object(&params[i+1], item)) {
	    fprintf(stderr, "\tGtk2-Perl: failed to convert value %s to type %s for parameter %d trying to emit signal %s on instance %s\n",
		    SvPV_nolen(item), g_type_name(G_VALUE_TYPE(&params[i+1])), i, name, SvPV_nolen(objref));
	    return &PL_sv_undef;
	}
    }
    if (query.return_type != G_TYPE_NONE) {
	g_value_init(&ret, query.return_type & ~G_SIGNAL_TYPE_STATIC_SCOPE);
	g_signal_emitv(params, signal_id, detail, &ret);
	retval = gperl_object_from_value(&ret);
	g_value_unset(&ret);
    } else
	g_signal_emitv(params, signal_id, detail, NULL);

    for (i = 0; i < query.n_params + 1; i++)
	g_value_unset(&params[i]);
    g_free(params);

    return retval;
}

static SV* signal_connect(SV* objref, SV* target, gchar* name, SV* callback, 
			  SV* data, SV* extra_data, int after) {
    perlClosure* closure = NULL;
    SV* closure_sv = NULL;
    SvREFCNT_inc(objref);
    closure_sv = gtkperl_gclosure_new(name, target, callback, data, extra_data);
    SvREFCNT_inc(closure_sv);
    closure = SvGClosure(closure_sv);
    closure->id = g_signal_connect_closure(SvGObject(objref), name,
					   (GClosure*) closure, after);
    return closure_sv;
  }

SV* gperl_signal__connect(char* class,
			   SV* objref, gchar* name, SV* callback, SV* data)
{
    return signal_connect(objref, objref, name, callback, data, NULL, 0);
}

SV* gperl_signal__connect_after(char* class,
				SV* objref, gchar* name, SV* callback, SV* data)
{
    return signal_connect(objref, objref, name, callback, data, NULL, 1);
}

SV* gperl_signal__connect_swapped(char* class, 
				   SV* objref, gchar* name, SV* callback, SV* data)
{
    return signal_connect(objref, data, name, callback, NULL, NULL, 0);
}

SV* gperl_signal__connect_menu(char* class, 
				SV* objref, gchar* name, SV* callback, SV* data, SV* type)
{
    return signal_connect(objref, data, name, callback, type, objref, 0);
}

/* void g_signal_handler_block (gpointer instance, gulong handler_id) */
void gperl_signal_handler_block(char* class, SV* objref, SV* closure)
{
    g_signal_handler_block(SvGObject(objref), SvGClosure(closure)->id);
}

/* void g_signal_handler_unblock (gpointer instance, gulong handler_id) */
void gperl_signal_handler_unblock(char* class, SV* objref, SV* closure)
{
    g_signal_handler_unblock(SvGObject(objref), SvGClosure(closure)->id);
}

/* void g_signal_handler_disconnect (gpointer instance, gulong handler_id) */
void gperl_signal_disconnect(char* class, SV* objref, SV* closure)
{
    g_signal_handler_disconnect(SvGObject(objref), SvGClosure(closure)->id);
    SvIV_set(closure, 0);
    SvREFCNT_dec(closure);
    SvREFCNT_dec(objref);
}

/* gboolean g_signal_handler_is_connected (gpointer instance, gulong handler_id) */
int gperl_signal_is_connected(char* class, SV* objref, SV* closure)
{
    return g_signal_handler_is_connected(SvGObject(objref), SvGClosure(closure)->id);
}

/* void g_signal_stop_emission_by_name (gpointer instance, const gchar *detailed_signal) */
void gperl_signal_stop_emission_by_name(char* class, SV* objref, gchar* detailed_signal)
{
    g_signal_stop_emission_by_name(SvGObject(objref), detailed_signal);
}


/** TIMEOUT functions
 ** placed here because they need marschalling 
 **/

#if 0
typedef struct _timeout_closure
{
    SV* function;
    SV* data;
    int id;
} timeout_closure;

guint       gtk_timeout_add_full            (guint32 interval,
                                             GtkFunction function,
                                             GtkCallbackMarshal marshal,
                                             gpointer data,
                                             GtkDestroyNotify destroy);
#endif

static gboolean timeout_closure_run(gpointer data)
{
    int i;
    perlClosure* ec = (perlClosure*) data;
    // fprintf(stderr, "Timeout run\n");
    {
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(ec->extra_args);
	PUTBACK;
  	i = perl_call_sv(ec->callback, G_SCALAR);
	SPAGAIN;
        if (i != 1)
		croak("Big trouble\n");
	else
		i = POPi;
  	PUTBACK;
	FREETMPS;
	LEAVE;
    }
    return i;
}

SV* gperl_signal_timeout_add(char* class, int interval, SV* function, SV* data)
{
    SV* closure_sv = gtkperl_gclosure_new("TIMEOUT", NULL, function, data, NULL);
    perlClosure* ec = SvGClosure(closure_sv);
    ec->id = gtk_timeout_add(interval, timeout_closure_run, ec);
    return closure_sv;
}

void gperl_signal_timeout_remove(char* class, SV* closure)
{
    perlClosure* ec = SvGClosure(closure);
    if (!ec)
	return; /* timeout was already removed (gtkperl_gclosure_destroy set it to 0 to prevent from double free) */
    gtk_timeout_remove(ec->id);
    gtkperl_gclosure_destroy(closure);
}

SV* gperl_signal_idle_add(char* class, SV* function, SV* data)
{
    SV* closure_sv = gtkperl_gclosure_new("IDLE", NULL, function, data, NULL);
    perlClosure* ec = SvGClosure(closure_sv);
    ec->id = gtk_idle_add(timeout_closure_run, ec);
    return closure_sv;
}

void gperl_signal_idle_remove(char* class, SV* closure)
{
    perlClosure* ec = SvGClosure(closure);
    if (!ec)
	return; /* idle was already removed (gtkperl_gclosure_destroy set it to 0 to prevent from double free) */
    gtk_idle_remove(ec->id);
    gtkperl_gclosure_destroy(closure);
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */


