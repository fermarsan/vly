module lexer

// -------------------------------------------------------------------------
// This object is a stand-in for a logging object created by the
// logging module.
struct VlyLogger {
mut:
    f os.File
}

fn new_ply_logger(f os.File) VlyLogger {
    return VlyLogger{
        f: f
    }
}

fn (mut p VlyLogger) critical(msg string, args ...string) {
    p.f.write_string('${msg % args.join(' ')}\n') or { panic(err) }
}

fn (mut p VlyLogger) warning(msg string, args ...string) {
    p.f.write_string('WARNING: ${msg % args.join(' ')}\n') or { panic(err) }
}

fn (mut p VlyLogger) error(msg string, args ...string) {
    p.f.write_string('ERROR: ${msg % args.join(' ')}\n') or { panic(err) }
}

fn (mut p VlyLogger) info(msg string, args ...string) {
    p.critical(msg, args)
}

fn (mut p VlyLogger) debug(msg string, args ...string) {
    p.critical(msg, args)
}
// -------------------------------------------------------------------------