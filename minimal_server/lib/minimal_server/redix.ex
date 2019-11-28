defmodule MinimalServer.Redix do
  def child_spec(_args) do
    children = [{Redix, name: :redix}]

    %{
      id: RedixSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

  def command(command) do
    Redix.command(:redix, command)
  end

  def pipeline(commad) do
    Redix.pipeline(:redix, commad)
  end
end
