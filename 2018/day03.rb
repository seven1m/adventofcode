claims=ARGF.read.split(/\n/).map { |c| c[1..-1].split(/: |@ |,|x/).map(&:to_i) }
map={}
claims.each do |(id, x, y, w, h)|
  (x...(x+w)).each do |xi|
    (y...(y+h)).each do |yi|
      map[[xi,yi]] ||= []
      map[[xi,yi]] << id
    end
  end
end
p map.values.count { |i| i.size >= 2 }
no=claims.map(&:first)
map.values.each { |si| si.each { |i| no.delete(i) } if si.size >= 2 }
p no
