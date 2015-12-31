require_relative "../lib/options"
require_relative "../lib/monitor"
require_relative "../lib/mars"
require "readline"

options = Options.new()
options.parse(ARGV)
mars = Mars.new(1024)
if options.interactive? then
  Monitor.new(mars, Readline, STDOUT).process()
else
  puts("Nothing to do")
end

