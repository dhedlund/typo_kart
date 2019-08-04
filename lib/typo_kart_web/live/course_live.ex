defmodule TypoKartWeb.CourseLive do
  use Phoenix.LiveView

  require Logger

  @timer_fps 60
  @timer_interval div(1000, @timer_fps)

  def render(assigns) do
    ~L"""
    <div id="course" phx-keydown="keydown" phx-keyup="keyup" phx-target="window">
      <img src="https://www.mariowiki.com/images/7/77/SNES_Mario_Circuit_4.png" phx-click="boom"/>
    </div>
    <style>
    #course img {
      transform:
        scale(<%= @scale %>, <%= @scale %>)
        translate3d(<%= @translate_x %>px ,<%= @translate_y %>px, -50px)
        rotateY(<%= -@rotation %>deg)
        rotateX(89.9deg);
    }
    </style>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(@timer_interval, self(), :tick)

    {:ok, assign(socket,
     rotation: 0,
     scale: 7,
     translate_x: -400,
     translate_y: -50,
     speed: 0
    )}
  end

  def handle_info(:tick, socket) do
    {:noreply, rotate(socket, socket.assigns.speed)}
  end

  def handle_event("keydown", "ArrowUp", socket) do
    {:noreply, set_speed(socket, 1)}
  end

  def handle_event("keydown", "ArrowDown", socket) do
    {:noreply, set_speed(socket, -1)}
  end

  def handle_event("keydown", _key, socket) do
    {:noreply, socket}
  end

  def handle_event("keyup", "Arrow" <> _, socket) do
    {:noreply, set_speed(socket, 0)}
  end

  def handle_event("key" <> _, _key, socket) do
    {:noreply, socket}
  end

  defp set_speed(socket, speed) do
    assign(socket, speed: speed)
  end

  defp rotate(socket, degrees) do
    new_rotation = rem(socket.assigns.rotation + degrees, 360)
    assign(socket, rotation: new_rotation)
  end
end
