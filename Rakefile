# -*- mode: ruby; coding: utf-8 -*-

require "rdoc/task"

ENV["RDOCOPT"] = "" if ENV["RDOCOPT"]

desc "Starts up IRB with the qemu-rb library loaded."
task :console do
  ARGV.clear # IRB runs havoc otherwise
  require "irb"
  require_relative "lib/qemu"
  puts "Loaded qemu-rb, version #{Qemu::VERSION}"
  IRB.start
end

RDoc::Task.new do |r|
  r.rdoc_dir = "doc"
  r.rdoc_files.include("lib/**/*.rb", "*.rdoc", "COPYING", "COPYING.LESSER")
  r.title = "Qemu-rb RDocs"
  r.main = "README.rdoc"
  r.generator = "emerald" # Ignored if not there
end
