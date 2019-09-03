input=ARGF.read
track=input.tr('<', '-').tr('>', '-').tr('^', '|').tr('v', '|').split("\n")
orig_carts=input.split("\n").each_with_index.each_with_object([]) { |(row, y), a|
  row.each_char.each_with_index { |c, x|
    a<<[y,x,c,0] if %w[< > ^ v].include?(c)
  }
}
cycle=->(carts,remove=false){
  carts.sort.each { |cart|
    (y,x,c,d)=cart
    case c
    when '^'
      y-=1
      c='<' if track[y][x] == '\\'
      c='>' if track[y][x] == '/'
      (c=%w[< ^ >][d%3]; d+=1) if track[y][x] == '+'
    when 'v'
      y+=1
      c='>' if track[y][x] == '\\'
      c='<' if track[y][x] == '/'
      (c=%w[> v <][d%3]; d+=1) if track[y][x] == '+'
    when '<'
      x-=1
      c='^' if track[y][x] == '\\'
      c='v' if track[y][x] == '/'
      (c=%w[v < ^][d%3]; d+=1) if track[y][x] == '+'
    when '>'
      x+=1
      c='v' if track[y][x] == '\\'
      c='^' if track[y][x] == '/'
      (c=%w[^ > v][d%3]; d+=1) if track[y][x] == '+'
    end
    cart.replace([y,x,c,d])
    if (collide=(carts-[cart]).detect { |y2, x2| y2==y && x2==x })
      if remove
        carts.delete(cart)
        carts.delete(collide)
      else
        return true
      end
    end
  }
  return true if remove && carts.size==1
  false
}
debug=->{
  track.each_with_index { |row, y|
    row.each_char.each_with_index { |c, x|
      (_, _, x)=carts.detect { |(cy, cx)| y==cy && x==cx }
      print x || c
    }
    puts
  }
}
carts=orig_carts.map(&:dup)
#100.times { puts }
#debug.()
until cycle.(carts)
  #debug.()
end
p carts.group_by { |y, x| [y, x] }.detect { |k, v| v.size > 1 }.first.reverse

carts=orig_carts.map(&:dup)
#100.times { puts }
#debug.()
until cycle.(carts,:remove)
  #debug.()
end
p carts.first[0..1].reverse
