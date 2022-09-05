defmodule Client do



  # flush() => {:udp, #Port<>, {ip}, port, msg}
  def read() do
    msg = receive do
      {_, _, _, _, x} -> x
    end
    msg
  end


  def keepalive_daemon(socket, c1_port, c1_ip) do
    :gen_udp.send(socket, c1_ip, c1_port, "KEEP_ALIVE")
    :timer.sleep(30 * 1000)
    keepalive_daemon(socket, c1_port, c1_ip)
  end

  def gen_port() do
    # non-reserved ports are in the range 49152 to 65535
    :rand.uniform(49152 + (65535 - 49152))
  end

  def terminal_interface() do

    IP = IO.gets "Enter the IP you would like to talk to: "
      |> String.trim("\n")
      |> String.split(".")
      |> Enum.map(fn x -> Integer.parse(x) |>
          case do
            {y, _} -> y
          end
        end)
      |> List.to_tuple

    c0_port = gen_port()
    IO.puts("Your port is #{c0_port}")
    c1_port = IO.gets("When ready, enter your friend's port: ") |> String.trim("\n")

    {:ok, socket} = :gen_udp.open(c0_port)
    keepalive_daemon(socket, c1_port, IP)
    IO.puts("success!")

  end

end
