/* $Id: Gtk2.c,v 1.14 2002/11/21 21:14:52 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Contributor:
 * - Dermot Musgrove
 */

#include "gtk2-perl.h"

typedef struct _perlFunction {
    SV *function;
    SV *data;
} perlFunction;

int gtkperl_gtk2_CHECK_VERSION(char* class, int major, int minor, int micro)
{
    return GTK_CHECK_VERSION(major, minor, micro);
}

int gtkperl_gtk2__init(char* class, SV* argv_ref)
{
    int i; char** a;
    AV* argv = (AV*) SvRV(argv_ref);
    int len = av_len(argv) + 1;
    a = (char**) g_malloc0((len+1) * sizeof(char*));
    for (i = 0; i < len; i++)
	{
	    int l1;
	    SV* sv = av_shift(argv);
	    a[i] = g_strdup(SvPV(sv,l1)); 
	    // fprintf(stderr, "ARGV shift %s (%d of %d)\n", a[i], i + 1, len);
	}
    a[i] = NULL;
    gtk_init(&len, &a);
    for (i = 0; i < len; i++)
	{
	    SV* sv = newSVpv(a[i], strlen(a[i]));
	    av_push(argv, sv);
	    // fprintf(stderr, "ARGV push %s (%d of %d)\n", a[i], i + 1, len);
	    g_free(a[i]);
	}
    g_free(a);
    return 1; /* success */
}

int gtkperl_gtk2__init_check(char* class, SV* argv_ref)
{
    gboolean ret;
    int i; char** a;
    AV* argv = (AV*) SvRV(argv_ref);
    int len = av_len(argv) + 1;
    a = (char**) g_malloc0((len+1) * sizeof(char*));
    for (i = 0; i < len; i++)
	{
	    int l1;
	    SV* sv = av_shift(argv);
	    a[i] = g_strdup(SvPV(sv,l1)); 
	    // fprintf(stderr, "ARGV shift %s (%d of %d)\n", a[i], i + 1, len);
	}
    a[i] = NULL;
    ret = gtk_init_check(&len, &a);
    for (i = 0; i < len; i++)
	{
	    SV* sv = newSVpv(a[i], strlen(a[i]));
	    av_push(argv, sv);
	    // fprintf(stderr, "ARGV push %s (%d of %d)\n", a[i], i + 1, len);
	    g_free(a[i]);
	}
    g_free(a);
    return ret;
}

/*
gboolean    gtk_init_check                  (int *argc,
                                             char ***argv);
*/
/* gchar*      gtk_set_locale                  (void); */
void gtkperl_gtk2_set_locale(char* class) { gtk_set_locale(); }

/* void        gtk_disable_setlocale           (void); */
/* PangoLanguage* gtk_get_default_language     (void); */
/* void        gtk_main                        (void); */
int gtkperl_gtk2_main(char* class) { gtk_main(); return 1; }
/* guint       gtk_main_level                  (void); */
/* void        gtk_main_quit                   (void); */
void gtkperl_gtk2_main_quit(char* class) { gtk_main_quit(); }
/* gboolean    gtk_true                        (void); */
/* gboolean    gtk_false                       (void); */
void gtkperl_gtk2_quit(char* class) { gtk_main_quit(); }
/* void        gtk_exit                        (gint error_code); */
void gtkperl_gtk2_exit(char* class, int errorcode) { gtk_exit(errorcode); }

/* gint        gtk_events_pending              (void); */
int gtkperl_gtk2_events_pending(char* class)
{
    return gtk_events_pending();
}

void gtkperl_gtk2_update_ui(char* class)
{
    while (gtk_events_pending ())
        gtk_main_iteration ();
}

/* gboolean    gtk_main_iteration              (void); */
int gtkperl_gtk2_main_iteration(char *class)
{
    return gtk_main_iteration ();
}

/* gboolean    gtk_main_iteration_do           (gboolean blocking); */
int gtkperl_gtk2_main_iteration_do(char *class, int blocking)
{
    return gtk_main_iteration_do (blocking);
}

/* void        gtk_main_do_event               (GdkEvent *event); */
/* void        (*GtkModuleInitFunc)            (gint *argc,
                                             gchar ***argv);
void        gtk_grab_add                    (GtkWidget *widget);
GtkWidget*  gtk_grab_get_current            (void);
void        gtk_grab_remove                 (GtkWidget *widget);

void        gtk_init_add                    (GtkFunction function,
                                             gpointer data);
void        gtk_quit_add_destroy            (guint main_level,
                                             GtkObject *object);
guint       gtk_quit_add                    (guint main_level,
                                             GtkFunction function,
                                             gpointer data);
guint       gtk_quit_add_full               (guint main_level,
                                             GtkFunction function,
                                             GtkCallbackMarshal marshal,
                                             gpointer data,
                                             GtkDestroyNotify destroy);
void        gtk_quit_remove                 (guint quit_handler_id);
void        gtk_quit_remove_by_data         (gpointer data);

guint       gtk_timeout_add_full            (guint32 interval,
                                             GtkFunction function,
                                             GtkCallbackMarshal marshal,
                                             gpointer data,
                                             GtkDestroyNotify destroy);
guint       gtk_timeout_add                 (guint32 interval,
                                             GtkFunction function,
                                             gpointer data);
void        gtk_timeout_remove              (guint timeout_handler_id);

guint       gtk_idle_add                    (GtkFunction function,
                                             gpointer data);
guint       gtk_idle_add_priority           (gint priority,
                                             GtkFunction function,
                                             gpointer data);
guint       gtk_idle_add_full               (gint priority,
                                             GtkFunction function,
                                             GtkCallbackMarshal marshal,
                                             gpointer data,
                                             GtkDestroyNotify destroy);
void        gtk_idle_remove                 (guint idle_handler_id);
void        gtk_idle_remove_by_data         (gpointer data);

guint       gtk_input_add_full              (gint source,
                                             GdkInputCondition condition,
                                             GdkInputFunction function,
                                             GtkCallbackMarshal marshal,
                                             gpointer data,
                                             GtkDestroyNotify destroy);
void        gtk_input_remove                (guint input_handler_id);

#define     GTK_PRIORITY_REDRAW
#define     GTK_PRIORITY_RESIZE
#define     GTK_PRIORITY_HIGH
#define     GTK_PRIORITY_INTERNAL
#define     GTK_PRIORITY_DEFAULT
#define     GTK_PRIORITY_LOW

guint       gtk_key_snooper_install         (GtkKeySnoopFunc snooper,
                                             gpointer func_data);
gint        (*GtkKeySnoopFunc)              (GtkWidget *grab_widget,
                                             GdkEventKey *event,
                                             gpointer func_data);
void        gtk_key_snooper_remove          (guint snooper_handler_id);

GdkEvent*   gtk_get_current_event           (void);
guint32     gtk_get_current_event_time      (void);
gboolean    gtk_get_current_event_state     (GdkModifierType *state);
GtkWidget*  gtk_get_event_widget            (GdkEvent *event);
void        gtk_propagate_event             (GtkWidget *widget,
                                             GdkEvent *event);
*/
