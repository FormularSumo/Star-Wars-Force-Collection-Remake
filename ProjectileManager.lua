ProjectileManager = Class{__includes = BaseState}

function ProjectileManager:init(name,team,xoffset,yoffset,graphics,imagesInfo)
    self.projectileCount = name['projectileCount'] or 1

    self.projectiles = {}
    for i=1,self.projectileCount do
        local imagePath
        local nameString = 'projectile' .. tostring(i)
        if name[nameString] then
            imagePath = 'Graphics/' .. name[nameString          ]
            self.projectiles[i] = Projectile(team,xoffset,yoffset,name['range'..tostring(i)] or name['range'],name[nameString],imagePath)
        else
            nameString = 'projectile1'
            imagePath = 'Graphics/' .. name[nameString]
            self.projectiles[i] = Projectile(team,xoffset,yoffset,name['range'],name[nameString],imagePath)
        end

        if graphics[imagePath] then
            self.projectiles[i]:init2(graphics[imagePath])
        else
            if imagesInfo[imagePath] then
                table.insert(imagesInfo[imagePath][1],self.projectiles[i])
            else
                imagesInfo[imagePath] = {{self.projectiles[i]}, false}
            end
        end
    end
end

function ProjectileManager:fire(projectile,card,card2)
    self.projectiles[projectile]:fire(card,card2)
end

function ProjectileManager:fireall(card,card2)
    for k, pair in pairs(self.projectiles) do
        pair:fire(card,card2)
    end
end

function ProjectileManager:update(dt)
    for k, pair in pairs(self.projectiles) do
        pair:update(dt)
    end
end

function ProjectileManager:hideProjectiles(graphics)
    for k, pair in pairs(self.projectiles) do
        pair:hideProjectile(graphics)
    end
end

function ProjectileManager:render(graphics)
    if graphics then
        for k, pair in pairs(self.projectiles) do
            pair:render(graphics)
        end
    end
end