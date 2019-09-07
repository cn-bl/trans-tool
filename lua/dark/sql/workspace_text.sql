
# replace efbbbf
# update kv_text_v set k = REPLACE(k, char(15711167),'')

create table if not exists file_list(
    id integer primary key auto_increment,
    p  text not null unique -- file path
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- k:v
create table if not exists kv_text(
    id bigint primary key auto_increment ,
    l integer not null, -- line
    k text, -- key
    v text, -- jp text
    c text, -- comment
    f integer, -- file id
    z text, -- jianti zhongwen
    t text, -- fanti
    b text, -- baidu fanyi
    KEY k (k(32)),
    KEY v (v(128)),
    KEY z (z(128)),
    KEY t (t(128))
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `kv_text_v155` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `f` int(11) DEFAULT NULL COMMENT '文件号file_list.id',
    `l` int(11) NOT NULL COMMENT '行号',
    `k` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '键',
    `v` varchar(4096) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '原文',
    `c` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注释',
    `cn` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简中',
    `cn-bs` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简中',
    `cn-t` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '繁中',
    `b` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '百度翻译',
    `tha` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '泰语',
    `en` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '英语',
    `ko` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '韩语',
    `tc` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '繁体',
    `ut` datetime DEFAULT NULL ON UPDATE current_timestamp(),
    `z_0723` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简中',
    PRIMARY KEY (`id`),
    UNIQUE KEY `kf` (`k`(256),`f`),
    KEY `k` (`k`(32)),
    KEY `v` (`v`(128)),
    KEY `z` (`cn`(128)),
    KEY `t` (`cn-t`(128))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

create view if not exists kv_text_view as
select t1.*, ktv.p path
from kv_text t1
left join file_list ktv on t1.f = ktv.id;


create view if not exists kv_text_unique_view as
select a.*, fl.p pathId, dic.zh bf
from (select * from kv_text t1 group by t1.v) a
         left join file_list fl on a.f = fl.id
         left join dic on a.v = dic.s
order by a.id
;


CREATE OR REPLACE VIEW `kv_text_vxx_uniq`
AS SELECT `id`, `l` , `k` , `v` , `c` , `f` , `cn`, `tc`,  `b`
FROM `kv_text_vxx` WHERE `v` <> '' AND `v` <> ' ' AND `v` IS NOT NULL GROUP BY `v` ORDER BY `id`;

## 删除条目
CREATE OR REPLACE VIEW kv_text_v155_delete AS
SELECT t.id, t.k, t.v, t.cn, t.en, t.f, t2.p path FROM kv_text_v155 t
LEFT JOIN `file_list` t2 ON t.f = t2.id
WHERE t.v IS NULL AND t.cn IS NOT NULL AND t.cn <> '' AND t.k NOT LIKE '%empty%'
ORDER BY t.f*10000 + t.l


CREATE OR REPLACE VIEW `kv_text_v155_diff_v133` AS
SELECT * FROM (
                  SELECT t.id, t.l, t.k, t.v jp, REPLACE(t3.v, CHAR(10), '\\n') jp133, t.cn, t.f, t2.p path
                  FROM kv_text_v155 t
                           LEFT JOIN `file_list` t2 ON t.f = t2.id
                           LEFT JOIN kv_text_v133 t3 ON t.f = t3.f AND t.k = t3.k
              ) t
-- WHERE t.v IS NULL AND t.cn IS NOT NULL AND t.cn <> '' AND t.k NOT LIKE '%empty%'
WHERE t.jp <> t.jp133 OR (t.jp IS NULL AND t.jp133 IS NOT NULL) OR (t.jp IS NOT NULL AND t.cn IS NULL AND (t.k NOT LIKE "//empty%" or t.f = 1106))
ORDER BY t.f*10000 + t.l


# insert ignore into file_list (p) values ('')


## ⚠️ GROUP_CONCAT 有长度限制，会被截断
SELECT
    a.*, b.p
FROM
    (SELECT id, l, f, GROUP_CONCAT(CASE k WHEN '' THEN c ELSE REPLACE(CONCAT(k, ":", v), CHAR(10), '\\n') END SEPARATOR '\n') s 
        FROM kv_text_v133 WHERE f < 10 GROUP BY f) a
        LEFT JOIN file_list b ON a.f = b.id