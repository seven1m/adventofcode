input=ARGF.read.split("\n")
ipr=input.shift.split.last.to_i
input=input.map { |i| i=i.split; [i[0]] + i[1..-1].map(&:to_i) }
reg=[0,0,0,0,0,0]
opcodes={
  'addr' => ->(a, b, c) { reg[c] = reg[a] + reg[b] },
  'addi' => ->(a, b, c) { reg[c] = reg[a] + b },
  'mulr' => ->(a, b, c) { reg[c] = reg[a] * reg[b] },
  'muli' => ->(a, b, c) { reg[c] = reg[a] * b },
  'banr' => ->(a, b, c) { reg[c] = reg[a] & reg[b] },
  'bani' => ->(a, b, c) { reg[c] = reg[a] & b },
  'borr' => ->(a, b, c) { reg[c] = reg[a] | reg[b] },
  'bori' => ->(a, b, c) { reg[c] = reg[a] | b },
  'setr' => ->(a, b, c) { reg[c] = reg[a] },
  'seti' => ->(a, b, c) { reg[c] = a },
  'gtir' => ->(a, b, c) { reg[c] = a > reg[b] ? 1 : 0 },
  'gtri' => ->(a, b, c) { reg[c] = reg[a] > b ? 1 : 0 },
  'gtrr' => ->(a, b, c) { reg[c] = reg[a] > reg[b] ? 1 : 0 },
  'eqir' => ->(a, b, c) { reg[c] = a == reg[b] ? 1 : 0 },
  'eqri' => ->(a, b, c) { reg[c] = reg[a] == b ? 1 : 0 },
  'eqrr' => ->(a, b, c) { reg[c] = reg[a] == reg[b] ? 1 : 0 },
}
run=->{
  count=0
  ip=0
  reg4={}
  loop do
    ip=reg[ipr]
    if ip == 28
      if reg4.include?(reg[4])
        puts reg4.keys # <- last one here is the highest
        p reg[4]
        break
      end
      reg4[reg[4]]=true
      count+=1
      p count
    end
    instr=input[ip]
    break if instr.nil?
    (instr,a,b,c)=instr
    opcodes[instr].(a,b,c)
    reg[ipr]+=1
  end
}
reg=[0,0,0,0,0,0]
#reg[0]=15823996 # part 1
#reg[0]=10199686 # part 2
run.()
