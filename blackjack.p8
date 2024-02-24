pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- blackjack
-- by koval

-- todo:
--
-- 
-- "press start" screen:
--  - game art screen
--  - stage update
--  - draw
-- 

-- game logic vars
bets = {0}
bank = 1000
hands= {{}}
active_hand=1
dealer = {}
fold = false
blackjacks={false,false}
game_results={0,0}
payout=0

-- technical vars
frame_counter = 1
stage = -1
hidden_card = false
item=0 item_lim=4

-- objects coords
dealerx=10 dealery=10
handx=30   handy=50
deckx=100  decky=10
betx=64    bety =100
bankx=40  banky=120
-- player choice window
menux=60   menuy=32
sizex=30   sizey=48
-- bet selection window
betmenux=31   betmenuy=32
betsizex=66   betsizey=40
-- game result window
endscreenx=23 endscreeny=32
endscreensx=82 endscreensy=18

-- graphics vars
cursor_anim_frame = 0
tempbet = 10

debug=false
-->8
-- game logic functions
function reset_game()
hands = {{}}
game_results = {0}
dealer = {}
stage=-1
blackjack=false fold=false
blackjacks={false}
hidden_card=false
item=0 item_lim=4
active_hand=1
bets={0}
end

function generate_card()
 return {flr(rnd(13)),flr(rnd(4))}
end

function hit(h)
	add(h,generate_card())
	if count_score(hands[active_hand]) >21 then
  game_results[active_hand]=1
	elseif count_score(hands[active_hand]) == 21 then
 end
end

-- score counting functions
--  they are unnessesary
--  complicated, i have no
--  idea how to rewrite it
function add_hard_score(card)
 val=0
 if (card[1]==0) then 
 elseif card[1]>9 then val=10
 else val=card[1]+1 end
 score+=val
end

function add_soft_score(card)
 val=0
 if (card[1]!=0) return
 if score<11 then val=11
 else val=1 end
 score+=val
end

function count_score(h)
 score=0
 foreach(h,add_hard_score)
 foreach(h,add_soft_score)
 return score
end

function next_hand()
	if #hands!=active_hand then
		active_hand+=1
	else 
	if (stage==6) reset_game() stage=-1 return
  stage+=1
	 active_hand=1
	end
end
-->8
-- draw functions
function draw_all_cards()
 for n,chand in pairs(hands) do
 	for k,v in pairs(chand) do
	 	draw_card(handx+k*11,handy+n*16,v[1],v[2])
		end
 end
 
	for k,v in pairs(dealer) do
	 draw_card(0+k*11,10,v[1],v[2])
	end
end

function draw_card(x,y,n,m)
 if m>1 then pal(8,0)
 else pal() end
 n+=1
  -- blank card
 sspr(8,0,11,16,x,y)
  -- value
 sspr(128-n*8,0,6,6,x+2,y+2)
  -- type
 sspr(24+m*8,8,5,5,x+3,y+9)
 pal()
end --draw_card

function draw_card_back(x,y)
 sspr(8,0,11,16,x,y)
 sspr(8,16,7,12,x+2,y+2)
end

function draw_chips(px,py,v,r)

chip_vals={50,25,10,5,1}
chip_amount={} 
offset=0
drawbet=min(300,v)

for v in all(chip_vals) do
	y = (v * (flr(drawbet/v)))
	add(chip_amount,flr(drawbet/v))
	drawbet-=y
end

for i=1,5 do
	if chip_amount[i]==0 then
		offset+=1
	end

	n=56-i

if r then
for j=1,chip_amount[i] do
	spr(n,px-(i-offset)*8,py-j*2)
end
else
	for j=1,chip_amount[i] do
	spr(n,px+(i-offset)*8,py-j*2)
end
end
end

end -- draw_chips()
-->8
-- draw ui functions
function draw_game_window()
  menux=handx+12
  menuy=handy-sizey-3
	 -- window background
	 if (blackjacks[active_hand]) return
	 menuy+=active_hand*16
	 line(menux,menuy-1,menux+sizex,menuy-1,7)
	 line(menux,menuy+sizey+1,menux+sizex,menuy+sizey+1,7)
	 line(menux-1,menuy,menux-1,menuy+sizey,7)
	 line(menux+sizex+1,menuy,menux+sizex+1,menuy+sizey,7)
  rectfill(menux,menuy,menux+sizex,menuy+sizey,1)
	 -- text
	 print("hit",menux+2,menuy+2,7)
	 print("stay",menux+2,menuy+10+2,7)
	 if (#hands[active_hand]>2) pal(7,13)
	 print("fold",menux+2,menuy+20+2,7)
	 if (bank<bets[1]) pal(7,13)
	 print("double",menux+2,menuy+30+2,7)
	 print("split",menux+2,menuy+40+2,7)
	 pal()
	 -- cursor
		spr(35+cursor_anim_frame,menux-10,menuy+item*10)


	
		menuy-=active_hand*16
end

function draw_bet_window()
  -- todo: graphical poker chips
	 -- window background
	 line(betmenux,betmenuy-1,betmenux+betsizex,betmenuy-1,7)
	 line(betmenux,betmenuy+betsizey+1,betmenux+betsizex,betmenuy+betsizey+1,7)
	 line(betmenux-1,betmenuy,betmenux-1,betmenuy+betsizey,7)
	 line(betmenux+betsizex+1,betmenuy,betmenux+betsizex+1,betmenuy+betsizey,7)
  rectfill(betmenux,betmenuy,betmenux+betsizex,betmenuy+betsizey,1)
	 -- text
	 print("choose your bet",betmenux+2,betmenuy+2,7)
	 print("➡️ + 1   ⬅️ - 1",betmenux+2,betmenuy+10+2,7)
	 print("⬆️ + 10  ⬇️ - 10",betmenux+2,betmenuy+20+2,7)
	 print(tempbet,betmenux+32,betmenuy+30+2,7)
	 -- cursor
		spr(35+cursor_anim_frame,betmenux-10,betmenuy+30)
end 

function draw_game_result_window()
  endscreeny+=active_hand*10
	 -- window background
	 line(endscreenx,endscreeny-1,endscreenx+endscreensx,endscreeny-1,7)
	 line(endscreenx,endscreeny+endscreensy+1,endscreenx+endscreensx,endscreeny+endscreensy+1,7)
	 line(endscreenx-1,endscreeny,endscreenx-1,endscreeny+endscreensy,7)
	 line(endscreenx+endscreensx+1,endscreeny,endscreenx+endscreensx+1,endscreeny+endscreensy,7)
  rectfill(endscreenx,endscreeny,endscreenx+endscreensx,endscreeny+endscreensy,1)
	 -- text
	 if game_results[active_hand]==0 then
	  if blackjacks[active_hand] then
	  print("blackjack! "..flr(bets[active_hand]*2.5),endscreenx+15,endscreeny+2,7)
	  else
		 print("you won "..bets[active_hand]*2,endscreenx+21,endscreeny+2,7)
		 end
	 elseif game_results[active_hand]==1 then
	  if fold then
	  	print("you lost "..abs(ceil(bets[active_hand]/2)),endscreenx+21,endscreeny+2,7)
	 	elseif bank>=10 then
		  print("you lost "..bets[active_hand],endscreenx+21,endscreeny+2,7)
	 	else
	 	 print("you are broke!",endscreenx+16,endscreeny+2,7)
	 	end
	 else
	  print("draw!",endscreenx+32,endscreeny+2,7)
	 end
	 print("press ❎ to continue",endscreenx+2,endscreeny+10+2,7)
	 endscreeny-=active_hand*10
end


-->8
-- _draw
function _draw()
	rectfill(0,0,128,128,3)

	for i=0,2 do
	 draw_card_back(deckx,decky-i*2)
	end
	
	if hidden_card then
	 draw_card_back(dealerx+12,dealery)
	end
	
 draw_all_cards()

	draw_chips(bankx,banky,bank)

	for n,hand in pairs(hands) do
		-- bets
		draw_chips(handx+10,(handy+12)+n*16,bets[active_hand],true)
	 -- counters
	 rectfill(handx+1,(handy+1)+n*16,handx+9,(handy+7)+n*16,1)
		print(count_score(hand),handx+2,(handy+2)+n*16,7)
	end
	
	-- dealer counter
	rectfill(dealerx-9,dealery+1,dealerx-1,dealery+7,1)
	print(count_score(dealer),dealerx-8,dealery+2,7)
	
 if stage==-1 then draw_bet_window()
 draw_chips(40,84,tempbet)
	elseif stage==2 then draw_game_window()
 elseif stage==6 then draw_game_result_window()
 end
 print("bank:"..bank,80,112)
 print("bet:"..bets[1],100,120)
 -- todo: iterate per hand
 
-- debug prints
if debug then
print(stage,0,0,7)
print("active_hand:"..active_hand,0,8,7)
print("scores:",0,24,7)
print("gmrslt:",0,32,7)
print("bjs:",0,40,7)
print("bets:",0,48,7)

for n,hand in pairs(hands) do
 print(count_score(hand),16+n*16,24,7)
 print(game_results[n],16+n*16,32,7)
 print(blackjacks[n],16+n*16,40,7)
 print(bets[n],16+n*16,48,7)
end
end -- debug

end

-->8
-- stage functions
function update_stage()

if stage==-1 then
-- stage -1: set bets
 stagem1()

elseif stage==2 then
-- stage 2: player's choice
 stage2()

elseif stage==6 then
-- stage 6: game result screen
 stage6()
end

-- from this point on, program
-- only executes every 20 frames
if (frame_counter%20!=0) return

-- stage 0: give player cards
	if stage==0 then
		stage0()

	elseif stage==1 then
	-- stage 1: give dealer card
		stage1()

elseif stage==3 then
-- stage 3: dealer's draw
stage3()

elseif stage==4 then
-- stage 4: comparing scores
--  this stage occurs when 
--  neither sides overdrawn
--  nor has drawn blackjack
stage4()

elseif stage==5 then
-- stage 5: payout
stage5()
end -- stage selector

end -- update_stage()

function stagem1()
-- stage -1: set bets
 if btnp(0) then
  if tempbet>10 then
  	tempbet-=1
  end
 elseif btnp(1) then
  if tempbet<bank then
  	tempbet+=1
  end
 elseif btnp(3) then
  if tempbet>19 then
  	tempbet-=10
  end
 elseif btnp(2) then
  if tempbet+9<bank then
  	tempbet+=10
  end
 elseif btnp(4) then
  bets[1]=tempbet
  bank-=tempbet
  stage+=1
 end

if (tempbet>bank) tempbet=bank
end -- stagem1()

function stage0()
-- stage 0: give player cards
for n,chand in pairs(hands) do

if (#chand<2) then
	if bets[1]==41 then
		add(chand,
		{0,flr(rnd(4))})-- ace
		add(chand,
		{11,flr(rnd(4))})-- queen
	else
	 add(chand,generate_card())
	end
	return
end 
end --foreach hand 
stage+=1
end --stage0()

function stage1()
-- stage 1: give dealer card
if (#dealer<1) then
 add(dealer,generate_card())
elseif hidden_card==false then
	hidden_card = true
else stage+=1 end
end -- stage1()

function stage2()
-- stage 2: player's choice

-- bj test
if (count_score(hands[active_hand])==21) then
 blackjacks[active_hand]=true
 next_hand()
end 

if (bank<bets[1]) item_lim=2
if #hands[active_hand]>2 then
 item_lim=1
 else item_lim=4 end

if btnp(3) and item<item_lim then
	item+=1 end
if btnp(2) and item>0 then
	item-=1 end
if btnp(4) then
 if item == 0 then -- hit
  hit(hands[active_hand])
  if count_score(hands[active_hand]) >= 21 then
	 	next_hand()
	 end
 elseif item == 1 then -- stand
 	next_hand()
 elseif item == 2 then -- fold
  if #hands==1 then
	 	fold=true
	 end

 elseif item == 3 then -- double
  hit(hands[active_hand]) 
  bank-=bets[active_hand] 
  bets[active_hand]*=2
 	next_hand()
 elseif item == 4 then -- split
  if #hands[active_hand] <2 
	  or bank<bets[1] 
 	 then return end
  add(hands,{})
  add(hands[#hands],
  hands[active_hand][2])
  del(hands[active_hand],hands[active_hand][2])
  bank-=bets[1]
  add(bets,bets[1])
 end
 
end -- menu selector
end -- stage2()

function stage3()
-- stage 3: dealer's draw
if #dealer==1 then
 hit(dealer)
elseif count_score(dealer) < 17 then
 hit(dealer)
else stage+=1 end
end --stage3()

function stage4()
-- stage 4: comparing scores
--  this stage occurs when 
--  neither sides overdrawn
--  nor has drawn blackjack
for n,hand in pairs(hands) do
if game_results[n] !=1 and
count_score(dealer) <= 21 and
blackjacks[active_hand]==false then
	diff = count_score(hand) -
	       count_score(dealer)
	if diff>0 then
		game_results[n]=0
	elseif diff<0 then
		game_results[n]=1
	else 
		game_results[n]=2
	end
end
next_hand()
end
end -- stage4()

function stage5()
-- stage 5: payout
--  0 - win
--  1 - loss
--  2 - draw
for n,hand in pairs(hands) do
payout=bets[n]
-- todo: iterate per hand
 
if fold then
 game_result=1
	bank+=flr(payout/2)
end

if game_results[n]==0 then
 if blackjacks[n] then
  payout*=2.5
  payout=flr(payout)
 else payout*=2 end
 bank+=payout
elseif game_results[n]==2 then
 bank+=payout
end --selector

end --iterator
bets[n]=0
active_hand=1
stage+=1
end -- stage5

function stage6()
-- stage 6: game result screen
if btnp(4) then 
	if bank<10 then run() end
next_hand()
end
end --stage6()
-->8
-- _update()
function _update()
frame_counter+=1
update_stage()

if frame_counter%2==0 then
	if (cursor_anim_frame>7) cursor_anim_frame=-1
cursor_anim_frame+=1
end

end --_update()


__gfx__
00000000001111111000000080080000088000000088800080088000088000000880000088880000088000008888000000880000088000000880000008800000
00000000017777777100000080880000800800000008000080800800800800008008000080080000800000008000000008080000800800008008000080080000
00700700177777777710000088800000800800000008000080800800088800000880000000800000888000008880000080080000008000000080000080080000
00077000177777777710000080880000800800000008000080800800000800008008000000800000800800000008000088880000000800000800000088880000
00077000177777777710000080080000088000008008000080800800800800008008000008000000800800008008000000080000800800008000000080080000
00700700177777777710000080080000008800000880000080088000088000000880000008000000088000000880000000080000088000008888000080080000
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
00000000711111700000000011000000000000000000000000000000000000000000000000000000770000007700000000000000000000000000000000000000
00000000111111100000000077110000110000000000000000000000000000000000000077000000777700007777000000000000000000000000000000000000
00000000111111100000000077771100771111001111000000000000000000007777000077777700777777007777770000000000000000000000000000000000
00000000111111100000000077777711777777117777111111111111777777777777777777777777777777777777777700000000000000000000000000000000
00000000111111100000000077777777777777777777777777777777111111117777111177777711777777117777777700000000000000000000000000000000
00000000111111100000000077777700777777007777000000000000000000001111000077111100777711007777770000000000000000000000000000000000
00000000111111100000000077770000770000000000000000000000000000000000000011000000771100007777000000000000000000000000000000000000
00000000111111100000000077000000000000000000000000000000000000000000000000000000110000007700000000000000000000000000000000000000
000000001111111000000000006666000088880000bbbb0000cccc00005555000000000000000000000000000000000000000000000000000000000000000000
0000000011111110000000006677776688777788bb7777bbcc7777cc557777550000000000000000000000000000000000000000000000000000000000000000
0000000011111110000000006777777687777778b777777bc777777c577777750000000000000000000000000000000000000000000000000000000000000000
0000000071111170000000006677776688777788bb7777bbcc7777cc557777550000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000116666111188881111bbbb1111cccc11115555110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000111100001111000011110000111100001111000000000000000000000000000000000000000000000000000000000000000000
__label__
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333311111113333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333177777771333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331771111177133333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331711111117133333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331711111117133333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331711111117133333333333333333
33333333333331111111333111111133333333333333333333333333333333337733777333333333333333333333333333331711111117133333333333333333
33333333333317777777131777777713333333333333333333333333333333333733737333333333333333333333333333331711111117133333333333333333
33333333333177887777717711111771333333333333333333333333333333333733737333333333333333333333333333331711111117133333333333333333
33333333333178778777717111111171333333333333333333333333333333333733737333333333333333333333333333331711111117133333333333333333
33333333333178778777717111111171333333333333333333333333333333337773777333333333333333333333333333331711111117133333333333333333
33333333333178778777717111111171333333333333333333333333333333333333333333333333333333333333333333331711111117133333333333333333
33333333333177887777717111111171333333333333333333333333333333333333333333333333333333333333333333331711111117133333333333333333
33333333333177788777717111111171333333333333333333333333333333333333333333333333333333333333333333331771111177133333333333333333
33333333333177777777717111111171333333333333333333333333333333333333333333333333333333333333333333331177777771133333333333333333
33333333333177787877717111111171333333333333333333333333333333333333333333333333333333333333333333331711111117133333333333333333
33333333333177888887717111111171333333333333333333333333333333333333333333333333333333333333333333331177777771133333333333333333
33333333333177888887717111111171333333333333333333333333333333333333333333333333333333333333333333331711111117133333333333333333
33333333333177788877717111111171333333333333333333333333333333333333333333333333333333333333333333331177777771133333333333333333
33333333333177778777717711111771333333333333333333333333333333333333333333333333333333333333333333331711111117133333333333333333
33333333333317777777131777777713333333333333333333333333333333333333333333333333333333333333333333333177777771333333333333333333
33333333333331111111333111111133333333333333333333333333333333333333333333333333333333333333333333333311111113333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333777777777777777777777777777777777777777773333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333337777333337117171777177711111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333337777777737117171171117111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333337777111137117771171117111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333331111333337117171171117111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117171777117111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111771777177717171111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117111171171717171111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117771171177717771111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111171171171711171111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117711171171717771111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117711177171717771711177711111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117171717171717171711171111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117171717171717711711177111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117171717171717171711171111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117771771117717771777177711111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117771177171117711111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117111717171117171111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117711717171117171111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117111717171117171111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337117111771177717771111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333337111111111111111111111111111111111111111117333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333777777777777777777777777777777777777777773333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333337733777333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333733737333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333733777333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333733337333333333333333333333333333333333333333333333333333333333
33333333333331111111333311111113333111111133333333333333333333337773337333333333333333333333333333333333333333333333333333333333
33333333333317777777133177777771331777777713333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333177007777711778877777117788777771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333170770777711787787777117877877771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333170770777711778877777117877877771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333170000777711787787777117877877771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333170770777711787787777117788777771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333170770777711778877777117778877771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333177777777711777777777117777777771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333177770777711777787777117778787771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333177700077711777888777117788888771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333177000007711778888877117788888771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333177070707711777888777117778887771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333177700077711777787777117777877771333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333317777777133177777771331777777713333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333331111111333311111113333111111133333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333

