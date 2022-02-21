<h1> Fang Yen Programming Langauge</br>方言程式語言 </h1>

##

> Concatenative stack-oriented programming language but written in Mandarin?!?! PogChamp <br/>
> 串接堆疊導向程式語言但是用中文撰寫？！？！ 太神啦

<p align="center">

<table>
<td>

繁體中文

</td>
<td>

[English](/README.md)

</td>
</table>

</p>

方言是一門串接程式語言，他受[Porth 程式語言](https://gitlab.com/tsoding/porth) 以及 [Forth 程式語言](https://zh.wikipedia.org/wiki/Forth) 啟發。 目前需要[象形虛擬機](https://github.com/ChAoSUnItY/HieroglyphVM)來運行。

<h3> 從原始碼建置 </h3>

```cmd
$ git clone https://github.com/ChAoSUnItY/FangYen.git
$ git submodule update --init --recursive   # 更新象形虛擬機
$ v up                                      # 更新V語言至最新版本（可選，但高度建議）
$ v --prod ./FangYen.v                      # 編譯方言編譯器
$ ./FangYen <原始碼檔案路徑>                # 編譯方言程式碼並執行
```

> 註解: 位元組碼可以在 ~/.hvm/cache 內找到

<h2> 入門 </h2>
<h3> 簡述 </h3>

在方言裡，
**所有的字詞（除了某些特定的關鍵字外）都有其對應的運算碼**，
也就是說，方言不允許多餘的操作。

<h3> 型別 </h3>

目前方言有以下原生形別：

- 整數
```c
1234
```
- 布林
```c
是 // 也就是true
非 // 也就是false
```

直接宣告原生型別將會將其值推送至虛擬機的棧上。

<h4> 輸出 </h4>

要傾印目前棧上頂端的值（傾印：從棧上移除值並輸出至終端），使用`傾印`關鍵字。

- 傾印
```c
123 傾印 // 在終端內輸出 123
```

