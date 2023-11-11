local M = {}
local class_tbl = {}

local ClassType = {
    class = 1, 
    instance = 2
}

function M.create_class(self, clz_name, super)
    assert(type(clz_name) == "string" and #clz_name > 0)
    local class_type = {}
    class_type.__init = false
    class_type.__delete = false
    class_type.__cname = clz_name
    class_type.__ctype = ClassType.class
    class_type.super = super

    -- 继承方法
    class_type.derive = function(self, clz_name) 
        return M.create_class(self, clz_name, self) 
    end
    -- 新建对象，不对外调用（走__call）
    class_type.new = function(...)
        local obj = {}
        obj._class_type = class_type
        obj.__ctype = ClassType.instance
        setmetatable(obj, {
            __index = class_tbl[class_type],
            -- 重载元方法
            __add = class_type.__mt_add,
            __sub = class_type.__mt_sub,
            __mul = class_type.__mt_mul,
            __div = class_type.__mt_div,
            __mod = class_type.__mt_mod,
            __pow = class_type.__mt_pow,
            __unm = class_type.__mt_unm,
            __concat = class_type.__mt_concat,
            __len = class_type.__mt_len,
            __eq = class_type.__mt_eq,
            __lt = class_type.__mt_lt,
            __le = class_type.__mt_le,
            __call = class_type.__mt_call,
            __tostring = class_type.__mt_tostring,
            __metatable = class_type.__mt_metatable,
        })
        do
            -- 定义和内容分开，防止无法捕获create上值
            local create
            create = function(c, ...)
                if c.super then 
                    create(c.super, ...) 
                end
                if c.__init then 
                    c.__init(...) 
                end
            end
            create(class_type, ...)
        end
        obj.delete = function(self)
            local now_super = self.__class_type
            while now_super ~= nil do
                if now_super.__delete then
                    now_super.__delete(self)
                end
                now_super = now_super.super
            end
        end
        return obj
    end

    local vtbl = {}
    class_tbl[class_type] = vtbl
    setmetatable(class_type, {
        __index = vtbl,
        __call = class_type.new,
        __newindex = function(t, k, v) 
            vtbl[k] = v
        end,
    })

    if super then
        setmetatable(vtbl, {
            __index = function(t, k)
                local ret = class_tbl[super][k]
                return ret
            end
        })
    end

    return class_type
end

setmetatable(M, {
    __call = M.create_class, 
})

return M
