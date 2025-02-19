# VLY will be a port of PLY / SLY parser on vlang

This repository contains the initial idea of implementing a port of Python's [PLY](https://ply.readthedocs.io/en/latest/ply.html#an-example) / [SLY](https://sly.readthedocs.io/en/latest/sly.html) parsers/lexers on vlang.

VLY pretends to implement parser/lexers like this calculator example:

```v
// Parser example
import os
import vly { 
    parser 
    parser.prod    // production
}

// Get the token map from the lexer.  This is required.
import calc_lexer { tokens }

p_expression_plus := GrammarRule {
    rule:   'expression : expression PLUS term'
    impl:   fn (p prod) prod {
        return p[0] = p[1] + p[3]
    }
}

p_expression_minus := GrammarRule {
    rule:   'expression : expression MINUS term'
    impl:   fn (p prod) prod {
        return p[0] = p[1] - p[3]
    }
}

p_expression_term := GrammarRule {
    rule:   'expression : term'
    impl:   fn (p prod) prod {
        return p[0] = p[1]
    }
}

p_term_times := GrammarRule {
    rule:   'term : term TIMES factor'
    impl:   fn (p prod) prod {
        return p[0] = p[1] * p[3]
    }
}

p_term_div := GrammarRule {
    rule:   'term : term DIVIDE factor'
    impl:   fn (p prod) prod {
        return p[0] = p[1] / p[3]
    }
}

p_term_factor := GrammarRule {
    rule:   'term : factor'
    impl:   fn (p prod) prod {
        return p[0] = p[1]
    }
}

p_factor_num := GrammarRule {
    rule:   'factor : NUMBER'
    impl:   fn (p prod) prod {
        return p[0] = p[1]
    }
}

p_factor_expr := GrammarRule {
    rule:   'factor : LPAREN expression RPAREN'
    impl:   fn (p prod) prod {
        return p[0] = p[2]
    }
}

// Error rule for syntax errors
fn p_error(p prod) {
    println('Syntax error in input!')
}
    

// Build the parser
parser := parser.parser()

for {
    s := input('calc > ') or {
        break
    }
    if !s { continue }
    result := parser.parse(s)
    println(result)
}
```

This declare instances of `GrammarRule`struct:

```v
struct GrammarRule {
mut:
	rule string
	impl fn(p vly.parser.prod) vly.parser.prod
}
```

PLY uses `docstrings` and SLY `decorators` for implementing the grammar rules strings on the implementation functions but `V` does not have nothing of them features so VLY will use the previous `struct` to associate the grammar rule string with its implementation function.