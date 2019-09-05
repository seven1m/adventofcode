require_relative './lib/dijkstra'

map=ARGF.read.split("\n")
units=[]
graph=->(sy, sx){
  g=Graph.new
  map.each_with_index { |line, y|
    line.chars.each_with_index { |c, x|
      next unless c == '.'
      next if units.any? { |uy, ux| y == uy && x == ux && (uy != sy || ux != sx) }
      g.add_node([y,x])
      [
        [-1,  0], # up
        [ 0, -1], # left
        [ 0,  1], # right
        [ 1,  0], # down
      ].each do |dy, dx|
        next if y+dy < 0 || x+dx < 0
        if map[y+dy][x+dx] == '.'
          next if units.any? { |uy, ux| y+dy == uy && x+dx == ux && (uy != sy || ux != sx) }
          g.add_edge([y,x], [y+dy,x+dx], 1)
        end
      end
    }
  }
  g.dijkstra([sy, sx])
}
map.each_with_index { |line, y|
  line.chars.each_with_index { |c, x|
    next unless %w[G E].include?(c)
    units<<[y,x,c,200]
    map[y][x]='.'
  }
}
free=->(y, x){
  map[y][x] == '.' && units.none? { |uy, ux| uy == y && ux == x }
}
debug=->{
  map.each_with_index { |line, y|
    line.chars.each_with_index { |c, x|
      unit=units.detect { |uy, ux| y == uy && x == ux }
      print unit ? unit[2] : c
    }
    print '   '
    puts units.select { |uy, *| uy == y }.sort.map { |_, _, u, hp| "#{u}(#{hp})" }.join(', ')
  }
}
move=->(unit){
  (y, x, u, hp) = unit
  (oy, ox) = [y, x]
  enemies=units.select { |_, _, eu| eu != u }
  return if enemies.empty?
  enemy_positions=enemies.map { |y, x| [[y-1,x], [y,x-1], [y,x+1], [y+1,x]] }.inject(&:+).select { |yy, xx| free.(yy, xx) || (yy==y && xx==x) }
  return if enemy_positions.any? { |ey, ex| ey == y && ex == x }
  return if enemy_positions.empty?
  (_, y, x, target, jumps) = [
    [-1,  0], # up
    [ 0, -1], # left
    [ 0,  1], # right
    [ 1,  0], # down
  ].map { |dy, dx|
    next unless free.(y+dy, x+dx)
    (dist, j)=graph.(y+dy, x+dx)
    dist=dist.slice(*enemy_positions)
    t=dist.sort_by { |(y, x), d| [d, y, x] }.first
    next unless t
    d=t.last
    [d, y+dy, x+dx, t, j]
  }.compact.sort.first
  if target
    ((ty, tx))=target
    #puts "#{u} at #{oy},#{ox} moves toward #{ty}, #{tx} by jumping to #{y}, #{x}"
    unit.replace([y, x, u, hp])
  end
}
attack=->(unit, elf_attack){
  (y, x, u, hp) = unit
  targets=units.select { |uy, ux, eu| eu != u && ((uy-y).abs+(ux-x).abs)==1 }
  hit_target=targets.sort_by { |y, x, _, hp| [hp, y, x] }.first
  if hit_target
    ((ty, tx))=hit_target
    hit_target[3] -= u == 'E' ? elf_attack : 3
    #puts "#{u} at #{y},#{x} hits #{hit_target.inspect}"
    hit_target.replace([]) if hit_target[3] <= 0
    units.reject!(&:empty?)
  end
}
round=->(elf_attack=3, end_if_elf_dies=false){
  elfs=units.count { |_, _, u| u == 'E' }
  return false if units.map { |_, _, u| u }.uniq.size <= 1
  units.sort.each { |unit|
    print '.'
    next if unit.empty?
    move.(unit)
    return false if units.map { |_, _, u| u }.uniq.size <= 1
    attack.(unit, elf_attack)
  }
  puts
  return false if end_if_elf_dies && elfs != units.count { |_, _, u| u == 'E' }
  true
}
play=->(elf_attack=3, end_if_elf_dies=false){
  puts '-' * 50
  rounds=0
  debug.()
  elfs=units.count { |_, _, u| u == 'E' }
  while round.(elf_attack, end_if_elf_dies)
    rounds+=1
    puts rounds
    debug.()
  end
  if end_if_elf_dies && elfs != units.count { |_, _, u| u == 'E' }
    puts "an elf died :-( after #{rounds} rounds"
  else
    puts
    puts "round=#{rounds}"
    hp=units.map { |_, _, _, hp| hp }.inject(&:+)
    puts "hp=#{hp}"
    puts "outcome=#{rounds*hp}"
    debug.()
  end
}

play.()
#play.(7, true) # an elf died :-( after 32 rounds
#play.(11, true) # an elf died :-( after 35 rounds
#play.(14, true) # an elf died :-( after 41 rounds
#play.(15, true) # an elf died :-( after 49 rounds (1 goblin left!)
play.(16, true)
