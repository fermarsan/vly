module lexer

import regex
import os

// -------------------------------------------
// This array contains acceptable string types
string_types := ['str', 'bytes']
// -------------------------------------------


// This regular expression is used to match valid token names
// _is_identifier = re.compile(r'^[a-zA-Z0-9_]+$')

// ------------------------------------------------------
// Exception thrown when invalid token encountered and no default error
// handler is defined.
struct LexerError {		// NOTE: Exception is missing
    message []string
    text    string
}

fn new_lexer_error(message string, s string) LexerError {
    return LexerError{
        message: [message]
        text: s
    }
}
// ------------------------------------------------------