/* $Id: Box.c,v 1.5 2002/11/28 13:55:28 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

void gtkperl_box_pack_start(SV* box, SV* widget, int expand, int fill, int padding)
{
    gtk_box_pack_start(SvGtkBox(box), SvGtkWidget(widget), expand != 0, fill != 0, padding);
}

void gtkperl_box_pack_end(SV* box, SV* widget, int expand, int fill, int padding)
{
    gtk_box_pack_end(SvGtkBox(box), SvGtkWidget(widget), expand != 0, fill != 0, padding);
}

void gtkperl_box_set_child_packing(SV* box, SV* widget, 
				   int expand, int fill, int padding, SV* pack_type)
{
    gtk_box_set_child_packing(SvGtkBox(box), SvGtkWidget(widget), 
			      expand != 0, fill != 0, padding, SvGtkPackType(pack_type));
}

/* void gtk_box_pack_start_defaults (GtkBox *box, GtkWidget *widget) */
void gtkperl_box_pack_start_defaults(SV* box, SV* widget)
{
    gtk_box_pack_start_defaults(SvGtkBox(box), SvGtkWidget(widget));
}

/* void gtk_box_pack_end_defaults (GtkBox *box, GtkWidget *widget) */
void gtkperl_box_pack_end_defaults(SV* box, SV* widget)
{
    gtk_box_pack_end_defaults(SvGtkBox(box), SvGtkWidget(widget));
}

/* gboolean gtk_box_get_homogeneous (GtkBox *box) */
int gtkperl_box_get_homogeneous(SV* box)
{
    return gtk_box_get_homogeneous(SvGtkBox(box));
}

/* void gtk_box_set_homogeneous (GtkBox *box, gboolean homogeneous) */
void gtkperl_box_set_homogeneous(SV* box, int homogeneous)
{
    gtk_box_set_homogeneous(SvGtkBox(box), homogeneous);
}

/* gint gtk_box_get_spacing (GtkBox *box) */
int gtkperl_box_get_spacing(SV* box)
{
    return gtk_box_get_spacing(SvGtkBox(box));
}

/* void gtk_box_set_spacing (GtkBox *box, gint spacing) */
void gtkperl_box_set_spacing(SV* box, int spacing)
{
    gtk_box_set_spacing(SvGtkBox(box), spacing);
}

/* void gtk_box_reorder_child (GtkBox *box, GtkWidget *child, gint position) */
void gtkperl_box_reorder_child(SV* box, SV* child, int position)
{
    gtk_box_reorder_child(SvGtkBox(box), SvGtkWidget(child), position);
}

/* void gtk_box_query_child_packing (GtkBox *box, GtkWidget *child,
                                     gboolean *expand, gboolean *fill, guint *padding, GtkPackType *pack_type) */
SV* gtkperl_box__query_child_packing(SV* box, SV* child)
{
    gboolean expand, fill;
    guint padding;
    GtkPackType pack_type;
    AV* values = newAV();
    gtk_box_query_child_packing(SvGtkBox(box), SvGtkWidget(child), &expand, &fill, &padding, &pack_type);
    av_push(values, newSViv(expand));
    av_push(values, newSViv(fill));
    av_push(values, newSVuv(padding));
    av_push(values, newSVGtkPackType(pack_type));
    return newRV_noinc((SV*) values);
}


/** methods to access internal stuff **/

SV* gtkperl_box__children(SV* box)
{
    return gtk2_perl_objects_of_GList(SvGtkBox(box)->children, "Gtk2::BoxChild");
}

int gtkperl_box_spacing(SV* box)
{
    return SvGtkBox(box)->spacing;
}

int gtkperl_box_homogeneous(SV* box)
{
    return SvGtkBox(box)->homogeneous;
}

