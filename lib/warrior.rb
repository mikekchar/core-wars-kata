require_relative "./task_queue"

class Warrior
  def initialize(mars, address)
    @mars = mars
    @address = address
    @tasks = TaskQueue.new(mars)
    @tasks.new_task(address)
  end

  def step
    @tasks.step()
    @tasks.writeCache()
  end

  def to_s
    @tasks.status.join("\n")
  end
end
