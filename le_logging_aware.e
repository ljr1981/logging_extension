note
	description: "[
		Representation of a {LE_LOGGING_AWARE}.
		]"

class
	LE_LOGGING_AWARE

feature -- Acces



feature {NONE} -- Implementation

	writer: LOG_ROLLING_WRITER_FILE
		once --("process")
			create Result.make_at_location (create {PATH}.make_from_string ("system.log"))
			Result.set_max_file_size (1000000)
			Result.enable_debug_log_level
		end

	logger: LOG_LOGGING_FACILITY
		once --("process")
			create Result.make
			Result.register_log_writer (writer)
		end

feature {NONE} -- Implementation: Syslog

	syslog_protocol
		note
			EIS: "src=https://tools.ietf.org/html/rfc5424"
		do

		end



end
