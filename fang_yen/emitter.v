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

pub fn (mut e Emitter) emit(tokens []Token) []byte {
	e.preinit()

	mut line := 0
	for t in tokens {
		if t.pos.line > line {
			line = t.pos.line
			e.code_buf << [byte(C.ATTR_LINE), byte(line), byte(line >> 8)]
			// TODO: Support up to 2^32 - 1 line numbers
		}

		match t.token_type {
			.integer_literal {
				integer := t.literal.int()

				e.constant_buf << [
					byte(0x00),
					byte(integer),
					byte(integer >> 8),
					byte(integer >> 16),
					byte(integer >> 24),
				]

				e.code_buf << [byte(C.OP_CONST), byte(e.constant_counter)]
				e.constant_counter++
			}
			.true_literal {
				e.code_buf << [byte(C.OP_CONST_1)]
			}
			.false_literal {
				e.code_buf << [byte(C.OP_CONST_0)]
			}
			.nil_literal {
				e.code_buf << [byte(C.OP_CONST_NIL)]
			}
			.@dump {
				e.code_buf << [byte(C.OP_DUMP)]
			}
			.neg {}
			.add {
				e.code_buf << [byte(C.OP_ADD)]
			}
			.sub {
				e.code_buf << [byte(C.OP_SUB)]
			}
			.mul {
				e.code_buf << [byte(C.OP_MUL)]
			}
			.div {
				e.code_buf << [byte(C.OP_DIV)]
			}
			.rem {
				e.code_buf << [byte(C.OP_REM)]
			}
			.@or {}
			.and {}
			.eq {
				e.emit_comparison(C.OP_IFEQ)
			}
			.nq {
				e.emit_comparison(C.OP_IFNE)
			}
			.gt {
				e.emit_comparison(C.OP_IFGT)
			}
			.ge {
				e.emit_comparison(C.OP_IFGE)
			}
			.lt {
				e.emit_comparison(C.OP_IFLT)
			}
			.le {
				e.emit_comparison(C.OP_IFLE)
			}
		}
	}

	e.code_buf << [byte(C.OP_RETURN)]

	e.file_buf << [byte(e.constant_counter), byte(e.constant_counter << 8)]
	e.file_buf << e.constant_buf
	e.file_buf << e.code_buf

	e.file.write(e.file_buf) or { println(err) }

	return e.file_buf
}

fn (mut e Emitter) preinit() {
	e.file_buf << [byte(0x43), byte(0x41), byte(0x53), byte(0x43), byte(C.V1_0), byte(C.V1_0 >> 8)]
}

fn (mut e Emitter) current_byte_offset() u16 {
	return u16(e.code_buf.len - 1)
}

fn (mut e Emitter) emit_comparison(opcode int) {
	byte_offset := e.current_byte_offset() + 8
	e.code_buf << [byte(opcode), byte(byte_offset), byte(byte_offset << 8), byte(C.OP_CONST_0),
		byte(C.OP_GOTO), byte((byte_offset + 1)), byte((byte_offset + 1) << 8), byte(C.OP_CONST_1)]
}
