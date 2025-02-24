module lexer

import os

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