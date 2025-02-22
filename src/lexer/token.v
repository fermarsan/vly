module lexer

// ------------------------------------------------------------------
// Token class.  This class is used to represent the tokens produced.
pub struct LexToken {
pub mut:
    typ         string
    value       string
    lineno      int
    lexpos    	int
}

pub fn (t LexToken) str() string {
    return "LexToken( typ:    '${t.typ}', 
          value:  '${t.value}', 
          lineno: ${t.lineno}, 
          lexpos: ${t.lexpos} )"
}
// ------------------------------------------------------------------