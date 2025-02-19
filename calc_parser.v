// Parser example
import os
import vly { 
	rule
    parser 
    parser.prod    // production
}

// Get the token map from the lexer.  This is required.
import calc_lexer { tokens }

p_expression_plus := rule.GrammarRule {
    rule:   'expression : expression PLUS term'
    impl:   fn (p prod) prod {
        return p[0] = p[1] + p[3]
    }
}

p_expression_minus := rule.GrammarRule {
    rule:   'expression : expression MINUS term'
    impl:   fn (p prod) prod {
        return p[0] = p[1] - p[3]
    }
}

p_expression_term := rule.GrammarRule {
    rule:   'expression : term'
    impl:   fn (p prod) prod {
        return p[0] = p[1]
    }
}

p_term_times := rule.GrammarRule {
    rule:   'term : term TIMES factor'
    impl:   fn (p prod) prod {
        return p[0] = p[1] * p[3]
    }
}

p_term_div := rule.GrammarRule {
    rule:   'term : term DIVIDE factor'
    impl:   fn (p prod) prod {
        return p[0] = p[1] / p[3]
    }
}

p_term_factor := rule.GrammarRule {
    rule:   'term : factor'
    impl:   fn (p prod) prod {
        return p[0] = p[1]
    }
}

p_factor_num := rule.GrammarRule {
    rule:   'factor : NUMBER'
    impl:   fn (p prod) prod {
        return p[0] = p[1]
    }
}

p_factor_expr := rule.GrammarRule {
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

// This file was inspired by the PLY calc example 
// https://ply.readthedocs.io/en/latest/ply.html#an-example 