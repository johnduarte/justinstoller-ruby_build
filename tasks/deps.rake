
desc 'Install all dependencies locally'
task :deps => %w{deps:ruby deps:puppet deps:spec}

namespace :deps do
  desc 'Install Ruby gem dependencies'
  task :ruby do
    puts ''
    puts 'Installing Ruby gem dependencies'
    Dir.chdir ROOT do
      system( 'bundle install' )
    end
  end

  desc 'Install Puppet module dependencies'
  task :puppet do
    require 'fileutils'

    puts ''
    puts 'Installing Puppet module dependencies'
    Dir.chdir ROOT do
      system( 'bundle exec librarian-puppet install' )

    end
  end

  desc 'Install module unit testing dependencies'
  task :spec do
    Rake::Task['deps:puppet'].invoke

    Dir.chdir ROOT do
      modname = File.basename(ROOT).split('-', 2).pop
      fixture_path = File.join('modules', modname)
      File.symlink(ROOT, fixture_path) unless File.exists?(fixture_path)

      FileUtils.mkdir_p(File.join(ROOT, '.tmp'))
      FileUtils.touch(File.join(ROOT, '.tmp', 'site.pp'))
    end
  end
end

