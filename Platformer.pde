// declare global variables on top
final static float MOVE_SPEED = 4;
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50; // pixels
final static float GRAVITY = 0.6;
final static float JUMP_SPEED = 14;
final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;
final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;
final static float WIDTH = SPRITE_SIZE * 16;
final static float HEIGHT = SPRITE_SIZE * 12;
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

// player configuration
final String PLAYER_FILE = "data/player.png";
final float PLAYER_SCALE = 0.8;
final float PLAYER_CENTER_X = 100;
final float PLAYER_CENTER_Y = 200;
Player player;

final String MAP_FILE = "data/map.csv";
final String SNOW_FILE = "data/snow.png";
final String CRATE_FILE = "data/crate.png";
final String RED_BRICK_FILE = "data/red_brick.png";
final String BROWN_BRICK_FILE = "data/brown_brick.png";
final String GOLD1_FILE = "data/gold1.png";
final String GOLD2_FILE = "data/gold2.png";
final String GOLD3_FILE = "data/gold3.png";
final String GOLD4_FILE = "data/gold4.png";
final String SPIDER_R1_FILE = "data/spider_walk_right1.png";
final String SPIDER_R2_FILE = "data/spider_walk_right2.png";
final String SPIDER_R3_FILE = "data/spider_walk_right3.png";
final String SPIDER_L1_FILE = "data/spider_walk_left1.png";
final String SPIDER_L2_FILE = "data/spider_walk_left2.png";
final String SPIDER_L3_FILE = "data/spider_walk_left3.png";
final String PLAYER_STAND_L_FILE = "data/player_stand_left.png";
final String PLAYER_STAND_R_FILE = "data/player_stand_right.png";
final String PLAYER_WALK_L1_FILE = "data/player_walk_left1.png";
final String PLAYER_WALK_L2_FILE = "data/player_walk_left2.png";
final String PLAYER_WALK_R1_FILE = "data/player_walk_right1.png";
final String PLAYER_WALK_R2_FILE = "data/player_walk_right2.png";
//final String PLAYER_JUMP_L_FILE = "data/player_jump_left.png";
//final String PLAYER_JUMP_R_FILE = "data/player_jump_right.png";
PImage snow;
PImage crate;
PImage redBrick;
PImage brownBrick;
PImage gold;
PImage spider;
PImage plyr;

ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
Enemy enemy;
int numCoins;

float viewX;
float viewY;
boolean isGameOver;

// similar to constructor (i.e. initializes variables)
// called automagically to initialize variables ONCE
void setup() {
  // https://processing.org/reference/size_.html
  size(800, 600);

  //https://processing.org/reference/imageMode_.html
  imageMode(CENTER);

  isGameOver = false;
  plyr = loadImage(PLAYER_FILE);
  PImage[] standLeft = { loadImage(PLAYER_STAND_L_FILE) };
  PImage[] standRight = { loadImage(PLAYER_STAND_R_FILE) };
  PImage[] walkLeft = {loadImage(PLAYER_WALK_L1_FILE), loadImage(PLAYER_WALK_L2_FILE)};
  PImage[] walkRight = {loadImage(PLAYER_WALK_R1_FILE), loadImage(PLAYER_WALK_R2_FILE)};

  player = new Player(plyr, PLAYER_SCALE, 3, RIGHT_FACING, true, true, standLeft, standRight, walkLeft, walkRight);
  player.setBottom(GROUND_LEVEL);
  player.setCenterX(PLAYER_CENTER_X);
  player.setCenterY(PLAYER_CENTER_Y);

  platforms = new ArrayList<Sprite>();
  coins = new ArrayList<Sprite>();
  numCoins = 0;

  // https://processing.org/reference/loadImage_.html
  snow = loadImage(SNOW_FILE);
  crate = loadImage(CRATE_FILE);
  redBrick = loadImage(RED_BRICK_FILE);
  brownBrick = loadImage(BROWN_BRICK_FILE);
  gold = loadImage(GOLD1_FILE);
  spider = loadImage(SPIDER_R1_FILE);
  createPlatforms(MAP_FILE);
  viewX = 0;
  viewY = 0;
}


// similar to the main method but it loops infinitely 60 times per second to create animation
// each iteration is a frame where objects can be drawn and updated
// cycling through a frame (e.g 60 frames per second) creates animation
void draw() {
  // increases something, 60x per second
  background(255); //(0 black, 255 white)

  // scroll() needs to be called first
  scroll();

  displayAll();

  if (!isGameOver) {
   updateAll();
   collectCoins();
   checkDeath();
  }

}

void displayAll() {
  player.display();

  for (Sprite s: platforms) {
    s.display();
  }

  for (Sprite c: coins) {
    c.display();
  }

  enemy.display();

  fill(255,0,0);
  textSize(32);
  text("Coin:" + numCoins, + viewX + 50, viewY + 50);
  text("Lives:" + player.getLives(), viewX + 50, viewY + 100);
}

void updateAll() {
  player.updateAnimation();
  resolvePlatformCollisions(player, platforms);
  enemy.update();
  enemy.updateAnimation();
  for (Sprite c: coins) {
    ((AnimatedSprite)c).updateAnimation();
  }

   collectCoins();
   checkDeath();
}

public void collectCoins() {
 ArrayList<Sprite> coinsList = checkCollisionList(player, coins);
 if (coinsList.size() > 0) {
  for (Sprite coin: coinsList) {
    numCoins++;
    coins.remove(coin);
  }
 }

 // collect all coins to win
 if (coins.size() == 0) {
  isGameOver = true;
 }
}

public void checkDeath() {
 boolean collideEnemy = checkCollision(player, enemy);
 boolean fallOffCliff = player.getBottom() > GROUND_LEVEL;

 if (collideEnemy || fallOffCliff) {
  player.decrementLives();
  if (player.getLives() <= 0) {
    isGameOver = true;
    // TODO: we should not see -1 when player loses all lives
    player.setLives(0);
  } else  {
    player.setCenterX(100);
   player.setBottom(GROUND_LEVEL);
  }
 }
}

public void scroll() {
  float rightBoundary = viewX + width - RIGHT_MARGIN;
  if (player.getRight() > rightBoundary) {
     viewX += player.getRight() - rightBoundary;
  }

  float leftBoundary = viewX + LEFT_MARGIN;
  if (player.getLeft() < leftBoundary) {
     viewX -= leftBoundary - player.getLeft();
  }

  float bottomBoundary = viewY + height - VERTICAL_MARGIN;
  if (player.getBottom() > bottomBoundary) {
     viewY += player.getBottom() - bottomBoundary;
  }

  float topBoundary = viewY + VERTICAL_MARGIN;
  if (player.getTop() < topBoundary) {
     viewY -= topBoundary - player.getTop();
  }

  translate(-viewX, -viewY);
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls) {
  s.incrementCenterY(5);
  ArrayList<Sprite> collisions = checkCollisionList(s, walls);
  s.decrementCenterY(5);
  return collisions.size() > 0;
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls) {
   // add gravity to changeY
   s.incrementChangeY(GRAVITY);

   // move vertically
   // handle collisions
   s.incrementCenterY();
   ArrayList<Sprite> collisions = checkCollisionList(s, walls);
   if (collisions.size() > 0) {
      Sprite collided = collisions.get(0);
      if (s.getChangeY() > 0) {
        s.setBottom(collided.getTop());
      } else if (s.getChangeY() < 0) {
         s.setTop(collided.getBottom());
      }
      s.setChangeY(0);
   }

   // move horizontally
   // handle collisions
   s.incrementCenterX();
   collisions = checkCollisionList(s, walls);
   if (collisions.size() > 0) {
    Sprite collided = collisions.get(0);
    if (s.getChangeX() > 0) {
      s.setRight(collided.getLeft());
    } else if (s.getChangeX() < 0) {
      s.setLeft(collided.getRight());
    }

   }
}

public boolean checkCollision(Sprite sprite1, Sprite sprite2){
  boolean noXOverlap = sprite1.getRight() <= sprite2.getLeft() || sprite1.getLeft() >= sprite2.getRight();
  boolean noYOverlap = sprite1.getBottom() <= sprite2.getTop() || sprite1.getTop() >= sprite2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

/**
   This method accepts a Sprite s and an ArrayList of Sprites and returns
   the collision list(ArrayList) which consists of the Sprites that collide with the given Sprite.
   MUST CALL THE METHOD checkCollision ABOVE!
*/
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> sprites){
  ArrayList<Sprite> collisions = new ArrayList<Sprite>();
  for (Sprite spriteTemp: sprites) {
     if (checkCollision(s, spriteTemp)) {
       collisions.add(spriteTemp);
     }
  }
  return collisions;
}


// called whenever a key is pressed
void keyPressed() {
  if (keyCode == RIGHT) {
    player.setChangeX(MOVE_SPEED);
  }
  else if (keyCode == LEFT) {
    player.setChangeX(-MOVE_SPEED);
  }
  else if (keyCode == UP) {
    player.setChangeY(-MOVE_SPEED);
  }
  else if (keyCode == DOWN) {
    player.setChangeY(MOVE_SPEED);
  } else if (key == 'a' && isOnPlatforms(player, platforms)) {
     player.setChangeY(-JUMP_SPEED);
  } else if (isGameOver && key == ' ') {
     setup();
  }
}

// called whenever a key is released
void keyReleased() {
  if (keyCode == RIGHT) {
    player.setChangeX(0);
  }
  else if (keyCode == LEFT) {
    player.setChangeX(0);
  }
  else if (keyCode == UP) {
    player.setChangeY(0);
  }
  else if (keyCode == DOWN) {
    player.setChangeY(0);
  }
}

void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
      if(values[col].equals("1")){
        Sprite s = new Sprite(redBrick, SPRITE_SCALE);
        s.setCenterX(SPRITE_SIZE/2 + col * SPRITE_SIZE);
        s.setCenterY(SPRITE_SIZE/2 + row * SPRITE_SIZE);
        platforms.add(s);
      }
      else if(values[col].equals("2")){
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.setCenterX(SPRITE_SIZE/2 + col * SPRITE_SIZE);
        s.setCenterY(SPRITE_SIZE/2 + row * SPRITE_SIZE);
        platforms.add(s);
      }
      else if(values[col].equals("3")){
        Sprite s = new Sprite(brownBrick, SPRITE_SCALE);
        s.setCenterX(SPRITE_SIZE/2 + col * SPRITE_SIZE);
        s.setCenterY(SPRITE_SIZE/2 + row * SPRITE_SIZE);
        platforms.add(s);
      }
      else if(values[col].equals("4")){
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.setCenterX(SPRITE_SIZE/2 + col * SPRITE_SIZE);
        s.setCenterY(SPRITE_SIZE/2 + row * SPRITE_SIZE);
        platforms.add(s);
      }
    else if(values[col].equals("5")){
        PImage[] standNeutral = {loadImage(GOLD1_FILE), loadImage(GOLD2_FILE), loadImage(GOLD3_FILE), loadImage(GOLD4_FILE)};
        Coin c = new Coin(gold, SPRITE_SCALE, standNeutral);
        c.setCenterX(SPRITE_SIZE/2 + col * SPRITE_SIZE);
        c.setCenterY(SPRITE_SIZE/2 + row * SPRITE_SIZE);
        coins.add(c);
      }
    else if(values[col].equals("6")){
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + 4 * SPRITE_SIZE;
        PImage[] moveLeft = {loadImage(SPIDER_L1_FILE), loadImage(SPIDER_L1_FILE), loadImage(SPIDER_L3_FILE)};
        PImage[] moveRight = {loadImage(SPIDER_R1_FILE), loadImage(SPIDER_R2_FILE), loadImage(SPIDER_R3_FILE)};
        enemy = new Enemy(spider, 50/72.0, bLeft, bRight, moveLeft, moveRight, 2);
        enemy.setCenterX(SPRITE_SIZE/2 + col * SPRITE_SIZE);
        enemy.setCenterY(SPRITE_SIZE/2 + row * SPRITE_SIZE);
      }
    }
  }
}