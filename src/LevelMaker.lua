function createMap(level)
    local bricks = {}
    
    local numRows = math.random(5)--5
    
    local numColumns = math.random(7,13)--7 13
    numColumns = numColumns % 2 == 0 and numColumns + 1 or numColumns
    
    local highestColor = math.min(5,(level % 5) + 3)
    local highestTier = math.min(4,math.floor(level / 5) + 1)
    
    local LockedTile = math.random(4) == 1 and true or false
    local Lrow = math.random(numRows)
    local LCol = math.random(7,numColumns)
    Lock = false

    if LockedTile then
        Lock = true
    end

    for y = 1,numRows do 
        
        --to enable skipping of blocks for a row
        local skipPattern = math.random(2) == 1 and true or false
        
        --to enable alternating of colors and tier for a row
        local alternatePattern = math.random(2) == 1 and true or false
        
        local alternateColor1 = math.random(1,highestColor)
        local alternateColor2 = math.random(1,highestColor)
        local alternateTier1 = math.random(1,highestTier)
        local alternateTier2 = math.random(1,highestTier)

        --to skip the current brick in this column
        local skipBrick = math.random(2) == 1 and true or false
        
        --to alternate (color & tier) the current brick in this column
        local changeBrick = math.random(2) == 1 and true or false
        
        local solidColor = math.random(1,highestColor)
        local solidTier = math.random(1,highestTier)
        
        
        for x = 1,numColumns do 

            if LockedTile and y == Lrow and x == LCol then
                b.color = 6
                b.tier = 4
                LockedTile = not LockedTile
                goto continue
            end

            if skipPattern and skipBrick then
                skipBrick = not skipBrick
                goto continue
            else
                skipBrick = not skipBrick
            end

            b = Brick(
                8 + (x - 1) * 32 + (13 - numColumns) * 16
                ,y * 16
            )

            if alternatePattern and changeBrick then
                b.color = alternateColor1
                b.tier = alternateTier1
                changeBrick = not changeBrick
            else
                b.color = alternateColor2
                b.tier = alternateTier2
                changeBrick = not changeBrick
            end

            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end

            table.insert(bricks,b)
            ::continue::
        end
    end
    if #bricks == 0 then
        return createMap(level)
    else
        return bricks
    end
end