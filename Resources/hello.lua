require "Cocos2d"
-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    require "implementation"

    local currentTime = GetTime.new()
    -- print(currentTime)

    ---------------

    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local N_Loop = 1000
    local N_Call = 1000000
    local N_MAT4 = 100000

    -- TestLayer
    local function TestLayer()

        local ret = cc.Layer:create()

        -- Label 
        local loop = cc.LabelTTF:create("Loop Test", "Arial", 30)
        local call = cc.LabelTTF:create("CallFunc Test", "Arial", 30)
        local mat4 = cc.LabelTTF:create("MAT4 Test", "Arial", 30)

        -- MenuItem
        local loopItem = cc.MenuItemLabel:create(loop)
        local callItem = cc.MenuItemLabel:create(call)
        local mat4Item = cc.MenuItemLabel:create(mat4)

        -- Callback 
        local function loopCallback(sender)
            cclog("loopCallback entered!")
            local start = currentTime:getCurrentTime()
            -- print(start)

            local i = 0
            while i < N_Loop do
                i = i + 1
                cclog("Count: " .. i)
            end

            local stop = currentTime:getCurrentTime()
            local duration = stop - start

            cclog("start: " .. start .. " end: " .. stop .. " duration: " .. duration)
        end

        local function callfuncCallback(sender)
            cclog("callfuncCallback entered!")
            local i = 0 
            local sum = 0

            local start = currentTime:getCurrentTime()

            while i < N_Call do
                sum = sum + addFunc(i, 1)
                i = i + 1
            end

            local stop = currentTime:getCurrentTime()
            local duration = stop - start

            cclog("sum: " .. sum)
            cclog("start: " .. start .. " end: " .. stop .. " duration: " .. duration)
        end

        local  function mat4Callback(sender)
            cclog("mat4Callback entered!")
            local n = 0
            local a = {{1, 2, 3, 4}, {2, 3, 4, 5}, {3, 4, 5, 6}, {4, 5, 6, 7}}
            local b = {{5, 6, 7, 8}, {6, 7, 8, 9}, {7, 8, 9, 10}, {8, 9, 10, 11}}
            local c = {}
            for i = 1, 4 do
                c[i] = {}
                for j = 1, 4 do
                    c[i][j] = 0
                end
            end
            local start = currentTime:getCurrentTime()

            while n < N_MAT4 do
                multiplayMatrix(a, b, c)
                n = n + 1
            end

            local stop = currentTime:getCurrentTime()
            local duration = stop - start

            cclog("start: " .. start .. " end: " .. stop .. " duration: " .. duration)
        end

        -- Register callback
        loopItem:registerScriptTapHandler(loopCallback)
        callItem:registerScriptTapHandler(callfuncCallback)
        mat4Item:registerScriptTapHandler(mat4Callback)

        loopItem:setPosition( cc.p(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 3 * 2) )
        callItem:setPosition( cc.p(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2) )
        mat4Item:setPosition( cc.p(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 3 ) )

        -- Menu
        local menu = cc.Menu:create()

        menu:addChild(loopItem)
        menu:addChild(callItem)
        menu:addChild(mat4Item)

        menu:setPosition( cc.p(0, 0) )

        ret:addChild(menu)


        return ret
    end


    -- run
    local sceneGame = cc.Scene:create()
    sceneGame:addChild(TestLayer())
    cc.Director:getInstance():runWithScene(sceneGame)
end



xpcall(main, __G__TRACKBACK__)
