/* $Id: Image.c,v 1.9 2002/12/06 20:44:48 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_image_new_from_file(char* class, gchar* filename)
{
    return gtk2_perl_new_object(gtk_image_new_from_file(filename));
}

SV* gtkperl_image_new_from_stock(char* class, gchar* stock_id, SV* size)
{
    return gtk2_perl_new_object(gtk_image_new_from_stock(stock_id, 
                                        SvGtkIconSize(size)));
}

/* NOT IMPLEMENTED YET
GtkWidget*  gtk_image_new_from_icon_set     (GtkIconSet *icon_set,
                                             GtkIconSize size);
*/

/* GtkWidget* gtk_image_new_from_image (GdkImage *image, GdkBitmap *mask) */
SV* gtkperl_image_new_from_image(char* class, SV* image, SV* mask)
{
    return gtk2_perl_new_object(gtk_image_new_from_image(SvGdkImage(image), SvGdkBitmap(mask)));
}

SV* gtkperl_image_new_from_pixbuf(char* class, SV* pixbuf)
{
    return gtk2_perl_new_object(gtk_image_new_from_pixbuf(SvGdkPixbuf_nullok(pixbuf)));
}

SV* gtkperl_image_new_from_pixmap(char* class, SV* pixmap, SV* mask)
{
    return gtk2_perl_new_object(gtk_image_new_from_pixmap(SvGdkPixmap_nullok(pixmap),
							  SvGdkBitmap_nullok(mask)));
}

/*
GtkWidget*  gtk_image_new_from_animation    (GdkPixbufAnimation *animation);

void        gtk_image_get_icon_set          (GtkImage *image,
                                             GtkIconSet **icon_set,
                                             GtkIconSize *size);
void        gtk_image_get_image             (GtkImage *image,
                                             GdkImage **gdk_image,
                                             GdkBitmap **mask);
*/

/* GdkPixbuf* gtk_image_get_pixbuf (GtkImage *image) */
SV* gtkperl_image_get_pixbuf(SV* image)
{
    return gtk2_perl_new_object_nullok(gtk_image_get_pixbuf(SvGtkImage(image)));
}

/* void gtk_image_get_pixmap (GtkImage *image, GdkPixmap **pixmap, GdkBitmap **mask) */
SV* gtkperl_image__get_pixmap(SV* image)
{
    AV* values = newAV();
    GdkPixmap* pixmap;
    GdkBitmap* bitmap;
    gtk_image_get_pixmap(SvGtkImage(image), &pixmap, &bitmap);
    if (pixmap && bitmap) {
	    av_push(values, gtk2_perl_new_object(pixmap));
	    av_push(values, gtk2_perl_new_object(bitmap));
    }
    return newRV_noinc((SV*) values);
}

/* void gtk_image_get_stock (GtkImage *image, gchar **stock_id, GtkIconSize *size) */
SV* gtkperl_image__get_stock(SV* image)
{
    AV* values = newAV();
    gchar* stock_id;
    GtkIconSize size;
    gtk_image_get_stock(SvGtkImage(image), &stock_id, &size);
    if (stock_id) {
	    av_push(values, newSVgchar_nofree(stock_id));
	    av_push(values, newSVGtkIconSize(size));
    }
    return newRV_noinc((SV*) values);
}

/* GtkImageType gtk_image_get_storage_type (GtkImage *image) */
SV* gtkperl_image_get_storage_type(SV* image)
{
    return newSVGtkImageType(gtk_image_get_storage_type(SvGtkImage(image)));
}

/* void gtk_image_set_from_file (GtkImage *image, const gchar *filename) */
void gtkperl_image_set_from_file(SV* image, gchar* filename)
{
    gtk_image_set_from_file(SvGtkImage(image), filename);
}

/* void gtk_image_set_from_image (GtkImage *image, GdkImage *gdk_image, GdkBitmap *mask) */
void gtkperl_image_set_from_image(SV* image, SV* gdk_image, SV* mask)
{
    gtk_image_set_from_image(SvGtkImage(image), SvGdkImage(gdk_image), SvGdkBitmap(mask));
}

/* void gtk_image_set_from_pixbuf (GtkImage *image, GdkPixbuf *pixbuf) */
void gtkperl_image_set_from_pixbuf(SV* image, SV* pixbuf)
{
    gtk_image_set_from_pixbuf(SvGtkImage(image), SvGdkPixbuf(pixbuf));
}

/* void gtk_image_set_from_pixmap (GtkImage *image, GdkPixmap *pixmap, GdkBitmap *mask) */
void gtkperl_image_set_from_pixmap(SV* image, SV* pixmap, SV* mask)
{
    gtk_image_set_from_pixmap(SvGtkImage(image), SvGdkPixmap(pixmap), SvGdkBitmap(mask));
}

/* void gtk_image_set_from_stock (GtkImage *image, const gchar *stock_id, GtkIconSize size) */
void gtkperl_image_set_from_stock(SV* image, gchar* stock_id, SV* size)
{
    gtk_image_set_from_stock(SvGtkImage(image), stock_id, SvGtkIconSize(size));
}

/* void gtk_image_set_from_animation (GtkImage *image, GdkPixbufAnimation *animation) */
void gtkperl_image_set_from_animation(SV* image, SV* animation)
{
    gtk_image_set_from_animation(SvGtkImage(image), SvGdkPixbufAnimation(animation));
}

/* GtkWidget* gtk_image_new (void) */
SV* gtkperl_image_new(char* class)
{
    return gtk2_perl_new_object(gtk_image_new());
}

/* void gtk_image_set (GtkImage *image, GdkImage *val, GdkBitmap *mask) */
void gtkperl_image_set(SV* image, SV* val, SV* mask)
{
    gtk_image_set(SvGtkImage(image), SvGdkImage(val), SvGdkBitmap(mask));
}

/*
GdkPixbufAnimation* gtk_image_get_animation (GtkImage *image);
void        gtk_image_set                   (GtkImage *image,
                                             GdkImage *val,
                                             GdkBitmap *mask);
void        gtk_image_get                   (GtkImage *image,
                                             GdkImage **val,
                                             GdkBitmap **mask);
*/
