mines = {}
mines.list = {}
mines._NbMax = 20
mines._PauseMin = 0.5
mines._PauseMax = 2.0
mines._SpeedMin = 50
mines._SpeedMax = 90
mines._DebugMsg = ""
mines._Mask = 
{
  {x = -28, y = -18, radius = 13},            -- Définition du premier cercle.
  {x = -28, y = 13, radius = 10},             -- Définition du deuxième cercle.
  {x = -35, y = -10, width = 17, height = 17},-- Définition du rectangle.
  {x = -28, y = 13, radius = 40}              -- Définition du cercle de détection.
}
mines._NbImages = 8
mines._timerByFrame = 0.08

function mines.load()
  mines.image = love.graphics.newImage("assets/mine.png")
  mines.sheet = love.graphics.newImage("assets/mineAnimation.png")
  mines.ox = mines.image:getWidth()
  mines.oy = mines.image:getHeight() / 2
  mines.pause = 0
  mines.quadsList = {}
  for i=0,mines._NbImages-1 do
    table.insert(mines.quadsList, love.graphics.newQuad(mines.ox * i, 0, mines.ox, mines.oy * 2, mines.sheet:getWidth(), mines.oy * 2))
  end
  mines.index = 1
  mines.timer = 0
  mines.speedAmplifier = 1
end

function mines.add()
  if #mines.list >= mines._NbMax or mines.pause > 0 then
    return
  end
  local mine = {}
  mine.x = SCREEN_WIDTH + mines.ox * 2
  mine.y = math.random(mines.oy, SCREEN_HEIGHT - mines.oy)
  mine.px = mine.x
  mine.py = mine.y
  mine.rotation = 0
  mine.rotationSpeed = math.random(50, 150)
  mine.distanceRotation = math.random(50, 90)
  mine.noDeplacement = math.random(1,3)
  mine.speed = math.random(mines._SpeedMin, mines._SpeedMax)
  mine.mask = 
  {
    {x = mine.x + mines._Mask[1].x, y = mine.y + mines._Mask[1].y, radius = mines._Mask[1].radius},
    {x = mine.x + mines._Mask[2].x, y = mine.y + mines._Mask[2].y, radius = mines._Mask[2].radius},
    {x = mine.x + mines._Mask[3].x, y = mine.y + mines._Mask[3].y, width = mines._Mask[3].width, height = mines._Mask[3].height},
    {x = mine.x + mines._Mask[4].x, y = mine.y + mines._Mask[4].y, radius = mines._Mask[4].radius}
  }
  table.insert(mines.list, mine)
  mines.pause = math.random(mines._PauseMin, mines._PauseMax)
end

function mines.laserCollision(pLaser)
  for i=#mines.list,1,-1 do
    local mine = mines.list[i]
    if collisions.pointCircle(pLaser, mine.mask[1]) or
    collisions.pointCircle(pLaser, mine.mask[2]) or
    collisions.pointRectangle(pLaser, mine.mask[3]) then
      Explosions.add(mine.mask[2].x, mine.mask[2].y)
      table.remove(mines.list, i)
      Score.add()
      return true
    end
  end
  return false
end

function mines.playerCollision(pPlayer)
  for i=#mines.list,1,-1 do
    local mine = mines.list[i]
    if collisions.CircleCircle(pPlayer.mask, mine.mask[4]) then
      Explosions.add(mine.mask[2].x, mine.mask[2].y)
      table.remove(mines.list, i)
      return true
    end
  end
end

function mines.deplacement(pMine, dt)
  if pMine.noDeplacement == 1 then
    pMine.x = pMine.x - (pMine.speed * mines.speedAmplifier) * dt
    return
  elseif pMine.noDeplacement == 2 then
    pMine.x = pMine.x - (pMine.speed * mines.speedAmplifier) * dt
    pMine.rotation = pMine.rotation + math.rad(pMine.rotationSpeed) * dt
    pMine.y = pMine.py + math.cos(pMine.rotation) * ( pMine.distanceRotation)
  elseif pMine.noDeplacement == 3 then
    pMine.px = pMine.px - (pMine.speed * mines.speedAmplifier) * dt
    pMine.rotation = pMine.rotation + math.rad(pMine.rotationSpeed) * dt
    pMine.x = pMine.px + math.sin(pMine.rotation) * ( pMine.distanceRotation)
    pMine.y = pMine.py + math.cos(pMine.rotation) * ( pMine.distanceRotation)
  end
end

function mines.update(dt)
  mines.timer = mines.timer + dt
  if mines.timer >= mines._timerByFrame then
    mines.timer = 0
    mines.index = mines.index + 1
    if mines.index > mines._NbImages then
      mines.index = 1
    end
  end
  if mines.pause > 0 then
    mines.pause = mines.pause - dt
    if mines.pause < 0 then
      mines.pause = 0
    end
  else
    mines.add()
  end
  for i=#mines.list,1,-1 do
    local mine = mines.list[i]
    mines.deplacement(mine, dt)
    mine.mask[1].x = mine.x + mines._Mask[1].x
    mine.mask[1].y = mine.y + mines._Mask[1].y
    mine.mask[2].x = mine.x + mines._Mask[2].x
    mine.mask[2].y = mine.y + mines._Mask[2].y
    mine.mask[3].x = mine.x + mines._Mask[3].x
    mine.mask[3].y = mine.y + mines._Mask[3].y
    mine.mask[4].x = mine.x + mines._Mask[4].x
    mine.mask[4].y = mine.y + mines._Mask[4].y
    if mine.x < -mines.ox then
      table.remove(mines.list, i)
      Score.remove()
    end
  end
  if _Debug then
    mines._DebugMsg = "NbMines="..#mines.list
  end
end

function mines.draw()
  for i=1,#mines.list do
    local mine = mines.list[i]
    love.graphics.draw(mines.sheet, mines.quadsList[mines.index], mine.x, mine.y, 0, 1, 1, mines.ox, mines.oy)
    if _Debug then
      love.graphics.line(mine.x, mine.y - 10, mine.x, mine.y + 10)
      love.graphics.line(mine.x - 10, mine.y, mine.x + 10, mine.y)
      love.graphics.circle("line", mine.x - 28, mine.y - 18, 13)
      love.graphics.circle("line", mine.x - 28, mine.y + 13, 10)
      love.graphics.circle("line", mine.x - 28, mine.y + 13, 40)
      love.graphics.rectangle("line", mine.x - 35, mine.y - 10, 7, 17)
    end
  end
end

return mines