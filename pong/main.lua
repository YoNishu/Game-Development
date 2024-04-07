--[[ 
    The Final Update
    "Polish"
  ]]
  push = require 'push'

  Class = require 'class'
  
  require 'Paddle'
  
  require 'Ball'
  
  WINDOW_WIDTH = 1280
  WINDOW_HEIGHT = 720
  
  VIRTUAL_WIDTH = 1280
  VIRTUAL_HEIGHT = 720
  
  PaddleSpeed = 450
  PaddleSpeed2 = 98
  
  
  function love.load()
      
      --love.graphics.setDefaultFilter('nearest','nearest')
      math.randomseed(os.time())
      
      gameFont = love.graphics.newFont('Font.ttf',25)
      scoreFont = love.graphics.newFont('Font.ttf',100)
      victoryFont = love.graphics.newFont('Font.ttf',60)
      
      love.window.setTitle('Pong')
      
      push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
          fullscreen = false,
          resizable = true,
          vsync = true
      })
      
      Score = {}
      Score.P1 = 0
      Score.P2 = 0
      
      servingPlayer = 1
      
      Player1 = Paddle(10,40,12,90)
      Player2 = Paddle(WINDOW_WIDTH-20,WINDOW_HEIGHT / 2 - 45,12,90)
      
      ball = Ball(WINDOW_WIDTH / 2,WINDOW_HEIGHT / 2,7.5)
      
      ballColor = 0
      
      Sounds = {
          ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
          ['score'] = love.audio.newSource('sounds/score.wav','static'),
          ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
      }
      
      gameState = 'start'
  end
  
  function love.resize(w,h)
     push:resize(w,h)
  end
  
  function love.update(dt)
  
      if gameState == 'serve' then
          ball.yspeed = math.random(-100,100)
          if servingPlayer == 1 then
              ball.xspeed = math.random(400,500)
          else
              ball.xspeed = -math.random(400,500)
          end
      elseif gameState == 'play' then
          if ball:collision(Player1) then
             
             ballColor = 1 
             ball.xspeed = -ball.xspeed*1.10
             ball.x = Player1.x + 19.5
             
             if ball.yspeed < 0 then
              ball.yspeed = -math.random(10,150)
          else
              ball.yspeed = math.random(10,150)
          end
          Sounds.paddle_hit:play()
      end
      if ball:collision(Player2) then
          
          ballColor = 2 
          ball.xspeed = -ball.xspeed*1.10
          ball.x = Player2.x - 7.5
              
              if ball.yspeed < 0 then
                  ball.yspeed = -math.random(10,150)
              else
                  ball.yspeed = math.random(10,150)
              end
              Sounds.paddle_hit:play()
          end
          
          if ball.y < 7.5 then
              ball.y = 7.5
              ball.yspeed = -ball.yspeed
              Sounds.wall_hit:play()
          elseif ball.y > WINDOW_HEIGHT - 7.5 then
              ball.y = WINDOW_HEIGHT - 7.5
              ball.yspeed = -ball.yspeed
              Sounds.wall_hit:play()
          end
          if ball.x < -7.5 then
              Score.P2 = Score.P2 + 1
              Sounds.score:play()
              if Score.P2 == 10 then
                  winning_player = 2
                  gameState = 'done'
              else
                  servingPlayer = 1
                  ballColor = 0
                  ball:reset()
                  gameState = 'serve'
              end
          end
          if ball.x > WINDOW_WIDTH + 7.5 then
              Score.P1 = Score.P1 + 1
              Sounds.score:play()
              if Score.P1 == 10 then
                  winning_player = 1
                  gameState = 'done'
              else
                  servingPlayer = 2
                  ballColor = 0
                  ball:reset()
                  gameState = 'serve'
              end
          end
      end
      
      if love.keyboard.isDown('w') then
          Player1.speed = -PaddleSpeed
      elseif love.keyboard.isDown('s') then
          Player1.speed = PaddleSpeed
      else
          Player1.speed = 0
      end
      Player1:update(dt)
      
  --     if love.keyboard.isDown('up') then
  --         Player2.speed = -PaddleSpeed
  --     elseif love.keyboard.isDown('down') then
  --         Player2.speed = PaddleSpeed
  --     else
  --         Player2.speed = 0
  --     end
      if gameState == 'play' then
          if Player2.y + Player2.height / 2 > ball.y then
              Player2.speed = -PaddleSpeed2
          elseif Player2.y + Player2.height / 2 < ball.y then
              Player2.speed = PaddleSpeed2
          else
              Player2.speed = 0
          end
      else
          Player2.speed = 0
      end
      Player2:update(dt)
      
      if gameState == 'play' then
          ball:update(dt)
      end
  end
  
  function love.keypressed(key)
      if key == 'escape' then
          love.event.quit()
      elseif key == 'enter' or key == 'return' then
          if gameState == 'start' then
              gameState = 'serve'
          elseif gameState == 'serve' then
              gameState = 'play'
          elseif gameState == 'done' then
              gameState = 'serve'
              ballColor = 0
              ball:reset()
              Score.P1 = 0
              Score.P2 = 0
  
              if winning_player == 1 then
                  servingPlayer = 2
              else
                  servingPlayer = 1
              end
          end
      end
  end
  
  function love.draw()
  
      push:apply('start')
      
      love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  
      love.graphics.setColor(1,1,1,1)
      
      love.graphics.setFont(gameFont)
      if gameState == 'start' then
          love.graphics.printf('Start State',0,20,WINDOW_WIDTH,'center')
          love.graphics.printf('Press enter to Start',0,50,WINDOW_WIDTH,'center')
          love.graphics.printf('Press escape to Quit',0,80,WINDOW_WIDTH,'center')
      elseif gameState == 'play' then
          love.graphics.printf('Play State',0,15,WINDOW_WIDTH,'right')
          love.graphics.printf('Press escape to Quit',0,40,WINDOW_WIDTH,'right')
      elseif gameState == 'serve' then
          if servingPlayer == 1 then
              love.graphics.setColor(255/255,173/255,0)
              love.graphics.printf('Player will Serve',0,20,WINDOW_WIDTH,'center')
              love.graphics.setColor(1,1,1)
              love.graphics.printf('Press enter to serve',0,50,WINDOW_WIDTH,'center')
              love.graphics.printf('Press escape to Quit',0,80,WINDOW_WIDTH,'center')
          else
              love.graphics.setColor(70/255,102/255,255/255)
              love.graphics.printf('AI will Serve',0,20,WINDOW_WIDTH,'center')
              love.graphics.setColor(1,1,1)
              love.graphics.printf('Press enter to start',0,50,WINDOW_WIDTH,'center')
              love.graphics.printf('Press escape to Quit',0,80,WINDOW_WIDTH,'center')
          end
      else
          if winning_player == 1 then
              love.graphics.setFont(victoryFont)
              love.graphics.setColor(255/255,173/255,0)
              love.graphics.printf('Player is the WINNER!',0,20,WINDOW_WIDTH,'center')
              love.graphics.setFont(gameFont)
              love.graphics.setColor(1,1,1)
              love.graphics.printf('Press enter to Start a New game or escape to Quit',0,80,WINDOW_WIDTH,'center')
              love.graphics.printf('-by Nishith',0,690,WINDOW_WIDTH,'right')
          else
              love.graphics.setFont(victoryFont)
              love.graphics.setColor(70/255,102/255,255/255)
              love.graphics.printf('AI is the WINNER!',0,20,WINDOW_WIDTH,'center')
              love.graphics.setFont(gameFont)
              love.graphics.setColor(1,1,1)
              love.graphics.printf('Press enter to Start a New game or escape to Quit',0,80,WINDOW_WIDTH,'center')
              love.graphics.printf('-by Nishith',0,690,WINDOW_WIDTH,'right')
          end
      end
      
      if gameState == 'play' then
          love.graphics.setFont(scoreFont)
          love.graphics.setColor(255/255,173/255,0)
          love.graphics.print(Score.P1,WINDOW_WIDTH / 2 - 120,30)
          love.graphics.setColor(70/255,102/255,255/255)
          love.graphics.print(Score.P2,WINDOW_WIDTH / 2 + 50,30)
          love.graphics.setFont(gameFont)
          love.graphics.setColor(1,1,1)
          love.graphics.printf('10 Points to WIN!',0,WINDOW_HEIGHT/1.05,WINDOW_WIDTH,'center')
          
      end
      if gameState == 'serve' then
          love.graphics.setFont(scoreFont)
          love.graphics.setColor(255/255,173/255,0)
          love.graphics.print(Score.P1,WINDOW_WIDTH / 2 - 120,120)
          love.graphics.setColor(70/255,102/255,255/255)
          love.graphics.print(Score.P2,WINDOW_WIDTH / 2 + 50,120)
          love.graphics.setFont(gameFont)
          love.graphics.setColor(1,1,1)
          love.graphics.printf('10 Points to WIN!',0,WINDOW_HEIGHT/1.05,WINDOW_WIDTH,'center')
      end
      
      love.graphics.setColor(255/255,173/255,0)
      Player1:render()
      love.graphics.setColor(70/255,102/255,255/255)
      Player2:render()
  
      if ballColor == 1 then
          love.graphics.setColor(255/255,173/255,0)
          ball:render()
      elseif ballColor == 2 then
          love.graphics.setColor(70/255,102/255,255/255)
          ball:render()
      else
          love.graphics.setColor(1,1,1)
          ball:render()
      end
      
      displayFPS()
  
      push:apply('end')
  end
  
  function displayFPS()
      love.graphics.setFont(gameFont)
      love.graphics.setColor(0,1,0,1)
      love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()),50,15)
  end
