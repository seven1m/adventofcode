rules_raw=ARGF.read.split("\n").map { |l| l.match(/Step ([A-Z]).*step ([A-Z])/).to_a[1..-1] }
steps=(rules_raw.map(&:first) + rules_raw.map(&:last)).uniq.sort
rules=rules_raw.each_with_object({}) { |r, h| h[r.last] ||= []; h[r.last] << r.first }
until steps.empty?
  step=steps.detect { |s| (rules[s] || []).empty? }
  print step
  steps.delete(step)
  rules.values.map! { |r| r.delete(step) }
end
puts
steps=(rules_raw.map(&:first) + rules_raw.map(&:last)).uniq.sort
rules=rules_raw.each_with_object({}) { |r, h| h[r.last] ||= []; h[r.last] << r.first }
sec=0
workers={0=>nil, 1=>nil, 2=>nil, 3=>nil, 4=>nil}
loop do
  workers.each do |w, j|
    next unless j
    if j.last == 1
      step = j.first
      rules.values.map! { |r| r.delete(step) }
      workers[w] = nil
    end
    j[1] = j.last - 1
  end
  free=workers.select { |_, j| j.nil? }
  free.keys.each do |w|
    if (step=steps.detect { |s| (rules[s] || []).empty? })
      steps.delete(step)
      workers[w] = [step, 60 + (step.ord - 64)]
    end
  end
  break if workers.all? { |_, j| j.nil? }
  sec += 1
end
p sec
