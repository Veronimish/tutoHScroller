tirs = {}
tirs.list = {}
tirs._NbMax = 5
tirs._Pause = 0.05
tirs._Speed = 10
tirs._MaxSpeed = 500
tirs._Acceleration = 1.1
tirs._DebugMsg = ""

function tirs.load()
  tirs.image = love.graphics.newImage("assets/laser.png")
  tirs.sound = love.audio.newSource("assets/sound/laserFire.ogg", "static")
  tirs.ox = tirs.image:getWidth()
  tirs.oy = tirs.image:getHeight() / 2
  tirs.pause = tirs._Pause
end

function tirs.add(pPlayer)
  if #tirs.list >= tirs._NbMax or tirs.pause > 0 then
    return 
  end
  local tir = {}
  tir.x = pPlayer.x + pPlayer.ox * 2
  tir.y = pPlayer.y
  tir.speed = tirs._Speed
  table.insert(tirs.list, tir)
  tirs.sound:rewind()
  tirs.sound:play()
  tirs.pause = tirs._Pause
end

function tirs.update(dt)
  if tirs.pause > 0 then
    tirs.pause = tirs.pause - dt
    if tirs.pause < 0 then
      tirs.pause = 0
    end
  end
  for i=#tirs.list,1,-1 do
    local tir = tirs.list[i]
    tir.x = tir.x + tir.speed * dt
    if tir.speed < tirs._MaxSpeed then
      tir.speed = tir.speed * tirs._Acceleration
    end
    if tir.x > SCREEN_WIDTH + tirs.ox then
      table.remove(tirs.list, i)
    elseif mines.laserCollision(tir) then
      table.remove(tirs.list, i)
    end
  end
  if _Debug then
    tirs._DebugMsg = "NbLaser="..#tirs.list
  end
end

function tirs.draw()
  for i=1,#tirs.list do
    local tir = tirs.list[i]
    love.graphics.draw(tirs.image, tir.x, tir.y, 0, 1, 1, tirs.ox, tirs.oy)
  end
end

return tirs