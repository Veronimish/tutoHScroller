require("utils")

BackGround = require("background")
Tirs = require("tirslaser")
Mines = require("mines")
Player = require("player")
Explosions = require("explosions")
Score = require("score")

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 480
_Debug = false
_DebugMsg = ""

function love.load()
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  math.randomseed(os.time())
  BackGround.load()
  Tirs.load()
  Mines.load()
  Player.load()
  Explosions.load()
  Score.load()
end

function love.update(dt)
  if dt > 0.01 then dt = 0.01 end
  BackGround.update(dt)
  Tirs.update(dt)
  Mines.update(dt)
  Player.update(dt)
  Explosions.update(dt)
  Score.update()

  if _Debug then
    _DebugMsg = Tirs._DebugMsg.." - "..Player._DebugMsg.." - "..Mines._DebugMsg
  end
end

function love.draw()
  BackGround.draw()
  Score.draw()
  Tirs.draw()
  Mines.draw()
  Player.draw()
  Explosions.draw()

  if _Debug then
    love.graphics.print(_DebugMsg)
  end
end

function love.keypressed(key)
  if key == "f12" then
    _Debug = not _Debug
  end
  if key == "space" then
    Tirs.add(Player)
  end
  if key == "escape" then
    love.event.quit()
  end
end
