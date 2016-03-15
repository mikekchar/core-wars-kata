require_relative "./task"

class TaskQueue
  def initialize(mars)
    @mars = mars
    @core = mars.core
    @queue = []
  end

  def new_task(address)
    @mars.addLog("Task", @queue.length, "added")
    task = Task.new(self, @core, address)
    @queue << task
    task
  end

  def step()
    @queue.each do |task| task.step() end
  end

  def writeCache
    # FIXME:  We shouldn't write the caches for all the
    # tasks at once.
    @queue.each do |task| task.writeCache() end
  end

  def status
    @queue.map do |task| task.to_s() end
  end

  def remove(task)
    # FIXME: Put the correct id here
    @mars.addLog("Task", -1, "removed")
    @queue.delete(task)
  end

  def length
    @queue.length
  end

  def empty?
    @queue.length == 0
  end

  def [](index)
    @queue[index]
  end
end
