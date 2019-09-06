ranges=ARGF.read.split("\n").map { |l|
  parts=l.split(", ")
  x=parts.grep(/x=/).first
  y=parts.grep(/y=/).first
  x=x[2..-1]
  if x.include?('..')
    (x1, x2) = x.split('..').map(&:to_i)
    x=(x1..x2).to_a
  else
    x=[x.to_i]
  end
  y=y[2..-1]
  if y.include?('..')
    (y1, y2) = y.split('..').map(&:to_i)
    y=(y1..y2).to_a
  else
    y=[y.to_i]
  end
  [x,y]
}
minx=ranges.flat_map(&:first).min
maxx=ranges.flat_map(&:first).max
miny=ranges.flat_map(&:last).min
maxy=ranges.flat_map(&:last).max
map=(miny..maxy+1).map { '.' * (maxx-minx+3) }
map[0][500-minx+1]='+'
ranges.each do |xx,yy|
  xx.each do |x|
    yy.each do |y|
      map[y-miny+1][x-minx+1] = '#'
    end
  end
end
drip=->{
  map.each_with_index.flat_map { |l, y|
    l.chars.each_with_index.map { |c, x|
      if c == '+' || c == '|' || c == '~'
        [y, x]
      end
    }
  }.compact.each { |y, x|
    next unless map[y+1]
    case map[y+1][x]
    when '.'
      map[y+1][x] = '|'
    when '#', '~'
      if map[y][x-1] == '.'
        map[y][x-1] = '|'
      end
      if map[y][x+1] == '.'
        map[y][x+1] = '|'
      end
    end
    map[y].gsub!(/#(\|+)#/) { "##{'~' * $1.size}#" }
  }
}
last=map.map(&:dup)
File.write('/tmp/map.txt', map.join("\n"))
loop do
  drip.()
  break if map == last
  last=map.map(&:dup)
  File.write('/tmp/map.txt', map.join("\n"))
end
p map.join.scan(/[~\|]/).size
p map.join.scan(/~/).size

