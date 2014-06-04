//
// Longing
//  by Katy Law

// play this music: https://soundcloud.com/katy-law/longingloop 
// please play the music in the above link at the same time while running the sketch for the 
// complete experience since sketchpad.cc does not support music upload at this time.
//  
//
// The general premise of this application are two figures (Parent/child relationship or lovers) 
// walking along in the snow, the main character is touched by the other person's joy and youthfulness.
// However at some stage, they get seperated. One lover/child is playfully walking around, while the 
// main character/player's task is to find and reunite with the other amongst the many people moving 
// around in the crowd but eventually the parent loses the youth, or the lover loses the other person.
// 
// This is built up of scenes.

// 
// Scene 1
// This is an initial setting up the premise of the app. This is a sideview based scene
// (Fade out)
//
// Scene 2 (Fade in)
// This is the main game canvas. It is top down looking at a number of umbrellas.
//
// Scene 3
// Concludes the short narrative.
// music source: http://thecreatorsproject.vice.com/mira-calix/my-secret-heart


import processing.video.*;

// Other objects
GameCanvas game;
InitialScene initialScene;
EndSnow endSnow;

Movie myMovie;

// Object counter to generate unique id's (where required)
static int objectCounter = 0;

void setup() {
  
  // Set the music
  myMovie = new Movie (this, "longing.mp3");
  myMovie.loop();
  
  // Set the canvas side
  size(800, 800);
  smooth();
  frameRate(30); // most computers run at 60 fps but that is too fast for the game
  
  // Set up the game canvas and cut scene objects
  game = new GameCanvas();
  initialScene = new InitialScene();
  endSnow = new EndSnow();
}

void draw() {

  // Show the cut scene or the game
  if (initialScene.hasFinished()) {
    // Detect if the game is won - if so we give the player congratulations
    //  and offer to start again
    if (game.hasFinished()) {
      if(endSnow.hasFinished()) {
        // Set up new game canvas and cut scene objects
        game = new GameCanvas();
        initialScene = new InitialScene();
        endSnow = new EndSnow();
      } else {
        endSnow.update();
        endSnow.draw(); 
      }
    } else {
      // Update the game positions and re-draw
      game.update();
      game.draw();    
    }
  } else {
    // Update the cut scene position and re-draw
    initialScene.update();
    initialScene.draw();
  }
  
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        initialScene.gameStarted = true;
        game.player.deltaY = -3;
        break;
      case DOWN:
        initialScene.gameStarted = true;
        game.player.deltaY = 3;
        break;
      case LEFT:
        initialScene.gameStarted = true;
        game.player.deltaX = -3;
        initialScene.player.deltaX = -3;
        endSnow.player.deltaX = -3;
        break;
      case RIGHT:
        initialScene.gameStarted = true;
        game.player.deltaX = 3;
        initialScene.player.deltaX = 3;
        endSnow.player.deltaX = 3;
        break;
    } 
  }
}

void keyReleased() {
if (key == CODED) {
    switch (keyCode) {
      case UP:
      case DOWN:
        game.player.deltaY = 0;
        break;
      case LEFT:
      case RIGHT:
        game.player.deltaX = 0;
        initialScene.player.deltaX = 0;
        endSnow.player.deltaX = 0;
        break;
    } 
  }}











//
// Initial Scene
//  by Katy Law
//
// Controls the Initial scene logic and whether it has been finished or not
//

class InitialScene {

  final int SNOWFALL_START_TIME = 9000; 
  final int CHILDRUN_LEFT_START_TIME = 20000;
  final int CHILDRUN_RIGHT_START_TIME = 29000;

  // Game states
  final int GAME1_INITIAL = 0;
  final int GAME1_LIGHTENING = 1;
  final int GAME1_DONE = 2;

  // GAME1 state
  //  0 = initial
  //  1 = lightning
  //  2 = done
  int state = GAME1_INITIAL; //GAME1_INITIAL; or GAME1_DONE;
//  int state = GAME1_DONE; 

  int lighteningTime = 0;

  boolean gameStarted = false;
  int gameStartTime = 999999999;

  SnowFlake[] snowFlake;
  Person[] person;

  Person player;
  Person child;

  PFont f;
  String message = "arrow keys to begin";
  

  InitialScene() {
    
    background(#583C1F, 100);

    f = createFont("Arial", 20, true);

    // Declare our array  
    snowFlake = new SnowFlake[500]; //make [this many] of them
    // Initialize each snow flake
    for (int i = 0; i < snowFlake.length; i++) {
      snowFlake[i] = new SnowFlake(random(width), random(height)-height, 2); // SnowFlake(float x, float y, float diameter)
      snowFlake[i].deltaY = 1;
    }

    person = new Person[6]; //make [this many] of them
    // Initialize each person
    for (int i = 0; i < person.length; i++) {
      person[i] = new Person(random(width), height-83, random(50.0, 60.0)); // Person(float x, float y, float diameter)
      if (i % 2 == 0) {
        person[i].deltaX = -1;
      }
      else
      {
        person[i].deltaX = 1;
      }
      person[i].personColor = color(random(100, 150), random(100, 150), random(100, 130), 150);
    }

    player = new Person(90, height-82, 55);
    player.personColor = #673547;
    player.deltaX = 0;

    child = new Person(300, height-70, 35);
    child.personColor = #ED2D5D;
    child.deltaX = random(1, 5);
  }

  // 
  boolean hasFinished() {
    return state == GAME1_DONE;  // GAME1_DONE - InitialScene has finished, false - start the sketch with InitialScene
  }


  // movement of snowflake and other objects...
  void update() {

    // if the game has started and the start time hasn't been set, then set it to current program time
    if (gameStarted && gameStartTime >= 999999999) {
      gameStartTime = millis();
      //println("Game started at " + gameStartTime);
    }

    if (millis() - gameStartTime > SNOWFALL_START_TIME) {  
      for (int i = 0; i < snowFlake.length; i++) {
        snowFlake[i].moveSnow();
      }
    }

    // move the city people
    for (int i = 0; i < person.length; i++) {
      person[i].movePerson();
      if (person[i].x < -30) {
        person[i].deltaX = 1;
      }
      if (person[i].x > width + 30) {
        person[i].deltaX = -1;
      }
    }

    // child runs randomly for some time
    if (int(random(0, 30)) == 10) {
      child.deltaX = random(-4, 5);
    }

    if (child.x < 0) {
      child.deltaX = 1;
    }

    if (child.x > width) {
      child.deltaX = -1;
    }

    // child runs off screen after some time
    if (millis() - gameStartTime > CHILDRUN_LEFT_START_TIME ) {
      child.deltaX = -4;
    }

    // child runs back on screen after some time
    if (millis() - gameStartTime > CHILDRUN_RIGHT_START_TIME) {
      child.deltaX = 4;
    }

    player.movePerson();
    child.movePerson();


   // if the player gets close to the child, the player will turn to shade of child 
    if (player.x < child.x + 33 && player.x > child.x - 33) {
 //     player.personColor = color(random(200, 237), random(20, 45), random(70, 93)); //random shade of child
        player.personColor = color(237, 45, 93, 200);
        player.alpha = random(200, 202);
    } 
    else {
      player.personColor = #B98B9B;
      player.alpha = 255;

    }


     
    // if the child and the player goes beyond the right edge in game1 initial, go to state lightening 
    if (state == GAME1_INITIAL && child.x > width + 20 && player.x > width + 20) {
      state = GAME1_LIGHTENING;
      lighteningTime = millis(); // collecting how much lightening time has passed
    }
  }

  // display my objects
  void draw() { 
    background(#583C1F, 100);


    // draw the sun
    noStroke();
    fill(#F0BF5C, random(20, 22));
    ellipse(150, 150, random(225, 230), random(215, 220));

    fill(#F0BF5C, random(30, 31));
    ellipse(150, 150, random(220, 215), random(205, 215));

    fill(#F0BF5C, random(40, 40));
    ellipse(150, 150, random(215, 210), random(195, 205));

    // draw the ground
    fill(#312011);
    noStroke();
    rect(0, height-56, 800, height-56);

    for (int i = 0; i < person.length; i++) {
      person[i].draw();
    }

    player.draw();
    child.draw();
    
    // give initial text instruction 
    if (!gameStarted) {
      fill(#B98B9B);
      textFont(f);
      text (message, 80, height - 30);

    }
   

    // wait for some SNOWFALL_START_TIME to draw the snowfall
    if (millis() - gameStartTime > SNOWFALL_START_TIME) {      
      for (int i = 0; i < snowFlake.length; i++) {
        snowFlake[i].draw();
      }
    }

    // in game state lightening, make the lightening flashes in the brown tone
    if (state == GAME1_LIGHTENING) {
      background(#311A03, random(200, 255));
    }

    // if time since lightening started is more than _ then GAME1 is done, move to game canvas
    if (state == GAME1_LIGHTENING && millis() - lighteningTime > 2000) {
      state = GAME1_DONE;
    }
  }
}










//
// Game Canvas
//  by Katy Law
//
// This class provides the game canvas and logic
//

class GameCanvas {
  
  // Some constants
  final int NUMBER_OF_ACTORS = 30;
  final int MIN_ACTOR_DIAMETER = 75;
  final int MAX_ACTOR_DIAMETER = 100;
  final int CHILD_DIAMETER = 30;  
  final int PLAYER_DIAMETER = 60;  
  final int EDGE_PADDING = 10;
  
  // Colors
  final color ACTOR_COLOR = #7E460D;
  final color PLAYER_COLOR = #B98B9B;
  final color CHILD_COLOR = #ED2D5D;
  
  // Directional constants
  final int MIN_ACTOR_SPEED = -3;
  final int MAX_ACTOR_SPEED = 3;
  final int MIN_CHILD_SPEED = -5;
  final int MAX_CHILD_SPEED = 5;
  
  // Game states
  final int GAME2_INITIAL = 0;
  final int GAME2_FADE = 1;
  final int GAME2_DONE = 2;
  
  // after child and player touch
  int fadeStartTime = 0;
  
  // The game is made up of actor umbrellas and father and child
  Umbrella[] actors = new Umbrella[NUMBER_OF_ACTORS];
  Umbrella player;
  Umbrella child;
  

  // Game state
  //  0 = playing
  //  1 = won
  //  2 = done 
  int gameState = GAME2_INITIAL; //GAME2_INITIAL; or GAME2_DONE;
  //int gameState = GAME2_DONE; 
  
  GameCanvas() {

    // Create the father and child first
    player = new Umbrella(EDGE_PADDING, EDGE_PADDING, PLAYER_DIAMETER/2, PLAYER_COLOR, 255);
    child = new Umbrella(width - CHILD_DIAMETER - EDGE_PADDING, height - CHILD_DIAMETER - EDGE_PADDING, CHILD_DIAMETER/2, CHILD_COLOR, 255);
    child.deltaX = random(MIN_CHILD_SPEED, MAX_CHILD_SPEED);
    child.deltaY = random(MIN_CHILD_SPEED, MAX_CHILD_SPEED);
    //child.doOpenUmbrella = true;
    //child.openSpeed = 0.5;
    
    // Set up each of the actors
    for (int indexOfActorBeingCreated = 0; indexOfActorBeingCreated < actors.length; indexOfActorBeingCreated++) {
      // Randomize the x, y and diamter
      float d = random(MIN_ACTOR_DIAMETER, MAX_ACTOR_DIAMETER);
      float r = d/2; 
      float deltaX = random(MIN_ACTOR_SPEED, MAX_ACTOR_SPEED);
      float deltaY = random(MIN_ACTOR_SPEED, MAX_ACTOR_SPEED);
      
      // Make sure we don't overlap any actors - we just run our
      //  hit detection for this
      boolean positionOk = false;
      float x = 0;
      float y = 0;
      // for the overlapping umbrellas
      while (!positionOk) {
        // Check for a hit on any current actors
        x = random(EDGE_PADDING + PLAYER_DIAMETER, width - CHILD_DIAMETER - EDGE_PADDING - MAX_ACTOR_DIAMETER);
        y = random(EDGE_PADDING + PLAYER_DIAMETER, height - CHILD_DIAMETER - EDGE_PADDING - MAX_ACTOR_DIAMETER);
        
        // Check to see if it is ok
        positionOk = true;
        for (int indexOfPreviouslyCreatedActor = 0; indexOfPreviouslyCreatedActor < indexOfActorBeingCreated; indexOfPreviouslyCreatedActor++) {
          if (actors[indexOfPreviouslyCreatedActor].detectHitWithCircle(x, y, r)) {
            positionOk = false;
            break;
          }
        }
      }
      
      // If so, set up the actor
      actors[indexOfActorBeingCreated] = new Umbrella(x, y, r, ACTOR_COLOR, random(255));
      actors[indexOfActorBeingCreated].deltaX = deltaX;
      actors[indexOfActorBeingCreated].deltaY = deltaY;
      // Random number 0 >= r < 2. By applying int we chop off the decimal point
      if (int(random(0,2)) == 0)
        actors[indexOfActorBeingCreated].doOpenUmbrella = true;
    }
    
  }

  
  boolean hasFinished() {
   return gameState == GAME2_DONE;
  }
  
  // movements of objects 
  void update() {

    // If we're not playing the game, then don't bother updating any of the
    //  actors or players
    if (gameState != GAME2_INITIAL) {
      return;
    }
    // Detect if we need to change direction of any actors
    for (int i = 0; i < actors.length; i++) {
      // Go through and either move or change direction
      //  NB: If they change direction we do not move immediately
      //      we wait for the next iteration
      moveAutomatedPlayer(actors[i], MAX_ACTOR_DIAMETER, MIN_ACTOR_SPEED, MAX_ACTOR_SPEED);
    }
    
    // Child movement
    moveAutomatedPlayer(child, CHILD_DIAMETER, MIN_CHILD_SPEED, MAX_CHILD_SPEED);
    
    // Check to see if the player wins first
    if (player.detectIfWillHitWithObject(child)) {
      gameState = GAME2_FADE;
      fadeStartTime = millis();

    } else {
      // Move the adult if it won't hit something
      if (!detectIfUmbrellaMovementWillHitSomething(player, 0)) {
        // Move the player
        player.move();
      }
    }
  }
  
  boolean detectIfUmbrellaMovementWillHitSomething(Umbrella u, float edgePadding) {
    // Check if it hits an edge  
    if (u.detectEdge(edgePadding))
      return true;
    
    // Check if it hits an actor 
    for (int j = 0; j < actors.length; j++) {
       if (u.id == actors[j].id) // Don't detect self
         continue;
       if (u.detectIfWillHitWithObject(actors[j])) {
         return true;
       }
    }
    // If not hitting anything - detect adult and child
    if ((u.id != player.id && u.detectIfWillHitWithObject(player) ||
        (u.id != child.id && u.detectIfWillHitWithObject(child)))) {
      return true;
    }    
    
    // No hit!
    return false;
  }
  
  void moveAutomatedPlayer(Umbrella u, float edgePadding, float minSpeed, float maxSpeed) {
    // If it hits an edge, change direction  
    boolean changeDirection = detectIfUmbrellaMovementWillHitSomething(u, edgePadding);
    
    // If we change direction
    if (changeDirection) {
      u.deltaX = random(minSpeed, maxSpeed);
      u.deltaY = random(minSpeed, maxSpeed);
    } else {
      if (!u.isOpening())
        u.move(); 
    }    
  }

  void draw() {
    if (gameState != GAME2_INITIAL) {
      if (gameState == GAME2_FADE) {
        int passedTime = millis() - fadeStartTime;
        
        // Figure out the alpha to mimick fading
        // relating time to alpha transparency
        float a = (passedTime/10000.0)*100;
        // Alpha can't be higher than 255
        if (a > 100) {
          a = 100;
        }
        // Do some fading
        //fill(#ffffff, a);
        //rect(0, 0, width, height);
        
        // If finished fading, move the game state forward
        if (passedTime > 2500) {
          gameState = GAME2_DONE;
        }
      }     
      //?player.umbrellaColor = #2822F0;
      return;  // freeze
      
      
      //player.alpha = 255;
    }
    

    
    // Redraw the background
    background(#312011);
    
    // Draw each object
    player.draw();
    child.draw();
    for (int i = 0; i < actors.length; i++) {
     actors[i].draw(); 
    }
    
    //for (int i = 0; i < snowFlake.length; i++) {
    //snowFlake[i].draw();
    //}
    fill(#7E460D, random(180, 255));
    stroke(#7E460D, random(255));
    for (int i = 0; i < 10; i++){
      ellipse(random(width), random(height), 5, 5);
    }
  }
}









//
// End Snow Scene
//  by Katy Law
//
// Controls the End Snow scene logic and whether it has been finished or not
//

class EndSnow {

  final int SNOWFALL_START_TIME = 0; 
  final int CHILDRUN_LEFT_START_TIME = 25000;
  final int CHILDRUN_RIGHT_START_TIME = 10000;

  // Game states
  final int GAME3_INITIAL = 0;
  final int GAME3_FADE = 1;
  final int GAME3_DONE = 2;

  // GAME1 state
  //  0 = initial
  //  1 = lightning
  //  2 = done
  int state = GAME3_INITIAL;

  int fadeStartTime = 0;
  int endSceneStartTime = 0;


  SnowFlake[] snowFlake;
  Person[] person;

  Person player;
  Person child;
  Person sun;
  Person night;

  EndSnow() {
    background(#583C1F, 100);

    // Declare our array  
    snowFlake = new SnowFlake[500]; //make [this many] of them
    // Initialize each snow flake
    for (int i = 0; i < snowFlake.length; i++) {
      snowFlake[i] = new SnowFlake(random(width), random(height)+height/13, 2); // SnowFlake(float x, float y, float diameter)
      snowFlake[i].deltaY = 1;
      snowFlake[i].snowFallAgain = false;  // to end snow fall
    }

    person = new Person[6]; //make [this many] of them
    // Initialize each person
    for (int i = 0; i < person.length; i++) {
      person[i] = new Person(random(width), height-83, random(50.0, 60.0)); // Person(float x, float y, float diameter)
      if (i % 2 == 0) {
        person[i].deltaX = -1;
      }
      else
      {
        person[i].deltaX = 1;
      }
      person[i].personColor = color(random(100, 150), random(100, 150), random(100, 130), 150);
    }

    player = new Person(width/3, height-82, 50);
    player.personColor = #B98B9B; //#2822F0;
    player.deltaX = 0;

    child = new Person(width/3, height-70, 30);
    child.personColor = #ED2D5D;
    child.deltaX = 1;

    sun = new Person(150, width/2, random(200, 220));
    sun.personColor = color(random(190, 206), random(130, 141), random(-10, 8), random(50, 70));
    sun.deltaY = .8;
  }

  // 
  boolean hasFinished() {
    return state == GAME3_DONE;  // GAME3_DONE - SnowScene has finished, false - start the sketch with InitialScene
  }


  // movement of snowflake and other objects...
  void update() {

    if (endSceneStartTime == 0) {
      endSceneStartTime = millis();
    }

    if (millis() - endSceneStartTime > SNOWFALL_START_TIME) {  
      for (int i = 0; i < snowFlake.length; i++) {
        snowFlake[i].moveSnow();
      }
    }

    for (int i = 0; i < person.length; i++) {
      person[i].movePerson();
      if (person[i].x < -30) {
        person[i].deltaX = 1;
      }
      if (person[i].x > width + 30) {
        person[i].deltaX = -1;
      }
    }

    // child runs randomly for some time
    if (int(random(0, 30)) == 10) {
      child.deltaX = random(-3, 5);
    }

    if (child.x < 0) {
      child.deltaX = 1;
    }

    if (child.x > width) {
      child.deltaX = 1;
    }

    // child runs off screen after some time
    if (millis() - endSceneStartTime > CHILDRUN_RIGHT_START_TIME) {
      child.deltaX = 4;
    }



    player.movePerson();
    child.movePerson();
    sun.movePerson();


    // if the player gets close to the child, the player will turn to shade of child 
    if (player.x < child.x + 33 && player.x > child.x - 33) {
      //player.personColor = color(random(200, 237), random(20, 45), random(70, 93)); //random shade of child
      player.personColor = color(237, 45, 93, 200);
      player.alpha = random(200, 202);
    } 
    else {
      player.personColor = #B98B9B;
      
      player.alpha = 255;
    }


    // start fade after some long amount of time on the end snow scene
    if (state == GAME3_INITIAL && millis() - endSceneStartTime > 60000) {
      state = GAME3_FADE;
      fadeStartTime = millis(); // collecting how much time has passed
    }
  }

  // display my objects
  void draw() { 
    if (state != GAME3_INITIAL) {
      if (state == GAME3_FADE) {
        int passedTime = millis() - fadeStartTime;

        // Figure out the alpha to mimick fading
        // relating time to alpha transparency
        float a = (passedTime/10000.0)*100;

        // Alpha can't be higher than 255
        if (a > 100) {
          a = 100;
        }

        // Do some fading to whilte
        fill(#ffffff, a);
        rect(0, 0, width, height);

        // If finished fading, move the game state forward
        if (passedTime > 5000) {
          state = GAME3_DONE;
        }
      }     
      return;  // freeze
    }

    background(#583C1F, 30);

    sun.draw();

    // draw the ground
    fill(#312011);
    noStroke();
    rect(0, height-56, 800, height-56);


    // draw the persons = people
    for (int i = 0; i < person.length; i++) {
      person[i].draw();
    }

    player.draw();
    child.draw();


    // draw snowfall
    int snowTime = millis() - endSceneStartTime;
    if (snowTime > SNOWFALL_START_TIME) {
      // By default draw all snow
      int snowToDraw = snowFlake.length;
    
      // and the scene gets darker according to snowTime     
      if (snowTime > 18000) {

            fill(#311A03, 50);          
        rect(0, 0, width, height-52);
      }
      
      if (snowTime > 24000) {

            fill(#311A03, 70);          
        rect(0, 0, width, height-52);
      }

      // After a certain period of time - stop drawing snow bit by bit

      if (snowTime > 30000) {
        snowToDraw = snowToDraw - int(((snowTime - 30000)/10000.0) * snowFlake.length); 
        
        fill(#311A03, 80);          
        rect(0, 0, width, height-50);
        
        }
      if (snowTime > 32000) {
            fill(#311A03, 100);          
        rect(0, 0, width, height-50);
        
      }

      // Draw the snow      
      for (int i = 0; i < snowToDraw; i++) {
        snowFlake[i].draw();
      }
    

    // if player runs off right screen, he will come back from the left side  
    if (player.x > width + 25) {
      player.x = -40;
    }
  }
}
}









//
//  Person
//  by Katy Law
//
// This provides drawing and hit detection logic for each person
//

class Person {
  

  // Location and size
  float x; 
  float y;
  float diameter;  

  float deltaX = 0;
  float deltaY = 0;

  // Set the color of the snow
  color personColor = #DEBC98;
  float alpha = 255;

  Person(float x, float y, float diameter) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
  }
  
  // Move the person to the next position
  void movePerson() {
    x += deltaX;
    y += deltaY; 

  }

    // Draw the circle
    void draw() {
      noStroke();
      fill(personColor, alpha);
      ellipse(x, y, diameter, diameter);
    }
  }










//
// Snow Flake
//  by Katy Law
//
// This provides drawing and hit detection logic for each snow flake
//

class SnowFlake {    

  // Location and size
  float x; 
  float y;
  float diameter;  

  float deltaX = 0;
  float deltaY = 0;

  // Set the color of the snow
  color snowColor = #DEBC98;
  
  boolean snowFallAgain = true;  // to let snow fall from top again in initial scene
                                 // and to not let snow fall again from top in end snow scene

  SnowFlake(float x, float y, float diameter) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
  }

  // Detect if the given point is within this snow flake
  //boolean isHit(float xPos, float yPos) {
  //  
  //}

  // Move the snow to the next position
  void moveSnow() {
    x += deltaX;
    y += deltaY;

    // Stop a snowflake at y position (the ground) and start it again
    if (y > height - 58) {
      deltaY = 0;
      
      // for the initial scene
      if (snowFallAgain){
        // 5% of snow will start from the top again
        if (random(0, 10) < 0.05) {
          y = 0;
          deltaY = 1;
        }
      }
      
    }
  }

    // Draw the circle
    void draw() {
      stroke(snowColor);
      fill(snowColor);
      ellipse(x, y, diameter, diameter);
    }
  }










//
// Umbrella
//  by Katy Law
//
// This encapsulates drawing, hit detection and movement direction for 
// each Umbrella
//

class Umbrella {
  
  // Constants
  final float MIN_UMBRELLA_OPEN_SPEED = 0.5;
  final float MAX_UMBRELLA_OPEN_SPEED = 1.0;
  
  // Object id
  int id;

  float x;
  float y;
  float radius;
  float openRadius = 0; // If this is less than radius then the umbrella is opening
  float openSpeed = random(MIN_UMBRELLA_OPEN_SPEED, MAX_UMBRELLA_OPEN_SPEED);
  boolean doOpenUmbrella = false;

  color umbrellaColor;  
  float alpha;
  
  // Direction
  float deltaX;
  float deltaY; 
  
  // Object constructor
  Umbrella(float x, float y, float radius, color umbrellaColor, float alpha) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.openRadius = radius/2;
    this.umbrellaColor = umbrellaColor;
    this.alpha = alpha;
    this.id = objectCounter++;
  }
  
  void move() {
    x += deltaX;
    y += deltaY;     
  }
  
  boolean detectEdge(float acceptableBounds) {
    // Estimate the next position
    float nextX = x + deltaX;
    float nextY = y + deltaY;
    if (nextX < 0 - acceptableBounds || nextX + (radius*2) > width + acceptableBounds)
      return true;
    if (nextY < 0 - acceptableBounds || nextY + (radius*2) > height + acceptableBounds)
      return true;
    return false;
  }
  
  boolean detectIfWillHitWithObject(Umbrella other) {
    // Estimate the next position
    float nextX = x + deltaX;
    float nextY = y + deltaY;
    return doCirclesCollide(nextX, nextY, radius, other.x, other.y, other.radius);
  }
/*  
  boolean detectIfCurrentlyHitsObject(Umbrella other) {
    return doCirclesCollide(x, y, radius, other.x, other.y, other.radius);    
  }
*/  
  boolean detectHitWithCircle(float otherX, float otherY, float otherRadius) {
    return doCirclesCollide(x, y, radius, otherX, otherY, otherRadius); 
  }
  
  boolean doCirclesCollide(float x1, float y1, float r1, float x2, float y2, float r2) {
    
    // From this tutorial
    // http://gamedev.tutsplus.com/tutorials/implementation/when-worlds-collide-simulating-circle-circle-collisions/
    
    // Our x,y coordinates need to reflect the center of the circle
    float ax1 = x1 + r1;
    float ax2 = x2 + r2;
    float ay1 = y1 + r1;
    float ay2 = y2 + r2; 
    
    // Detect a collision
    if ((ax1 + r1 + r2) > ax2 &&
        ax1 < (ax2 + r1 + r2) &&
        (ay1 + r1 + r2) > ay2 && 
        ay1 < (ay2 + r1 + r2)) {
      if (sqrt(pow(ax1 - ax2, 2) + pow(ay1 - ay2, 2)) < (r1 + r2)) {
        return true;
      }
    }    
    return false;
  }
  
  boolean isOpening() {
   return doOpenUmbrella && openRadius < radius; 
  }

  void draw() {
    fill(umbrellaColor, alpha);
    stroke(umbrellaColor, alpha);
    
    // Either opening or opened
    float r = radius;
    if (isOpening()) {
      openRadius = openRadius + openSpeed;
      r = openRadius;
    }
    
    // Calculate actual x,y
    float ax = x + r;
    float ay = y + r;
    
    // TODO: this could be calculated
    beginShape();
    vertex(r*cos(radians(60)) + ax, r*sin(radians(60)) + ay); 
    vertex(r*cos(radians(80)) + ax, r*sin(radians(80)) + ay);
    vertex(r*cos(radians(90)) + ax, r*sin(radians(90)) + ay); 
    vertex(r*cos(radians(110)) + ax, r*sin(radians(110)) + ay);
    
    vertex(r*cos(radians(120)) + ax, r*sin(radians(120)) + ay); 
    vertex(r*cos(radians(130)) + ax, r*sin(radians(130)) + ay);
    
    vertex(r*cos(radians(150)) + ax, r*sin(radians(150)) + ay); 
    vertex(r*cos(radians(170)) + ax, r*sin(radians(170)) + ay);
    
    vertex(r*cos(radians(180)) + ax, r*sin(radians(180)) + ay);
    vertex(r*cos(radians(190)) + ax, r*sin(radians(190)) + ay);
    vertex(r*cos(radians(210)) + ax, r*sin(radians(210)) + ay);
    vertex(r*cos(radians(230)) + ax, r*sin(radians(230)) + ay);
    
    vertex(r*cos(radians(240)) + ax, r*sin(radians(240)) + ay);
    vertex(r*cos(radians(250)) + ax, r*sin(radians(250)) + ay);
    vertex(r*cos(radians(270)) + ax, r*sin(radians(270)) + ay);
    vertex(r*cos(radians(290)) + ax, r*sin(radians(290)) + ay);
    vertex(r*cos(radians(300)) + ax, r*sin(radians(300)) + ay);
    vertex(r*cos(radians(310)) + ax, r*sin(radians(310)) + ay);
    vertex(r*cos(radians(330)) + ax, r*sin(radians(330)) + ay);
    vertex(r*cos(radians(350)) + ax, r*sin(radians(350)) + ay);
    
    vertex(r*cos(radians(360)) + ax, r*sin(radians(360)) + ay);
    vertex(r*cos(radians(370)) + ax, r*sin(radians(370)) + ay);
    vertex(r*cos(radians(390)) + ax, r*sin(radians(390)) + ay);
    vertex(r*cos(radians(410)) + ax, r*sin(radians(410 )) + ay);
    vertex(r*cos(radians(60)) + ax, r*sin(radians(60)) + ay);
    endShape();    
  }
}
