-- firefly

node_=include("lib/node")
c=1
nodes={}

function init()
  print("hello")
  for i=1,4 do
    nodes[i]=node_:new{id=i}
  end
  params:add_number("coupling","coupling",0,100,0)
  t=0
  clock.run(function()
    while true do
      clock.sleep(1/20)
      t=t+0.3141592652589
      if t>=10000*3.14159 then
        t=0
      end
      for i,n in ipairs(nodes) do
        n:update_u(params:get("coupling")/4000)
      end
      for i,n in ipairs(nodes) do
        n:update(t)
      end
      redraw()
    end
  end)
end

function enc(k,z)
  if k==1 then
    params:delta("coupling",z)
  else
    nodes[k].amp=util.clamp(nodes[k].amp+z/100,0,1)
  end
end
function key(k,z)
  if z==1 then
    if params:get("coupling")>0 then
      params:set("coupling",0)
    else
      params:set("coupling",100)
    end
  end
end

blend_m=3
function redraw()
  screen.clear()
  screen.aa(0)
  screen.line_width(1)
  screen.blend_mode(5)
  screen.move(8,8)
  screen.text(params:get("coupling"))
  for i,n in ipairs(nodes) do
    n:redraw()
  end
  screen.update()
end
