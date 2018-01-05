/*Module 5.14 Breakout -Version 2- by Umai Balendra*/
PFont words;
final int numBricks=80;
int numColors= 4;
int brickWidth, brickHeight;
int colIndex; //keeps track of color array's index
int ballX, ballY, directionX, directionY; //ball
final int ballDim=20; 
int ballSpeedX, ballSpeedY;
int paddleX, paddleY, paddleWidth, paddleHeight; //paddle
float fontX, fontY;
int lives;
int scoreCounter;

int [] brickX = new int [numBricks]; //brick x points array
int [] brickY = new int [numBricks]; //brick y points array
color [] colors = new color [numBricks]; //brick colors array

color red = color(224, 32, 32); //red 0
color orange= color(245, 120, 62); //orange 1 
color green = color(55, 201, 43); //green 2
color yellow = color(250, 241, 53); //yellow 3

void setup()
{
  size(800, 700);
  background(200);
  brickWidth=width/10; //dimensions
  brickHeight=height/20; //dimensions

  ballX=width/2;
  ballY=(height/9)*5;
  directionX=2;
  directionY=2;

  paddleX=width/2;
  paddleY=(height/10)*9;
  paddleWidth=100;
  paddleHeight=20; //variables for paddle

  fill(0);
  noStroke();
  rectMode(CORNER);
  rect(paddleX, paddleY, paddleWidth, paddleHeight, 4);

  words= loadFont("Serif-30.vlw");
  fontX=width/2-100;
  fontY=height/2;
  frameRate(200);

  lives=3;
  scoreCounter=0;

  for (int colNum=0; colNum<10; colNum++)
  {
    for (int rowNum=0; rowNum<8; rowNum++)
    {
      int spot = 10*(rowNum)+colNum; //use this to shift each brick's spot to the right
      brickX[spot] = (brickWidth)*colNum;
      brickY[spot] = (brickHeight)*rowNum;
    }
  }
}

void moveBall()
{
  fill(0);
  noStroke();
  ballX+=directionX;
  ballY+=directionY;
  ellipse(ballX, ballY, ballDim, ballDim);

  if ((ballY >= height-ballDim/2) || (ballY <= ballDim/2))
  {
    directionY*=-1; //change direction of ball if bounces on vertical edges
    lives--;
  } else if ((ballX >= width - ballDim/2) || (ballX <= ballDim/2))
  {
    directionX*=-1;//change direction of ball if bounces on side edges of window
  } else if ((ballY >= paddleY - paddleHeight/2) && (ballX >= mouseX - paddleWidth/2) 
    && (ballX <= mouseX + paddleWidth/2))
  {
    directionY*=-1;
  } 

  if (lives == 0)
  {
    textFont(words, 30);
    fill(0);
    text("GAME OVER", fontX-10, fontY); //display game end
    text("Your final score is: " + scoreCounter, fontX-30, fontY+60); //final score
  }
} //ball function

void paddle()
{ 
  if ((mouseX >= paddleWidth/2) && (mouseX <= width-paddleWidth/2))
  {
    fill(0);
    noStroke();
    rectMode(CENTER);
    paddleX=mouseX;
    rect(paddleX, paddleY, paddleWidth, paddleHeight, 4);
  } //draw paddle

  if (ballY < paddleY)
  {
    fill(0);
    textFont(words, 30);
    text("Lives: " + lives, width/10, 650); //display num of lives

    textFont(words, 30);
    text("Score: " + scoreCounter, 4*(width/5), 650); //display num of lives
  } 

  if ((ballY >= height - ballDim/2))//per death
  {
    //subtract the user's life
    textFont(words, 30);
    background(200);
    textFont(words, 30);
    text("Lives: " + lives, width/10, 650);
  }
}

void drawBricks()
{
  for (int colNum=0; colNum<10; colNum++)
  {
    for (int rowNum=0; rowNum<8; rowNum++)
    {
      int spot = 10*(rowNum)+colNum; //use this to shift each brick's spot to the right
      if (rowNum==0 || rowNum==1)
      {
        colors[spot] = red; //rows 0 and 1
      } else if (rowNum==2 || rowNum==3)
      {
        colors[spot] = orange;
      } else if (rowNum==4 || rowNum==5)
      {
        colors[spot] = green;
      } else 
      {
        colors[spot] = yellow;
      }

      for (int j=0; j<numBricks; j++)
      {
        fill(colors[j]);
        stroke(0);
        rectMode(CORNER);
        rect(brickX[j], brickY[j], brickWidth, brickHeight);
      }//draw bricks with colors across screen
    }
  }
}
void deleteBricks()
{
  for (int colNum=0; colNum<10; colNum++)
  {
    for (int rowNum=0; rowNum<8; rowNum++)
    {
      int spot = 10*(rowNum)+colNum; //use this to shift each brick's spot to the right

      if ((ballX >= brickX[spot]-brickWidth/2) && (ballX <= brickX[spot]+brickWidth/2)
        && (ballY >= brickY[spot]-brickHeight/2) && (ballY <= brickY[spot]+brickHeight/2))
      {
        directionY*=-1; //reverse bounce dir'n
        colors[spot]= color(240); //make invisible while shifting
        fill(colors[spot]);
        brickY[spot]-= height*3;
        brickX[spot]+= width*3; //shift brick off the screen

        if (rowNum==6 || rowNum==7)//yellow row
        {
          scoreCounter++;
        } else if (rowNum==4 || rowNum==5)//green
        {
          scoreCounter+=3;
        } else if (rowNum==2 || rowNum==3)//orange
        {
          scoreCounter+=5;
          directionY*=2;
          directionX*=2; //speed up after orange contact
        } else if (rowNum==6 || rowNum==7)//red
        {
          scoreCounter+=7;
          directionY*=2;
          directionX*=2; //speed up after red contact
        } //add points based on which brick ball collides with  

        if (scoreCounter == 4) //after four hits on brick
        {
          directionY*=2;
          directionX*=2;
        } else if (scoreCounter == 12) //after twelve hits
        {
          directionY*=2;
          directionX*=2;
        }
      }
    }
  }
} //function to destroy bricks

void draw()
{ 
  background(200);

  paddle(); //call paddle 
  moveBall(); //call ball 
  drawBricks(); //call bricks
  deleteBricks(); //call delete bricks and scores
}