module fang_yen

import os
import strings

struct Emitter {
mut:
	file   os.File
	indent int
}

pub fn new_emitter(file_path string) Emitter {
	path_entries := file_path.split('/')
	path := path_entries[0..path_entries.len - 1].join('/')
	if !os.exists(path) {
		os.mkdir(path) or { panic(err) }
	}
	return Emitter{os.open_file(file_path, 'w') or { panic(err) }, 0}
}

// TODO: Change tokens into Stmts or Exprs
pub fn (mut e Emitter) emit(tokens []Token) {
	e.preinit()

	for i, t in tokens {
		match t.token_type {
			.integer_literal {}
			.push {}
			.@dump {}
		}
	}
}

fn (mut e Emitter) preinit() {
	e.writeln('segment .text')
	e.writeln('global _start')
	e.writeln('_start:')
	e.indent++
	e.writeln('mov rax, 60')
	e.writeln('mov rdi, 0')
	e.writeln('syscall')
	e.indent--
}

fn (mut e Emitter) writeln(s string) {
	e.emit_indent()
	e.file.writeln(s) or { panic(err) }
}

fn (mut e Emitter) write(s string) {
	e.emit_indent()
	e.file.write_string(s) or { panic(err) }
}

fn (mut e Emitter) emit_indent() {
	e.file.write_string(strings.repeat_string('    ', e.indent)) or { panic(err) }
}
