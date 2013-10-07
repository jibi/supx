#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#

require 'sequel'
module Supx

class SupxManager
	include Database
	include Smile

	def initialize(path)
		@data_folder = path
		@msg_db_path = path + '/msgstore.db'

		db_connect
	end

	def read_messages(contact)
		open_html

		@db[:messages].filter(:key_remote_jid => contact).order(:_id).each do |msg|
			@msg = msg
			$stderr.print "\r" + msg[:_id].to_s

			html_date
			html_msg_content
		end

		close_html
	end

private

	def open_html
		@html = <<END
<html><head>
<style>
	body { background-color: #f1eae0; font: 'lucida grande, thaoma, verdana'; }
	#container {width: 800px; margin: 0px auto }
	.msg { width: 80%; background: #dde; padding: 16px; overflow: hidden; border-radius: 4px; }
	.msg > .time { margin-top: 16px; font-size: 9px; }
	.r { background-color: #f3ffe9; float: right; text-align: right; }
	.l { background-color: #fcfbf6; float: left; }
	.date { background-color: #d8eff7; width: 200px; margin: 16px auto; border-radius: 4px; border: 4px; height: 24;  text-align: center}
	#wrapper { overflow:auto; padding: 4px; }
</style>
</head><body><div id=container>
END
	end

	def close_html
		@html += "</div></body></html>"
	end

	def html_date
		timestamp = @msg[:timestamp]
		date      = Time.at(timestamp.to_s[0..-4].to_i).strftime('%Y-%m-%d')

		if @last_date.nil? or @last_date != date
			@last_date =  date
			@html      += "<div class='date'>" + date + "</div>"
		end
	end

	def html_msg_content
		@html += "<div id='wrapper'><div class='msg " + (@msg[:key_from_me] == 1 ? "r" : "l") + "'>"

		@html += case @msg[:media_wa_type]
		when "0"
			get_msg_text
		when "1"
			get_msg_media
		else
			"[TODO: add other medias]"
		end

		time  =  Time.at(@msg[:timestamp].to_s[0..-4].to_i).strftime("%l:%M%p")
		@html += "<div class=time>" + time + "</div>"

		@html += "</div></div>\n"
	end

	def get_msg_text
		data = @msg[:data]

		if data.nil?
			data = ""
		else
			$smiles.each do |s|
				data = data.gsub(s[0], "<img src='imgs/" + s[1] + "'>")
			end
		end

		data
	end

	def get_msg_media
		if @msg[:key_from_me] == 0
			media_size = @msg[:media_size]
			timestamp  = @msg[:timestamp]

			media_name = find_photo(timestamp, media_size)
			data = "<img src='#{@data_folder}/Media/WhatsApp Images/#{media_name}'>"
		else
			media_name = @msg[:media_name]
			data = "<img src='#{@data_folder}/Media/WhatsApp Images/Sent/#{media_name}'>"
		end

		data
	end

	def find_photo(timestamp, media_size)
		date = Time.at(timestamp.to_s[0..-4].to_i).strftime("%Y%m%d")

		Dir.entries("./#@data_folder}/Media/WhatsApp Images/").grep(Regexp.new("IMG-" + date)).each do |p|
			path = "./data/Media/WhatsApp Images/" + p
			return p if File.size(path) == media_size
		end
	end
end
end

