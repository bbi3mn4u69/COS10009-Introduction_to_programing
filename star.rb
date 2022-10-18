
class Star
    attr_accessor :x, :y, :radius, :color, :animation
    def initialize(animation)
        @radius = 15
        @animation = animation
        @color = Gosu::Color.new(0xff_000000)
        @color.red = rand(255 - 40) + 40
        @color.green = rand(255 - 40) + 40
        @color.blue = rand(255 - 40) + 40
        @x = rand * 800
        @y = 0
    end

end


