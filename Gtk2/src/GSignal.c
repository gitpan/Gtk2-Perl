/* $Id: GSignal.c,v 1.29 2002/11/22 18:18:27 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* TEMP REMOVE START */


/* TEMP REMOVE END */

/* SIGNALS */

static SV* signal_connect(SV* objref, SV* target, gchar* name, SV* callback, 
			  SV* data, SV* extra_data) {
    perlClosure* closure = NULL;
    SV* closure_sv = NULL;
    SvREFCNT_inc(objref);
    closure_sv = gtkperl_gclosure_new(name, target, callback, data, extra_data);
    SvREFCNT_inc(closure_sv);
    closure = SvGClosure(closure_sv);
    closure->id = g_signal_connect_closure(SvGObject(objref), name, 
					   (GClosure*) closure, FALSE);
    return closure_sv;
  }

SV* gperl_signal__connect(char* class,
			   SV* objref, gchar* name, SV* callback, SV* data)
{
    return signal_connect(objref, objref, name, callback, data, NULL);
}

SV* gperl_signal__connect_swapped(char* class, 
				   SV* objref, gchar* name, SV* callback, SV* data)
{
    return signal_connect(objref, data, name, callback, NULL, NULL);
}

SV* gperl_signal__connect_menu(char* class, 
				SV* objref, gchar* name, SV* callback, SV* data, SV* type)
{
    return signal_connect(objref, data, name, callback, type, objref);
}

void gperl_signal_disconnect(char* class, SV* objref, SV* closure)
{
    g_signal_handler_disconnect(SvGObject(objref), SvGClosure(closure)->id);
    SvIV_set(closure, 0);
    SvREFCNT_dec(closure);
    SvREFCNT_dec(objref);
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


