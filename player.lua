player = {}
player._DebugMsg = ""
player._NbImages = 8
player._timerByFrame = 0.08

function player.load()
  player.image = love.graphics.newImage("assets/player.png")
  player.sheet = love.graphics.newImage("assets/shipAnimation.png")
  player.width = player.sheet:getWidth() / player._NbImages
  player.ox = player.width / 2
  player.x = 10
  player.oy = player.image:getHeight() / 2
  player.y = SCREEN_HEIGHT / 2 - player.oy
  player.quadsList = {}
  for i=0,player._NbImages-1 do
    table.insert(player.quadsList, love.graphics.newQuad(player.width * i, 0, player.width, player.oy * 2, player.sheet:getWidth(), player.oy * 2))
  end
  player.index = 1
  player.timer = 0
  player.hull = 100
  player.mask = {x = player.x + player.ox + 10, y = player.y, radius = 35}
  player.nbFire = 0
  player.particules = {}
  player.particules.count = 5
  player.particules.list = {}
  player.particules.image = love.graphics.newImage("assets/part1.png")
  local p = love.graphics.newParticleSystem(player.particules.image, 100)
  p:setEmissionRate(50)
  p:setSpeed(10, 40)
  p:setSizes(0.4, 0.2)
  p:setColors( 255, 255, 0, 0, 255, 0, 0, 255)
  p:setEmitterLifetime(0.1)
  p:setParticleLifetime(1)
  p:setDirection(math.rad(180))
  p:setSpread(math.rad(45))
  p:stop()
  table.insert(player.particules.list, p)
  for i=1,4 do
    p = p:clone()
    table.insert(player.particules.list, p)
  end
  player.particules.list[1]:setPosition(24,0)
  player.particules.list[2]:setPosition(37,-6)
  player.particules.list[3]:setPosition(101,9)
  player.particules.list[4]:setPosition(77,-6)
  player.particules.list[5]:setPosition(44,15)
end

function player.destroy()
  player.hull = 100
  Score.nbLifes = Score.nbLifes - 1
  Score.nextLife = 0
  Explosions.add(player.x + player.ox, player.y)
end

function player.getHits()
  player.hull = player.hull - math.random(20,50)
  if player.hull < 0 then
    player.destroy()
  end
end

function player.update(dt)
  player.timer = player.timer + dt
  if player.timer >= player._timerByFrame then
    player.timer = 0
    player.index = player.index + 1
    if player.index > player._NbImages then
      player.index = 1
    end
  end
  if love.keyboard.isDown("down") then
    player.y = player.y + 5
    if player.y > SCREEN_HEIGHT then
      player.y = SCREEN_HEIGHT
    end
  end
  if love.keyboard.isDown("up") then
    player.y = player.y - 5
    if player.y < 0 then
      player.y = 0
    end
  end
  
  player.mask.x = player.x + player.ox + 10
  player.mask.y = player.y
  
  if Mines.playerCollision(player) then
    player.getHits()
  end
  
  
  if player.hull > 80 then 
    player.nbFire = 0 
  elseif player.hull > 60 then
    player.nbFire = 1
  elseif player.hull > 40 then
    player.nbFire = 2 
  elseif player.hull > 20 then
    player.nbFire = 3 
  else
    player.nbFire = 5 
  end
  
  if player.nbFire > 0 then
    for i=1,player.nbFire do
      player.particules.list[i]:start()
      player.particules.list[i]:update(dt)
    end
  end
  
  if _Debug then
    player._DebugMsg = "Player.y="..player.y
  end  
end

function player.draw()
  love.graphics.draw(player.sheet,player.quadsList[player.index], player.x, player.y, 0, 1, 1, 0, player.oy)
  for i=1,player.nbFire do
    love.graphics.draw(player.particules.list[i], player.x, player.y)
  end
  if _Debug then
    love.graphics.rectangle("line", player.x, player.y - player.oy, player.ox * 2, player.oy * 2)
    love.graphics.circle("line", player.x + player.ox + 10, player.y, 35)
  end
end

return player