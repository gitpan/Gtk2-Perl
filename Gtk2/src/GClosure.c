/* $Id: GClosure.c,v 1.12 2002/11/28 14:25:38 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* TEMP REMOVE START */


/* TEMP REMOVE END */

/* SIGNALS */


static void perl_closure_invalidate(gpointer data, GClosure *closure)
{
    perlClosure *pc = (perlClosure *)closure;
//    fprintf(stderr,"Invalidating closure for %s\n", pc->name);
    if (pc->target) SvREFCNT_dec(pc->target);
    pc->target = NULL;
    /* FIXME when the following code is run, there is a refcount problem with this variable :(
       test it with misc-examples/signal-disconnect-immediate.pl                   */
    // if (pc->callback) SvREFCNT_dec(pc->callback);     
    pc->callback = NULL;
    if (pc->extra_args) SvREFCNT_dec(pc->extra_args);
    pc->extra_args = NULL;
    if (pc->swap_data) SvREFCNT_dec(pc->swap_data);
    pc->swap_data = NULL;
    if (pc->name) g_free(pc->name);
    pc->name = NULL;
}

/* from Gtk2/Gdk/src/Event.c */
extern SV* gdkperl_event_make(GdkEvent* event);

static void
perl_closure_marshal(GClosure *closure,
		     GValue *return_value,
		     guint n_param_values,
		     const GValue *param_values,
		     gpointer invocation_hint,
		     gpointer marshal_data)
{
    int i;
    AV* supp_args = newAV();
    perlClosure *pc = (perlClosure *)closure;
    /*
    fprintf(stderr, "Marshalling: params: %d\n", n_param_values);
    fprintf(stderr,"Marshalling: func: %lx (refcnt: %d) target: %lx (refcnt: %d) data: %lx (refcnt: %d)\n", 
	    pc->callback, pc->callback->sv_refcnt,
            pc->target, pc->target->sv_refcnt,
	    pc->extra_args, pc->extra_args ? pc->extra_args->sv_refcnt : 0);
    */
    {
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(pc->target);
	if (n_param_values > 1) {
           for (i=1; i<n_param_values; i++) {
               SV * arg;
/*               fprintf(stderr, "examining name: %s type: %s fundtype: %s\n",
                       pc->name,
                       g_type_name(G_VALUE_TYPE(param_values + i)),
                       g_type_name(G_TYPE_FUNDAMENTAL(G_VALUE_TYPE(param_values + i)))); */
               if (!strcmp(g_type_name(G_VALUE_TYPE(param_values + i)), "GdkEvent"))
                   arg = gdkperl_event_make(g_value_get_boxed(param_values + i));
               else
                   arg = gperl_object_from_value((GValue*) param_values + i);
	       if (!arg) {
		   fprintf(stderr, "[perl_closure_marshal] Warning, failed to convert object from value for name: %s number: %d type: %s fundtype: %s\n",
			   pc->name, i,
			   g_type_name(G_VALUE_TYPE(param_values + i)),
			   g_type_name(G_TYPE_FUNDAMENTAL(G_VALUE_TYPE(param_values + i))));
		   arg = &PL_sv_undef;
	       }
               SvREFCNT_inc(arg);
               XPUSHs(arg);
	       av_push(supp_args, arg);
	   }
	}
	XPUSHs(pc->extra_args ? pc->extra_args : &PL_sv_undef);
	XPUSHs(pc->swap_data ? pc->swap_data : &PL_sv_undef);
	PUTBACK;
	perl_call_sv(pc->callback, G_DISCARD);
	for (i=0; i<=av_len(supp_args); i++)
	    SvREFCNT_dec(*av_fetch(supp_args, i, 0));
	SvREFCNT_dec(supp_args);
	FREETMPS;
	LEAVE;
    }
}

SV* gtkperl_gclosure_new(gchar* name, SV* target, SV *callback, 
			 SV *extra_args, SV *swap_data)
{
  perlClosure *closure;
  g_return_val_if_fail(callback != NULL, NULL);
  closure = (perlClosure*) g_closure_new_simple(sizeof(perlClosure), NULL);
  g_closure_add_invalidate_notifier((GClosure*) closure, NULL, perl_closure_invalidate);
  g_closure_set_marshal((GClosure*) closure, perl_closure_marshal);
  closure->target = NULL;
  if (target && target != &PL_sv_undef) {
      SvREFCNT_inc(target);
      closure->target = target;
  }
  closure->callback = NULL;
  if (callback && callback != &PL_sv_undef) {
      SvREFCNT_inc(callback);
      closure->callback = callback;
  }
  closure->extra_args = NULL;
  if (extra_args && extra_args != &PL_sv_undef) {
    SvREFCNT_inc(extra_args);
    closure->extra_args = extra_args;
  }
  closure->swap_data = NULL;
  if (swap_data && swap_data != &PL_sv_undef) {
    SvREFCNT_inc(swap_data);
    closure->swap_data = swap_data;
    closure->closure.derivative_flag = TRUE;
  }
  closure->name = name ? g_strdup(name) : NULL;
  return gtk2_perl_new_object_from_pointer(closure, "Gtk2::GClosure");
}

void gtkperl_gclosure_destroy(SV* closure)
{
    perlClosure* pc = SvGClosure(closure);
    if (pc) {
	SV* obj;
	g_closure_unref((GClosure*) pc);
	obj = SvRV(closure);
	SvREADONLY_off(obj);
	sv_setiv(obj, (IV) 0);
	SvREADONLY_on(obj);
    } else
	fprintf(stderr, "WARNING: double free attempted on GClosure %s\n", SvPV_nolen(closure));
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */


