require_relative "./command"

class Examine < Command
  EXAMINE_RE = /^E$/

  def match(command)
    EXAMINE_RE.match(command.upcase())
  end


  def execute
    return if @matchdata.nil?
    @monitor.puts("Warriors")
    @monitor.puts("--------")
    @monitor.mars.warriors.each_with_index do |warrior, i|
      @monitor.puts("#{i} - #{warrior}")
    end
  end
end
