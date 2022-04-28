pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--game setup and calls
animation_timer = 30
animtimer = 30

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

--☉ ✽➡️░█⌂☉♪● ♥█⧗░ 😐▤★░⬅️✽
if (isalive == 1) then
--if there is no textbox then update
	if(not active_text) then
		direction = move_appa()
		flip_button()
		open_door()
		clear_button()
		if (animtimer < 0) then
    animtimer=animation_timer
    toggle_tiles()
  else
    animtimer -=1
  end
		
		if(btnp(🅾️)) then
		  jumping = 1
		  update_jump()
		end
		if(jumping == 1) then
		update_jump()
		end
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
// draw_text()
	drown()
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
	flyable = 3
	anim = 5
	unanim = 6
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

function swap_tile(x,y,z)
  tile = mget(x,y)
  mset(x,y,tile+z)
end

function can_fly(x,y)
	return is_tile(flyable,x,y)
end

--change the animation tiles
function toggle_tiles()
 for x=mapx, mapx+15 do
  for y=mapy, mapy+15 do
   if(is_tile(anim,x,y)) then
     swap_tile(x,y,1)
   else if(is_tile(unanim,x,y)) then
     swap_tile(x,y,-1)
     end
   end
  end
 end
end
-->8
--appa (player) functions

--makes the player on the map
function makeplayer()
	p={}
 isalive = 1
--sets starting position for appa
	
	if(play_x == 0 and play_y == 0) then
	p.x = 49  
	p.y = 57
	
	else
	p.x = play_x
	p.y = play_y
	end
	prevdir = 'u'
 timerdur = 90
 timer = timerdur
 jumping = 0

--char sprite numbers
	p.spritedr=1
	p.spritedl=2
	p.spriteur=4
	p.spriteul=3
	p.spriteu=6
	p.sprited=5
	p.drown=18

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

--if appa is drowning
--  change the sprite
function drown()
 if ((jumping == 0) and (is_tile(nomove,p.x,p.y))) then
		  isalive = 0
		  spr(p.drown,p.x*8,p.y*8)
		  --sfx(2)
		  
		 textx=mapx*8+16
   texty=mapy*8+56
   
   rectfill(textx,texty,textx+94,texty+16,7)
   print("press ❎ to revive!", textx+12,texty+6,1)
 
		  
		  --press x for revive
		  if (btnp(❎)) then
		  --revive!/reload
		  --revive sound
		  sfx(2)
		  --go to before takeoff
		  p.x = dget(0)
    p.y = dget(1)
    isalive=1
		end
		end

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

if(isalive == 1) then
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
 else if (not can_fly(tox,toy)) then
  sfx(0)
 else
 end
 end
 
 if (is_powerup(tox,toy)) then
 		timerdur = timer + 90
 		swap_tile(tox,toy,16)
 		sfx(0)
 end

 if (can_fly(tox,toy) and (jumping == 1)) then
  p.x=mid(0,tox,127)
		p.y=mid(0,toy,63)
 else
   dset(0, p.x)
   dset(1, p.y)
 end
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
 door.x=20
 door.y=27
 
 if(dsprite==19) then
 door.sprite=19
 else
 mset(20,27,114)
 door.sprite=dsprite
 end
end

--draws the door
function draw_door()
 spr(door.sprite,door.x*8,door.y*8)
end

--opens the door when switch is pushed
function open_door()
	if (switch.sprite==50) mset(20,27,114) door.sprite=16 dset(2, 16)
end

--makes switch
function switch_button()
 switch={}
 switch.x=13
 switch.y=10
 switch.sprite=49
end

--draws the switch
function draw_switch()
 spr(switch.sprite,switch.x*8,switch.y*8)
end

--if the player pushes x in the correct spot the switch flips
function flip_button()
	if (btnp(❎) and (p.x==12 or p.x==13 or p.x==14) and (p.y==9 or p.y==10 or p.y==11)) switch.sprite=50
end


function clear_button()
	if (btnp(❎) and (p.x==44 or p.x==43 or p.x==42) and (p.y==59 or p.y==58 or p.y==56 or p.y==57)) then
	 data_clear() 
	end
end

function data_clear()
mset(20,27,19)
door.sprite=19
dset(2,19)

p.x = 49  
dset(0,49)
p.y = 57 
dset(1,57)

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
00000000000000000000000000000000000000000000000000000000000005055050000050500000000005050500050005000500005555000055500008808800
0000000000000000000000000000000000000000000000000000000000ff4ffffff4ff00f4f4ff0000ff4f4f0ff4ff000fffff00000000000000000088888880
000000000000050550500000505000000000050505000500050005000ff4f1f11f1f4ff0ffff4ff00ff4ffff0f1f1f000f444f00000000000000000088888880
0000000000ff4ffffff4ff00f4f4ff0000ff4f4f0ff4ff000fffff0044fff555555fff44ffffff4444ffffff0f555f000ff4ff00000000000000000008888800
000000000ff4f1f11f1f4ff0ffff4ff00ff4ffff0f1f1f000f444f0040f0f0f00f0f0f040f0f0f0440f0f0f000f0f00000f0f000000000000000000000888000
0000000044fff555555fff44ffffff4444ffffff0f555f000ff4ff00000000000000000000000000000000000000000000000000000000000000000000080000
0000000040f0f0f00f0f0f040f0f0f0440f0f0f000f0f00000f0f000005555000055550000555500005555000055500000555000000000000000000000000000
00000000000000000000000000000000000000000000000000000000055555500555555005555550055555500555550005555500000000000000000000000000
000000000000000000000000a555555a666666667777777700040000ff000ff0000000000000000000055500b336633300444400000fcf000000000000000000
0000000000000000000000009aaaaaa9655555567777777700444000f5f0f5f00033300000444400005333503366663ba01f14000001f1000000000000000000
000000000000000000500500444444446555555677700777001f10000fffff00005f5000001f14000036f630331f1f33a0ff8400000fff000000000000000000
000000000000000000f4ff004994499465555556770aa07700fff000003f304000fff00000fff040005fff5022fff622905555500099a8900000000000000000
0000000000000000f01f1fc04994499465555656770aa0770ccc7c0000f5f00f03b333000cccc7c0003bb33f25366b52f50850f000fa8af00000000000000000
0000000000000000fc55511c4994499465555556770aa0770fc7cf0004fff40f0fbbbf000f0770f003fbb0002533b352000580000008a9000000000000000000
0000000000000000c11e11f14994499465555556777007770077700000fffff000333000001cc10000333300225ff52200500500000a99000000000000000000
0000000000000000111111f14994499466666666777007770040400000404000004040b000dccd0000f33f0022b3332200500500000f0f000000000000000000
0000000000000000666566659f0f9f0fbbbbbbbb77700777bbb4bbbbff111ff100000000777777776655566d0000000066444466555fcf530000000000000000
00000000000000005555555599999999b444444b77700777bb444bbbf5f1f5f100000000774444776533356600000000a61f14665351f1330000000000000000
00000000000000006656665699f99f99b4ffff4b77700777bb1f1bbb1fffff1100000000761f1477636f636600000000a6ff8466535fff550000000000000000
0000000000000000555555559f0ff0f9b4f55f4b75500557bbfffbbb113f31410000000077fff747d5fff56600000000965555565599a8950000000000000000
00000000000000006566656699099099b4ffff4b75000057bccc7cbb17f5f71f000000007cccc6c763bb33f600000000f56856f655fa8af50000000000000000
0000000000000000555555559f9ff9f9b444444b75555557bfc7cfbb74fff47f000000007f7667f73fbb666600000000666586665358a9350000000000000000
00000000000000006656665699f99f99bbb44bbb77777777bb777bbb11fffff100000000771cc176633336dd0000000066566566955a99550000000000000000
0000000000000000555555559f9ff9f9bbb44bbb77777777bb4b4bbb114141110000000077dccd776f33f6660000000066566566995f5f550000000000000000
00000000455555544555555457777775577777750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000556666555566665565555556655555560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000546dd6555465565567676767666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000556dd645556dd64576776676677667760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000556dd655556dd65566676666677667760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000045655655456dd65567667677677667760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000556666545566665476677666677667760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555455555554555566766676677667760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55556553bbbbbbbbbbbbbbbb777777775a555555555a55551111111111111111bbbbbbbb33330000000000000000000000003b33000000000000000011111111
53555333bbbbbbbbbb7bbbbb7771c77755aaaaaaaaaaa5551111111111111111bbb666bb3b33099f9f0f9f0f9f0f9f0f9ff03333099f9f0ff9f09ff01cc11111
53659965bbbbbbbbb7a7bbbb77111c775a525252525a9a451117771111111111bb56666b333b0ff044444444444444440ff0333b0ff0444444444ff011111cc1
55397795bbbbbbbbbb7bbbbb711111c75a252525252a9a55117cccc711177711b555666633330ff099909999999099990ff033330ff0999999990ff011100111
55979779bbbbbbbbbbbbb7bb7771c777a252525252a999a51cccc1c7111ccc11355555663b330ff09990990999909909099033330ff0999999990990110bb011
59777979bbbbbbbbbbbb7a7b7771c777aaaaaaaaaaa9944accccc1111111ccc1335555533333099099999909999999090ff033330990999999990ff010bb3b01
99777977bbbbbbbbbbbbb7bb7771c77754999999994449941111111111111111b333333b33330ff099999999999999990ff03b330ff0999999990ff003333b30
97767797bbbbbbbbbbbbbbbb77777777549aa99aa9499a941111111111111111bbbbbbbb33b30ff044444444444444440ff033330ff044440000000003333330
55556553111111111111111177777777549559955949a594111b1111166b51116665666633330ff0666666dd666666dd099033b30ff03333333309900333b330
5355533311111cc111cc111177667777549aa99aa949559411b3111116b351115556666533330990dd666666dd6666660ff033330990000000000ff010333301
53653365111111111111111176776777549999999949aa941b3337111b3337115566665533330ff0666dd666666dd6660ff033b30fff9f09f0f9fff011044011
553553551111111111111111777777775499999999499994b3333371b3333371566644443b330ff066666666666666660ff03333099999999999999033044030
555555351cc111111111cc1177777777549994499949999416665777166657774664ff4f33330ff066666dd666666dd609903333099990999999099030444903
53655535111111111111111177777667549994599949994516a6511116a65111f44fffff33b309906dd666666dd666660ff03333099990999999099030444903
9555535511111cc11cc111117777677654999449994994551665571116655711ffffffff33330ff0666666dd666666dd0ff03bb3099999999999999004494490
9956555511111111111111117777777754995555994445551665577116655771ffffffffb3330ff06dd666666dd666660ff03333099999999999999030000003
bbb4bbbbbbbbbbbb3333333355556553a555555a3333333316655111166556661665511133330ff033333333333333330ff033b3000000000000000000000000
bb4f4bbbbb7bbbbb33233333535553339aaaaaa933b3b33b1665511116556665166551113333099000000000900000090990333b000000000000000000000000
b4f9f4bbb7a7bbbb3222333353653365949494943333333376655711165666551655511133b30fff9f0f9f0f99900999fff03333000000000000000000000000
b4fff4bbbb7bbbbb33b3333355355355994499493333b333165557711556665546554411333309999999999999f00f9999903333000000000000000000000000
4444444bbbbbb7bb33333323555555354994949933b3333316555777156665554554ff1fb33309999099999999000099099033b3000000000000000000000000
b4fff4bbbbbb7a7b3332322253655535949949443b33b3331555511116666555f44fffff33330999909999999000000999903333000000000000000000000000
b4fff4bbbbbbb7bb332223b33555535599944999333333b31555571116665555ffffffff333b0999999999099055550999903333000000000000000000000000
b4f5f4bbbbbbbbbb333b3333355655559949994933b333331555577116655555ffffffff3b330999999999099066660999903333000000000000000000000000
66655111f9999999555555551111111166655666111111116665511155555555f5ffffff3333000000000000000000000000b333000000000000000000000000
666551119999995955545555177111116689986611111111666551115555556654fff55f333333333333333333b3b33b33333bb3000000000000000000000000
66555111950999995455554577771711689aa9861111133366655711555566664fff5445333333b3333b33b3333333333333b333000000000000000000000000
465544119999509f555555551111777159a1ca95333333336655577155566666fff54ff4333b3333333b33333333b33333333333000000000000000000000000
4554ff1f99f95999555554551771177759a11a953333b3b36655577756666655ff54ffff3b3333b333333b3333b3333333b33333000000000000000000000000
f44fffff999999995555555511111111689aa9863b3333336555511166665555ff4ff55f3333b333b33b33333b33b33333333b33000000000000000000000000
ffffffff99999509554555551177771166899866333b33336555571166555555ffff544f33b333333b333333333333b333333333000000000000000000000000
fffffffff50999995555554517777771666556663333333b6555577155555555fff54fff333333333333333333b333333333b333000000000000000000000000
15151515151515151527464646464646462727272715151515151515151515151515151515151515151515151515151515151515151515151515151515151515
1515151515151515151515151515151515151515151515151515151596e4565694a4b4c456a5565695a5a5a5c556565695565656151515151515151515151515
15151515151515151515272727272727272727271515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
1515151515151515151515151515151515151515151515151515155656955656955656c556a5565696a6a6b6c656a5a595565615151515151515151515151515
15151515151515151515151515152727272727271515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
151515151515151515151515151515151515151515151515151515565695565696a6b6c656a5a5a5a5a7a7a5c756a55695561515151515151515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
151515151515151515151515151515151515151515151515151556565696e456a5a5a5a5a5a55656a5a5a5a5a5a5a55695151515151515151515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
1515151515151515151515151515151515151515151515151515565656569556a556d4a4a4a4a4a4a4c45694a4a4a4c495561515151515151515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
1515151515151515151515151515151515151515151515151556562626a6e556a556c5565656565656d5a6e5565656c595561515151515151515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
1515151515151515151515151515151515151515151515151556565656565656a556c5265656565656565656565656d5e5565656151515151515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
1515151515151515151515151515151515151515151515151556562626b4e4565656c55656562656565656565626565656565656151515151515151515151515
15151515151515151515151515151515373737373737151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151515151515151515151515151515565656565696a6a6a6c65626565656565656155656565656265656151515151515151515151515
15151515151515151515151515373737373737373737373715151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151515168416161615151515151515565656565656565656565656562656561515151556562656565615151515151515151515151515
15151515151515151515153737373737363737373636373737151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151516161684161616161616151515151515155656565656565656562656565656151515151515151515151515151515151515151515151515
15151515151515151515153737373736363637363636373737151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515171717171616160606160616151515151515155656565656565656565656561515151515151515151515151515151515151515151515151515
15151515151515151515373737373636360405363636373737371515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151717171717171716061717171784161515151515151515151556565656561515151515151515151515151515151515151515151515151515151515
1515151515151515151515373736363604d204040536363737371515151515151515151515151515151515151515151515151515151515151515151515151515
15151515171717171717171717171717068416161515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515153737360404363604053604053637151515151515151515151515151515151515151515151515151515151515151515151515151515
15151564171717171717171717171706161616151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515153737373636040536360404053637371515151515151515151515151515151515353515151515151515151515151515151515151515
15151515151515641517171717170616166216151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151537373636360404040405363637151515151515151515151515151515151535353535151515156415151515151515151515151515
15151515151515151564171717171716161616151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151537373736040536363636363715151515151515151515151515151515151515351515151515151515151515353515151515151515
15151515151515151564151717171717161615151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151515153737370405040405373737371515151515151515151515151515151515151535353535353535353515153535151515151515
15151515151515641515641717171717161515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151515151537373737363637373737373715151515151515151515153515151535353535353535353535353535151515153535151515
15151515151515151515171717171716161515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151537373737373737373737373737373737371515151515151515353535153535353535353535353535353535353515153535351515
15151515151515156417171717161616151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515153737373737373737373737373737373737371515151515151535353515153535353535353535353535353535353535151535353515
15151515151515151717171717171515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151537373737363637373737373704043704043737371515151515151515151515353535353535343535353535353535353535351535353515
15151515151564171717171715151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515153737373736363636373737370436040536363737371515151515351535351535353535353535353535353535353535353535351535351535
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515373737373604053636363737363636363636373737371515151535353535151535353535353535353535353535353535353535351515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515373737040536360405373737373604053637373737151515151535153535153535353535513535353535353535353535353535351515151535
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515373737363636363737373737373736363737373715151515151535351535153535353535523535353535353535353535353535151535151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515153737370405373737373737373737373737371515151515151515151535151535353535353535353535353535353535353535153515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151537373737373737373737373737373715151515151515151515151515151515353535353535353535353535353535353515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151515151515153737373737371515151515151515151515151515151515153535353535353535353535353535353515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515153535353535353535353535353535351515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515353535353535353535353515151515151515151515
15151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515
__gff__
0000000000000000000000000000000000000001010100000000000000010000000001011101010901010100010100000001010101000000000000000000000001000080010129490901010101010109002949000101010100010000010101010100000001000101000101000100000000000009000001010000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
5151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515353535353535151515153535353515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515173737373515151515151
5151515151515151515151515151515151515151515151515151515151515151515151515151515151515153535353535353535353535151515353515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151737373737373737351515151
5151515151515151515151515151515151515151515151515151515151515151515151515151515151515153535353535353535353535353515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515173737373567373737373735151
5151515151515151515151515151515151515151515151515151515151515151515151515151515153535353535353535353535353535353535353535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515173737356577373737373735151
5151515151515151515151515151515151515151515151515151515151515151515151515151535353535353535353535353535353535353535353535351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151517373732757577373737373735151
5151515151515151515151515151515151515151515151515151515151515151515151515153535353535353535333333333333333333353535353535353515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151737373735666665673737373735151
5151515151515151515151515151515151515151515151515151515151515151515151515353535353535353333333535353535353533333335353535353535353515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151737373736667765773737373735151
5151515151515151515151517272725151515151515151515151515151515151515151535353535353535333333353535353535353535353333353535353535353535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151737373736777706673737373515151
5151515151515151515151727272727251515151515151515151515151515151515151535353535353533333535353535353535329535353533353535353535353535351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151517373735858786873737373515151
5151515151515151517272727272727272515151515151515151515151515151515151535353535353533353535353535353535353535353533333535353535353535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515173787878787878737351515151
5151515151515151517272727231727272515151515151515151515151515151515151535353535353333353535353535353535353535353535333535353535353535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151517373717171717171737351515151
5151515151515151517272727272727272515151515151515151515151515151515153535353535353335353535353535353535353535353535333535353535353535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151517373717178717871735151515151
5151515172727272515172727272727251515151515151515151515151515151515153535353535353335353535353535353535353535353535333535353535353535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151517373737171717173735151515151
5151517272727272725151517272725151515151515151515151515151515151515153535353535353335353535353535353535353535353535333535353535353535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515173737371717373515151515151
5151517272727272727251515151515151515151515151515151515151515151515151535353535353335353535353535353535353535353533333535353535353515351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515173737373737351515151515151
5151515172727272727272727272725151515151515151515151515151515151515151535353535353335353535353535353535353535353533353535353535351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151
5151515151727272727272727272727272515151515151515151515151515151515151535353535353333353535353535353535353535353333353535353515151515351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151
5151515151727272726464647272727272515151515151515151515151515151515151515353535353533333333333335353535353535333335353535351515351515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151
51515151517264646444455a6464727251515151515151515151515151515151515151515151515353535353535353333333335333333333535353535351535151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151
51515151726472727254555a7272646472725172727272725151515151515151515151515151515151535353535353335353535353535333535353535151515151515151515151515151515151515151515151515151515151515151516565656565656565656551515151515151515151515151515151515151515151515151
51515151726444457272725a7244455a647272727272727272515151515151515151515151515151515153535353333353535353535353333353535351515151515151515151515151515151515151515151515151515151514f5165656565656565626565656565515151515151515151515151515151515151515151515151
51515172647254554445725a7254555a726472727272727272515151515151515151515151515151515151535333335353535353535353533353535151515151515151515151515151515151515151515151515151515151515f7565626565656565656565656565655151515151515151515151515151515151515151515151
51515151645a5a725455725a4445725a44456472727272727272515151515151515151515151515151515151333353535353535353535353333351515151515151515151515151515151515151515151515151515151515175651b65656565656565656562656565655151515151515151515151515151515151515151515151
5151515164725a5a5a5a725a54555a5a54556472727272727272515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151517565656565656565656565656565656565655151515151515151515151515151515151515151515151
5151515164727272725a5a5a745a5a7272726472727272727272515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151516565656565656562656565656565656565655151515151515151515151515151515151515151515151
515151517264727244455a742c744445724445647272727272725151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515165656565626565654d4a4a4a4a4a4a4a4c656551515151515165656565655151515151515151515151
515151515164727254555a5a745a5455725455646472727272725151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515165626565656565655c656565656565655c656565515151515165656565656551515151515151515151
51515151516444455a5a5a44455a5a5a5a5a5a5a1372727272725151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515165656562656565655c65494a4b4c62655c6565654d4a4e516565656562656551515151515151515151
51515151516454555a444554555a444572444572647272727251515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151516565656565494a4a6c655965655c65655d6a6a6a6c6559656562656565656551515151515151515151
515151515151645a5a545572725a5455725455647272727251515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151516565655965656562696a6b6c656565656565656559656565656565656551515151515151515151
515151515151516472727244455a4445727272647272725151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151655965656565655a5a5a5a6562494a4a4a4c59654d4e656565656551515151515151515151
515151515151515164647254555a5455726464727272515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515151515965626565656565655a6565595a2a5a5c696a6c59656265655151515151515151515151
__sfx__
000100000905000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000000000105003050090500d0500f0500f0500e0500f050120501a0501c05012000280502d0501e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001907020070270702e0702c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
