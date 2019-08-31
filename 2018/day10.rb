points=ARGF.read.split("\n").map { |l| l.scan(/-?\d+/).map(&:to_i) }
secs=0
loop do
  secs+=1
  points.each_with_index do |(x, y, dx, dy), i|
    x+=dx; y+=dy
    points[i][0]=x
    points[i][1]=y
  end
  ys=points.map { |p| p[1] }; miny=ys.min; maxy=ys.max; h=maxy-miny
  break if h<=10 # super scientific
end
map=[]
points.each do |(x, y)|
  map[y] ||= []
  map[y][x] = '#'
end
map.each do |row|
  next if row.nil?
  row[199..-1].each do |pt|
    print(pt || '.')
  end
  puts
end
p secs
