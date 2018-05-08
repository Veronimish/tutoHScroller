bg = {}

function bg.load()
  bg.mainImg = love.graphics.newImage("assets/bg/mainbackground.png")
  bg.layer1Img = love.graphics.newImage("assets/bg/bgLayer1.png")
  bg.layer2Img = love.graphics.newImage("assets/bg/bgLayer2.png")

  bg.decalageLayer1 = 0
  bg.decalageLayer2 = 0
  bg.speedLayer1 = 0.5
  bg.speedLayer2 = 1.0
  bg.widthLayer1 = bg.layer1Img:getWidth()
  bg.widthLayer2 = bg.layer2Img:getWidth()
end

function bg.update(dt)
  bg.decalageLayer1 = bg.decalageLayer1 - bg.speedLayer1
  bg.decalageLayer2 = bg.decalageLayer2 - bg.speedLayer2
  if bg.decalageLayer1 <= -bg.widthLayer1 then
    bg.decalageLayer1 = 0
  end
  if bg.decalageLayer2 <= -bg.widthLayer2 then
    bg.decalageLayer2 = 0
  end
end

function bg.draw()
  love.graphics.draw(bg.mainImg)
  love.graphics.draw(bg.layer1Img, bg.decalageLayer1)
  love.graphics.draw(bg.layer1Img, bg.widthLayer1 + bg.decalageLayer1)
  love.graphics.draw(bg.layer2Img, bg.decalageLayer2)
  love.graphics.draw(bg.layer2Img, bg.widthLayer2 + bg.decalageLayer2)
end

return bg