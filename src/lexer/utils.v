module lexer


import regex

// ------------------------------------------------------------------------
// This regular expression is used to match valid token names
pub const is_identifier = regex.regex_opt(r'^[a-zA-Z0-9_]+$') or { panic(err) }
// ------------------------------------------------------------------------

// # Exception thrown when invalid token encountered and no default error
// # handler is defined.
// class LexError(Exception):
//     def __init__(self, message, s):
//         self.args = (message,)
//         self.text = s

