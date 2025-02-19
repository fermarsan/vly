// class LexError(Exception):
//     def __init__(self, message, s):
//         self.args = (message,)
//         self.text = s

struct LexerError {
    message []string
    text    string
}

fn new_lexer_error(message string, s string) LexerError {
    return LexerError{
        message: [message]
        text: s
    }
}