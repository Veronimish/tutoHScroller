explosions = {}
explosions.list = {}
explosions._NbImages = 12
explosions._timerByFrame = 0.09
explosions._Radius = 50

function explosions.load()
  explosions.image = love.graphics.newImage("assets/explosion.png")
  explosions.sound = love.audio.newSource("assets/sound/explosion.ogg", "static")
  explosions.width = explosions.image:getWidth() / explosions._NbImages
  explosions.height = explosions.image:getHeight()
  explosions.ox = explosions.width / 2
  explosions.oy = explosions.height / 2
  explosions.quadsList = {}
  for i=0,explosions._NbImages-1 do
    table.insert(explosions.quadsList, love.graphics.newQuad(explosions.width * i, 0, explosions.width, explosions.height, explosions.width * explosions._NbImages, explosions.height))
  end
end

function explosions.add(x, y)
  local explo = {}
  explo.x = x
  explo.y = y
  explo.radius = explosions._Radius
  explo.index = 1
  explo.timer = 0
  table.insert(explosions.list, explo)
  explosions.sound:rewind()
  explosions.sound:play()
end

function explosions.update(dt)
  for i=#explosions.list,1,-1 do
    local explo = explosions.list[i]
    explo.timer = explo.timer + dt
    if explo.timer >= explosions._timerByFrame then
      explo.timer = 0
      explo.index = explo.index + 1
    end
    if explo.index > explosions._NbImages then
      table.remove(explosions.list, i)
    end
  end
end

function explosions.draw()
  for i=1,#explosions.list do
    local explo = explosions.list[i]
    love.graphics.draw(explosions.image, explosions.quadsList[explo.index], explo.x, explo.y, 0, 1, 1, explosions.ox, explosions.oy)
  end
end

return explosions