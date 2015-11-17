require 'optparse'
class Options
  def initialize
    @options = {}
  end

  # Better to inject at the lowest possible level
  def parse(args)
    OptionParser.new do |opts|
      opts.banner = "Usage: cw.rb [options]"

      opts.on("-i", "--interactive", "Enter interactive mode") do |i|
        @options[:interactive] = i
      end
    end.parse(args)
    self 
  end

  def interactive?
    @options[:interactive] == true
  end

  # Doing this for now
  def empty?
    @options == {}
  end
end
