require_relative "./dat"
require_relative "./add"

module InstructionParser
  def self.construct(klass, string)
    matchdata = klass.INSTR_RE.match(string)
    return nil if matchdata.nil?

    klass.build(matchdata[1])
  end

  def self.parse(string)
    instruction = self.construct(::DAT, string)
    if instruction.nil?
      instruction = construct(::ADD, string)
    end
    instruction
  end
end
