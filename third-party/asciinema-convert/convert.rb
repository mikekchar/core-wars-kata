require 'json'
require 'open3'
require 'stringio'

class Hash
  def slice *keys
    select{|k| keys.member?(k)}
  end
end

class Stdout
  include Enumerable

  class SingleFile < self
    attr_reader :path

    def initialize(path)
      @path = path
      @stdout = JSON.load(File.read(path))['stdout']
    end

    def each(&blk)
      @stdout.each(&blk)
    end

  end

  class Buffered < self
    MIN_FRAME_LENGTH = 1.0 / 60

    attr_reader :stdout

    def initialize(stdout)
      @stdout = stdout
    end

    def each
      buffered_delay, buffered_data = 0.0, []

      stdout.each do |delay, data|
        if buffered_delay + delay < MIN_FRAME_LENGTH || buffered_data.empty?
          buffered_delay += delay
          buffered_data << data
        else
          yield(buffered_delay, buffered_data.join)
          buffered_delay = delay
          buffered_data = [data]
        end
      end

      yield(buffered_delay, buffered_data.join) unless buffered_data.empty?
    end

  end
end

class Terminal

  CURRENT_PATH = File.dirname(__FILE__)
  BINARY_PATH = CURRENT_PATH + "/terminal"

  def initialize(width, height)
    @process = Process.new("#{BINARY_PATH} #{width} #{height}")
  end

  def feed(data)
    process.write("d\n#{data.bytesize}\n")
    process.write(data)
  end

  def snapshot
    process.write("p\n")
    lines = JSON.parse(process.read_line)

    Snapshot.build(lines)
  end

  def cursor
    process.write("c\n")
    c = JSON.parse(process.read_line)

    Cursor.new(c['x'], c['y'], c['visible'])
  end

  def release
    process.stop
  end

  private

  attr_reader :process

  class Process

    def initialize(command)
      @stdin, @stdout, @thread = Open3.popen2(command)
    end

    def write(data)
      raise "terminal died" unless @thread.alive?
      @stdin.write(data)
    end

    def read_line
      raise "terminal died" unless @thread.alive?
      @stdout.readline.strip
    end

    def stop
      @stdin.close
    end

  end

end

class Cursor

  attr_reader :x, :y, :visible

  def initialize(x, y, visible)
    @x, @y, @visible = x, y, visible
  end

  def diff(other)
    diff = {}
    diff[:x] = x if other && x != other.x || other.nil?
    diff[:y] = y if other && y != other.y || other.nil?
    diff[:visible] = visible if other && visible != other.visible || other.nil?

    diff
  end

end

class Grid

  attr_reader :width, :height, :lines

  def initialize(lines)
    @lines = lines
    @width = lines.first && lines.first.inject(0) { |l| l.size } || 0
    @height = lines.size
  end

  def crop(x, y, width, height)
    cropped_lines = lines[y...y+height].map { |line| crop_line(line, x, width) }

    self.class.new(cropped_lines)
  end

  def diff(other)
    (0...height).each_with_object({}) do |y, diff|
      if other.nil? || other.lines[y] != lines[y]
        diff[y] = lines[y]
      end
    end
  end

  def as_json(*)
    lines.as_json
  end

  private

  def crop_line(line, x, width)
    n = 0
    cells = []

    line.each do |cell|
      if n <= x && x < n + cell.size
        cells << cell[x-n...x-n+width]
      elsif x < n && x + width >= n + cell.size
        cells << cell
      elsif n < x + width && x + width < n + cell.size
        cells << cell[0...x+width-n]
      end

      n += cell.size
    end

    cells
  end

end

class Snapshot < Grid

  def self.build(data)
    data = data.map { |cells|
      cells.map { |cell|
        Cell.new(cell[0], Brush.new(cell[1]))
      }
    }

    new(data)
  end

  def thumbnail(w, h)
    x = 0
    y = height - h - trailing_empty_lines
    y = 0 if y < 0

    crop(x, y, w, h)
  end

  private

  def trailing_empty_lines
    n = 0

    (height - 1).downto(0) do |y|
      break unless line_empty?(y)
      n += 1
    end

    n
  end

  def line_empty?(y)
    lines[y].empty? || lines[y].all? { |cell| cell.empty? }
  end

end

class Cell

  attr_reader :text, :brush

  def initialize(text, brush)
    @text = text
    @brush = brush
  end

  def size
    text.size
  end

  def empty?
    text.blank? && brush.default?
  end

  def ==(other)
    text == other.text && brush == other.brush
  end

  def [](*args)
    self.class.new(text[*args], brush)
  end

  def as_json(*)
    [text, brush.as_json]
  end

  def to_json(*)
    JSON.dump(as_json)
  end

end

class Brush

  ALLOWED_ATTRIBUTES = [:fg, :bg, :bold, :underline, :inverse, :blink]
  DEFAULT_FG_CODE = 7
  DEFAULT_BG_CODE = 0

  def initialize(attributes = {})
    @attributes = Hash[*attributes.map { |k,v| [k.to_sym, v] }.flatten]
  end

  def ==(other)
    fg == other.fg &&
      bg == other.bg &&
      bold? == other.bold? &&
      underline? == other.underline? &&
      blink? == other.blink?
  end

  def fg
    inverse? ? bg_code || DEFAULT_BG_CODE : fg_code
  end

  def bg
    inverse? ? fg_code || DEFAULT_FG_CODE : bg_code
  end

  def bold?
    !!attributes[:bold]
  end

  def underline?
    !!attributes[:underline]
  end

  def inverse?
    !!attributes[:inverse]
  end

  def blink?
    !!attributes[:blink]
  end

  def default?
    fg.nil? && bg.nil? && !bold? && !underline? && !inverse? && !blink?
  end

  def as_json(*)
    attributes.slice(*ALLOWED_ATTRIBUTES)
  end

  protected

  attr_reader :attributes

  private

  def fg_code
    calculate_code(:fg, bold?)
  end

  def bg_code
    calculate_code(:bg, blink?)
  end

  def calculate_code(attr_name, strong)
    code = attributes[attr_name]

    if code
      if code < 8 && strong
        code += 8
      end
    end

    code
  end

end

class JsonFileWriter

  def write_enumerable(file, array)
    first = true
    file << '['

    array.each do |item|
      if first
        first = false
      else
        file << ','
      end

      file << item.to_json
    end

    file << ']'
    file.close
  end

end

class Film

  def initialize(stdout, terminal)
    @stdout = stdout
    @terminal = terminal
  end

  def snapshot_at(time)
    stdout_each_until(time) do |delay, data|
      terminal.feed(data)
    end

    terminal.snapshot
  end

  def frames
    frames = stdout.map do |delay, data|
      terminal.feed(data)
      [delay, Frame.new(terminal.snapshot, terminal.cursor)]
    end

    FrameDiffList.new(frames)
  end

  private

  def stdout_each_until(seconds)
    stdout.each do |delay, frame_data|
      seconds -= delay
      break if seconds <= 0
      yield(delay, frame_data)
    end
  end

  attr_reader :stdout, :terminal

end

class Frame

  attr_reader :snapshot, :cursor

  def initialize(snapshot, cursor)
    @snapshot = snapshot
    @cursor = cursor
  end

  def diff(other)
    FrameDiff.new(snapshot_diff(other), cursor_diff(other))
  end

  private

  def snapshot_diff(other)
    snapshot.diff(other && other.snapshot)
  end

  def cursor_diff(other)
    cursor.diff(other && other.cursor)
  end

end

class FrameDiff

  def initialize(line_changes, cursor_changes)
    @line_changes = line_changes
    @cursor_changes = cursor_changes
  end

  def as_json(*)
    json = {}
    json[:lines] = line_changes unless line_changes.empty?
    json[:cursor] = cursor_changes unless cursor_changes.empty?

    json
  end

  def to_json(*)
    JSON.dump(as_json)
  end

  private

  attr_reader :line_changes, :cursor_changes

end

class FrameDiffList
  include Enumerable

  def initialize(frames)
    @frames = frames
  end

  def each(*args, &blk)
    frame_diffs.each(*args, &blk)
  end

  private

  attr_reader :frames

  def frame_diffs
    previous_frame = nil

    frames.map { |delay, frame|
      diff = frame.diff(previous_frame)
      previous_frame = frame
      [delay, diff]
    }
  end

end

input_file = ARGV[0]
output_file = ARGV[1]

asciicast = JSON.load(File.read(input_file))
terminal = Terminal.new(asciicast['width'], asciicast['height'])
stdout = Stdout::Buffered.new(Stdout::SingleFile.new(input_file))
film = Film.new(stdout, terminal)
if true
  # Original code
  file = File.open(output_file, 'w')
  JsonFileWriter.new.write_enumerable(file, film.frames)
  terminal.release
else
  # Pretty printed JSON
  # This is nice, but it doubles the file size since there
  # are a *lot* of carriage returns
  file = StringIO.new()
  JsonFileWriter.new.write_enumerable(file, film.frames)
  terminal.release
  out = File.open(output_file, 'w')
  json = JSON.parse(file.string)
  pretty_json = JSON.pretty_generate(json)
  out.write(pretty_json)
  out.close()
end
