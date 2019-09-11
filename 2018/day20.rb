require_relative './lib/dijkstra'
w=Hash.new('#')
w[[0,0]]='X'
chars=ARGF.read.chars
walk=->(y,x){
  start_y=y;start_x=x
  loop {
    c=chars.shift
    break unless c
    case c
    when 'N'
      w[[y-1,x]]='-'
      y-=2
      w[[y,x]]='.'
    when 'E'
      w[[y,x+1]]='|'
      x+=2
      w[[y,x]]='.'
    when 'S'
      w[[y+1,x]]='-'
      y+=2
      w[[y,x]]='.'
    when 'W'
      w[[y,x-1]]='|'
      x-=2
      w[[y,x]]='.'
    when '('
      walk.(y,x)
    when ')'
      return
    when '|'
      (y,x)=[start_y,start_x]
    end
  }
}
walk.(0,0)
g=Graph.new
y1=w.keys.map(&:first).min
y2=w.keys.map(&:first).max
x1=w.keys.map(&:last).min
x2=w.keys.map(&:last).max
(y1-1..y2+1).each do |y|
  (x1-1..x2+1).each do |x|
    c=w[[y,x]]
    #print c
    case c
    when '.', 'X'
      g.add_node([y,x])
    when '|'
      g.add_edge([y,x-1], [y,x+1], 1)
    when '-'
      g.add_edge([y-1,x], [y+1,x], 1)
    end
  end
  #puts
end
(dist,paths)=g.dijkstra([0,0])
p dist.invert.sort.last.first
p dist.select { |_, v| v >= 1000 }.size
