require_relative "../lib/options"
require_relative "../lib/monitor"
require_relative "../lib/core"
require_relative "../lib/mars"
require "readline"

options = Options.new()
options.parse(ARGV)
core = Core.new(1024)
mars = Mars.new(core)
if options.interactive? then
  Monitor.new(mars, Readline, STDOUT).process()
else
  puts("Nothing to do")
end

