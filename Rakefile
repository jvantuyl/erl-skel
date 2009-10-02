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
  l.gsub! /VSN/,  "0.1"
  l
end

def copy_skel( skeldir, modname )
  text_ext = ['.app','.erl']
  Find.find 'templates/' + skeldir do |f|
    if File.directory?(f)
      mkdir_p renamefile(skeldir,modname,f + '/')
    elsif File.file?(f)
      newname = renamefile(skeldir,modname,f)
      print "translate #{f} #{newname}\n"
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

# Administrivia
task :help do
  puts 'Helpful Tasks:'
  puts '  compile:          Compiles all modules in lib'
  puts '  clean:            Removes all compiled modules'
  puts '  test:             Runs Unit Tests'
  puts '  cover:            Runs Unit Tests, Generating Code Coverage Report'
  puts '  report:           Opens Code Coverage Report (using open, for MacOSX)'
  puts '  console:          starts an interactive Erlang node as a console'
  puts '  workers:          Lists running worker processes'
  puts '  start_workers[N]: starts N detached workers, if none are running'
  puts '  kill_workers:     kills any running workers'
  puts '  release:          Builds latest release defined in releases'
  puts '  add_release:      Adds a new release'
  puts '  new_module:       Creates a new module'
end

# Building the Erlang Code
task :compile do
  Dir.glob('lib/*').each do |d|
    if File.directory?(d) and File.exists?(d + '/Emakefile')
      Dir.chdir d 
      sh 'erl', '-make'
      Dir.chdir '../..'
    end
  end
end

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
task :test => [:compile] do
  sh 'prove', 'lib/*/tests/*.t','tests/*.t'
end

task :cover => [:compile] do
  ENV['COVER'] = '1'
  sh 'prove', 'lib/*/tests/*.t','tests/*.t'
  sh 'scripts/make_report'
end

task :report => [:cover] do
  sh 'open', 'cover/index.html'
end

# Workers and Such
task :console => [:compile] do
  sh 'erl', '-sname', 'console'
end

task :workers do
  puts workers
end

task :start_workers, [:number] => [:compile] do |t,args|
  raise "workers already started" if workers.length > 0
  workers = args.number.to_i
  if workers > 0
    (0 ... workers).each do |x|
      sh "scripts/start_node", sprintf("worker_%05d",x)
    end
  else
    puts "Please specify how many workers to start..."
  end
end

task :kill_workers do
  workers.each do |w|
    sh "scripts/stop_node", w
  end
end

task :new_module, [:dir,:skel] do |t,args|
  args.with_defaults(:skel => 'skel')
  copy_skel args[:skel], args[:dir]
end
