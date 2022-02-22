module fang_yen

import encoding.utf8
import strings

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
	@dump
	add
	sub
	mul
	div
	rem
}

const keywords = {
	'傾印': TokenType.@dump
	'加':    .add
	'減':    .sub
	'乘':    .mul
	'除':    .div
	'餘':    .rem
}

pub fn (mut l Lexer) lex(source []string) []Token {
	mut tokens := []Token{cap: 100}

	for i in 0 .. source.len {
		runes := source[i].runes()

		for j := 0; j < runes.len; j++ {
			if is_space(runes[j]) {
				continue
			}

			if is_arabic_number(runes[j]) {
				start_pos := j + 1
				mut builder := strings.new_builder(5)

				for is_arabic_number(runes[j]) {
					builder.write_rune(runes[j])
					j++
				}

				tokens << Token{.integer_literal, builder.str(), Pos{i + 1, start_pos}}
				continue
			}

			// multiple word keywords
			mut mapped := false
			for k, v in fang_yen.keywords {
				result, len := word(k, runes, j)

				if result {
					mapped = true
					j += len - 1
					tokens << Token{v, k, Pos{i + 1, j + 1}}
					break
				}
			}

			if mapped {
				continue
			} else {
				l.reports << Report{'未知字元 `${runes[j]}`', Pos{i + 1, j + 1}}
			}
		}
	}

	return tokens
}

fn word(match_word string, runes []rune, start int) (bool, int) {
	len := utf8.len(match_word)

	if runes.len - start < len {
		return false, len
	}

	return match_word == runes[start..start + len].string(), len
}

fn is_space(r rune) bool {
	return r == ` ` || r == `\t`
}

fn is_arabic_number(r rune) bool {
	return r >= `0` && r <= `9`
}
