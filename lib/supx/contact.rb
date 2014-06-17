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
module Contact
  def get_contacts
    contacts = []

    contact_like = Sequel.like(:key_remote_jid, '%@s%%') | Sequel.like(:key_remote_jid, '%@g%%')

    @message_db[:chat_list].where(contact_like).each do |m|
      next if m.nil?

      c = { id: m[:key_remote_jid] }

      contact = @contact_db[:wa_contacts].where(jid: m[:key_remote_jid]).first

      if contact and contact[:display_name] and not contact[:display_name].empty?
        c[:name] = contact[:display_name]
        contacts << c
      end
    end

    contacts
  end
end
end
