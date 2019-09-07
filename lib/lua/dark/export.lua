require("util.stringx")
local util = require("util")
local luasql = require "luasql.mysql"
local db = assert(luasql.mysql():connect("dark_text", "dark", "654123", "cn"))
--local sql = [[
--SELECT
--    a.*, b.p
--FROM
--    (SELECT id, l, 
--        GROUP_CONCAT(CASE k WHEN '' THEN c ELSE REPLACE(CONCAT(k, ":", IFNULL(z,   v)), CHAR(10), '\\n') END SEPARATOR '\n') cns, 
--        GROUP_CONCAT(CASE k WHEN '' THEN c ELSE REPLACE(CONCAT(k, ":", IFNULL(tc,  v)), CHAR(10), '\\n') END SEPARATOR '\n') tcs, 
--        GROUP_CONCAT(CASE k WHEN '' THEN c ELSE REPLACE(CONCAT(k, ":", IFNULL(tha, v)), CHAR(10), '\\n') END SEPARATOR '\n') thas, 
--        f
--        FROM kv_text_v133 
--        # WHERE f < 10 
--        GROUP BY f
--    ) a
--LEFT JOIN file_list b ON a.f = b.id
--]]

local flist = {}
local sql = [[select * from file_list;]]
local res = assert(db:exec(sql))
local rows = res:numrows()
print("rows", rows)
for i=0, rows-1 do
    local t = {}
    res:fetch(t, "*a")
    --print(i, t.p, t.cns)
    table.insert(flist, t)
end

--local sqlfmt = [[
--SELECT id, l, k, v, c, z tr
----    GROUP_CONCAT(CASE k WHEN '' THEN c ELSE REPLACE(CONCAT(k, ':', IFNULL(z,   v)), CHAR(10), '\\n') END SEPARATOR '\n') cns
--FROM kv_text_v133 
--where f = %d
---- GROUP BY f;
--]]
local sqlfmt = [[
SELECT id, f, l, k, v, c, cn tr
FROM kv_text_v133 
where f = %d and v is not null
order by l
]]
local function fwrite(path, str)
    local f = assert(io.open(path, "w"), path)
    f:write(str)
    f:close()
    --print(path, str)
end

for i, v in ipairs(flist) do
    local sql = string.format(sqlfmt, v.id)
    print(i, type(i), v.id, v.p, sql:gsub("\n", " "))
    local res = assert(db:exec(sql))
    local rows = res:numrows()
    --print("rows", rows)
    local all = {}
    for ii=0, rows-1 do
        local t = {}
        res:fetch(t, "*a")

        --print(t.id, t.tr == nil and "" or t.tr)
        if i == 1106 then
            --print(1106, t.tr)
            table.insert(all, t.tr or "")
        else
            t.tr = t.tr or t.v
            if t.k ~= "" and string.sub(t.k, 1,2) ~= "//" then
                table.insert(all, t.k..":"..string.gsub(t.tr, "\n", "\\n"))
            else
                table.insert(all, t.c)
            end
        end
    end
    local s = table.concat(all,"\n")
    fwrite(v.p, s)
    fwrite(v.p:gsub("/ja/", "/cn/"), s)
end
res:close()
db:close()