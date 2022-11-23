dwxmlcreator_sources = [
  'main.vala',
  'window.vala',
]

dwxmlcreator_deps = [
  dependency ('gtk4'),
  dependency ('libadwaita-1'),
]

gnome = import('gnome')

dwxmlcreator_sources += gnome.compile_resources('dwxmlcreator-resources',
  'dwxmlcreator.gresource.xml',
  c_name: 'dwxmlcreator',
)

executable('com.github.alexkdeveloper.dwxmlcreator', dwxmlcreator_sources, 
include_directories: config_h_dir, vala_args: ['--target-glib=2.50', meson.source_root() + '/src/config.vapi'], 
c_args: ['-include', 'config.h'], 
dependencies: dwxmlcreator_deps,
install: true,
)
