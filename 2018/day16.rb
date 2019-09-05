(input1,input2)=ARGF.read.split("\n\n\n\n")
reg=[0,0,0,0]
opcodes={
  addr: ->(a, b, c) { reg[c] = reg[a] + reg[b] },
  addi: ->(a, b, c) { reg[c] = reg[a] + b },
  mulr: ->(a, b, c) { reg[c] = reg[a] * reg[b] },
  muli: ->(a, b, c) { reg[c] = reg[a] * b },
  banr: ->(a, b, c) { reg[c] = reg[a] & reg[b] },
  bani: ->(a, b, c) { reg[c] = reg[a] & b },
  borr: ->(a, b, c) { reg[c] = reg[a] | reg[b] },
  bori: ->(a, b, c) { reg[c] = reg[a] | b },
  setr: ->(a, b, c) { reg[c] = reg[a] },
  seti: ->(a, b, c) { reg[c] = a },
  gtir: ->(a, b, c) { reg[c] = a > reg[b] ? 1 : 0 },
  gtri: ->(a, b, c) { reg[c] = reg[a] > b ? 1 : 0 },
  gtrr: ->(a, b, c) { reg[c] = reg[a] > reg[b] ? 1 : 0 },
  eqir: ->(a, b, c) { reg[c] = a == reg[b] ? 1 : 0 },
  eqri: ->(a, b, c) { reg[c] = reg[a] == b ? 1 : 0 },
  eqrr: ->(a, b, c) { reg[c] = reg[a] == reg[b] ? 1 : 0 },
}
p input1.split("\n\n").count { |sample|
  (before, instr, after) = sample.split("\n")
  before = before.scan(/\d+/).map(&:to_i)
  instr = instr.split.map(&:to_i)
  after = after.scan(/\d+/).map(&:to_i)
  c = opcodes.count { |name, fn|
    reg = before.dup
    fn.(*instr[1..-1])
    reg == after
  }
  c >= 3
}
nums={}
while opcodes.any?
  input1.split("\n\n").each { |sample|
    (before, instr, after) = sample.split("\n")
    before = before.scan(/\d+/).map(&:to_i)
    instr = instr.split.map(&:to_i)
    after = after.scan(/\d+/).map(&:to_i)
    matching = opcodes.select { |name, fn|
      reg = before.dup
      fn.(*instr[1..-1])
      reg == after
    }
    if matching.size == 1
      (name, fn) = matching.first
      nums[instr.first] = fn
      opcodes.delete(name)
    end
  }
end
reg=[0, 0, 0, 0]
input2.split("\n").map { |l| l.split.map(&:to_i) }.each { |o, a, b, c|
  nums[o].(a, b, c)
}
p reg[0]
