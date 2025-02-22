module lexer

import regex
import os

// -------------------------------------------
// This array contains acceptable string types
string_types := ['str', 'bytes']
// -------------------------------------------


// This regular expression is used to match valid token names
// _is_identifier = re.compile(r'^[a-zA-Z0-9_]+$')

// --------------------------------------------------------------------
// Exception thrown when invalid token encountered and no default error
// handler is defined.
// struct LexerError {		// NOTE: Exception is missing
//     message []string
//     text    string
// }

// fn new_lexer_error(message string, s string) LexerError {
//     return LexerError{
//         message: [message]
//         text: s
//     }
// }
// --------------------------------------------------------------------









// -----------------------------------------------------------------------------
//                           ==== Lex Builder ===
//
// The functions and classes below are used to collect lexing information
// and build a Lexer object from it.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// _get_regex(func)
// 
// Returns the regular expression assigned to a function either as a doc string
// or as a .regex attribute attached by the @TOKEN decorator.
// -----------------------------------------------------------------------------
fn get_regex(func fn () string) string {
    return func() or { '' }
}
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// get_caller_module_dict()
//
// This function returns a dictionary containing all of the symbols defined within
// a caller further down the call stack.  This is used to get the environment
// associated with the yacc() call if none was provided.
// -----------------------------------------------------------------------------
fn get_caller_module_dict(levels int) map[string]string {
    mut result := map[string]string{}
    // Simulación de la obtención del entorno del llamador
    // En V, no hay una forma directa de obtener el marco de pila del llamador
    // como en Python. Por lo tanto, esta función debe ser adaptada según las necesidades específicas.
    // Aquí se proporciona un ejemplo básico de cómo podría estructurarse.
    // Puedes agregar las variables globales y locales necesarias manualmente.
    result['example_key'] = 'example_value'
    return result
}
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// _form_master_re()
//
// This function takes a list of all of the regex components and attempts to
// form the master regular expression.  Given limitations in the Python re
// module, it may be necessary to break the master regex into separate expressions.
// -----------------------------------------------------------------------------
def _form_master_re(relist, reflags, ldict, toknames):
    if not relist:
        return [], [], []
    regex = '|'.join(relist)
    try:
        lexre = re.compile(regex, reflags)

        # Build the index to function map for the matching engine
        lexindexfunc = [None] * (max(lexre.groupindex.values()) + 1)
        lexindexnames = lexindexfunc[:]

        for f, i in lexre.groupindex.items():
            handle = ldict.get(f, None)
            if type(handle) in (types.FunctionType, types.MethodType):
                lexindexfunc[i] = (handle, toknames[f])
                lexindexnames[i] = f
            elif handle is not None:
                lexindexnames[i] = f
                if f.find('ignore_') > 0:
                    lexindexfunc[i] = (None, None)
                else:
                    lexindexfunc[i] = (None, toknames[f])

        return [(lexre, lexindexfunc)], [regex], [lexindexnames]
    except Exception:
        m = (len(relist) // 2) + 1
        llist, lre, lnames = _form_master_re(relist[:m], reflags, ldict, toknames)
        rlist, rre, rnames = _form_master_re(relist[m:], reflags, ldict, toknames)
        return (llist+rlist), (lre+rre), (lnames+rnames)


fn form_master_re(relist []string, reflags int, ldict map[string]fn (LexToken) ?LexToken, toknames map[string]string) ([]regex.RE, []string, []string) {
    if relist.len == 0 {
        return []regex.RE{}, []string{}, []string{}
    }
    regex_str := relist.join('|')
    mut lexre := regex.regex_opt(regex_str) or { panic(err) }

    // Build the index to function map for the matching engine
    mut lexindexfunc := []fn (LexToken) ?LexToken{len: lexre.group_count + 1, init: fn (LexToken) ?LexToken { return none }}
    mut lexindexnames := []string{len: lexre.group_count + 1, init: ''}

    for f, i in lexre.group_map {
        handle := ldict[f] or { fn (LexToken) ?LexToken { return none } }
        if handle != voidptr(0) {
            lexindexfunc[i] = handle
            lexindexnames[i] = toknames[f]
        } else if f.contains('ignore_') {
            lexindexfunc[i] = fn (LexToken) ?LexToken { return none }
        } else {
            lexindexfunc[i] = fn (LexToken) ?LexToken { return none }
            lexindexnames[i] = toknames[f]
        }
    }

    return [lexre], [regex_str], lexindexnames
}

fn form_master_re_recursive(relist []string, reflags int, ldict map[string]fn (LexToken) ?LexToken, toknames map[string]string) ([]regex.RE, []string, []string) {
    if relist.len == 0 {
        return []regex.RE{}, []string{}, []string{}
    }
    regex_str := relist.join('|')
    mut lexre := regex.regex_opt(regex_str) or { panic(err) }

    // Build the index to function map for the matching engine
    mut lexindexfunc := []fn (LexToken) ?LexToken{len: lexre.group_count + 1, init: fn (LexToken) ?LexToken { return none }}
    mut lexindexnames := []string{len: lexre.group_count + 1, init: ''}

    for f, i in lexre.group_map {
        handle := ldict[f] or { fn (LexToken) ?LexToken { return none } }
        if handle != voidptr(0) {
            lexindexfunc[i] = handle
            lexindexnames[i] = toknames[f]
        } else if f.contains('ignore_') {
            lexindexfunc[i] = fn (LexToken) ?LexToken { return none }
        } else {
            lexindexfunc[i] = fn (LexToken) ?LexToken { return none }
            lexindexnames[i] = toknames[f]
        }
    }

    return [lexre], [regex_str], lexindexnames
}