/* $Id: AccelLabel.c,v 1.1 2002/11/03 07:39:36 glade-perl Exp $
 * Copyright 2002, Dermot Musgrove <dermot.musgrove@virgin.net>
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_accel_label_new(char* class, gchar* text)
{
    return gtk2_perl_new_object(gtk_accel_label_new(text));
}

SV* gtkperl_accel_label_get_accel_widget(SV* accel_label)
{
    return gtk2_perl_new_object(gtk_accel_label_get_accel_widget(
        SvGtkAccelLabel(accel_label)));
}

void gtkperl_accel_label_set_accel_widget(SV* accel_label, SV *accel_widget)
{
    gtk_accel_label_set_accel_widget(
        SvGtkAccelLabel(accel_label), SvGtkWidget(accel_widget));
}

/*

GtkWidget*  gtk_accel_label_new             (const gchar *string);
  void        gtk_accel_label_set_accel_closure
                                              (GtkAccelLabel *accel_label,
                                               GClosure *accel_closure);
  guint       gtk_accel_label_get_accel_width (GtkAccelLabel *accel_label);
  gboolean    gtk_accel_label_refetch         (GtkAccelLabel *accel_label);

*/
