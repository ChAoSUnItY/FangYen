module fang_yen

import encoding.utf8

struct Lexer {
pub mut:
	reports []Report
}

pub fn new_lexer() Lexer {
	return Lexer{[]Report{cap: 100}}
}

struct Token {
pub:
	token_type TokenType
	literal    string
	pos        Pos
}

enum TokenType {
	integer_literal
	push
	@dump
}

pub fn (shared l Lexer) lex(source []string) []Token {
	mut tokens := []Token{cap: 100}

	for i in 0 .. source.len {
		runes := source[i].runes()

		for j in 0 .. runes.len {
			if is_space(runes[j]) {
				continue
			}

			match runes[j] {
				`推` {
					tokens << Token{.push, utf8.raw_index(source[i], j), Pos{i + 1, j + 1}}
				}
				else {
					lock l {
						l.reports << Report{'未知字元 `${runes[j]}`', Pos{i + 1, j + 1}}
					}
				}
			}
		}
	}

	return tokens
}

// returns
fn match(match_word string, runes []rune, start int) (bool, int) {

}

fn is_space(r rune) bool {
	return r == ` ` || r == `\t`
}
