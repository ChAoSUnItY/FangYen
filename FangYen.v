module main

import fang_yen { new_emitter, new_lexer }
import fang_yen.c
import os

fn main() {
	if os.args.len > 1 && os.exists(os.args[1]) {
		file_name := os.file_name(os.args[1]).split('.')[0]
		lines := os.read_lines(os.args[1]) or { panic(err) }
		mut lexer := new_lexer()
		tokens := lexer.lex(lines)

		if lexer.reports.len > 0 {
			println(lexer.reports)
		}

		if !os.exists('$os.home_dir()/.hvm/cache') {
			os.mkdir_all('$os.home_dir()/.hvm/cache') or { println(err) }
		}

		mut emitter := new_emitter('$os.home_dir()/.hvm/cache/${file_name}.hvmc')
		bytecode := emitter.emit(tokens)

		C.loadAndInterpret(bytecode.data, bytecode.len)
	} else {
		println('Usage: fy <source file>')
	}
}
