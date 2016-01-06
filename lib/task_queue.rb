require_relative "./task"

class TaskQueue
  def initialize(mars)
    @mars = mars
    @queue = []
  end

  def new_task(address)
    @queue << Task.new(@mars, address)
  end

  def step
    @queue.each do |task| task.step() end
  end

  def status
    @queue.map do |task| task.to_s() end
  end
end
