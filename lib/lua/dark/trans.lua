require("util.stringx")
local luasql = require "luasql.mysql"

local util = require("util")
local excel = require("util.excel")

local db = assert(luasql.mysql():connect("dark_text", "dark", "654123", "cn"))

--local epath = "/Volumes/《尼尔》国服/翻译同步/V1.2.1/已翻译/20210709_翻译更新/dark-client-jp-kv-text-v1.2.1-20210709155400更新.xlsx"
--local epath = "/Volumes/《尼尔》国服/翻译同步/V1.3.30/已翻译/20210716增量翻译返回/1.2-1.3.30版本迭代后新增前端待翻译部分20210622.xlsx"
--local epath = "/Volumes/《尼尔》国服/翻译同步/V1.2.1/已翻译/20210721_第一批本地化校对内容/20210721_dark-client-jp-kv-text-v1.2.1-20210428111844_zho-CN.xlsx"
--local epath = "/Volumes/《尼尔》国服/翻译同步/V1.2.1/已翻译/20210702_第一批本地化翻译内容/dark-client-jp-kv-text-v1.2.1-20210428111844.xlsx"
local epath = "/Volumes/《尼尔》国服/翻译同步/V1.2.1/已翻译/20210721_第一批本地化校对内容/20210721_dark-client-jp-kv-text-v1.2.1-20210428111844_zho-CN.xlsx"
local sheetName = "kv_text(去重)"
local book = excel.OpenExcel(epath)
local sheet = book:GetSheet(sheetName)
local jpIdx = 3
local trIdx = 4
excel.EnumerateRowInSheet(sheet, function(i, row)
    local id = row:GetCell(0):ToString()
    local key = row:GetCell(2):ToString()
    --local jp = row:GetCell(2):ToString():gsub("'", "''"):gsub('\n*$', '')
    local jp = row:GetCell(jpIdx):ToString():gsub("'", "''"):gsub('\n*$', '')
    --local tr = row:GetCell(3) and row:GetCell(3):ToString():gsub("'", "''"):gsub('\n*$', '') or ""
    local tr = row:GetCell(trIdx) and row:GetCell(trIdx):ToString():gsub("'", "''"):gsub('\n*$', '') or ""
    if #tr > 1 then
        local sql = string.format([[update kv_text_v133 set cn = '%s' where v = '%s' and cn <> '%s';]]
        , tr, jp, tr)
        print(i, sql:gsub("\n", "\\n"))
         assert(db:exec(sql))
    else
        print(id, "no trans", jp:gsub("\n", "\\n"))
    end
end)
--local sql = [[
--UPDATE
-- -- SELECT t1.id, t1.v, t2.z FROM 
--    `kv_text_v133` t1
--LEFT JOIN `kv_text_v121` t2 ON (t1.v = t2.v and t1.f = t2.f)
--SET t1.z = t2.z
--WHERE t1.v <> '' AND t2.v <> '' AND t1.v <> '-' AND t2.v <> '-'
--]]
--assert(db:exec(sql))
db:close()