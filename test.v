import src.lexer


my_token := lexer.LexToken{
	typ: 	'unknown'
	value:	'~'
	lineno:	4
	lexpos: 5
}

println('My token:\n${my_token}')