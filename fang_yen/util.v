module fang_yen

struct Report {
	message string
	pos     Pos
}

struct Pos {
	line int
	pos  int
}
