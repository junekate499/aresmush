module AresMUSH
  module Bbs
    class BbsListcmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      include PluginWithoutSwitches
      include TemplateFormatters
           
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle        
        boards = BbsBoard.all_sorted
        boards = boards.each_with_index.map { |b, i| board_list_entry(b, i) }

        output = "%xh#{t('bbs.boards_list_title')}%xn%r%l2%r"
        output << boards.join("%r")

        client.emit BorderedDisplay.text(output, t('bbs.boards_list'))
      end
      
      def board_list_entry(board, i)
        num = "#{i+1}".rjust(2)
        name = left(board.name,27)
        desc = left(board.description,34)
        read_status = Bbs.can_read_board?(client.char, board) ? "r" : "-"
        write_status = Bbs.can_write_board?(client.char, board) ? "w" : "-"
        permission = center("#{read_status}#{write_status}", 5)
        unread_status = board.has_unread?(client.char) ? t('bbs.unread_marker') : " "
        unread_status = center(unread_status, 5)
        "#{num} #{unread_status} #{name} #{desc} #{permission}"
      end
    end
  end
end
