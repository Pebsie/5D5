me = {
    x = 0,
    y = 3,
    hp = 10,
    atk = 1
}

room = 1

enemy = {}

map = {}

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
    end
    map = {}
    enemy = {}
    for x = 0, 6 do
        map[x] = {}
        for y = 0, 6 do
            if x == 0 or x == 6 or y == 0 or y == 6 then -- border around the map
                map[x][y] = "Wall"
            else
                if love.math.random(1,50-room) == 1 then
                    map[x][y] = "Skeleton"
                elseif love.math.random(1,150-room) == 1 then
                    map[x][y] = "Chest"
                elseif love.math.random(1,50-room) == 1 then
                    map[x][y] = "Pot"
                elseif love.math.random(1,100-room) == 1 then
                      map[x][y] = "Statue"
                else
                    map[x][y] = "Floor"..tostring(love.math.random(1,4))
                end

                if (room > 20 and love.math.random(1,4) == 1) or (love.math.random(1,30-room) == 1 and room ~= 1) then
                    enemy[#enemy+1] = {
                        x = x,
                        y = y,
                        hp = love.math.random(math.floor(room/2),room),
                        atk = love.math.random(math.floor(room/2),atk),
                        type = love.math.random(1,5)
                    }
                    enemy[#enemy].mhp = enemy[#enemy].hp
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

        love.graphics.draw(assets.Player, me.x*16,me.y*16)

        for i,v in ipairs(enemy) do
            love.graphics.draw(assets.Monster[v.type], v.x*16, v.y*16)
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle("fill",v.x*16,(v.y*16)-2,(v.hp/v.mhp)*16,2)
            love.graphics.setColor(1,1,1)
        end

        love.graphics.print("Room "..room.."\n"..me.hp.." HP\n"..me.atk.." ATK")
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

    if me.x == 8 or me.x == 0 and map[me.x][me.y] ~= "Open Door" then
        me.x = originals[1]
    end
    if me.y == 6 or me.y == 0 and map[me.x][me.y] ~= "Open Door" then
        me.y = originals[2]
    end


    for i,v in ipairs(enemy) do
        if me.x == v.x and me.y == v.y then
            v.hp = v.hp - me.atk
            me.x = originals[1]
            me.y = originals[2]
            if v.hp <= 0 then
                table.remove(enemy, i)
            end
        end
    end

    if map[me.x] and map[me.x][me.y] and map[me.x][me.y] == "Chest" then
        me.atk = me.atk + 1
        map[me.x][me.y] = "Floor1"
        tutorialText = "1 ATK gained from Chest"
    elseif map[me.x] and map[me.x][me.y] and map[me.x][me.y] == "Pot" then
        me.hp = me.hp + room
        map[me.x][me.y] = "Floor1"
        tutorialText = room.." HP gained from Pot"
    end

    if me.x == 7 or me.y == -1 then
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
                if #enemy == 0 then
                    map[x][y] = "Open Door"
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