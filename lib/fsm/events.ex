defmodule Fsm.Events do

    def verify_timelapse(comment), do: :gen_fsm.send_event(__MODULE__, {:verify_timelapse, comment})

    def timelapse_exists(comment), do: :gen_fsm.send_event(__MODULE__, {:timelapse_exists, comment})
    def timelapse_not_exists(comment), do: :gen_fsm.send_event(__MODULE__, {:timelapse_not_exists, comment})

    def got_time(comment), do: :gen_fsm.send_event(__MODULE__, {:got_time, comment})
    def not_got_time(comment), do: :gen_fsm.send_event(__MODULE__, {:not_got_time, comment})

    def created_comment(comment), do: :gen_fsm.send_event(__MODULE__, {:created_comment, comment})
    def not_created_comment(comment), do: :gen_fsm.send_event(__MODULE__, {:not_created_comment, comment})

    def stop(), do: :gen_fsm.sync_send_all_state_event(__MODULE__, {:stop})
end  
  
  