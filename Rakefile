# Boilerplate
require 'find'
task :default => [:compile]

# Some Environment Tweaks
ENV['ERL_LIBS'] = File.expand_path './lib'

# Helpful Functions
def workers
  nodes = %x[scripts/list_nodes].grep /worker_\d+/
  nodes.collect do |l|
    l.chomp
  end
end

def glob( *args )
  Dir::glob *args
end

def renamefile(skeldir,modname,f)
  f = f.sub /^templates\/#{skeldir}\//, "lib/#{modname}-0.1/"
  f.gsub! /SKEL/,"#{modname}"
  f
end

def translate_line(modname,l)
  l = l.gsub /SKEL/, "#{modname}"
  l.gsub! /VSN/,  '0.1'
  l
end

def copy_skel( skeldir, modname )
  text_ext = ['.app','.erl']
  Find.find 'templates/' + skeldir do |f|
    if File.directory?(f)
      mkdir_p renamefile(skeldir,modname,f + '/')
    elsif File.file?(f)
      newname = renamefile(skeldir,modname,f)
      puts "translate #{f} #{newname}"
      if text_ext.include? File.extname(f)
        src = File.new(f)
        dst = File.new(newname,'w')
        src.each_line do |l|
          dst.write translate_line(modname,l)
        end
        src.close
        dst.close
      else
        cp f, newname
      end
    end
  end
end

## Tasks

# Building the Erlang Code
desc 'compile code (default)'
task :compile do
  Dir.glob('lib/*').each do |d|
    if File.directory?(d) and File.exists?(d + '/Emakefile')
      Dir.chdir d 
      sh 'erl', '-make'
      Dir.chdir '../..'
    end
  end
end

desc 'erase generated files'
task :clean do
  files  = glob('lib/*/ebin/*.beam')
  files += glob('cover/*.coverdata')
  files += glob('cover/*.html')
  files += glob('releases/*.{boot,script,tar.gz}')
  files += glob('erl_crash.dump')
  files += glob('releases/relup')
  rm_f files
end

# Testing
desc 'run tests (assumes TAP and prove command are available)'
task :test => [:compile] do
  sh 'prove', 'lib/*/tests/*.t','tests/*.t'
end

desc 'uses etap to generate code coverage report'
task :cover => [:compile] do
  ENV['COVER'] = '1'
  sh 'prove', 'lib/*/tests/*.t','tests/*.t'
  sh 'scripts/make_report'
end

desc 'lazy task to open the report on MacOSX'
task :report => [:cover] do
  sh 'open', 'cover/index.html'
end

# Workers and Such
desc 'open a console loaded with the apps in this library'
task :console => [:compile] do
  sh 'erl', '-sname', 'console'
end

desc 'lists workers'
task :workers do
  puts workers
end

desc 'starts workers'
task :start_workers, [:number] => [:compile] do |t,args|
  raise "workers already started" if workers.length > 0
  workers = args.number.to_i
  if workers > 0
    (0 ... workers).each do |x|
      sh 'scripts/start_node', sprintf('worker_%05d',x)
    end
  else
    puts 'Please specify how many workers to start...'
  end
end

desc 'kills workers'
task :kill_workers do
  workers.each do |w|
    sh "scripts/stop_node", w
  end
end

desc 'create a new app in the library (skel is optional)'
task :new_app, [:dir,:skel] do |t,args|
  args.with_defaults(:skel => 'skel')
  unless args[:dir]
    puts 'Please specify a name for the new application...'
    exit 1
  end 
  copy_skel args[:skel], args[:dir]
end

