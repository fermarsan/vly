module lexer

import os

fn test_logger() {
	mut log_file := os.create('my_log.txt') or { 
		panic('Failed to create file: my_log.txt') 
	}

	mut my_logger := lexer.new_logger(log_file)

	my_logger.critical('unknown identifier.', 'unknown variable')

	my_logger.info('unknown identifier.', 'unknown variable')

	my_logger.debug('unknown identifier.', 'unknown variable')

	my_logger.warning('unknown identifier.', 'unknown variable')

	my_logger.error('unknown identifier.', 'unknown variable')
}