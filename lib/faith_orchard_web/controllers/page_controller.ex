defmodule FaithOrchardWeb.PageController do
  use FaithOrchardWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
