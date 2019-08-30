ids=ARGF.read.split(/\n/)
p ids.count { |id| ('a'..'z').any? { |l| id.count(l) == 2 } } *
  ids.count { |id| ('a'..'z').any? { |l| id.count(l) == 3 } }
ids.each do |id1|
  id2 = ids.find do |id2|
    id1.each_char.each_with_index.count { |c, i| id2[i] == c } == 25
  end
  (p id1, id2; break) if id2
end
