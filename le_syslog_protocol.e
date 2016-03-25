note
	description: "[
		Representation of a {LE_SYSLOG_PROTOCOL}
		]"
	design: "[
		Based on RFC 5424, especially section 6
		]"
	EIS: "src=https://tools.ietf.org/html/rfc5424"
	EIS: "src=https://tools.ietf.org/html/rfc5424#section-6"
	EIS: "name=Character_codes",
			"src=https://www.rosettacode.org/wiki/Character_codes#Eiffel"

class
	LE_SYSLOG_PROTOCOL

inherit
	ASCII

feature -- Access

	is_sd_param (a_string: STRING): BOOLEAN
		do
			do_nothing -- yet ...
		end
	sd_param: STRING
		once
			-- SD-PARAM        = PARAM-NAME "=" %d34 PARAM-VALUE %d34
			Result := param_name
			Result.append_character ('=')
			Result.append_character ('%/34/')
			Result.append_string (param_value)
			Result.append_character ('%/34/')
		end

	is_sd_id (a_string: STRING): BOOLEAN
		do
			Result := across a_string as ic all sd_name.has (ic.item) end
		end
	sd_id: STRING
		once
			-- SD-ID           = SD-NAME
			Result := sd_name
		end

	is_param_name (a_string: STRING): BOOLEAN
		do
			Result := across a_string as ic all sd_name.has (ic.item) end
		end
	param_name: STRING
		once
			-- PARAM-NAME      = SD-NAME
			Result := sd_name
		end

	is_param_value (a_string: STRING): BOOLEAN
		do
			Result := across
							a_string as ic
						all
							param_value.has (ic.item) or ic.item = esc
						end and
						(a_string.has (']') implies a_string.has_substring (escaped_left_square_bracket))
		end
	param_value: STRING
		once
			--       PARAM-VALUE     = UTF-8-STRING ; characters '"', '\' and
            --                       ; ']' MUST be escaped.
			Result := utf_8_string
			Result.append_character ('"')
			Result.append_character ('\')
		end

	escaped_left_square_bracket: STRING = "/]"

	is_sd_name (a_string: STRING): BOOLEAN
		do
			-- SD-NAME         = 1*32PRINTUSASCII
            --						; except '=', SP, ']', %d34 (")
			Result := across a_string as ic all
							sd_name.has (ic.item) and
								ic.item /= '=' and
								ic.item /= space and
								ic.item /= ']' and
								ic.item /= '%/34/' and
								(1 |..| 32).has (a_string.count)
						end
		end
	sd_name: STRING
		once
            Result := print_usa_ascii
		end

	is_msg (a_string: STRING): BOOLEAN
		do
			-- MSG             = MSG-ANY / MSG-UTF8
			Result := across a_string as ic all
							msg_any.has (ic.item) or
							msg_utf8.has (ic.item)
						end
		end
	msg: STRING
		once
			-- MSG             = MSG-ANY / MSG-UTF8
			Result := msg_any
			Result.append_string (msg_utf8)
		end

	is_msg_any (a_string: STRING): BOOLEAN
		do
			Result := across a_string as ic all
							msg_any.has (ic.item)
						end
		end
	msg_any: STRING
		once
			-- MSG-ANY         = *OCTET ; not starting with BOM
			Result := octet
		end

	is_msg_utf8 (a_string: STRING): BOOLEAN
		do
			Result := a_string.has_substring (bom) and
						across
							utf_8_string as ic
						all
							a_string.has (ic.item)
						end
		end
	msg_utf8: STRING
		once
			-- MSG-UTF8        = BOM UTF-8-STRING
			Result := bom
			Result.append_string (utf_8_string)
		end

	is_bom (a_string: STRING): BOOLEAN
		do
			Result := across a_string as ic all
							bom.has (ic.item)
						end
		end
	bom: STRING
		once
			-- BOM             = %xEF.BB.BF
			create Result.make_empty
			Result.append_character ('%/0xEF/')
			Result.append_character ('%/0xBB/')
			Result.append_character ('%/0xBF/')
		end

	is_utf_8_string (a_string: STRING): BOOLEAN
		do
			Result := across a_string as ic all
							octet.has (ic.item)
						end
		end
	utf_8_string: STRING
		once
			-- UTF-8-STRING    = *OCTET ; UTF-8 string as specified
			Result := octet
		end

	is_octet (a_string: STRING): BOOLEAN
		do
			Result := across a_string as ic all
							octet.has (ic.item)
						end
		end
	octet: STRING
		once
			-- OCTET           = %d00-255
			Result := ranged_string (<<(0 |..| 255)>>)
		end

	is_space (a_character: CHARACTER): BOOLEAN
		do
			Result := a_character = space
		end
	space: CHARACTER = '%/32/'

	is_print_usa_ascii (a_string: STRING): BOOLEAN
		do
			Result := across a_string as ic all
							print_usa_ascii.has (ic.item)
						end
		end
	print_usa_ascii: STRING
		local
			l_str: STRING
		once
			-- PRINTUSASCII    = %d33-126
			Result := ranged_string (<<(33 |..| 126)>>)
		end
	is_non_zero_digit (a_digits: STRING): BOOLEAN
		do
			Result := across a_digits as ic all
							non_zero_digit.has (ic.item)
						end
		end
	non_zero_digit: STRING
		once
			-- NONZERO-DIGIT   = %d49-57
			Result := ranged_string (<<(49 |..| 57)>>)
		end

	is_digit (a_character: CHARACTER): BOOLEAN
		do
			Result := a_character = digit
		end
	digit: CHARACTER = '%/48/'

	is_nilvalue (a_character: CHARACTER): BOOLEAN
		do
			Result := a_character = nilvalue
		end
	nilvalue: CHARACTER = '-'

feature {NONE} -- Implementation: Basic Operations

	ranged_string (a_range_list: ARRAY [INTEGER_INTERVAL]): STRING
			-- `ranged_string' based on `a_range_list'.
		do
			create Result.make_empty
			across
				a_range_list as ic_range
			loop
				across
					ic_range.item as ic_digit
				loop
					Result.append_code (ic_digit.item.to_natural_32)
				end
			end
		end

end
