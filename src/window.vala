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
	public class Window : Adw.ApplicationWindow {
		[GtkChild]
		unowned Gtk.Stack stack;
		[GtkChild]
		unowned Gtk.Box start_time_box;
        [GtkChild]
        unowned Gtk.Box add_box;
        [GtkChild]
        unowned Gtk.Box create_xml_box;
        [GtkChild]
        unowned Gtk.Button add_image_button;
        [GtkChild]
        unowned Gtk.Button create_button;
        [GtkChild]
        unowned Gtk.Button back_button;
        [GtkChild]
        unowned Gtk.Button next_button;
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
        [GtkChild]
        unowned Adw.ToastOverlay overlay;

        private StringBuilder builder;

        private string main_part;
        private string start_time;
        private string first_image;
        private string image;

        private int counter = 0;
        private int duration;

		public Window (Adw.Application app) {
			Object (application: app);
			path_to_image.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "document-open-symbolic");
			path_to_image.icon_press.connect ((pos, event) => {
              on_path_to_image();
        });
        path_to_xml_directory.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "folder-open-symbolic");
			path_to_xml_directory.icon_press.connect ((pos, event) => {
              on_path_to_xml_directory();
          });
        transition_duration.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        transition_duration.icon_press.connect ((pos, event) => {
                transition_duration.set_text("");
                transition_duration.grab_focus();
          });
         static_duration.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         static_duration.icon_press.connect ((pos, event) => {
                 static_duration.set_text("");
                 static_duration.grab_focus();
           });
         xml_name.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         xml_name.icon_press.connect ((pos, event) => {
                 xml_name.set_text("");
                 xml_name.grab_focus();
           });
          day.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
          day.icon_press.connect ((pos, event) => {
                  day.set_text("");
                  day.grab_focus();
            });
         month.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         month.icon_press.connect ((pos, event) => {
                 month.set_text("");
                 month.grab_focus();
           });
          year.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
          year.icon_press.connect ((pos, event) => {
                  year.set_text("");
                  year.grab_focus();
            });
         hours.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         hours.icon_press.connect ((pos, event) => {
                 hours.set_text("");
                 hours.grab_focus();
           });
         minutes.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         minutes.icon_press.connect ((pos, event) => {
                 minutes.set_text("");
                 minutes.grab_focus();
           });
         seconds.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
         seconds.icon_press.connect ((pos, event) => {
                 seconds.set_text("");
                 seconds.grab_focus();
           });
			add_image_button.clicked.connect(add_image);
			create_button.clicked.connect(create_xml);
			back_button.clicked.connect(go_to_back);
            next_button.clicked.connect(go_to_next);
			set_widget_visible(back_button, false);
            set_widget_visible(create_button, false);
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
		    if (stack.get_visible_child()==add_box){
                stack.visible_child = start_time_box;
                set_widget_visible(back_button, false);
		    }else{
		        stack.visible_child = add_box;
		        set_widget_visible(next_button, true);
                set_widget_visible(create_button, false);
		    }
		}
		private void go_to_next(){
         if(stack.get_visible_child()==add_box){
            go_to_create_xml_page();
        }else{
            add_start_time();
          }
        }
		private void add_start_time(){
		if(is_empty(year.get_text())||is_empty(month.get_text())||is_empty(day.get_text())||
		is_empty(hours.get_text())||is_empty(minutes.get_text())||is_empty(seconds.get_text())){
            alert(_("Enter correct data in all fields!"),"");
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
              alert(_("Enter correct data in all fields!"),"");
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
		      set_toast(_("Add images"));
		      return;
		  }
		  set_widget_visible(next_button, false);
          set_widget_visible(create_button, true);
		 stack.visible_child = create_xml_box;
		 xml_name.set_text("dynamic_wallpaper_"+Random.int_range(100,10000).to_string());
		}
        private void create_xml(){
           if(builder.str==""){
               set_toast(_("Nothing to create"));
               return;
           }
           if(is_empty(path_to_xml_directory.get_text())||is_empty(xml_name.get_text())){
               alert(_("Enter correct data in all fields!"),"");
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
                alert(_("File created successfully"),"");
            }else{
                alert(_("An unknown error has occurred!\nFailed to create file"),"");
            }
            counter = 0;
            builder = new StringBuilder();
            xml_name.set_text("");
            image_counter.set_text(_("Add images"));
        }
		private void on_path_to_image(){
            var filter = new Gtk.FileFilter ();
            filter.add_mime_type ("image/jpeg");
            filter.add_mime_type ("image/png");
            filter.add_mime_type ("image/svg+xml");

            var filechooser = new Gtk.FileDialog () {
                title = _("Select image file"),
                modal = true,
                default_filter = filter
            };
            filechooser.open.begin (this, null, (obj, res) => {
                try {
                    var file = filechooser.open.end (res);
                    if (file == null) {
                        return;
                    }
                    path_to_image.text = file.get_path ();
                } catch (Error e) {
                    warning ("Failed to select image file: %s", e.message);
                }
            });
		}
		private void on_path_to_xml_directory(){
             var filechooser = new Gtk.FileDialog () {
                title = _("Choose a directory"),
                modal = true
            };
            filechooser.select_folder.begin (this, null, (obj, res) => {
                try {
                    var file = filechooser.select_folder.end (res);
                    if (file == null) {
                        return;
                    }
                    path_to_xml_directory.text = file.get_path ();
                } catch (Error e) {
                    warning ("Failed to choose a directory: %s", e.message);
                }
            });
		}
		private void set_widget_visible (Gtk.Widget widget, bool visible) {
         widget.visible = !visible;
         widget.visible = visible;
       }
        private void set_toast (string str){
            var toast = new Adw.Toast (str);
            toast.set_timeout (3);
            overlay.add_toast (toast);
        }
       private void alert (string heading, string body){
            var dialog_alert = new Adw.MessageDialog(this, heading, body);
            if (body != "") {
                dialog_alert.set_body(body);
            }
            dialog_alert.add_response("ok", _("_OK"));
            dialog_alert.set_response_appearance("ok", SUGGESTED);
            dialog_alert.response.connect((_) => { dialog_alert.close(); });
            dialog_alert.show();
        }
       private bool is_empty(string str){
        return str.strip().length == 0;
        }
	}
}
