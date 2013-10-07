#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#

module Supx
module Database
	@messages_schema = Proc.new {
		primary_key :_id
		String      :key_remote_jid
		Integer     :key_from_me
		String      :key_id
		Integer     :status
		Integer     :needs_push
		String      :data
		Integer     :timestamp
		String      :media_url
		String      :media_mime_type
		String      :media_wa_type
		Integer     :media_size
		String      :media_name
		Float       :latitude
		Float       :longitude
		String      :thumb_image
		String      :remote_resource
		Integer     :received_timestamp
		Integer     :send_timestamp
		Integer     :receipt_server_timestamp
		Integer     :receipt_device_timestamp
		Blob        :raw_data
		String      :media_hash
		Int         :recipient_count
		Integer     :media_duration
		Integer     :origin
	}

	class << self
		attr_reader :messages_schema
	end

	def db_connect
		@db = Sequel.connect('sqlite://' + @db_path)
		@db.create_table?(:messages, &Supx::Database.messages_schema)
	end
end
end
