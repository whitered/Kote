require 'sprout'

sprout 'as3'

task :default => :build

desc 'Build the swc package'
task :build => ['libs:signaller:fetch', 'kote.swc']



compc 'kote.swc' do |t|
  source_dir = 'src'
  t.output = 'bin/kote.swc'
  t.source_path << source_dir
  t.source_path << File.join('libs', 'signaller', 'src')
  t.static_link_runtime_shared_libraries = true
  t.include_classes << Dir.chdir(source_dir) { Dir.glob(File.join('**', '*.as'))}.map { |fn| fn.gsub('.as', '').gsub(File::SEPARATOR, '.') }
end



namespace :libs do
  namespace :signaller do

    desc 'Fetch signaller sources from github'
    task :fetch do
      system 'git submodule init'
      system 'git submodule update'
    end
  end
end