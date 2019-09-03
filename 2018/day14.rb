input=ARGF.read.to_i
cook=->(check){
  e1=0
  e2=1
  score='37'
  i=0
  until i % 100000 == 0 && check.(score)
    score<<(score[e1].to_i + score[e2].to_i).to_s
    e1=(e1+score[e1].to_i+1) % score.size
    e2=(e2+score[e2].to_i+1) % score.size
    i+=1
  end
  score
}
puts cook.(->(score){ score.size >= input+10 })[input...input+10]
puts cook.(->(score){ score.index(input.to_s) }).index(input.to_s)
