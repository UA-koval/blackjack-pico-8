pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function draw_card(x,y,n,m)
 if m>1 then pal(8,0)
 else pal() end
 n+=1
 sspr(8,0,11,16,x,y) --blank card
 sspr(128-n*8,0,6,6,x+2,y+2) --value
 sspr(24+m*8,8,5,5,x+3,y+9) --type
end

function draw_card_back(x,y)
 sspr(8,0,11,16,x,y)
 sspr(8,16,7,12,x+2,y+2)
end

function _draw()
rectfill(0,0,128,128,3)
draw_card_back(20,10)
draw_card_back(20,8)
draw_card_back(20,6)
end

function _update()
 if (btn(0)) camx-=1
 if (btn(1)) camx+=1
 if (btn(2)) camy-=1
 if (btn(3)) camy+=1
 camera(camx,camy)
end

__gfx__
00000000001111111000000080080000088000000088800080088000088000000880000088880000088000008888000000880000088000000880000088888000
00000000017777777100000080880000800800000008000080800800800800008008000080080000800000008000000008080000800800008008000000800000
00700700177777777710000088800000800800000008000080800800088800000880000000800000888000008880000080080000008000000080000000800000
00077000177777777710000080880000800800000008000080800800000800008008000000800000800800000008000088880000000800000800000000800000
00077000177777777710000080080000088000008008000080800800000800008008000008000000800800008008000000080000800800008000000000800000
00700700177777777710000080080000008800000880000080088000088000000880000008000000088000000880000000080000088000008888000000800000
00000000177777777710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777777710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777777710000008080000008000000080000000800000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777777710000088888000088800000888000008880000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777777710000088888000888880008888800080808000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777777710000008880000088800008080800088088000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777777710000000800000008000000888000080808000000000000000000000000000000000000000000000000000000000000000000000000000
00000000177777777710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000017777777100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000711111700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000711111700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
