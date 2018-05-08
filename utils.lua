collisions = {}

function math.distance(pPoint1, pPoint2)
  return math.sqrt((pPoint1.x - pPoint2.x)^2 + (pPoint1.y - pPoint2.y)^2)
end

function collisions.CircleCircle(pCircle1, pCircle2)
  return math.distance(pCircle1, pCircle2) <= (pCircle1.radius + pCircle2.radius)
end

function collisions.pointCircle(pPoint, pCircle)
  return math.distance(pPoint, pCircle) <= pCircle.radius
end

function collisions.pointRectangle(pPoint, pRectangle)
  return (
    ( pPoint.x >= pRectangle.x ) and ( pPoint.x <= pRectangle.x + pRectangle.width ) and
    ( pPoint.y >= pRectangle.y ) and ( pPoint.y <= pRectangle.y + pRectangle.width )
  )
end

lg = love.graphics