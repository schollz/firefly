local Node={}

function Node:new(o)
  o=o or {}
  setmetatable(o,self)
  self.__index=self
  o:init()
  return o
end

function Node:init()
  self.coupling={
    {-3,1,1,1},
    {1,-2,1,0},
    {1,1,-3,1},
    {1,0,1,-2},
  }
  self.id=self.id or 1
  self.w=math.random(300,2*1700)/1000
  self.w0=self.w
  self.u=0
  self.c=0
  self.m=1
  self.msteps=10
  self.amp=1
  self.x={}
  self.accum=0
  for i=1,128 do
    table.insert(self.x,0)
  end
end

function Node:update_u(coupling_strength)
  self.c=coupling_strength
  self.u=0
  for i=1,4 do
    self.u=self.u+self.coupling[self.id][i]*nodes[i].w
  end
  self.u=self.u*coupling_strength
end

function Node:sign(x)
  if x>=0 then
    return 1
  end
  return-1
end

function Node:update(t)
  -- self.accum=self.accum+self.w*t
  local x=math.sin(self.w*t)
  if self.msteps>0 then
    self.msteps=self.msteps-1
    if self.msteps%10==0 then
      self.w=self.w*self.m
    end
  else
    if self:sign(x)>self:sign(self.x[1]) and math.random(1,20)<12 then
      self.m=1+math.random(-2,2)/1000
      self.msteps=math.random(0,80)
    end
  end
  table.remove(self.x,128)
  table.insert(self.x,1,x)
  self.w=self.w+self.u
  -- self.w=(self.c/0.025*self.w)+(1-self.c/0.025)*(self.w0)
end

function Node:redraw()
  for i,v in ipairs(self.x) do
    if i>1 then
      screen.level(2)
      screen.move(i-1,(self.id*16)+(self.x[i-1])*6*self.amp-8)
      screen.line_rel(i,(self.id*16)+(self.x[i])*6*self.amp-8)
      screen.stroke()
      screen.level(5)
      screen.move(i-1,(self.id*16)+(self.x[i-1])*6*self.amp-8)
      screen.line(i,(self.id*16)+(self.x[i])*6*self.amp-8)
      screen.stroke()
    end
  end
end

return Node
