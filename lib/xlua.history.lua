
dbs = require "luasql.mysql"
9-9
print(9999)
dbc=dbs.mysql()
dbc
db=dbc:connect("dark_text", "cn.local", "dark", "654123")
db
db=assert(dbc:connect("dark_text", "cn.local", "dark", "654123"))
db=assert(dbc:connect("dark_text", "cn.local", "dark", "654123", "jlj"))
db=assert(dbc:connect("dark_text", "cn.local", "dark", "654123", 1))
db=assert(dbc:connect("dark_text", "cn.local", "dark", "cn.local", 1))
db=assert(dbc:connect("dark_text", "cn.local", "dark", "cn.local"))
db=assert(dbc:connect("dark_text", "dark", "cn.local", "654123"))
db=assert(dbc:connect("dark_text", "dark", "654123", "cn.local"))
for k,v in pairs(db)do print(k,v)end
for k,v in pairs(getmetatable(db))do print(k,v)end
getmetatable(db)
getmetatable(dbs)
getmetatable(dbc)
dbs
for k,v in pairs(getmetatable(dbs))do print(k,v)end
for k,v in pairs(dbs)do print(k,v)end
