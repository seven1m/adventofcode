(pc, high) = ARGF.read.scan(/\d+/).map(&:to_i)
class Node < Struct.new(:val, :left, :right); end
debug=->(c) { n=c; all=[]; loop { all<<n.val; n=n.right; break if n==c }; p all }
play=->(high){
  c=Node.new(0); c.left=c; c.right=c
  players=Array.new(pc, 0)
  pi=0
  (1..high).each do |val|
    pi=0 if pi>=players.size
    c=c.right
    new=Node.new(val, c, c.right)
    if val % 23 == 0
      players[pi]+=val
      8.times { c=c.left }
      players[pi]+=c.val
      c.left.right=c.right
      c.right.left=c.left
      c=c.right
    else
      c.right=new
      new.right.left=new
      c=c.right
    end
    #debug.(c)
    pi+=1
  end
  players.max
}
p play.(high)
p play.(high * 100)
