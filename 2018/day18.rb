input=ARGF.read.split("\n")
forest=input.dup
round=->{
  new=forest.map(&:dup)
  forest.each_with_index { |line, y|
    line.chars.each_with_index { |c, x|
      points=[
        [y-1,x-1],
        [y-1,x],
        [y-1,x+1],
        [y,x-1],
        [y,x+1],
        [y+1,x-1],
        [y+1,x],
        [y+1,x+1],
      ].reject { |y, x| y.negative? || x.negative? || y>=forest.size || x>=forest[y].size }
      adj=points.map { |y, x| forest[y][x] }
      if forest[y][x]=='.'
        new[y][x]='|' if adj.count('|')>=3
      elsif forest[y][x]=='|'
        new[y][x]='#' if adj.count('#')>=3
      elsif forest[y][x]=='#'
        new[y][x]='.' unless adj.count('#')>=1 && adj.count('|')>=1
      end
    }
  }
  forest=new
}
10.times { round.() }
p forest.join.count('#') * forest.join.count('|')

forest=input.dup
500.times { round.() }
#compare=forest.dup
#i=0
#loop do
  #i+=1
  #round.()
  #break if forest==compare
#end
#puts "R=#{i} (repeat)"
# W=whole number; find X in (1000000000-500-X)/R = W
24.times { round.() }
p forest.join.count('#') * forest.join.count('|')
