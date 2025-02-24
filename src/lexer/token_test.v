module lexer


fn test_token() {
	my_token := LexToken{
		typ: 	'unknown'
		value:	'~'
		lineno:	4
		lexpos: 5
	}

	println('My token:\n${my_token}')
}