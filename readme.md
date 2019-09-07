

本工具脚本用于**A3!满开剧团**，**尼尔·重生** 游戏代码和资源中的日文翻译回填

使用百度翻译生成的翻译结果仅用于回填验证

### 使用方法
- 原文提取
>- CollectExcelDic: 收集 Excel 文件中的日文提取到字典 Excel jp 列
>- CollectExcelDiff2Dic: 提取增量
>- CollectImg2Excel: 将待翻译图片和路径插入Excel文件提供给翻译人员

- 翻译
>- bf: 调用百度翻译API将翻译结果存到 sqlite/mysql bf 列(用于验证回填)
>- Excel2Sqlite: 将 Excel 文件导入到 sqlite {language:zh} 列

- 翻译回填
>- TransExcel: Excel翻译回填
>- codeTrans: 代码翻译回填

### 系统支持
- macos
- windows(大部份功能可用)
