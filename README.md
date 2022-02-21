<h1> Fang Yen Programming Langauge</br>方言程式語言 </h1>

##

> Concatenative stack-oriented programming language but written in Mandarin?!?! PogChamp <br/>
> 串接堆疊導向程式語言但是用中文撰寫？！？！ 太神啦

<p align="center">

<table>
<td>

[繁體中文](/README_ZH.md)

</td>
<td>

English

</td>
</table>

</p>

Fang Yen is a concatenative programming language inspired by [Porth programming language](https://gitlab.com/tsoding/porth) and [Forth programming language](https://zh.wikipedia.org/wiki/Forth). Requires [Hieroglymph Virtual Machine](https://github.com/ChAoSUnItY/HieroglyphVM) to execute.

<h2> Build </h2>
<h3> Prereuisites </h3>

- [V Lang](https://github.com/vlang/vlang)
- Makefile

<h3> Build it from source </h3>

```cmd
$ git clone https://github.com/ChAoSUnItY/FangYen.git
$ git submodule update --init --recursive   # pull Hieroglymph VM
$ v up                                      # update V to latest version (optional but highy suggest)
$ v --prod ./FangYen.v                      # compile Fang Yen compiler into executable
$ ./FangYen <source file path>              # compile Fang Yen into bytecode and execute it
```

> Note: bytecode can be found at ~/.hvm/cache

<h2> Getting started </h2>
<h3> Fang Yen 101 </h3>

Since Fang Yen is concatenative stack-oriented programming language,
**all single words in Fang Yen (except several keywords) has specific opcode to be emitted**.
That's it, no redundant operation is allowed.

<h3> Types </h3>

Currently Fang Yen has the following primitive types:

- Integer
```c
1234
```
- Boolean
```c
是 // Stands for true
非 // Stands for false
```
<h3> Output </h3>

To dump a value from stack (dump: pop and print), use `傾印` keyword.

- Dump
```c
123 傾印 // this will print out 123
```

