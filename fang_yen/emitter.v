module fang_yen

import os

struct Emitter {
mut:
	file_buf         []byte
	constant_buf     []byte
	code_buf         []byte
	constant_counter u16
	file             os.File
}

pub fn new_emitter(file_path string) Emitter {
	path_entries := file_path.split('/')
	path := path_entries[0..path_entries.len - 1].join('/')
	if !os.exists(path) {
		os.mkdir(path) or { panic(err) }
	}
	return Emitter{[]byte{cap: 8}, []byte{cap: 8}, []byte{cap: 8}, 0, os.open_file(file_path,
		'w') or { panic(err) }}
}

pub fn (mut e Emitter) emit(tokens []Token) {
	e.preinit()

	for i, t in tokens {
		println(t)

		match t.token_type {
			.integer_literal {
				integer, zb := t.literal.int(), 0x30

				e.constant_buf << [
					byte(0x00),
					byte(integer),
					byte(integer >> 8),
					byte(integer >> 16),
					byte(integer >> 24),
				]

				e.code_buf << [byte(C.OP_CONST), byte(e.constant_counter)]
				e.constant_counter++

				dump((int(e.constant_buf[1]) << 0) + (int(e.constant_buf[2]) << 8) + (int(e.constant_buf[3]) << 16) + (int(e.constant_buf[4]) << 24))
			}
			.@dump {
				e.code_buf << [byte(C.OP_DUMP)]
			}
		}
	}

	e.code_buf << [byte(C.OP_RETURN)]

	e.file_buf << [byte(e.constant_counter << 0), byte(e.constant_counter << 8)]
	e.file_buf << e.constant_buf
	e.file_buf << e.code_buf

	e.file.write(e.file_buf) or { println(err) }
}

fn (mut e Emitter) preinit() {
	e.file_buf << [byte(0x43), byte(0x41), byte(0x53), byte(0x43)]
}
