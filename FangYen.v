module main

import fang_yen { new_emitter, new_lexer }
import fang_yen.c
import os

fn main() {
	lines := os.read_lines('examples/main.fangyen') or { panic(err) }
	shared lexer := new_lexer()
	lex := go lexer.lex(lines)
	tokens := lex.wait()

	rlock lexer {
		println(lexer.reports)
	}

	mut emitter := new_emitter('examples/out/main.hvmc')
	emitter.emit(tokens)
}
