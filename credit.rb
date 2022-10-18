class Credit
  SPEED = 2
  attr_reader :y

  def initialize(_window, text, x, y)
    @x = x
    @y = @initial_y = y
    @text = text
    @font = Gosu::Font.new(50)
  end
end
