require_relative "./task_queue"

class Warrior
  attr_reader :tasks

  def initialize(core, address)
    @address = address
    @tasks = TaskQueue.new(core)
    @tasks.new_task(address)
  end

  def step
    @tasks.step()
    @tasks.writeCache()
  end

  def to_s
    @tasks.status.join("\n")
  end

  def killed?
    @tasks.empty?
  end
end
