defmodule Client do



  # flush() => {:udp, #Port<>, {ip}, port, msg}
  def read() do
    msg = receive do
      {_, _, _, _, x} -> x
    end
    msg
  end


  def keepalive_daemon(c0_port, c1_port, c1_ip) do
    {:ok, socket} = :gen_udp.open(c0_port)
    :gen_udp.send(socket, c1_ip, c1_port, "KEEP_ALIVE")
    :timer.sleep(30 * 1000)
    keepalive_daemon(c0_port, c1_port, c1_ip)
  end

  def convert_ip_to_tuple(ip) do
    String.split(ip, ".") |> Enum.map(fn x -> Integer.parse(x) |> case do {y, _} -> y end end) |> List.to_tuple
  end

  def gen_port() do
    # non-reserved ports are in the range 49152 to 65535
    :rand.uniform(49152 + (65535 - 49152))
  end

  def terminal_interface() do
    IP = IO.gets "Enter the IP you would like to talk to: "
    c0_port = gen_port()
    IO.puts("Your port is #{c0_port}")
    c1_port = IO.gets("When ready, enter your friend's port: ")
    keepalive_daemon(c0_port, c1_port, IP)
    IO.puts("success!")
  end

end
