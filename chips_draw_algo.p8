pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
chip_vals={50,25,10,5,1}
chip_amount={}
x = 234 
sx=64 sy=64 n=0

cls()

for v in all(chip_vals) do
--print(v.."*("..x.."//"..v..")), ("..flr(x/v)..")"..", y="..(v * (flr(x/v))))
y = (v * (flr(x/v)))
chip_amount[v]=flr(x/v)
x-=y
end

for k,v in pairs(chip_amount) do
--print(k.." "..v)
if k == 50 then n = 5
elseif k == 25 then n = 4
elseif k == 10 then n = 3
elseif k == 5 then n = 2
else n = 1 end
	for a=0,v do
		spr(n,sx,sy)
		sy-=2
	end
sx+=10
sy=64

for k,v in pairs(chip_amount) do
	print(k.." "..v)
end

for k in all(chip_amount) do
	print(k)
end

end
__gfx__
00000000007777000088880000bbbb0000cccc000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007777777788888888bbbbbbbbcccccccc5555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
007007007777777788888888bbbbbbbbcccccccc5555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
000770007777777788888888bbbbbbbbcccccccc5555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000117777111188881111bbbb1111cccc111155551100000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700001111000011110000111100001111000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000
