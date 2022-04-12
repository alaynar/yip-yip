pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
--game setup and calls

--calls the setup functions
function _init()
 cartdata("yipyip")
 play_x = dget(0)
 play_y = dget(1)
 dsprite = dget(2)
	makeplayer()
	map_set()
	switch_button()
	set_door()
	text_setup()
end

--this updates functions throughout the game
function _update()

--if there is no textbox then update
	if(not active_text) then
		direction = move_appa()
		flip_button()
		open_door()
		clear_button()
		
		if(btnp(🅾️)) then
		  jumping = 1
		  update_jump()
		end
		if(jumping == 1) then
		update_jump()
		end
	end

 
end

--draws parts of the game
function _draw()
 cls()
 draw_map()
 drawappa(direction)
 draw_switch()
 draw_door()
 draw_text()
end

function logo()
  sfx(1)
  local t = 0
  while (t<190) do
    cls()
    if (t>124) then
    spr(2,55,68)
    elseif (t>60) then
    spr(2,55,68)
    elseif (t>28) then
    spr(2,65,68)
    elseif (t>13) then
    spr(2,75,68)
    else
    spr(2,85,68)
    end
    if (t>60) then
    spr(15,55,60)
    print("sky bison!",41,50,7)
    end
    flip() t+=1
  end
end

logo()
-->8
--map and tile functions
function map_set()
	nomove=0
	text=4
	powerup = 7
end

--draw the map
function draw_map()
	mapx = flr(p.x/16)*16 
 mapy = flr(p.y/16)*16
 camera(mapx*8,mapy*8)
 map(0,0,0,0,128,64)
end

--checks what kind of flag the tile has
function is_tile(tile_type,x,y)
 tile=mget(x,y)
 has_flag=fget(tile,tile_type)
 return has_flag
end

--based on the tile flag the player can move or not
function can_move(x,y)
 return not is_tile(nomove,x,y)
end

function is_powerup(x,y)
  return is_tile(powerup,x ,y)
end

function swap_tile(x,y)
 tile = mget(x,y)
 mset(x,y,tile+1)
end
-->8
--appa (player) functions

--makes the player on the map
function makeplayer()
	p={}

--sets starting position for appa
	
	if(play_x == nil and play_y == nil) then
	p.x = 6  
	p.y = 2
	
	else
	p.x = play_x
	p.y = play_y
	end
	prevdir = 'u'
 timerdur = 300
 timer = timerdur
 jumping = 0

--char sprite numbers
	p.spritedr=1
	p.spritedl=2
	p.spriteur=4
	p.spriteul=3
	p.spriteu=6
	p.sprited=5

--char sprite jump numbers
	p.spritedrj=7
	p.spritedlj=8
	p.spriteurj=10
	p.spriteulj=9
	p.spriteuj=12
	p.spritedj=11
	p.spritebsha=13
	p.spritessha=14

end

--function for timers
--specifically for the jump
function update_jump()
 
  if (timer < 0) then
    spr(p.sprited,p.x*8,p.y*8)
    jumping=0
    timer=timerdur
  else
    --jumping = 1 at this time
    timer -=1
  end
end


--curenttly draws appa and
--jumping appa to screen
function drawappa(direct) --direction parameter will be added

 if(jumping == 0) then
	  if(direct == 0) then
     spr(p.spritedl,p.x*8,p.y*8)
	  elseif(direct == 1) then
 	   spr(p.spritedr,p.x*8,p.y*8)
   elseif(direct == 2) then
     spr(p.spriteu,p.x*8,p.y*8)
   elseif(direct == 3) then
     spr(p.sprited,p.x*8,p.y*8)
   elseif(direct == 4) then
     spr(p.spriteul,p.x*8,p.y*8)
   elseif(direct == 5) then
     spr(p.spriteur,p.x*8,p.y*8)
	  else 
	    spr(p.sprited,(p.x)*8,p.y*8)
     --spr(p.spritej,(p.x)*8,(p.y+1)*8)
	  end 
	else
   if(direct == 0) then
     spr(p.spritedlj,p.x*8,p.y*8)
     spr(p.spritebsha,(p.x)*8,(p.y+1)*8)
	  elseif(direct == 1) then
 	   spr(p.spritedrj,p.x*8,p.y*8)
 	   spr(p.spritebsha,(p.x)*8,(p.y+1)*8)
   elseif(direct == 2) then
spr(p.spritessha,(p.x)*8,(p.y+1)*8)     spr(p.spriteuj,p.x*8,p.y*8)
   elseif(direct == 3) then
spr(p.spritessha,(p.x)*8,(p.y+1)*8)     spr(p.spritedj,p.x*8,p.y*8)
   elseif(direct == 4) then
     spr(p.spriteulj,p.x*8,p.y*8)
     spr(p.spritebsha,(p.x)*8,(p.y+1)*8)
   elseif(direct == 5) then
     spr(p.spriteurj,p.x*8,p.y*8)
     spr(p.spritebsha,(p.x)*8,(p.y+1)*8)
	  else 
	    spr(p.spritedj,(p.x)*8,p.y*8)
     --spr(p.spritej,(p.x)*8,(p.y+1)*8)
   end
 end
--jumping appa sprite here
--spr(p.sprite2,(p.x+2)*8,p.y*8)
--spr(p.spritej,(p.x+2)*8,(p.y+1)*8)
end

--movement function
function move_appa()
	tox=p.x
	toy=p.y

 if (prevdir=='u') then
   if (btnp(⬅️)) then
 	  tox -=1
		  lastdir = 4
	  end
	  if (btnp(➡️)) then
 	  tox +=1
 	  lastdir = 5 
   end
 	 if (btnp(⬇️)) then
 	   toy +=1
 	   lastdir = 3
 	   prevdir = 'd'
 	 end
 	 if (btnp(⬆️)) then
 	   toy -=1
 	   lastdir = 2
 	 end
 elseif (prevdir=='d') then
   if (btnp(⬅️)) then
 	  tox -=1
		  lastdir = 0
	  end
	  if (btnp(➡️)) then
 	  tox +=1
 	  lastdir = 1 
   end
   if (btnp(⬆️)) then
    toy -=1
    lastdir = 2
    prevdir = 'u'
   end
   if (btnp(⬇️)) then 
    toy +=1
    lastdir = 3
   end 
	end

--checks for textbox
 interaction_text(tox,toy)
 
-- checks if the player can move 
 if (can_move(tox,toy)) then
 	p.x=mid(0,tox,127)
		p.y=mid(0,toy,63)
 else
  sfx(0)
 end
 
 if (is_powerup(tox,toy)) then
 		timerdur = timer + 300
 		swap_tile(tox,toy)
 		sfx(0)
 end

 
 dset(0, p.x)
 dset(1, p.y)
  
 return lastdir
end
-->8
--interaction item functions

--gets the correct text for the textbox
function interaction_text(x,y)
	if (is_tile(text,x,y)) then active_text=get_text(x,y)
	end
end

--creates the door
function set_door()
 door={}
 door.x=9
 door.y=5
 
 if(dsprite==20) then
 door.sprite=20
 else
 mset(9,5,19)
 door.sprite=dsprite
 end
end

--draws the door
function draw_door()
 spr(door.sprite,door.x*8,door.y*8)
end

--opens the door when switch is pushed
function open_door()
	if (switch.sprite==50) mset(9,5,19) door.sprite=16 dset(2, 16)
end

--makes switch
function switch_button()
 switch={}
 switch.x=10
 switch.y=4
 switch.sprite=49
end

--draws the switch
function draw_switch()
 spr(switch.sprite,switch.x*8,switch.y*8)
end

--if the player pushes x in the correct spot the switch flips
function flip_button()
	if (btnp(❎) and (p.x==9 or p.x==10 or p.x==11) and (p.y==3 or p.y==4)) switch.sprite=50
end


function clear_button()
	if (btnp(❎) and (p.x==3 or p.x==4) and (p.y==6 or p.y==7)) data_clear() 
end

function data_clear()
mset(9,5,20)
door.sprite=20
dset(2,20)

p.x = 6  
dset(0,6)
p.y = 2 
dset(1,2)

run()
end
-->8
--textbox functions

--set the textboxs and what they will say
function text_setup()	
	texts={}
	add_text(7,3,"push the switch to open the \ndoor!")
	add_text(13,3,"hi 😐")
 add_text(11,10,"tutorial completed!")
 add_text(2,6,"press ❎ on the tile twice \nto reset the game!")
end

--creates the textbox
function add_text(x,y,message)
 texts[x+y*128]=message
end

--gets the text
function get_text(x,y)
	return texts[x+y*128]
end

--draws the textbox on the screen
function draw_text()

--if the textbox is open
 if (active_text) then 
  textx=mapx*8+4
  texty=mapy*8+48
   
  rectfill(textx,texty,textx+119,texty+31,7)
  print(active_text,textx+4,texty+4,1)
  print("❎ to close", textx+4,texty+23,6)
 end

--if the textbox is closed 
 if (btnp(❎)) active_text=nil
end
__gfx__
00000000000000000000000000000000000000000000000000000000000005055050000050500000000005050500050005000500003333000033300008808800
0000000000000000000000000000000000000000000000000000000000ff4ffffff4ff00f4f4ff0000ff4f4f0ff4ff000fffff00000000000000000088888880
000000000000050550500000505000000000050505000500050005000ff4f1f11f1f4ff0ffff4ff00ff4ffff0f1f1f000f444f00000000000000000088888880
0000000000ff4ffffff4ff00f4f4ff0000ff4f4f0ff4ff000fffff0044fff555555fff44ffffff4444ffffff0f555f000ff4ff00000000000000000008888800
000000000ff4f1f11f1f4ff0ffff4ff00ff4ffff0f1f1f000f444f0040f0f0f00f0f0f040f0f0f0440f0f0f000f0f00000f0f000000000000000000000888000
0000000044fff555555fff44ffffff4444ffffff0f555f000ff4ff00000000000000000000000000000000000000000000000000000000000000000000080000
0000000040f0f0f00f0f0f040f0f0f0440f0f0f000f0f00000f0f000003333000033330000333300003333000033300000333000000000000000000000000000
00000000000000000000000000000000000000000000000000000000033333300333333003333330033333300333330003333300000000000000000000000000
00000000bbbbbbbb00000000bbbbbbbb666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb7bbbbb00000000bbbbbbbb65555556bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b7a7bbbb00000000bbbbbbbb65555556bbb00bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb7bbbbb00000000bbbbbbbb65555556bb0aa0bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbb7bb00000000bbbbbbbb65555656bb0aa0bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbb7a7b00000000bbbbbbbb65555556bb0aa0bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbb7bb00000000bbbbbbbb65555556bbb00bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb00000000bbbbbbbb66666666bbb00bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111116665666511111111bbbbbbbbbbb00bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000011111cc15555555511111111b444444bbbb00bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111116656665611111111b4ffff4bbbb00bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111115555555511111111b4f55f4bb330033b00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001cc111116566656611111111b4ffff4bb300003b00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111115555555511111111b444444bb333333b00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000011111cc16656665611111111bbb44bbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111115555555511111111bbb44bbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb5555bbbb5555bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb5dd5bbbb5665bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb5dd5bbbb5dd5bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb5dd5bbbb5dd5bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb5665bbbb5dd5bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb5555bbbb5555bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb0000000000000000bbbbbbbbbbbbbbbb00000000111111111111111111111111bbbb000000000000000000000000bbbb000000000000000000000000
bbbbbbbb0000000000000000bbb1cbbbbbbbbbbb00000000111111111111111111111111bbbb055656065606560656065660bbbb000000000000000000000000
bbbbbbbb0000000000000000bb111cbbbbbbbbbb00000000111777111111111711111111bbbb066011111111111111110660bbbb000000000000000000000000
bbbbbbbb0000000000000000b11111cbbbbbbbbb00000000117cccc7111111cc11111111bbbb066055505555555055550660bbbb000000000000000000000000
bbbbbbbb0000000000000000bbb1cbbbbbbbbbbb000000001cccc1c71111cccc11111111bbbb066055505505555055050550bbbb000000000000000000000000
bbbbbbbb0000000000000000bbb1cbbbbbbbbbbb00000000ccccc111111cccc71c1ccc11bbbb055055555505555555050660bbbb000000000000000000000000
bbbbbbbb0000000000000000bbb1cbbbbbbbbbbb00000000111111111111111111111111bbbb066055555555555555550660bbbb000000000000000000000000
bbbbbbbb0000000000000000bbbbbbbbbbbbbbbb00000000111111111111111111111111bbbb066011111111111111110660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb0660666666dd000000000550bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb0550dd666666000000000660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb0660666dd666000000000660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb066066666666000000000660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb066066666dd6000000000550bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb05506dd66666000000000660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb0660666666dd000000000660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb06606dd66666000000000660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb0660bbbbbbbb666666660660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb055000000000900000090550bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb066656065606555005556660bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb055555555555556006555550bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb055550555555550000550550bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb055550555555500000055550bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb055555555505505555055550bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb055555555505506666055550bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbb000000000000000000000000bbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000bbbbbbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000bbbbbbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000bbbbbbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000bbbbbbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000bbbbbbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000bbbbbbbb000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000bbbbbbbb000000000000000000000000
__gff__
0000000000000000000000000000000000000000010100000000000000000000000001001100000000000000000000000001010000000000000000000000000000000080000000000001010101000000000000000000000000010000010000000000000000000000000001000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
494a4a4a4a4a4a4a4a4a4a4a4a4b4b4c40404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5940404040404040401140404040405c40404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5940404040114040404040404011405c40404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5940114040404024404013404024405c40404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5940404040404040404031404040135c40404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
696a6a6a6a6a6a6a6a146a6a6a6a6a6c40404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
797a24157a7a7a7a7a407a7a7a7a7a7c40404040404040404040404040404040404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4011402540404040404040404040114040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404011404040114040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404011404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404340404040244040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4011404040404040114040404040114040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404011404040404040114040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040404040404040404040404040404040404040404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000905000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000000105003050090500d0500f0500f0500e0500f050120501a0501c05012000280502d0501e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
