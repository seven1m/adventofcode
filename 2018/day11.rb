input=ARGF.read.to_i
map=[]
(0...300).each do |y|
  map[y]=[]
  (0...300).each do |x|
    rackid=x+10
    map[y][x]=((rackid*y+input)*rackid).to_s.chars[-3].to_i-5
  end
end
cache={}
calc=->(s) {
  powers=(0..300-s).to_a.product((0..300-s).to_a).map do |y, x|
    p=if (c=cache[[x,y,s-1]])
        right=(y...y+s).map { |y| map[y][x+s-1] }.inject(&:+)
        bottom=(x...x+s-1).map { |x| map[y+s-1][x] }.inject(&:+)
        c+right+bottom
      else
        (y...y+s).to_a.product((x...x+s).to_a).map { |y, x| map[y][x] }.inject(&:+)
      end
    cache[[x,y,s]]=p
    [x, y, p]
  end
  powers.sort_by(&:last).last
}
p calc.(3)
best=[nil, nil, nil, 0]
p (1..300).map { |s|
  (x, y, pwr)=calc.(s)
  [x, y, s, pwr]
}.sort_by(&:last).last
