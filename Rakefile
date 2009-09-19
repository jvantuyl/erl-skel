task :default => [:compile]

# Some Environment
lib_dir = File.expand_path '.'
ENV['ERL_LIBS'] = File.expand_path './lib'
 
task :help do
  puts 'Helpful Tasks:'
  puts '  compile:     Compiles all modules in lib'
  puts '  clean:       Removes all compiled modules'
  puts '  test:        Runs Unit Tests'
  puts '  cover:       Runs Unit Tests, Generating Code Coverage Report'
  puts '  report:      Opens Code Coverage Report (using open, basically for MacOSX)'
  puts '  live:        Starts a special debugging Erlang node with the shortname "live"'
  puts '  release:     Builds latest release defined in releases'
  puts '  add_release: Adds a new release'
  puts '  add_module:  Creates a new module'
end

task :compile do
  Dir.glob('lib/*').each do |d|
    if File.directory?(d) and File.exists?(d + '/Emakefile')
      Dir.chdir d 
      system 'erl -make'
      Dir.chdir '../..'
    end
  end
end

task :clean do
  system 'rm -f lib/*/ebin/*.beam'
  system 'rm -f cover/*.coverdata cover/*.html'
  system 'rm -f erl_crash.dump'
  system 'rm -f releases/*.{boot,script,tar.gz} releases/relup'
end

task :test => [:compile] do
  system 'prove lib/*/tests/*.t tests/*.t'
end

task :cover => [:compile] do
  ENV['COVER'] = '1'
  system 'prove lib/*/tests/*.t tests/*.t'
  system 'erl -noshell -s etap_report create -s init stop'
end

task :report => [:cover] do
  system 'open cover/index.html'
end

task :live => [:compile] do
  system 'erl -sname console'
end


