require_relative "./task_queue"

class Warrior
  attr_reader :tasks

  def initialize(id, core, address)
    @id = id
    @address = address
    @tasks = TaskQueue.new(core)
    @tasks.new_task(address)
  end

  def step
    @tasks.step()
    @tasks.writeCache()
  end

  def to_s
    return "" if @tasks.length == 0
    # FIXME: The \n is probably not what I want...
    "#{@id} - #{@tasks.status.join("\n")}"
  end

  def killed?
    @tasks.empty?
  end
end
