module lexer


import os
import regex

// -------------------------------------------
// This array contains acceptable string types
const string_types := ['str', 'bytes']
// -------------------------------------------

// ------------------------------------------------------------------------
// This regular expression is used to match valid token names
const is_identifier = regex.regex_opt(r'^[a-zA-Z0-9_]+$') or { panic(err) }
// ------------------------------------------------------------------------

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

// --------------------------------------------------------------------
// Token struct.  This struct is used to represent the tokens produced.
struct LexToken {
mut:
    typ         string
    value       string
    lineno      int
    lexpos    	int
}

fn (t LexToken) str() string {
    return "LexToken( typ:    '${t.typ}', 
          value:  '${t.value}', 
          lineno: ${t.lineno}, 
          lexpos: ${t.lexpos} )"
}
// --------------------------------------------------------------------

// -------------------------------------------------------------------------
// This object is a stand-in for a logging object created by the
// logging module.
struct Logger {
mut:
    f os.File
}

pub fn new_logger(f os.File) Logger {
    return Logger{
        f: f
    }
}

pub fn (mut p Logger) critical(msg string, args ...string) {
    p.f.write_string('${msg} ${args.join(' ')}\n') or { panic(err) }
}

pub fn (mut p Logger) warning(msg string, args ...string) {
    p.f.write_string('WARNING: ${msg} ${args.join(' ')}\n') or { panic(err) }
}

pub fn (mut p Logger) error(msg string, args ...string) {
    p.f.write_string('ERROR: ${msg} ${args.join(' ')}\n') or { panic(err) }
}

pub fn (mut p Logger) info(msg string, args ...string) {
    p.critical(msg, ...args)
}

pub fn (mut p Logger) debug(msg string, args ...string) {
    p.critical(msg, ...args)
}
// -------------------------------------------------------------------------