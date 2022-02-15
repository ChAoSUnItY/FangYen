module main

import fang_yen { new_lexer }
import os

fn main() {
	lines := os.read_lines('examples/main.fangyen') or { panic(err) }
	shared lexer := new_lexer()
	lex := go lexer.lex(lines)
	tokens := lex.wait()

	for token in tokens {
		println(token)
	}

	rlock lexer {
		println(lexer.reports)
	}
}
