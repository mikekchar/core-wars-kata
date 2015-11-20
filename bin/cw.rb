require_relative "../lib/options"
require_relative "../lib/monitor"
require_relative "../lib/core"
require "readline"

options = Options.new()
options.parse(ARGV)
core = Core.new(1024)
if options.interactive? then
  Monitor.new(core, Readline, STDOUT).process()
else
  puts("Nothing to do")
end

