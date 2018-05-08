score = {}

function score.load()
  fonteMedium = love.graphics.newFont("assets/kenvector_future.ttf", 15)
  fonteSmall = love.graphics.newFont("assets/kenvector_future.ttf", 9)
  love.graphics.setFont(fonteMedium)
  score.global = 0
  score.nbMines = 0
  score.nbLifes = 3
  score.maxLife = 5
  score.nextLife = 0
  score.nextLifeCap = 1000
  score.nextLifePercent = 0
  score.nextSpeedIncrement = 0.05
  score.maxSpeedAmplifier = 3
  score.mineExplode = 10
  score.mineWin = 100
  score.gameOver = false
end

function score.add()
  score.nbMines = score.nbMines + 1
  if Mines.speedAmplifier < score.maxSpeedAmplifier then
    Mines.speedAmplifier = Mines.speedAmplifier + score.nextSpeedIncrement
  end

  score.global = score.global + score.mineExplode
  if score.nbLifes < score.maxLife then
    score.nextLife = score.nextLife + score.mineExplode
    score.nextLifePercent = math.floor(score.nextLife/score.nextLifeCap * 100)
  end
  if score.nextLife == score.nextLifeCap then
    score.nextLife = 0
    score.nextLifePercent = 0
    if score.nbLifes < score.maxLife then
      score.nbLifes = score.nbLifes + 1
    end
  end
end

function score.remove()
  score.nextLife = score.nextLife - score.mineWin
  score.nextLifePercent = math.floor(score.nextLife/score.nextLifeCap * 100)
  if score.nextLife < 0 then
    score.nbLifes = score.nbLifes - 1
    score.nextLife = 0
    player.hull = 100
    Explosions.add(Player.x + Player.ox, Player.y)
  end
end

function score.update(dt)
end

function score.draw()
  lg.setColor(0,0,128,50)
  lg.rectangle("fill", 0,0,SCREEN_WIDTH, 30)
  lg.setColor(255,255,255)
  lg.rectangle("line", 0,0,SCREEN_WIDTH, 30)
  lg.draw(Player.image, 0, 0, 0, 0.5, 0.5)
  lg.draw(Mines.image, 95, 0, 0, 0.5, 0.5)
  love.graphics.setFont(fonteMedium)
  lg.print(score.nbLifes, 60, 5)
  lg.print(score.nbMines, 120, 5)
  lg.print("Score : "..score.global, 280, 5)
  lg.setColor(255,0,0,70)
  lg.rectangle("fill", 160, 5, score.nextLifePercent, 20)
  lg.setColor(255,255,255)
  lg.rectangle("line", 160, 5, 100, 20)
  lg.setFont(fonteSmall)
  lg.print("next life",180, 10) 
end

return score