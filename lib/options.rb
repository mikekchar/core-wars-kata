require 'optparse'
class Options
  def initialize
    @options = {}
  end

  def parse
    OptionParser.new do |opts|
      opts.banner = "Usage: cw.rb [options]"

      opts.on("-i", "--interactive", "Enter interactive mode") do |i|
        @options[:interactive] = i
      end
    end.parse!
  end

  def interactive?
    @options[:interactive] == true
  end
end
