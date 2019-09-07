
local sqlutil = require "util.sqlutil"

sqlutil.Mysql2Excel("dark_text",
   {
        "kv_text_v155_en_增量",
        "kv_text_v155_en_去重",
        "kv_text_v155_en_全量",
        "file_list"
    }
    , "dark", "654123", "cn"
    , "dark_client-kv_text-en-v155-"..os.date("%Y%m%d%H%M%S")..".xlsx"
)
