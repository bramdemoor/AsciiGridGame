require 'csv'
require 'rainbow'

$FPS = 3
$BOT_COLORS = [:red, :green, :yellow, :magenta, :cyan]
$BOT_NAMES = ["Wyvern", "Apollo", "Poseidon", "Dragon", "Vengeance", "Ripper", "Jack The Ripper", "Honeybunny"]

@@lvl1 = <<EOS
w,w,w,w,w,w
w, , , , ,w
w,p, , , ,w
w,w, , , ,w
w, , ,p, ,w
w,w,w,w,w,w
EOS

class Bot
  def initialize num, name, color
    @num = num
    @name = name
    @color = color
  end
  def spawn x, y
    @x = x
    @y = y
  end
  def to_abbr
    Rainbow(@name[0,2]).fg(@color)
  end
  def to_s
    Rainbow(@name).fg(@color)
  end
end

class DemoGame
  def initialize    
    @rows = 0
    @columns = 0
    
    @matrixTest = Hash.new('  ')
    
    @bots = []
    @spawnPoints = []
    
    @frameCounter = 0    
    
    createBots
    loadLevel
    spawnBots
  end
  def loadLevel
    cells = CSV.parse @@lvl1
    
    @rows = cells.length
    @columns = cells[0].length
    
    (0...@rows).each do |y|
      (0...@columns).each do |x|        
        c = cells[y][x]        
        if c == 'w'
          @matrixTest[[x,y]] = '##'
        elsif c == 'p'
          @spawnPoints << [x, y]
        end       
      end  
    end     
  end  
  def createBots    
    @avBotColors = $BOT_COLORS.shuffle
    @avBotNames = $BOT_NAMES.shuffle
    addBot
    addBot  
  end
  def spawnBots
    @bots.each do |b|
      s = @spawnPoints.pop
      x = s[0]
      y = s[1]
      @matrixTest[[x,y]] = b.to_abbr
      b.spawn x, y
    end
  end
  def addBot
    @bots << Bot.new(@bots.length + 1, @avBotNames.pop, @avBotColors.pop)
  end
  def printPlayers
    @bots.each do |b|
      puts "#{b.to_abbr} - #{b}"
    end
  end
  def drawLevel
   (0...@rows).each do |y|
      (0...@columns).each do |x|
        drawCell x, y
      end
      puts
    end  
  end 
  def update
    #...
  end
  def draw
    system 'clear'
    puts "[DEBUG Frame: #{@frameCounter}]"
    printPlayers
    drawLevel
  end  
  def drawCell x, y
    print @matrixTest[[x,y]]   
  end
  def start
    puts "Game started"
  
    begin
      sleep(1.0 / $FPS.to_f)
      update
      draw      
      @frameCounter+=1
    end while @frameCounter < 10

    puts "10 frames hit, game over"  
  end  
end

game = DemoGame.new
game.start
