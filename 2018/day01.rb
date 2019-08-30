c=ARGF.read.each_line.map(&:to_i); p c.inject(&:+)
f=0; a={}; loop { c.each { |i| f+=i; a[f] ? (p f; exit) : a[f]=1 } }; 
