require_relative "./task"

class TaskQueue
  def initialize(mars)
    @mars = mars
    @queue = []
  end

  def new_task(address)
    task = Task.new(@mars, address)
    @queue << task
    task
  end

  def step
    @queue.each do |task| task.step() end
  end

  def status
    @queue.map do |task| task.to_s() end
  end

  def length
    @queue.length
  end
end
