// -----------------------------------------------------------------------------
//                        === Lexing Engine ===
//
// The following Lexer class implements the lexer runtime.   There are only
// a few public methods and attributes:
//
//    input()          -  Store a new string in the lexer
//    token()          -  Get the next token
//    clone()          -  Clone the lexer
//
//    lineno           -  Current line number
//    lexpos           -  Current position in the input string
// -----------------------------------------------------------------------------

struct Lexer {
mut:
    lexre             []regex.RE
    lexretext         []string
    lexstatere        map[string][]regex.RE
    lexstateretext    map[string][]string
    lexstaterenames   map[string][]string
    lexstate          string = 'INITIAL'
    lexstatestack     []string
    lexstateinfo      map[string]string
    lexstateignore    map[string]string
    lexstateerrorf    map[string]fn (tok LexToken) ?LexToken
    lexstateeoff      map[string]fn (tok LexToken) ?LexToken
    lexreflags        int
    lexdata           string
    lexpos            int
    lexlen            int
    lexerrorf         fn (tok LexToken) ?LexToken
    lexeoff           fn (tok LexToken) ?LexToken
    lextokens         []string
    lexignore         string
    lexliterals       string
    lexmodule         voidptr
    lineno            int = 1
}

fn (mut l Lexer) clone(object voidptr) Lexer {
    mut c := l
    if object != voidptr(0) {
        mut newtab := map[string][]regex.RE{}
        for key, ritem in l.lexstatere {
            mut newre := []regex.RE{}
            for cre, findex in ritem {
                mut newfindex := []fn (tok LexToken) ?LexToken{}
                for f in findex {
                    if f == voidptr(0) {
                        newfindex << f
                        continue
                    }
                    newfindex << fn (tok LexToken) ?LexToken {
                        return call_method(object, f, tok)
                    }
                }
                newre << cre
            }
            newtab[key] = newre
        }
        c.lexstatere = newtab
        c.lexstateerrorf = map[string]fn (tok LexToken) ?LexToken{}
        for key, ef in l.lexstateerrorf {
            c.lexstateerrorf[key] = fn (tok LexToken) ?LexToken {
                return call_method(object, ef, tok)
            }
        }
        c.lexmodule = object
    }
    return c
}

fn (mut l Lexer) input(s string) {
    l.lexdata = s
    l.lexpos = 0
    l.lexlen = s.len
}

fn (mut l Lexer) begin(state string) {
    if state !in l.lexstatere {
        panic('Undefined state $state')
    }
    l.lexre = l.lexstatere[state]
    l.lexretext = l.lexstateretext[state]
    l.lexignore = l.lexstateignore[state] or { '' }
    l.lexerrorf = l.lexstateerrorf[state] or { fn (tok LexToken) ?LexToken { return none } }
    l.lexeoff = l.lexstateeoff[state] or { fn (tok LexToken) ?LexToken { return none } }
    l.lexstate = state
}

fn (mut l Lexer) push_state(state string) {
    l.lexstatestack << l.lexstate
    l.begin(state)
}

fn (mut l Lexer) pop_state() {
    l.begin(l.lexstatestack.pop())
}

fn (l Lexer) current_state() string {
    return l.lexstate
}

fn (mut l Lexer) skip(n int) {
    l.lexpos += n
}

fn (mut l Lexer) token() ?LexToken {
    lexpos := l.lexpos
    lexlen := l.lexlen
    lexignore := l.lexignore
    lexdata := l.lexdata

    for lexpos < lexlen {
        if lexdata[lexpos] in lexignore {
            lexpos++
            continue
        }

        for lexre, lexindexfunc in l.lexre {
            m := lexre.match_string(lexdata[lexpos..]) or { continue }
            if m.len == 0 {
                continue
            }

            mut tok := LexToken{}
            tok.value = m[0]
            tok.lineno = l.lineno
            tok.lexpos = lexpos

            i := m.len - 1
            func, tok.typ := lexindexfunc[i]

            if func == voidptr(0) {
                if tok.typ != '' {
                    l.lexpos = lexpos + m[0].len
                    return tok
                } else {
                    lexpos += m[0].len
                    break
                }
            }

            lexpos += m[0].len
            tok.lexer = l
            l.lexpos = lexpos
            newtok := func(tok) or { none }
            if newtok == none {
                lexpos = l.lexpos
                lexignore = l.lexignore
                break
            }
            return newtok
        }

        if lexdata[lexpos] in l.lexliterals {
            mut tok := LexToken{}
            tok.value = lexdata[lexpos].ascii_str()
            tok.lineno = l.lineno
            tok.typ = tok.value
            tok.lexpos = lexpos
            l.lexpos = lexpos + 1
            return tok
        }

        if l.lexerrorf != voidptr(0) {
            mut tok := LexToken{}
            tok.value = lexdata[lexpos..]
            tok.lineno = l.lineno
            tok.typ = 'error'
            tok.lexer = l
            tok.lexpos = lexpos
            l.lexpos = lexpos
            newtok := l.lexerrorf(tok) or { none }
            if lexpos == l.lexpos {
                panic('Scanning error. Illegal character ${lexdata[lexpos]}')
            }
            lexpos = l.lexpos
            if newtok == none {
                continue
            }
            return newtok
        }

        l.lexpos = lexpos
        panic('Illegal character ${lexdata[lexpos]} at index $lexpos')
    }

    if l.lexeoff != voidptr(0) {
        mut tok := LexToken{}
        tok.typ = 'eof'
        tok.value = ''
        tok.lineno = l.lineno
        tok.lexpos = lexpos
        tok.lexer = l
        l.lexpos = lexpos
        newtok := l.lexeoff(tok) or { none }
        return newtok
    }

    l.lexpos = lexpos + 1
    if l.lexdata == '' {
        panic('No input string given with input()')
    }
    return none
}

fn (mut l Lexer) next() ?LexToken {
    t := l.token() or { return none }
    if t == none {
        return none
    }
    return t
}
// -----------------------------------------------------------------------------
