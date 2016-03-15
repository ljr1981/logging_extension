note
	description: "Tests of {LOGGING_EXTENSION}."
	testing: "type/manual"

class
	LOGGING_EXTENSION_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	log_writer_file_tests
			-- `log_writer_file_tests'
		local
			l_writer: LOG_ROLLING_WRITER_FILE
			l_logger: LOG_LOGGING_FACILITY
			l_rnd: RANDOMIZER
		do
			create l_writer.make_at_location (create {PATH}.make_from_string ("system.log"))
			l_writer.set_max_file_size (1000000)
			create l_logger.make
			create l_rnd

			l_logger.register_log_writer (l_writer)

			across
				(1 |..| 200) as ic
			loop
					-- With stock "writer" and "logger" ...
				l_logger.write_alert (l_rnd.uuid.out)		-- Yes
				l_logger.write_critical (l_rnd.uuid.out)	-- Yes
				l_logger.write_debug (l_rnd.uuid.out)		-- No
				l_logger.write_emergency (l_rnd.uuid.out)	-- Yes
				l_logger.write_error (l_rnd.uuid.out)		-- Yes
				l_logger.write_information (l_rnd.uuid.out)	-- No
				l_logger.write_notice (l_rnd.uuid.out)		-- No
				l_logger.write_warning (l_rnd.uuid.out)		-- No

				l_writer.enable_debug_log_level -- Possible log levels	UNKNO < EMERG < ALERT < CRIT < ERROR < WARN < NOTIC < INFO < DEBUG

					-- With stock "writer" and "logger" ...
				l_logger.write_alert ("debug - " + l_rnd.uuid.out)			-- Yes
				l_logger.write_critical ("debug - " + l_rnd.uuid.out)		-- Yes
				l_logger.write_debug ("debug - " + l_rnd.uuid.out)			-- No
				l_logger.write_emergency ("debug - " + l_rnd.uuid.out)		-- Yes
				l_logger.write_error ("debug - " + l_rnd.uuid.out)			-- Yes
				l_logger.write_information ("debug - " + l_rnd.uuid.out)	-- No
				l_logger.write_notice ("debug - " + l_rnd.uuid.out)			-- No
				l_logger.write_warning ("debug - " + l_rnd.uuid.out)		-- No			
			end
		end

end
