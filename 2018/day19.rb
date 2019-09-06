input=ARGF.read.split("\n")
ipr=input.shift.split.last.to_i
reg=[0,0,0,0,0,0]
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
ip=0
loop do
  ip=reg[ipr]
  instr=input[ip]
  break if instr.nil?
  (instr,a,b,c)=instr.split
  (a,b,c)=[a,b,c].map(&:to_i)
  opcodes[instr.to_sym].(a,b,c)
  reg[ipr]+=1
end
p reg[0]

reg=[1,0,0,0,0,0]
20.times {
  ip=reg[ipr]
  instr=input[ip]
  (instr,a,b,c)=instr.split
  (a,b,c)=[a,b,c].map(&:to_i)
  opcodes[instr.to_sym].(a,b,c)
  reg[ipr]+=1
}
p2_number=reg[2]
factors=(1..p2_number).select { |n| p2_number % n == 0 }
p factors.inject(&:+)
