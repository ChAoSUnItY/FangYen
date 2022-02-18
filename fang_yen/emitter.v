module fang_yen

import os

struct Emitter {
mut:
	file_buf        []byte
	constant_buf        []byte
	code_buf             []byte
	stored_constants map[]
	constant_counter int
	file             os.File
}

pub fn new_emitter(file_path string) Emitter {
	path_entries := file_path.split('/')
	path := path_entries[0..path_entries.len - 1].join('/')
	if !os.exists(path) {
		os.mkdir(path) or { panic(err) }
	}
	return Emitter{[]byte{cap: 8}, []byte{cap: 8}, []byte{cap: 8}, os.open_file(file_path,
		'w') or { panic(err) }}
}

pub fn (mut e Emitter) emit(tokens []Token) {
	e.preinit()

	for i, t in tokens {
		println(t)

		match t.token_type {
			.integer_literal {}
			.@dump {}
		}
	}
}

fn (mut e Emitter) preinit() {
}
