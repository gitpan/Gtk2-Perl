/* $Id: AccelGroup.c,v 1.2 2002/11/04 01:13:03 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_accel_group_new(char* class)
{
    return gtk2_perl_new_object_from_pointer(gtk_accel_group_new(), class);
}

/*
void gtkperl_accel_group_connect(SV* accel_group, int accel_key,
                                SV* accel_mods, SV* accel_flags,
                                SV* closure)
{
    gtk_accel_group_connect(SvGtkAccelGroup(accel_group),
                            accel_key, 
                            SvGdkModifierType(accel_mods),
                            SvGtkAccelFlags(accel_flags),
                            SvGClosure(closure));
}
*/
/* NOT IMPLEMENTED YET
#define     gtk_accel_group_ref
#define     gtk_accel_group_unref
void        gtk_accel_group_connect         (GtkAccelGroup *accel_group,
                                             guint accel_key,
                                             GdkModifierType accel_mods,
                                             GtkAccelFlags accel_flags,
                                             GClosure *closure);
void        gtk_accel_group_connect_by_path (GtkAccelGroup *accel_group,
                                             const gchar *accel_path,
                                             GClosure *closure);
gboolean    (*GtkAccelGroupActivate)        (GtkAccelGroup *accel_group,
                                             GObject *acceleratable,
                                             guint keyval,
                                             GdkModifierType modifier);
gboolean    gtk_accel_group_disconnect      (GtkAccelGroup *accel_group,
                                             GClosure *closure);
gboolean    gtk_accel_group_disconnect_key  (GtkAccelGroup *accel_group,
                                             guint accel_key,
                                             GdkModifierType accel_mods);
GtkAccelGroupEntry* gtk_accel_group_query   (GtkAccelGroup *accel_group,
                                             guint accel_key,
                                             GdkModifierType accel_mods,
                                             guint *n_entries);
void        gtk_accel_group_lock            (GtkAccelGroup *accel_group);
void        gtk_accel_group_unlock          (GtkAccelGroup *accel_group);
GtkAccelGroup* gtk_accel_group_from_accel_closure
                                            (GClosure *closure);
gboolean    gtk_accel_groups_activate       (GObject *object,
                                             guint accel_key,
                                             GdkModifierType accel_mods);
GSList*     gtk_accel_groups_from_object    (GObject *object);
GtkAccelKey* gtk_accel_group_find           (GtkAccelGroup *accel_group,
                                             gboolean (*find_func) (GtkAccelKey *key,GClosure    *closure,gpointer     data),
                                             gpointer data);
struct      GtkAccelKey;
gboolean    gtk_accelerator_valid           (guint keyval,
                                             GdkModifierType modifiers);
void        gtk_accelerator_parse           (const gchar *accelerator,
                                             guint *accelerator_key,
                                             GdkModifierType *accelerator_mods);
gchar*      gtk_accelerator_name            (guint accelerator_key,
                                             GdkModifierType accelerator_mods);
void        gtk_accelerator_set_default_mod_mask
                                            (GdkModifierType default_mod_mask);
guint       gtk_accelerator_get_default_mod_mask
                                            (void);
 */



