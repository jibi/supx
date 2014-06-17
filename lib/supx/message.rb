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
module Message
  def read_msgs(contact)
    @contact = contact
    @bubbles = []

    set_conversation_type

    @message_db[:messages].filter(key_remote_jid: contact).order(:_id).each do |msg|
      @cur_msg = msg

      next if @conversation == :group and
        @cur_msg[:media_wa_type].eql?(0) and
        @cur_msg[:media_size].nonzero?

      check_data_change
      read_msg
    end

    @bubbles
  end

private

  def set_conversation_type
    if @contact =~ /@s.whatsapp.net/
      @conversation =:single
    elsif @contact =~ /@g.us/
      @conversation = :group
    else
      raise 'Invalid contact'
    end
  end

  def check_data_change
    timestamp = @cur_msg[:timestamp]
    date      = Time.at(timestamp.to_s[0..-4].to_i).strftime('%Y-%m-%d')

    if not @last_date.eql? date
      @last_date =  date
      @bubbles << { what: :date_changed, data: date }
    end
  end

  def get_contact_name(contact)
    if @contacts
      @contact_db[:wa_contacts].where(jid: contact).first[:display_name]
    else
      contact
    end
  end

  def info_msg
    case @cur_msg[:media_size]
      when 1
        @bubbles << { what: :group_name, data: @cur_msg[:data] }
      when 4
        @bubbles << { what: :group_join, data: get_contact_name(@cur_msg[:remote_resource]) }
      when 5
        @bubbles << { what: :group_left, data: get_contact_name(@cur_msg[:remote_resource]) }
      when 6
        #puts "[TODO]: changed group pic"
      end
  end

  def contact_msg
    msg = {what: :msg, from_me: @cur_msg[:key_from_me]}

    if @conversation == :group and @cur_msg[:key_from_me] == 0
      msg[:sender] = get_contact_name(@cur_msg[:remote_resource])
    end

    msg[:data] =
      case @cur_msg[:media_wa_type]
      when "0"
        get_msg_text
      when "1"
        get_msg_media
      else
        "[TODO: add other medias]"
      end

    msg[:time] = Time.at(@cur_msg[:timestamp].to_s[0..-4].to_i).strftime("%l:%M%p")

    @bubbles << msg
  end

  def read_msg
    if @cur_msg[:status] == 6
      info_msg
    else
      contact_msg
    end
  end

  def get_msg_text
    data = @cur_msg[:data]

    if data.nil?
      data = ""
    else
      $smiles.each do |s|
        data = data.gsub(s[0], '<img src="/imgs/' + s[1] + '">')
      end
    end

    data
  end

  def get_msg_media
    if @cur_msg[:key_from_me] == 0
      media_size = @cur_msg[:media_size]
      timestamp  = @cur_msg[:timestamp]

      media_name = find_photo(timestamp, media_size)
      data = "/media/WhatsApp Images/" + media_name.to_s
    else
      media_name = @cur_msg[:media_name]
      data = "/media/WhatsApp Images/Sent/" + media_name
    end

    '<div class="attachment"><img src="' + data + '"></img></div>'
  end

  def find_photo(timestamp, media_size)
    date = Time.at(timestamp.to_s[0..-4].to_i).strftime("%Y%m%d")

    Dir.entries(@media_path + "/WhatsApp Images/").grep(Regexp.new("IMG-" + date)).each do |p|
      path = @media_path + "/WhatsApp Images/" + p
      return p if File.size(path) == media_size
    end
  end
end
end

