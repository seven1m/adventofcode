events=ARGF.read.split(/\n/).sort
guards={}
guard=nil
asleep=nil
events.each do |event|
  case event
  when /Guard #(\d+)/ then guard=$1.to_i
  when /(\d\d)\].*asleep/ then asleep=$1.to_i
  when /(\d\d)\].*wakes/
    guards[guard] ||= []
    (asleep...$1.to_i).each { |m| guards[guard][m] = guards[guard][m].to_i + 1 }
  end
end
(guard, mins)=guards.sort_by { |g, m| m.compact.inject(&:+) }.last
sleepiest_min=mins.each_with_index.sort_by { |c, m| c.to_i }.last.last
p guard*sleepiest_min
(guard, mins)=guards.sort_by { |g, m| m.map(&:to_i).max }.last
sleepiest_min=mins.each_with_index.sort_by { |c, m| c.to_i }.last.last
p guard*sleepiest_min
