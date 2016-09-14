LIB_NAME = 'DLX'
LIB_VERSION_FILE = File.join('lib', 'src', 'pixeldroid', 'dsa', 'DLX.ls')

begin
  load(File.join(ENV['HOME'], '.loom', 'tasks', 'loomlib.rake'))
  #load(File.join(ENV['HOME'], '.loom', 'tasks', 'loomlib_demo.rake')) # optional
rescue LoadError
  abort([
    'error: missing loomlib.rake',
    '  please install loomtasks before running this Rakefile:',
    '  https://github.com/pixeldroid/loomtasks/',
  ].join("\n"))
end
