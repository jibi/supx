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

  @chat_list_schema = Proc.new {
    primary_key :_id
    String      :key_remote_jid
    Integer     :message_table_id
  }

  @contacts_schema = Proc.new {
    primary_key :id
    String      :jid
    Bool        :is_whatsapp_user
    String      :status
    String      :number
    Integer     :raw_contact_id
    String      :display_name
    Integer     :phone_type
    String      :phone_label
    Integer     :unseen_msg_count
    Integer     :photo_ts
    Integer     :thumb_ts
    Integer     :photo_id_timestamp
    String      :given_name
    String      :family_name
    String      :wa_name
    String      :sort_name
  }
  class << self
    attr_reader :messages_schema, :chat_list_schema
    attr_reader :contacts_schema
  end

  def db_connect
    raise 'No messages database found' if not File.exists?(@msg_db_path)

    @message_db = Sequel.connect('sqlite://' + @msg_db_path)
    @message_db.create_table?(:messages,  &Supx::Database.messages_schema)
    @message_db.create_table?(:chat_list, &Supx::Database.chat_list_schema)

    if File.exists?(@contact_db_path)
      @contacts   = true
      @contact_db = Sequel.connect('sqlite://' + @contact_db_path)
      @contact_db.create_table?(:wa_contacts, &Supx::Database.contacts_schema)
    else
      @contact = false
    end

  end
end
end
