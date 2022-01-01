dwxmlcreator_sources = [
  'main.vala',
  'window.vala',
]

dwxmlcreator_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
]

gnome = import('gnome')

dwxmlcreator_sources += gnome.compile_resources('dwxmlcreator-resources',
  'dwxmlcreator.gresource.xml',
  c_name: 'dwxmlcreator'
)

executable('com.github.alexkdeveloper.dwxmlcreator', dwxmlcreator_sources,
  vala_args: '--target-glib=2.50',  dependencies: dwxmlcreator_deps,
  install: true,
)
