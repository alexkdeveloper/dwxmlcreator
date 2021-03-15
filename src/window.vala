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
	[GtkTemplate (ui = "/org/example/App/window.ui")]
	public class Window : Gtk.ApplicationWindow {
		[GtkChild]
		Gtk.Stack stack;
		[GtkChild]
		Gtk.Box start_time_box;
        [GtkChild]
        Gtk.Box add_box;
        [GtkChild]
        Gtk.Box create_xml_box;
        [GtkChild]
        Gtk.Button add_start_time_button;
        [GtkChild]
        Gtk.Button add_button;
        [GtkChild]
        Gtk.Button add_image_button;
        [GtkChild]
        Gtk.Button create_button;
        [GtkChild]
        Gtk.Button back_button;
        [GtkChild]
        Gtk.Entry path_to_image;
        [GtkChild]
        Gtk.Entry transition_duration;
        [GtkChild]
        Gtk.Entry static_duration;
        [GtkChild]
        Gtk.Entry path_to_xml_directory;
        [GtkChild]
        Gtk.Entry xml_name;
        [GtkChild]
        Gtk.Entry day;
        [GtkChild]
        Gtk.Entry month;
        [GtkChild]
        Gtk.Entry year;
        [GtkChild]
        Gtk.Entry hours;
        [GtkChild]
        Gtk.Entry minutes;
        [GtkChild]
        Gtk.Entry seconds;
        [GtkChild]
        Gtk.Label image_counter;

        StringBuilder builder;

        string last_folder;
        string main_part;
        string start_time;
        string first_image;
        string image;

        int counter = 0;
        int duration;

		public Window (Gtk.Application app) {
			Object (application: app);
			path_to_image.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "document-open-symbolic");
			path_to_image.icon_press.connect ((pos, event) => {
        if (pos == Gtk.EntryIconPosition.SECONDARY) {
              on_path_to_image();
           }
        });
        path_to_xml_directory.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "document-open-symbolic");
			path_to_xml_directory.icon_press.connect ((pos, event) => {
        if (pos == Gtk.EntryIconPosition.SECONDARY) {
              on_path_to_xml_directory();
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
            alert("Enter correct data in all fields!");
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
              alert("Enter correct data in all fields!");
              return;
          }
          counter++;
          duration = int.parse(static_duration.get_text())*60-int.parse(transition_duration.get_text());
          if(counter != 1){
             image = path_to_image.get_text();
             main_part ="<to>"+image+"</to>
  </transition>
  <static>
    <duration>"+duration.to_string()+".0"+"</duration>
    <file>"+image+"</file>
  </static>
  <transition>
    <duration>"+transition_duration.get_text()+".0"+"</duration>
    <from>"+image+"</from>\n";
    }else{
    first_image = path_to_image.get_text();
             main_part = "<static>
    <duration>"+duration.to_string()+".0"+"</duration>
    <file>"+first_image+"</file>
  </static>
  <transition>
    <duration>"+transition_duration.get_text()+".0"+"</duration>
    <from>"+first_image+"</from>\n";
    }
  image_counter.set_text(counter.to_string()+" images were added");
  path_to_image.set_text("");
  builder.append(main_part);
   }
		private void go_to_create_xml_page(){
		  if(counter < 2){
		      alert("Add images");
		      return;
		  }
		 stack.visible_child = create_xml_box;
		 path_to_xml_directory.set_text(Environment.get_home_dir());
		 xml_name.set_text("dynamic_wallpaper_"+Random.int_range(100,10000).to_string());
		}
        private void create_xml(){
           if(builder.str==""){
               alert("Nothing to create");
               return;
           }
           if(is_empty(path_to_xml_directory.get_text())||is_empty(xml_name.get_text())){
               alert("Enter correct data in all fields!");
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
                alert("File created successfully");
            }else{
                alert("An unknown error has occurred! Failed to create file");
            }
            counter = 0;
            builder = new StringBuilder();
            xml_name.set_text("");
            image_counter.set_text("Add images");
        }
		private void on_path_to_image(){
		     var file_chooser = new Gtk.FileChooserDialog ("Select image file", this, Gtk.FileChooserAction.OPEN, "_Cancel", Gtk.ResponseType.CANCEL, "_Open", Gtk.ResponseType.ACCEPT);
	    Gtk.FileFilter filter = new Gtk.FileFilter ();
		file_chooser.set_filter (filter);
		filter.add_mime_type ("image/jpeg");
        filter.add_mime_type ("image/png");
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
        if (file_chooser.run () == Gtk.ResponseType.ACCEPT) {
            last_folder = file_chooser.get_current_folder ();
            path_to_image.set_text(file_chooser.get_filename());
        }
        file_chooser.destroy ();
		}
		private void on_path_to_xml_directory(){
             var file_chooser = new Gtk.FileChooserDialog ("Choose a directory", this, Gtk.FileChooserAction.SELECT_FOLDER, "_Cancel", Gtk.ResponseType.CANCEL, "_Open", Gtk.ResponseType.ACCEPT);
        if (file_chooser.run () == Gtk.ResponseType.ACCEPT) {
            path_to_xml_directory.set_text(file_chooser.get_filename());
        }
        file_chooser.destroy ();
		}
		private void set_widget_visible (Gtk.Widget widget, bool visible) {
         widget.no_show_all = !visible;
         widget.visible = visible;
       }
      private void alert (string str){
          var dialog_alert = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, str);
          dialog_alert.set_title("Message");
          dialog_alert.run();
          dialog_alert.destroy();
       }
       private bool is_empty(string str){
        return str.strip().length == 0;
        }
	}
}
