c=ARGF.read.split("\n").map { |c| c.split(', ').map(&:to_i) }
w=1000
map=[]
pts={}
c.each_with_index do |(x,y),i|
  x+=w/2; y+=w/2
  pts[i]=[x,y]
end
(0...w).each do |y|
  (0...w).each do |x|
    sorted=pts.map do |p, (px, py)|
      [p, (x-px).abs+(y-py).abs]
    end.sort_by(&:last)
    closest=sorted[0].last==sorted[1].last ? nil : sorted.first.first
    map[y] ||= []
    map[y][x]=closest
  end
end
inf=[map.first, map.last, map.map(&:first), map.map(&:last)].flatten.uniq
(0...w).each do |y|
  (0...w).each do |x|
    map[y][x] = nil if inf.include?(map[y][x])
  end
end
p pts.keys.map { |pt| map.flatten.count { |p| p == pt } }.max

(0...w).each do |y|
  (0...w).each do |x|
    sum=pts.map do |p, (px, py)|
      (x-px).abs+(y-py).abs
    end.inject(&:+)
    map[y] ||= []
    map[y][x]=sum if sum < 10_000
  end
end
p map.flatten.compact.size
