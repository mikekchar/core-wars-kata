require_relative "./dat"
require_relative "./add"

module InstructionParser
  INSTRUCTIONS = ::DAT, ::ADD

  def self.construct(klass, string)
    matchdata = klass::INSTR_RE.match(string)
    return nil if matchdata.nil?

    klass.build(matchdata[1])
  end

  def self.parse(string)
    INSTRUCTIONS.select do |klass|
      construct(klass, string)
    end.first
  end
end
