defmodule Client do

  def terminal_interface() do
    maybePort = IO.gets "Do you have a known port you want to connect to? (Y/n) "
    if maybePort == 'y' || maybePort == 'y' do
      c0_port = gen_port()
      IO.puts("Your port is #{port}")
      c1_port = IO.gets("When ready, enter your friend's port: ")
      keepalive_daemon(c1_port)
    else
      c1_port = IO.gets("What port would you like to talk to? ")
      keepalive_daemon(c1_port)
  end

  def keepalive_daemon(c0_port, c1_port, c1_ip) do
    {:ok, socket} = :gen_udp.open(c0_port)
    :gen_udp.send(socket, c1_ip, c1_port, "KEEP_ALIVE")
    keepalive_daemon(c1_port, c1_ip)
  end

  def convert_ip_to_tuple(ip) do
    String.split(ip, ".") |> List.to_tuple
  end




  def gen_port() do
    # non-reserved ports are in the range 49152 to 65535
    :rand.uniform(49152 + (65535 - 49152))
  end
end
