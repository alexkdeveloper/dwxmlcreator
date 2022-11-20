/* window.vala
 *
 * Copyright 2021 Alex
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Dwxmlcreator {
	[GtkTemplate (ui = "/com/github/alexkdeveloper/dwxmlcreator/window.ui")]
	public class Window : Gtk.ApplicationWindow {
		[GtkChild]
		unowned Gtk.Stack stack;
		[GtkChild]
		unowned Gtk.Box start_time_box;
        [GtkChild]
        unowned Gtk.Box add_box;
        [GtkChild]
        unowned Gtk.Box create_xml_box;
        [GtkChild]
        unowned Gtk.Button add_start_time_button;
        [GtkChild]
        unowned Gtk.Button add_button;
        [GtkChild]
        unowned Gtk.Button add_image_button;
        [GtkChild]
        unowned Gtk.Button create_button;
        [GtkChild]
        unowned Gtk.Button back_button;
        [GtkChild]
        unowned Gtk.Entry path_to_image;
        [GtkChild]
        unowned Gtk.Entry transition_duration;
        [GtkChild]
        unowned Gtk.Entry static_duration;
        [GtkChild]
        unowned Gtk.Entry path_to_xml_directory;
        [GtkChild]
        unowned Gtk.Entry xml_name;
        [GtkChild]
        unowned Gtk.Entry day;
        [GtkChild]
        unowned Gtk.Entry month;
        [GtkChild]
        unowned Gtk.Entry year;
        [GtkChild]
        unowned Gtk.Entry hours;
        [GtkChild]
        unowned Gtk.Entry minutes;
        [GtkChild]
        unowned Gtk.Entry seconds;
        [GtkChild]
        unowned Gtk.Label image_counter;

        private StringBuilder builder;

        private string last_folder;
        private string main_part;
        private string start_time;
        private string first_image;
        private string image;

        private int counter = 0;
        private int duration;

		public Window (Gtk.Application app) {
			Object (application: app);
			path_to_image.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "document-open-symbolic");
			path_to_image.icon_press.connect ((pos, event) => {
        if (pos == Gtk.EntryIconPosition.SECONDARY) {
              on_path_to_image();
           }
        });
        path_to_xml_directory.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "folder-open-symbolic");
			path_to_xml_directory.icon_press.connect ((pos, event) => {
        if (pos == Gtk.EntryIconPosition.SECONDARY) {
              on_path_to_xml_directory();
           }
          });
        transition_duration.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        transition_duration.icon_press.connect ((pos, event) => {
          if (pos == Gtk.EntryIconPosition.SECONDARY) {
                transition_duration.set_text("");
                transition_duration.grab_focus();
             }
          });
         static_duration.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         static_duration.icon_press.connect ((pos, event) => {
           if (pos == Gtk.EntryIconPosition.SECONDARY) {
                 static_duration.set_text("");
                 static_duration.grab_focus();
              }
           });
         xml_name.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         xml_name.icon_press.connect ((pos, event) => {
           if (pos == Gtk.EntryIconPosition.SECONDARY) {
                 xml_name.set_text("");
                 xml_name.grab_focus();
              }
           });
          day.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
          day.icon_press.connect ((pos, event) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                  day.set_text("");
                  day.grab_focus();
               }
            });
         month.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         month.icon_press.connect ((pos, event) => {
           if (pos == Gtk.EntryIconPosition.SECONDARY) {
                 month.set_text("");
                 month.grab_focus();
              }
           });
          year.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
          year.icon_press.connect ((pos, event) => {
            if (pos == Gtk.EntryIconPosition.SECONDARY) {
                  year.set_text("");
                  year.grab_focus();
               }
            });
         hours.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         hours.icon_press.connect ((pos, event) => {
           if (pos == Gtk.EntryIconPosition.SECONDARY) {
                 hours.set_text("");
                 hours.grab_focus();
              }
           });
         minutes.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         minutes.icon_press.connect ((pos, event) => {
           if (pos == Gtk.EntryIconPosition.SECONDARY) {
                 minutes.set_text("");
                 minutes.grab_focus();
              }
           });
         seconds.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         seconds.icon_press.connect ((pos, event) => {
           if (pos == Gtk.EntryIconPosition.SECONDARY) {
                 seconds.set_text("");
                 seconds.grab_focus();
              }
           });
			add_start_time_button.clicked.connect(add_start_time);
			add_image_button.clicked.connect(add_image);
			add_button.clicked.connect(go_to_create_xml_page);
			create_button.clicked.connect(create_xml);
			back_button.clicked.connect(go_to_back);
			set_widget_visible(back_button, false);
			builder = new StringBuilder();
			var date_time = new DateTime.now_local();
			day.set_text(date_time.format("%d"));
			month.set_text(date_time.format("%m"));
			year.set_text(date_time.format("%Y"));
            if(int.parse(date_time.format("%M"))>=55){
                hours.set_text((int.parse(date_time.format("%H"))+1).to_string());
            }else{
                hours.set_text(date_time.format("%H"));
            }
		}
		private void go_to_back(){
		    if (stack.get_visible_child_name()=="page1"){
                stack.visible_child = start_time_box;
                set_widget_visible(back_button, false);
		    }else{
		        stack.visible_child = add_box;
		    }
		}
		private void add_start_time(){
		if(is_empty(year.get_text())||is_empty(month.get_text())||is_empty(day.get_text())||
		is_empty(hours.get_text())||is_empty(minutes.get_text())||is_empty(seconds.get_text())){
            alert(_("Enter correct data in all fields!"));
            return;
		}
           start_time ="<background>
  <starttime>
    <year>"+year.get_text()+"</year>
    <month>"+month.get_text()+"</month>
    <day>"+day.get_text()+"</day>
    <hour>"+hours.get_text()+"</hour>
    <minute>"+minutes.get_text()+"</minute>
    <second>"+seconds.get_text()+"</second>
  </starttime>\n";
		    stack.visible_child = add_box;
		    set_widget_visible(back_button, true);
		}
		private void add_image(){
          if(is_empty(path_to_image.get_text())||is_empty(transition_duration.get_text())||
          is_empty(static_duration.get_text())){
              alert(_("Enter correct data in all fields!"));
              return;
          }
          counter++;
          string type = "type="+"\"overlay\"";
          duration = int.parse(static_duration.get_text())*60-int.parse(transition_duration.get_text());
          if(counter != 1){
             image = path_to_image.get_text();
             main_part ="<to>"+image+"</to>
  </transition>
  <static>
    <duration>"+duration.to_string()+".0"+"</duration>
    <file>"+image+"</file>
  </static>
  <transition "+type+">
    <duration>"+transition_duration.get_text()+".0"+"</duration>
    <from>"+image+"</from>\n";
    }else{
    first_image = path_to_image.get_text();
             main_part = "<static>
    <duration>"+duration.to_string()+".0"+"</duration>
    <file>"+first_image+"</file>
  </static>
  <transition "+type+"> 
    <duration>"+transition_duration.get_text()+".0"+"</duration>
    <from>"+first_image+"</from>\n";
    }
  image_counter.set_text(counter.to_string()+_(" images were added"));
  path_to_image.set_text("");
  builder.append(main_part);
   }
		private void go_to_create_xml_page(){
		  if(counter < 2){
		      alert(_("Add images"));
		      return;
		  }
		 stack.visible_child = create_xml_box;
		 xml_name.set_text("dynamic_wallpaper_"+Random.int_range(100,10000).to_string());
		}
        private void create_xml(){
           if(builder.str==""){
               alert(_("Nothing to create"));
               return;
           }
           if(is_empty(path_to_xml_directory.get_text())||is_empty(xml_name.get_text())){
               alert(_("Enter correct data in all fields!"));
               return;
           }
           string end_xml = "<to>"+first_image+"</to>
  </transition>
</background>";
           builder.append(end_xml);
           builder.insert(0, start_time);
           GLib.File file = GLib.File.new_for_path(path_to_xml_directory.get_text()+"/"+xml_name.get_text()+".xml");
            try {
              FileUtils.set_contents (file.get_path(), builder.str);
           } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
          }
            if(file.query_exists()){
                alert(_("File created successfully"));
            }else{
                alert(_("An unknown error has occurred!\nFailed to create file"));
            }
            counter = 0;
            builder = new StringBuilder();
            xml_name.set_text("");
            image_counter.set_text(_("Add images"));
        }
		private void on_path_to_image(){
		     var file_chooser = new Gtk.FileChooserNative (_("Select image file"), this, Gtk.FileChooserAction.OPEN, null, null){
                 local_only = true
            };
	    Gtk.FileFilter filter = new Gtk.FileFilter ();
		file_chooser.set_filter (filter);
		filter.add_mime_type ("image/jpeg");
        filter.add_mime_type ("image/png");
	    filter.add_mime_type ("image/svg+xml");
        Gtk.Image preview_area = new Gtk.Image ();
		file_chooser.set_preview_widget (preview_area);
		file_chooser.update_preview.connect (() => {
			string uri = file_chooser.get_preview_uri ();
			string path = file_chooser.get_preview_filename();
			if (uri != null && uri.has_prefix ("file://") == true) {
				try {
					Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file_at_scale (path, 250, 250, true);
					preview_area.set_from_pixbuf (pixbuf);
					preview_area.show ();
				} catch (Error e) {
					preview_area.hide ();
				}
			} else {
				preview_area.hide ();
			}
		});
		if (last_folder != null) {
            file_chooser.set_current_folder (last_folder);
        }
		file_chooser.response.connect ((response_id) => {
                if (response_id == Gtk.ResponseType.ACCEPT) {
                     last_folder = file_chooser.get_current_folder ();
                     path_to_image.set_text(file_chooser.get_filename());
                }
            });
            file_chooser.show ();
		}
		private void on_path_to_xml_directory(){
             var file_chooser = new Gtk.FileChooserNative (_("Choose a directory"), this, Gtk.FileChooserAction.SELECT_FOLDER, null, null){
                    local_only = true
                };
		file_chooser.response.connect ((response_id) => {
                if (response_id == Gtk.ResponseType.ACCEPT) {
                     path_to_xml_directory.set_text(file_chooser.get_filename());
                }
            });
            file_chooser.show ();
		}
		private void set_widget_visible (Gtk.Widget widget, bool visible) {
         widget.no_show_all = !visible;
         widget.visible = visible;
       }
      private void alert (string str){
          var dialog_alert = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, str);
          dialog_alert.set_title(_("Message"));
          dialog_alert.run();
          dialog_alert.destroy();
       }
       private bool is_empty(string str){
        return str.strip().length == 0;
        }
	}
}
