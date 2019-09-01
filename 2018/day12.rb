input=ARGF.read.split("\n")
state=input[0].split.last
offset=0
pad=->{ l=state.match(/^(\.+)/).to_s.size;state.gsub!(/^\.*|\.*$/,'.'*30);offset-=(30-l) }
pad.()
patterns=input[2..-1].map { |i| i.split(' => ') }
gen=->{
  state.chars.each_cons(5).each_with_index { |pot, idx|
    pot=pot.join
    found=false
    patterns.each { |p, o|
      if pot==p
        state[idx+2]=o
        found=true
        break
      end
    }
    state[idx+2]='.' unless found
  }
}
20.times { |i| gen.(); pad.() if i%25==0 }
score=->{ i=offset; state.each_char.inject(0) { |s, c| s=s+(c=='#' ? i : 0); i+=1; s } }
p score.()

state=input[0].split.last
offset=0
pad.()
500.times { |i| gen.(); pad.() if i%25==0 }
p score.()

state=input[0].split.last
offset=0
pad.()
5000.times { |i| gen.(); pad.() if i%25==0 }
p score.()

state=input[0].split.last
offset=0
pad.()
50000.times { |i| gen.(); pad.() if i%25==0 }
p score.()

# ^ that answer with 6 more repeating digits
# 399957 => 399999999957
