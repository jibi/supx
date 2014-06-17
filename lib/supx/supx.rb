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
  include Contact
  include Message
  include Smile

  def initialize(path)
    @data_folder     = path

    @msg_db_path     = path + '/db/msgstore.db'
    @contact_db_path = path + '/db/wa.db'
    @media_path      = path + '/media'

    db_connect
  end
end
end

