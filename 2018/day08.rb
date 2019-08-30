input=ARGF.read.split.map(&:to_i)
nodes={}
metas=[]
walk=->(i) { start=i; c=input[i]; m=input[i+1]; i+=2; node={c: [], m: []}; (0...c).each { node[:c] << i; i = walk.(i) }; node[:m]=input[i...i+m]; metas+=input[i...i+m]; nodes[start]=node; input[start...i+m]; i + m }
walk.(0)
p metas.inject(&:+)
val=->(ni) { return 0 unless (n = nodes[ni]); n[:c].empty? ? n[:m].inject(&:+) : n[:m].inject(0) { |s, i| s + val.(n[:c][i-1]) } }
p val.(0)
