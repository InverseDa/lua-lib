local Class = require "class"
local Vec4 = Class("Vec4")

function Vec4:__init(x, y, z, w)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
end

function Vec4:__mt_tostring()
    return string.format("Vec4(%f, %f, %f, %f)", self.x, self.y, self.z, self.w)
end

function Vec4:__mt_add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y
    self.z = self.z + v.z
    self.w = self.w + v.w
    return self
end

function Vec4:__mt_sub(v)
    self.x = self.x - v.x
    self.y = self.y - v.y
    self.z = self.z - v.z
    self.w = self.w - v.w
    return self
end 

function Vec4:__mt_mul(v)
    if type(v) == "number" then
        self.x = self.x * v
        self.y = self.y * v
        self.z = self.z * v
        self.w = self.w * v
    else
        self.x = self.x * v.x
        self.y = self.y * v.y
        self.z = self.z * v.z
        self.w = self.w * v.w
    end
    return self
end

function Vec4:__mt_div(v)
    if type(v) == "number" then
        self.x = self.x / v
        self.y = self.y / v
        self.z = self.z / v
        self.w = self.w / v
    else
        self.x = self.x / v.x
        self.y = self.y / v.y
        self.z = self.z / v.z
        self.w = self.w / v.w
    end
    return self
end

return Vec4
