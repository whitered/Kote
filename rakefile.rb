require 'rubygems'
require 'bundler'
require 'bundler/setup'

require 'rake/clean'
require 'flashsdk'
require 'asunit4'

task :default => :build

desc 'Build the swc package'
task :build => 'kote.swc'

compc 'kote.swc' do |t|
  source_dir = 'src'
  t.output = 'bin/kote.swc'
  t.source_path << source_dir
  t.static_link_runtime_shared_libraries = true
  t.include_classes << Dir.chdir(source_dir) { Dir.glob(File.join('**', '*.as'))}.map { |fn| fn.gsub('.as', '').gsub(File::SEPARATOR, '.') }.join(',')
end

