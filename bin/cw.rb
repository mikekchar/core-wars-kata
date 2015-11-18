require_relative "../lib/options"
require_relative "../lib/monitor"
require "readline"

options = Options.new()
options.parse(ARGV)
if options.interactive? then
  cl = Monitor.new("> ", Readline)
  while buf = cl.read
    p buf
  end
else
  puts("Nothing to do")
end

