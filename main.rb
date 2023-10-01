require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'boss'
require_relative 'star'
require_relative 'player2'
require_relative 'player2bullet'

module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
  end
  

#----------------------------Player-------------------------------------------------------------------
def turn_right_player(player)
    player.angle += 2.5
end
def turn_left_player(player)
    player.angle -= 2.5
end

def accelerate(player)
    player.velocity_x += Gosu.offset_x(player.angle, 1.1)
    player.velocity_y += Gosu.offset_y(player.angle, 1.1)
end

def move_player(player)
    player.x += player.velocity_x
    player.y += player.velocity_y
    player.velocity_x *= 0.9 # increase player speed 
    player.velocity_y *= 0.9 # increase player speed 
        if player.x > player.window.width - player.radius 
            player.x = player.window.width - player.radius
        end

        if player.x < player.radius 
            player.velocity_x = 0 
            player.x = player.radius
        end

        if player.y > player.window.height - player.radius 
            player.velocity_y = 0
            player.y = player.window.height - player.radius
        end
end
def draw_player(player)
    player.image.draw_rot(player.x, player.y, 1, player.angle)
end
#----------------------------------------------------------------------------------------------------
#---------------------player2---------------------------------------------

def turn_right_player(player2)
    player2.angle += 2.5
end
def turn_left_player(player2)
    player2.angle -= 2.5
end

def accelerate(player2)
    player2.velocity_x += Gosu.offset_x(player2.angle, 1.1)
    player2.velocity_y += Gosu.offset_y(player2.angle, 1.1)
end

def move_player(player2)
    player2.x += player2.velocity_x
    player2.y += player2.velocity_y
    player2.velocity_x *= 0.9 #player 2 speed 
    player2.velocity_y *= 0.9 #player 2 speed
        if player2.x > player2.window.width - player2.radius 
            player2.x = player2.window.width - player2.radius
        end

        if player2.x < player2.radius 
            player2.velocity_x = 0 
            player2.x = player2.radius
        end

        if player2.y > player2.window.height - player2.radius 
            player2.velocity_y = 0
            player2.y = player2.window.height - player2.radius
        end
end
def draw_player(player2)
    player2.image.draw_rot(player2.x, player2.y, 1, player2.angle)
end

#----------------------------------star------------------------------------ 
def move_star(star)
    # Move towards bottom of screen
    star.y += 3
    # Return false when out of screen (gets deleted then)
    star.y < 650
end

def draw_star(star)
    img = star.animation[Gosu.milliseconds / 100 % star.animation.size];
    img.draw_rot(star.x, star.y, 1, star.y, 0.5, 0.5, 1, 1, star.color, :add)
end

#----------------------------Boss---------------------------------------------
def move_boss(boss)
    boss.y += 1

end
def draw_boss(boss)
    boss.image.draw(boss.x-boss.radius, boss.y-boss.radius, 1)
end

#------------------------------------Bullet------------------------------------
def move_bullet(bullet)
    bullet.x += Gosu::offset_x(bullet.direction, 5)
    bullet.y += Gosu::offset_y(bullet.direction, 5)
end
def draw_bullet(bullet)
    bullet.image.draw(bullet.x - bullet.radius, bullet.y - bullet.radius, 1)
end
def check_onscreen(bullet)
    right = bullet.window.width + bullet.radius 
    left = -bullet.radius 
    top = -bullet.radius 
    bottom = bullet.window.height + bullet.radius 
    bullet.x > left and bullet.x < right and bullet.y > top and bullet.y < bottom 
end

#-----------------------------Player2 bullet------------------------------
def move_bullet(player2bullet)
    player2bullet.x += Gosu::offset_x(player2bullet.direction, 5)
    player2bullet.y += Gosu::offset_y(player2bullet.direction, 5)
end
def draw_bullet(player2bullet)
    player2bullet.image.draw(player2bullet.x - player2bullet.radius, player2bullet.y - player2bullet.radius, 1)
end
def check_onscreen(player2bullet)
    right = player2bullet.window.width + player2bullet.radius 
    left = -player2bullet.radius 
    top = -player2bullet.radius 
    bottom = player2bullet.window.height + player2bullet.radius 
    player2bullet.x > left and player2bullet.x < right and player2bullet.y > top and player2bullet.y < bottom 
end

#--------------------------------Enemy----------------------------------- 
def move_enemy(enemy)
    enemy.y += 2.5
end
def draw_enemy(enemy)
    enemy.image.draw(enemy.x-enemy.radius, enemy.y-enemy.radius, 1)
end

#------------------------------Explosion---------------------------------
def draw_explosion(explosion)
    if explosion.image_index < explosion.images.count 
        explosion.images[explosion.image_index].draw(explosion.x - explosion.radius, explosion.y - explosion.radius, 2)
        explosion.image_index += 1
    else
        explosion.finished = true
    end
end
#-------------------------------------------------------------------------

class Spacewar < Gosu::Window 
    WIDTH = 800
    HEIGHT = 640
    ENEMY_FREQUENCY = 0.01 #enemy appear fequency
    BOSS_FREQUENCY = 0.002 #boss appear fequency
    MAX_ENEMIES = 20
    MAX_BOSSES = 100
    MAX_HEART = 10
    MAX_SHIELD = 10
    def initialize 
        super(WIDTH,HEIGHT) 
        self.caption = 'SpaceWar'
        @start_image = Gosu::Image.new('image/startbackground.png')
        @scene = :start
        @start_option_1 = "SINGLE MODE (Press 1)"
        @start_option_2 = "MULTIPLAYER MODE (Press 2)"
        @start_option_3 = "INSTRUCTION (Press 3)"
        @start_option_4 = "QUIT (Press 4)"
        @start_option_font = Gosu::Font.new(self, 'font/quinque-five-font/Quinquefive-0Wonv.ttf',20)
        @start_music = Gosu::Song.new('sound/startmusic.mp3') 
        @start_music.play(false)
    end

    def draw 
        case @scene
        when :start
            draw_start
        when :instruction
            draw_instruction
        when :game_single
            draw_game_single_player
        when :game_multiplayer
            draw_game_multiple_player
        when :end 
            draw_end
        end
    end
#staring of the program
    def draw_start
        @start_image.draw(0,0,0)
        @start_option_font.draw(@start_option_1,230,360,1,1,1,Gosu::Color::WHITE)
        @start_option_font.draw(@start_option_2,230,400,1,1,1,Gosu::Color::WHITE)
        @start_option_font.draw(@start_option_3,230,440,1,1,1,Gosu::Color::WHITE)
        @start_option_font.draw(@start_option_4,230,480,1,1,1,Gosu::Color::WHITE)
    end
    def initialize_instruction
        @scene = :instruction
        @instruction_image = Gosu::Image.new('image/instruction.png')
    end
    def draw_instruction
        @instruction_image.draw(0,0,0)
    end
    def button_down_instruction(id)
        if id == Gosu::KbP
            initialize
        end
    end
#button down for game mode 
    def button_down_start(id)
        if id == Gosu::Kb1
            initialize_game_single_mode
        end
        if id == Gosu::Kb2
            initialize_game_multiplayer_mode
        end 
        if id == Gosu::Kb3
            initialize_instruction
        end
        if id == Gosu::Kb4
            close
        end
    end
#-------------------------------
# when button down
    def button_down(id)
        case @scene
        when :start 
            button_down_start(id)
        when :instruction
            button_down_instruction(id)
        when :game_single
            button_down_game_single(id)
        when :game_multiplayer
            button_down_game_multiplayer(id)
        when :end
            button_down_end(id)
        end
    end
    def update 
        case @scene
        when :game_single
            update_game_single
        when :game_multiplayer
            update_game_multiplayer
        end
    end
#---------------------------------------------------------------------------------------------------------------
#------------------------------------------multiplayer game mode------------------------------------------------
def draw_game_multiple_player
#ingame information
    player_health_percentage = @player_heart / MAX_HEART.to_f
    player2_health_percentage = @player2_heart / MAX_HEART.to_f
    player_shield_percentage = @player_shield / MAX_SHIELD.to_f
    player2_shield_percentage = @player2_shield / MAX_SHIELD.to_f
    
    Gosu.draw_rect(0, 0, 150, 100, Gosu::Color::GRAY, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(650, 0, 150, 100, Gosu::Color::GRAY, ZOrder::TOP, mode=:default)

    @in_game_font.draw("PLAYER 2",687,2,2,1,1,Gosu::Color::BLACK)
    @in_game_font.draw("SCORE:#{@player2_score}",687,80,2,1,1,Gosu::Color::BLACK)

    @in_game_font.draw("PLAYER 1",37,2,2,1,1,Gosu::Color::BLACK)
    @in_game_font.draw("SCORE:#{@player_score}",37,80,2,1,1,Gosu::Color::BLACK)

    Gosu.draw_rect(37, 23, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(37, 53, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(687, 23, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(687, 53, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)


    Gosu.draw_rect(39, 25, 100 * player_health_percentage, 20, Gosu::Color::RED, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(39, 55, 100 * player_shield_percentage, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(689, 25, 100 * player2_health_percentage, 20, Gosu::Color::RED, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(689, 55, 100 * player2_shield_percentage, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

    @ingame_heart.draw(-8, 22, 2, ZOrder::TOP)
    @ingame_heart.draw(642, 22, 2, ZOrder::TOP)

    @ingame_shield.draw(0, 55, 2, ZOrder::TOP)
    @ingame_shield.draw(650, 55, 2, ZOrder::TOP)
#create backgound
    @ingame_background.draw(0,0,0)
#create player 1
    draw_player(@player)
#create player 2
    draw_player(@player2)
#create star
    @stars.each do |star|
        draw_star(star)
    end
#create player 1 bullet
    @player_bullets.each do |bullet|
        draw_bullet(bullet)
    end
#create player 2 bullet
    @player2_bullets.each do |player2bullet|
        draw_bullet(player2bullet)
    end
#create explosion
    @explosions.each do |explosion|
        draw_explosion(explosion)
    end
end

def initialize_game_multiplayer_mode
    @player = Player.new(self) 
    @player2 = Player2.new(self)
    @player_bullets = [] 
    @player2_bullets = [] 
    @explosions = []
    @stars = []
    @player_shield = 10
    @player2_shield = 10
    @scene = :game_multiplayer
    @player_score = 0 
    @player2_score = 0
    @in_game_font = Gosu::Font.new(self, 'font/quinque-five-font/Quinquefive-0Wonv.ttf', 12)
    @star_anim = Gosu::Image::load_tiles("image/star.png", 25, 25)
    @game_music = Gosu::Song.new('sound/ingamemusic3.mp3') 
    @game_music.volume = 0.6
    @game_music.play(true)
    @explosion_sound = Gosu::Sample.new('sound/explosion.wav')
    @shooting_sound = Gosu::Sample.new('sound/gunsound.wav')
    @star_sound = Gosu::Sample.new('sound/ability.wav')
    @ingame_background = Gosu::Image.new('image/background.jpg')
    @ingame_heart = Gosu::Image.new('image/heart.png')
    @ingame_shield = Gosu::Image.new('image/shield.png')
    @player_heart = 10
    @player2_heart = 10 
end


def update_game_multiplayer
#move for player 1 
    turn_left_player(@player) if button_down?(Gosu::KbLeft)
    turn_right_player(@player) if button_down?(Gosu::KbRight)
    accelerate(@player) if button_down?(Gosu::KbUp)
    move_player(@player)
    
#move for player 2
    turn_left_player(@player2) if button_down?(Gosu::KbA)
    turn_right_player(@player2) if button_down?(Gosu::KbD)
    accelerate(@player2) if button_down?(Gosu::KbW)
    move_player(@player2)
#move bullet
    @player_bullets.each do |bullet| #move bullet 
        move_bullet(bullet)
    end
#Move bullet
    @player2_bullets.each do |player2bullet| #move bullet 
        move_bullet(player2bullet)
    end
#move star
    @stars.push(Star.new(@star_anim)) if rand(50) == 0 # star appear  
    @stars.each do |star| 
        move_star(star) 
    end
#player 1 get star
    @stars.dup.each do |star| 
        distance_player_star = Gosu::distance(star.x, star.y, @player.x, @player.y)
        if distance_player_star < @player.radius + star.radius
            @star_sound.play
            @stars.delete star 
            if @player_heart < MAX_HEART
                @player_heart += 1
            elsif @player_shield < MAX_SHIELD
                @player_shield += 1
            end
        end
    end
#player 2 get star
    @stars.dup.each do |star| 
        distance_player2_star = Gosu::distance(star.x, star.y, @player2.x, @player2.y)
        if distance_player2_star < @player.radius + star.radius
            @star_sound.play
            @stars.delete star 
            if @player2_heart < MAX_HEART
                @player2_heart += 1
            elsif @player2_shield < MAX_SHIELD
                @player2_shield += 1 
            end
        end
    end
#if player 2 is hitted by player 1 bullet
    @player_bullets.dup.each do |bullet|
        distance_player = Gosu.distance(@player2.x, @player2.y, bullet.x, bullet.y) 
        if distance_player < @player2.radius + bullet.radius 
            @player_bullets.delete bullet
            @explosions.push Explosion.new(self, @player2.x, @player2.y)
            @player_score += 1
            if @player2_shield > 0
                @player2_shield -= 1
            else
                @player2_heart -= 1
            end
            @explosion_sound.play
        end
    end
#if player 1 is hitted by player 2 bullet
    @player2_bullets.dup.each do |player2bullet|
        distance_player2 = Gosu.distance(@player.x, @player.y, player2bullet.x, player2bullet.y) 
        if distance_player2 < @player.radius + player2bullet.radius 
            @player2_bullets.delete player2bullet
            @explosions.push Explosion.new(self, @player.x, @player.y)
            @player2_score += 1
            if @player_shield > 0 
                @player_shield -=1
            else
                @player_heart -= 1
            end
            @explosion_sound.play
        end
    end
#delete explosion when finished
    @explosions.dup.each do |explosion| 
        @explosions.delete explosion if explosion.finished
    end
#delete bullet player 1
    @player_bullets.dup.each do |bullet|  
        @player_bullets.delete bullet unless check_onscreen(bullet)
    end
#delete bullet player 2
    @player2_bullets.dup.each do |player2bullet| 
        @player2_bullets.delete player2bullet unless check_onscreen(player2bullet)
    end

#ending for each player
    initialize_end(:player_win)  if @player2_heart == 0
    initialize_end(:player2_win) if @player_heart == 0
    initialize_end(:off_top1_mul) if @player.y < -@player.radius
    initialize_end(:off_top2_mul) if @player2.y < -@player2.radius


#shoot for player
    def button_down_game_multiplayer(id)
        if id == Gosu::KbSpace 
            @player_bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
            @shooting_sound.play(0.3)
        end
#shoot for player2
        if id == Gosu::KbG
            @player2_bullets.push Player2bullet.new(self, @player2.x, @player2.y, @player2.angle)
            @shooting_sound.play(0.3)
        end
    end
end


#-----------------------------------------------------------------------------------------------------------------------------


#-----------------------single game mode----------------------------------------------------------------------------------------
    def draw_game_single_player
#ingame information
      
        player_health_percentage = @health / MAX_HEART.to_f
        player_shield_percentage = @shield / MAX_SHIELD.to_f

        Gosu.draw_rect(0, 0, 370, 100, Gosu::Color::GRAY, ZOrder::TOP, mode=:default)

        @in_game_font.draw("PLAYER ",37,2,2,1,1,Gosu::Color::BLACK)
        @in_game_font.draw("SCORE: #{@score}",37,80,2,1,1,Gosu::Color::BLACK)
        @in_game_font.draw("Enemies Left: #{MAX_ENEMIES - @enemies_destroyed}",151,22,2,1,1,Gosu::Color::BLACK)
        @in_game_font.draw("Bosses Left: #{MAX_BOSSES - @bosses_destroyed}",151,55,2,1,1,Gosu::Color::BLACK)

        Gosu.draw_rect(37, 23, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
        Gosu.draw_rect(37, 53, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)

        Gosu.draw_rect(39, 25, 100 * player_health_percentage, 20, Gosu::Color::RED, ZOrder::TOP, mode=:default)
        Gosu.draw_rect(39, 55, 100 * player_shield_percentage, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

        @ingame_heart.draw(-8, 22, 2, ZOrder::TOP)
        @ingame_shield.draw(0, 55, 2, ZOrder::TOP)
#draw background
        @ingame_background.draw(0,0,0)
#draw player
        draw_player(@player)
#draw enemies
        @enemies.each do |enemy|
            draw_enemy(enemy)
        end
#draw bullet
        @bullets.each do |bullet|
            draw_bullet(bullet)
        end
#draw explosion
        @explosions.each do |explosion|
            draw_explosion(explosion)
        end
#draw boss
        @bosses.each do |boss|
            draw_boss(boss)
        end
#draw star
        @stars.each do |star|
            draw_star(star)
        end
#draw enemy bullet
        @enemy_bullets.each do |bullet|
            draw_bullet(bullet)
        end
#..................................
    end
    

    def initialize_game_single_mode
        @player = Player.new(self) 
        @enemies = [] 
        @bullets = [] 
        @explosions = []
        @enemy_bullets = []
        @bosses = []
        @stars = []
        @shield = MAX_SHIELD
        @scene = :game_single
        @score = 0 
        @in_game_font = Gosu::Font.new(self, 'font/quinque-five-font/Quinquefive-0Wonv.ttf', 12)
        @bosses_destroyed = 0 
        @bosses_appeared = 0 
        @enemies_appeared = 0 
        @enemies_destroyed = 0 
        @star_anim = Gosu::Image::load_tiles("image/star.png", 25, 25)
        @game_music = Gosu::Song.new('sound/ingamemusic2.ogg') 
        @game_music.volume = 0.6
        @game_music.play(true)
        @explosion_sound = Gosu::Sample.new('sound/explosion.wav')
        @shooting_sound = Gosu::Sample.new('sound/gunsound.wav')
        @star_sound = Gosu::Sample.new('sound/ability.wav')
        @ingame_background = Gosu::Image.new('image/background.jpg')
        @ingame_heart = Gosu::Image.new('image/heart.png')
        @ingame_shield = Gosu::Image.new('image/shield.png')
        @health = MAX_HEART
    end

    def update_game_single
#move player
        turn_left_player(@player) if button_down?(Gosu::KbLeft)
        turn_right_player(@player) if button_down?(Gosu::KbRight)
        accelerate(@player) if button_down?(Gosu::KbUp)
        move_player(@player)
#create enemy
        if rand < ENEMY_FREQUENCY  
            @enemies.push Enemy.new(self)
            @enemies_appeared += 1 
        end
#create boss
        if rand < BOSS_FREQUENCY  
            @bosses.push Boss.new(self)
            @bosses_appeared += 1
        end
#move enemy 
        @enemies.each do |enemy| 
            move_enemy(enemy)
        end
# move boss
        @bosses.each do |boss|  
            move_boss(boss)
        end
#move bullet
        @bullets.each do |bullet|  
            move_bullet(bullet)
        end
#move star
        @stars.push(Star.new(@star_anim)) if rand(50) == 0 # star appear  
        @stars.each do |star| 
            move_star(star) 
        end
#move enemy bullet 
        @enemy_bullets.each do |bullet|
            move_bullet(bullet)
        end
#create collision between enemy bullet and player
    @enemies.dup.each do |enemy|
        @enemy_bullets.push Bullet.new(self, enemy.x, enemy.y, 180) if rand < ENEMY_FREQUENCY / 50
        @enemy_bullets.each do |bullet|
            distance = Gosu.distance(@player.x, @player.y, bullet.x, bullet.y)
            if distance < @player.radius + bullet.radius
            @enemy_bullets.delete bullet
            @explosions.push Explosion.new(self, @player.x, @player.y)
                if @shield > 0
                    @shield -= 1
                else
                    @health -= 1
                end
            end
            initialize_end(:hit_by_enemy) if @health == 0
        end
    end

#create collision between enemy and bullet
        @enemies.dup.each do |enemy|   
            @bullets.dup.each do |bullet|
                distance_enemy_bullet = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y) 
                if distance_enemy_bullet < enemy.radius + bullet.radius 
                    @enemies.delete enemy 
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @enemies_destroyed += 1
                    @score += 1
                    @explosion_sound.play
                end
            end
        end
#create collision between player a star 
        @stars.dup.each do |star| 
            distance_player_star = Gosu::distance(star.x, star.y, @player.x, @player.y)
            if distance_player_star < @player.radius + star.radius
                @star_sound.play
                @stars.delete star
                if @health < MAX_HEART
                    @health += 1
                elsif @shield < MAX_SHIELD
                    @shield += 1
                end
            end
        end
#create collision between boss and bullet 
        @bosses.dup.each do |boss|  
            @bullets.dup.each do |bullet|
                distance_boss_bullet = Gosu.distance(boss.x, boss.y, bullet.x, bullet.y) 
                if distance_boss_bullet < boss.radius + bullet.radius
                    boss.hp -= 1 
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, boss.x, boss.y)
                    @explosion_sound.play
                    if boss.hp == 0 
                        @bosses.delete boss
                        @bosses_destroyed += 1 
                        @score += 5
                    end
                end
            end
        end
#delete ecplosion when finished
        @explosions.dup.each do |explosion| 
            @explosions.delete explosion if explosion.finished
        end
#delete enemy
        @enemies.dup.each do |enemy|  
            if enemy.y > HEIGHT + enemy.radius
                @enemies.delete enemy 
            end
        end
 #delete bullet 
        @bullets.dup.each do |bullet| 
            @bullets.delete bullet unless check_onscreen(bullet)
        end
        
        initialize_end(:count_reached)  if @enemies_destroyed >= MAX_ENEMIES or @bosses_destroyed >= MAX_BOSSES
        
#lose when health = 0 (create collision between enemy and player)

        @enemies.each do |enemy| 
            distance1 = Gosu::distance(enemy.x, enemy.y, @player.x, @player.y)
            if distance1 < @player.radius + enemy.radius 
                @enemies.delete enemy 
                @explosions.push Explosion.new(self, enemy.x, enemy.y)
                @explosion_sound.play
                if @shield > 0
                    @shield -= 1
                else
                    @health -= 1
                end
            end
            initialize_end(:hit_by_enemy) if @health == 0 
        end
#Lose when a boss reaches base or player gets hit by a boss
        @bosses.each do |boss| 
            distance2 = Gosu::distance(boss.x, boss.y, @player.x, @player.y)
            initialize_end(:hit_by_boss) if distance2 < @player.radius + boss.radius
        end
#lose when player reachs the top border
        initialize_end(:off_top) if @player.y < -@player.radius  
    end
#button to shoot
    def button_down_game_single(id)
        if id == Gosu::KbSpace 
            @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
            @shooting_sound.play(0.3)
        end
    end

#--------------------------------end of singple player mode-----------------------------------------
    
#---------------------------------------ending ----------------------------------------
    def initialize_end(status)
        case status
        when :count_reached
          @message = "You made it! You destroyed #{@enemies_destroyed} ships"
        when :hit_by_enemy
          @message = "Hi there! I'm sorry but you were hit by an enemy ship."
          @message_two = 'However before your ship was destroyed you took out '
          @message_two += "#{@enemies_destroyed} enemy ships, #{@bosses_destroyed} bosses ships"
        when :hit_by_boss
            @message = "Hi there! I'm sorry but you were hit by a boss ship."
            @message_two = 'However before your ship was destroyed you took out '
            @message_two += "#{@enemies_destroyed} enemy ships, #{@bosses_destroyed} bosses ships"
        when :off_top
          @message = 'Hi there! Why did you run from combat ?'
          @message_two = "You took out #{@enemies_destroyed} enemy ships but we still counted on you!"
        when :player2_win
            @message = 'Congratulations player 2 win the game'
            @message_two = "player 2 score: #{@player2_score}   player 1 score: #{@player_score}"
        when :player_win 
            @message = 'Congratulations player 1 win the game'
            @message_two = "player 2 score: #{@player2_score}   player 1 score: #{@player_score}"
        when :off_top1_mul
            @message = 'Player 2 is running out of combat'
            @message_two = 'PLayer 1 WIN'
        when :off_top2_mul
            @message = 'Player 1 is running out of combat'
            @message_two = 'PLayer 2 WIN'
        end
    
        @game_message = 'Press P to return to the main menu or Q to quit.'
        @message_font = Gosu::Font.new(self, 'font/quinque-five-font/Quinquefive-0Wonv.ttf', 13)
        @scene = :end
        @end_music = Gosu::Song.new('sound/startmusic.mp3')
        @end_music.play(false)

      def draw_end
        @message_font.draw(@message, 30, 40, 1, 1, 1, Gosu::Color::GRAY)
        @message_font.draw(@message_two, 30, 75, 1, 1, 1, Gosu::Color::GRAY)
        @message_font.draw(@game_message, 30, 125, 1, 1, 1, Gosu::Color::AQUA)
        draw_line(0, 180, Gosu::Color::GRAY, WIDTH, 180, Gosu::Color::GRAY)
      end
    
    end
#----------------------------------------------------
#return to the main menu or quit the game
    def button_down_end(id) 
        if id == Gosu::KbP
            initialize
        elsif id == Gosu::KbQ
            close
        end
    end
end
#------------------------------------------------
window = Spacewar.new
window.show