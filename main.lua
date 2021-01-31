me = {
    x = 0,
    y = 3,
    hp = 10,
    atk = 1,
    xp = 0,
    lvl = 1
}

room = 1

enemy = {}

map = {}
lastMap = {}

tutorialText = "Press WASD to move"

function newRoom()

    if room == 2 then
        tutorialText = "Walk into enemies"
    elseif room == 3 then
        tutorialText = "Doors open enemies dead"
    elseif room == 4 then
        tutorialText = "Chests increase ATK"
    elseif room == 5 then
        tutorialText = "Pots give HP"
    elseif room == 7 then
        tutorialText = "Enemies give 1 XP"
    elseif room == 8 then
        tutorialText = "Lv increase chest ATK"
    end
    map = {}
    enemy = {}

    roomType = "normal"
    if love.math.random(1,10) == 1 then roomType = "treasure" tutorialText = "**TREASURE ROOM**" end
    for x = 0, 6 do
        map[x] = {}
        for y = 0, 6 do
            if x == 0 or x == 6 or y == 0 or y == 6 then -- border around the map
                map[x][y] = "Wall"
            else
                map[x][y] = "Floor"..tostring(love.math.random(1,4))
                if roomType == "treasure" then
                    -- TREASURE ROOM WOOO
                    map[x][y] = "Carpet"
                    if love.math.random(1,5) == 1 then
                        map[x][y] = "Chest"
                    elseif love.math.random(1,5) == 1 then
                        map[x][y] = "Pot"
                    elseif love.math.random(1,8) == 1 then
                        map[x][y] = "Statue"
                    end
                else
                    
                    if love.math.random(1,50-room) == 1 then
                        map[x][y] = "Skeleton"
                    elseif love.math.random(1,150-room) == 1 then
                        map[x][y] = "Chest"
                    elseif love.math.random(1,50-room) == 1 then
                        map[x][y] = "Pot"
                    elseif love.math.random(1,100-room) == 1 then
                        map[x][y] = "Statue"
                    elseif love.math.random(1,25) == 1 then
                        map[x][y] = "Lever"
                    end

                    if (room > 20 and love.math.random(1,20) == 1) or (love.math.random(1,30-room) == 1 and room ~= 1) then
                        enemy[#enemy+1] = {
                            x = x,
                            y = y,
                            hp = love.math.random(me.lvl,me.atk*2),
                            atk = love.math.random(room,room*2),
                            type = love.math.random(1,14)
                        }
                        enemy[#enemy].mhp = enemy[#enemy].hp
                    end
                end
            end
        end
    end
    

        map[love.math.random(1,5)][0] = "Door"
        map[6][love.math.random(1,5)] = "Door"

    map[me.x][me.y] = "Stuck Door Open" 
end

function love.load()


love.graphics.setDefaultFilter( "nearest", "nearest" )
    assets = {
        Wall = love.graphics.newImage("assets/wall1.png"),
        Skeleton = love.graphics.newImage("assets/skeleton.png"),
        Pot = love.graphics.newImage("assets/pot.png"),
        Statue = love.graphics.newImage("assets/statue.png"),
        Floor1 = love.graphics.newImage("assets/floor1.png"),
        Floor2 = love.graphics.newImage("assets/floor2.png"),
        Floor3 = love.graphics.newImage("assets/floor3.png"),
        Floor4 = love.graphics.newImage("assets/floor4.png"),
        Chest = love.graphics.newImage("assets/chest.png"),
        Door = love.graphics.newImage("assets/door.png"),
        Carpet = love.graphics.newImage("assets/carpet.png"),
        Lever = love.graphics.newImage("assets/lever.png"),
        ["Open Door"] = love.graphics.newImage("assets/door_open.png"),
        ["Stuck Door Open"] = love.graphics.newImage("assets/door_open.png"),
        ["Stuck Door"] = love.graphics.newImage("assets/door.png"),
        Player = love.graphics.newImage("assets/player.png"),
        Monster = {
            love.graphics.newImage("assets/monster1.png"),
            love.graphics.newImage("assets/monster2.png"),
            love.graphics.newImage("assets/monster3.png"),
            love.graphics.newImage("assets/monster4.png"),
            love.graphics.newImage("assets/monster5.png"),
            love.graphics.newImage("assets/monster6.png"),
            love.graphics.newImage("assets/monster7.png"),
            love.graphics.newImage("assets/monster8.png"),
            love.graphics.newImage("assets/monster9.png"),
            love.graphics.newImage("assets/monster10.png"),
            love.graphics.newImage("assets/monster11.png"),
            love.graphics.newImage("assets/monster12.png"),
            love.graphics.newImage("assets/monster13.png"),
            love.graphics.newImage("assets/monster14.png"),
        }
    }

    newRoom()

    love.graphics.setFont(love.graphics.newFont(8))
end

function love.draw()
    love.graphics.push()
   love.graphics.scale(love.graphics.getWidth()/(16*7), love.graphics.getHeight()/(16*7))  
   if me.hp < 0 then
    love.graphics.print("Dead.\nYou got to room "..room)
   else
        for x = 0,6 do
            for y = 0, 6 do
                love.graphics.draw(assets["Floor1"],x*16,y*16)
                love.graphics.draw(assets[map[x][y]], x*16, y*16)
            end
        end

        if me.hp < room then
            love.graphics.setColor(1,0,0)
        end
        love.graphics.draw(assets.Player, me.x*16,me.y*16)
        love.graphics.setColor(1,1,1)

        for i,v in ipairs(enemy) do
            love.graphics.draw(assets.Monster[v.type], v.x*16, v.y*16)
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle("fill",v.x*16,(v.y*16)-2,(v.hp/v.mhp)*16,2)
            love.graphics.setColor(1,1,1)
        end

        love.graphics.print("Room "..room.."\n"..me.hp.." HP\n"..me.atk.." ATK\nLv "..me.lvl.."\n"..me.xp.." XP")
        love.graphics.print(tutorialText, 0,16*6)
    end
    love.graphics.pop()
end

function love.keypressed(key)
    tutorialText = ""
    local originals = {me.x,me.y}
    if key == "w" then
        me.y = me.y - 1
        
    elseif key == "s" then
        me.y = me.y + 1
    
    elseif key == "a" then
        me.x = me.x -1
    
    elseif key == "d" then
        me.x = me.x + 1 
    
    end

    if (me.x == 6 or me.x == 0) and map[me.x][me.y] ~= "Open Door" then
        me.x = originals[1]
    end
    if me.y == 6 or me.y == 0 and map[me.x][me.y] ~= "Open Door" then
        me.y = originals[2]
    end
    if me.x == -1 then
        room = room -1
        map = lastMap
        me.x = 5
        map[me.x+1][me.y] = "Stuck Door"
        enemy = {}
    end
    if me.y == 7 then
        room = room -1
        map = lastMap
        me.y = 1
        map[me.x][me.y-1] = "Stuck Door"
        enemy = {}
    end

    if not love.keyboard.isDown("lshift") then
        for i,v in ipairs(enemy) do
            if me.x == v.x and me.y == v.y then
                v.hp = v.hp - me.atk
                if me.hp < room then
                    tutorialText = "HP is low"
                end
                me.x = originals[1]
                me.y = originals[2]
                if v.hp <= 0 then
                    me.xp = me.xp + 1
                    tutorialText = "+1 XP"
                  
                    table.remove(enemy, i)
                end
            end
        end
    end

    if map[me.x] and map[me.x][me.y] and map[me.x][me.y] == "Chest" then
        me.atk = me.atk + love.math.random(1, me.lvl)
        map[me.x][me.y] = "Floor1"
        tutorialText = "1 ATK gained from Chest"
        if me.atk > me.lvl then
            me.atk = me.lvl
            tutorialText = "Max ATK reached"
            me.xp = me.xp + 1
        end

    elseif map[me.x] and map[me.x][me.y] and map[me.x][me.y] == "Pot" then
        me.hp = me.hp + love.math.random(1, room+me.lvl)
        map[me.x][me.y] = "Floor1"
        tutorialText = room.." HP gained from Pot"
        if me.hp > me.lvl*10 then
            me.hp = me.lvl*10
            tutorialText = "Max HP reached"
            me.xp = me.xp + 1
        end
    end

    if me.xp > me.lvl then
        me.xp = 0
        me.lvl = me.lvl + 1
        tutorialText = "Level up!"
    end

    if me.x == 7 or me.y == -1 then
        lastMap = map
        if me.x == 7 then
            me.x = 0
        elseif me.y == -1 then
            me.y = 6
        end
        newRoom()
        room = room + 1
    end

    tick()
end

function tick() 

    for x = 0,6 do
        for y = 0, 6 do
            if map[x][y] == "Door" then
                if #enemy == 0 or map[me.x][me.y] == "Lever" then
                    map[x][y] = "Open Door"
                    tutorialText = "Doors opened"
                end
            elseif map[x][y] == "Stuck Door Open" and (me.x ~= x or me.y ~= y) then
                map[x][y] = "Stuck Door"
            end
        end
    end

    for i,v in ipairs(enemy) do
        local originals = {v.x, v.y}
        if v.x > me.x  then
            v.x = v.x - 1
        elseif v.x < me.x then
            v.x = v.x + 1
        elseif v.y > me.y then
            v.y = v.y - 1
        elseif v.y < me.y then
            v.y = v.y + 1
        end
        if v.x == me.x and v.y == me.y then
            me.hp = me.hp - v.atk
            v.x = originals[1]
            v.y = originals[2]
        end
        if v.x == 0 or v.x == 6 or v.y == 0 or v.y == 6 then
            v.x = originals[1]
            v.y = originals[2]
        end
        for k,x in ipairs(enemy) do
            if k ~= i then
                if v.x == x.x and v.y == x.y then
                    v.x = originals[1]
                    v.y = originals[2]
                end
            end
        end
    end
end