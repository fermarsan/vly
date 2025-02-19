module calc_lexer

import vly {
	lexer,
	lexer.token
}

// List of token names.   This is always required
tokens := [
  'number',
  'plus',
  'minus',
  'times',
  'divide',
  'lparen',
  'rparen',
]

// Regular expression rules for simple tokens
t_plus    := '\+'
t_minus   := '-'
t_times   := '\*'
t_divide  := '/'
t_lparen  := '\('
t_rparen  := '\)'

// A regular expression rule with some action code
t_number := rule.TokenRule {
  rule:   '\d+'
  impl:   fn (t token) token {
    t.value = int(t.value)
    return t
  }
}

// Define a rule so we can track line numbers
t_newline := rule.TokenRule {
  rule:   '\n+'
  impl:   fn (t token) token {
    t.lexer.lineno += len(t.value)
    return nil
  }
}

// A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'

// Error handling rule
fn t_error(t token) {
  println("Illegal character '${t.value[0]}'")
  t.lexer.skip(1)
}

// Build the lexer
lexer = lexer.lexer()


// struct LexerRule {
// mut:
// 	rule string
// 	impl fn(p vly.lexer.token) vly.lexer.token
// }


// This file was inspired by the PLY calc example 
// https://ply.readthedocs.io/en/latest/ply.html#an-example 