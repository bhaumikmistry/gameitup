size(500,500);
void keyPressed(){
	input[keyCode] = true;};
void keyReleased(){
	input[keyCode] = false;};

var debugMode=true;//turn on for debug
var Php=100;
var PlayerDeaths=0;
var Timer;
// subscribe to Tazal - https://goo.gl/txScyJ 

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/** SUPER PLATFORMER GAME ENGINE 3*/
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

// Spin-off and play around the code

/** 
 * feel free to use this engine without giveing me any credit 
 * all i ask is that you tell me that your useing it in the T&T
 * so i can check out what you make
 *
 * if you need any help with the engine ask me in the tips and thanks
*/

//╔══════════════════════════════════════╗        
//║                 Press ctrl+f                ║
//║      and type in the Corresponding text.    ║
//║            to find the section              ║
//╚══════════════════════════════════════╝
//     _1_ - games settings 
//     _2_ - levels array
//     _3_ - level start function
//     _4_ - blocks array (add and edit blocks)
//     _5_ - contols ( player controls)
//     _6_ - player display
//     _7_ - collison detecion
//     _8_ - games physic function (main game physics)
//     _9_ - game render (renders the game )
//     _0_ - Draw function ( background and final render)


//+========================================+
//               update log
//+========================================+
//- 0.01 - added base
//- 0.02 - fix collison
//- 0.03 - added better level arrays
//- 0.06 - fix collison (they were bad
//- 0.10 - added better Documentation 
//- 0.19 - fix a ton of bugs
//- 0.20 - add new blocks
//- 0.25 - fixed a HUGE bug
//- 0.3  - Even better documentation
//+========================================+

// _1_
//+========================================+
//             Game settings 
//+========================================+
//edit physics here
{
var CP={x:0,y:0};
var level = 1; // what level the player is on

// Players current cordinates in the map.
var px=40, py =40;

// players velocity at a current point.
var PXV=0, PYV=1;


var GravityPower = 0.32;// how strong is gravity
var GravityMin=-9;var GravityMax=9;//gravity min/map
var jumpPower=6.5;// how much power you jump has
var Pspeed=0.4;//the players speed

var MAXYV=9,MINYV=-2;//MAX & MIN players Y vel
var MAXXV=5,MINXV=-5;//MAX & MIN players X vel

var airFriction=0.2;//how much air slows the player
var groundFriction=1.0;//how much slower a player is on the ground
var XvolSlow=0.08;//how fast the player slows down

var scaleFactor=1.7;// how the levels scale
var ForceScale=1;//forces Scale level

var playerI={
    w:18,// players width
    h:20 // players height
};

// vars storage ( don't change ) 

var jumpTimer=0;// so player can't spam jump
var Gravity = 0;//the gravity
var canJump = false ,canMoveL=true , canMoveR=true;//if the player can move
var MX=0, MY=0;
var transX=0;
var transY=0;
var scl = 0;
var canMove=true;
frameRate(60);
smooth();
noStroke();
var input = [];
var BX=0;// makes the blockX var
var BY=0;

var FPStimer=millis();//
var FPSCount=0;//
var FPSCountT=0;//
var FPSstor=[];
var PastYV=0;

// bhaumik added
var cloudRelativeVelocityX = 0;

}
//+========================================+

var particlestor = [];
// _2_
//+========================================+
//               Level array
//+========================================+
// this is where you add/edit levels
var levels = [
   {
        // THIS LEVEL IS HERE AS A PLACE HOLDER
        
        name:"BLANK",// the name of the level
        spawnPoint:{x:3,y:3},// spawn point in tiles 
        W:1,// level width (in tiles)
        H:1,// level height (in tiles)
        MAP:[//the map of the level
           "D",
        ],
        MAPL1:[//the maps background
            "_",
        ],
        ONSTART:function(){},// what happens when level is started
        levelEX:function(){}// extra things add over the level Ex:(an enemy)
    },
    
    {
        
        name:"welcome",// the name of the level
        spawnPoint:{x:3,y:3},// spawn point in tiles 
        W:5,// level width (in tiles)
        H:8,// level height (in tiles)
        MAP:[//the map of the level
            "D_E_D",
            "@___@",
            "@___@",
            "@___@",
            "@@@@@",
            "_____",
            "#4ED3",
            "CK?L@",
        
        ],
        MAPL1:[
            "_###_",
            "_@@@_",
            "_@@@_",
            "_@@@_",
            "_____",
            "_____",
            "_____",
            "_____",
            ],
        ONSTART:function(){},// what happens when level is started
        levelEX:function(){// extra things add over the level Ex:(an enemy)
        },
    },    
   {
        name:"BLANK",// the name of the level
        spawnPoint:{x:1,y:3},// spawn point in tiles 
        W:120,// level width (in tiles)
        H:10,// level height (in tiles)
        MAP:[//the map of the level
            "D______________________________________________________________________________________________________________________D",
            "D__D___D_______________________________________D_______________________________________D_______________________________D",
            "D_____DD__2___________________________________DD______________________________________DD_______________________________D",
            "DDDDDDDDDDDDD     DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     DDDDDDDDDDDDDDDDD__DDD",
            "#####333####DDDDDDDD#####333####DDDDDDDD#####333####DDDDDDDD#####333####DDDDDDDD#####333####DDDDDDDD#####333####DDD__DDD",
            "D______________________________________________________________________________________________________________________D",
            "D______D_______________________________________D_______________________________________D_______________________________D",
            "D__E__DD______________________________________DD______________________________________DD_____________________C_________D",
            "DDDDDDDDDDDDD     DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD     DDDDDDDDDDDDDDDDDDDDDD",
            "#####333####DDDDDDDD#####333####DDDDDDDD#####333####DDDDDDDD#####333####DDDDDDDD#####333####DDDDDDDD#####333####DDDDDDDD",
        ],
        MAPL1:[//the maps background
            "_____1___1_______________C__11_______________1___1_____C__________1__11_______________1___1_______________1__11__________",
            "###__1___1_________C_______11______C____###__1___1_______________1__11__________###__1___1_______________1__11__________",
            "__##_1___1__1____________1__11________##__##_1___1__1____________1__11________##__##_1___1__1____________1__11__________",
            "__##_1___1__1___1____11___1__11_______##__##_1___1__1___1____11___1__11_______##__##_1___1__1___1____11___1__11_________",
            "_________________________1__11___________________________________1__11___________________________________1__11__________",
            "_____1___1_______________1__11_______________1___1_______________1__11_______________1___1_______________1__11__________",
            "###__1___1_______________1__11__________###__1___1_______________1__11__________###__1___1_______________1__11__________",
            "__##_1___1__1____________1__11________##__##_1___1__1____________1__11________##__##_1___1__1____________1__11__________",
            "__##_1___1__1___1____11___1__11_______##__##_1___1__1___1____11___1__11_______##__##_1___1__1___1____11___1__11_________",
            "_________________________1__11___________________________________1__11___________________________________1__11__________",

        ],
        ONSTART:function(){},// what happens when level is started
        levelEX:function(){
         fill(0, 0, 0);
         textSize(10);
         text("welcome to skyworld\npress arrow keys to move\n\nthis is lava\ndon't touch it",130,0);
         text("this is a checkpoint\nsave progress here",350,100);
        }// extra things add over the level Ex:(an enemy)
   },

    {
        name:"TEST",
        spawnPoint:{x:2,y:16},
        W:20,
        H:20,
        MAP:[
            "______________@@@___",
            "______________@3@___",
            "_______________3____",
            "_______________3____",
            "_______________@____",
            "_______________E____",
            "_______________E____",
            "_______________@____",
            "_______________3____",
            "_____________33333__",
            "_____________3@3@3__",
            "_____________3@@@3__",
            "_____________3@3@3__",
            "________C____3_3_3__",
            "______DDDDD4_3_3_3__",
            "DDDDDDD###D@3333333@",
            "_##########@3333333@",
            "____########@33333@_",
            "______####__#@333@__",
            "_______##_____@@@___",
        ],
        MAPL1:[
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "_______________@____",
            "_______________@____",
            "____________________",
            "____________________",
            "______________@_@___",
            "______________@_@___",
            "_______________@@___",
            "____________________",
            "______________@@@___", 
            "______________@@@___",
            "______________@@____",
            "____________________",
            "____________________",
            "____________________",
            "____________________",

    
        ],
        ONSTART:function(){
        },
        levelEX:function(){
            //rect(200,200,100,100);
        }
    },
   {
        name:"BLANK",// the name of the level
        spawnPoint:{x:8,y:26},// spawn point in tiles 
        W:40,// level width (in tiles)
        H:31,// level height (in tiles)
        
        MAP:[//the map of the level
            "_______D______D______________D_______L__",
            "_____________________D______________DL__",
            "_E___________________________________L__",
            "DDDD_________________________________L__",
            "_##________________________________C_L__",
            "__#________________________________DDDDD",
            "____________________________________####",
            "_____________________________________##_",
            "______________________________________#_",
            "________________________________________",
            "________________________________________",
            "_______________________D44D_____________",
            "________________________##______________",
            "________________________________4_______",
            "_DD____________________________DDD______",
            "D##D___________C________________##D_____",
            "_###__DDD_L___DDD________________#______",
            "__##_D###DL__D###D______________________",
            "__DDD###@@L__@@##_______________________",
            "__######@_L___@#________________________",
            "__######@_L___@#D_______________________",
            "___#####@_L___@##D______________________",
            "____####@_L___@###D_________________444_",
            "___D####@@@@@W@####_________________DDD_",
            "___#@@@@@WWWWW@###___________________#__",
            "__D#@___@WWWWW@###___________444________",
            "DD##@W@@@@W@@@@##____________DDD________",
            "####@WWWWWW@#####____444______#_________",
            "####@@@@@@@@####_____DDD________________",
            "_#############________#_________________",
            "__###########___________________________",
        ],MAPL1:[//the maps background            
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",
            "________________________________________",

            "________________________________________",
            "________________________________________",
            "__________@@@___________________________",
            "_________@@@@@__________________________",
            "_________@@@@@__________________________",
            "_________@@@@@__________________________",
            "_________@@@@@__________________________",
            "_________@@@@@__________________________",
            "_________@@@@@__________________________",
            "_____@@@_@@@@@__________________________",
            "_____@____@@____________________________",
            "_____@@@@@@@____________________________",
            "_____@@@@_______________________________",
            "________________________________________",
            "________________________________________",
        ],
        ONSTART:function(){},// what happens when level is started
        levelEX:function(){
        }// extra things add over the level Ex:(an enemy)
   },
    {
        
        name:"The Temple",// the name of the level
        spawnPoint:{x:3,y:3},// spawn point in tiles 
        W:20,// level width (in tiles)
        H:20,// level height (in tiles)
        MAP:[//the map of the level

            "____________________",
            "____________________",
            "____________________",
            "DDDD________________",
            "####________________",
            "_###DWWWWDDDD_______",
            "_###WWWWW####_______",
            "__#WWWWWW#+#____DDDD",
            "__#######________###",
            "__________________#_",
            "____________________",
            "____@@@@@@@_________",
            "___WW@_E_@33DDD_____",
            "___W@@_L_@@3_#______", 
            "___W_@@L@@_3________",
            "___W___L___3________",
            "___W___L___3________",
            "@WWWW@_L_@3333@_____",
            "@WWWW@@@@@3333@_____",
            "_@@@@_____@@@@______",
        ],
        MAPL1:[
            "____________________",
            "____________________",
            "____________________",
            "####________________",
            "____________________",
            "1___________________",
            "1__#######__________",
            "11_#########1___1___",
            "_1_#########1___1_1_",
            "_1__########1___1_1_",
            "_1___#######1_____1_",
            "_____###_4##______1_",
            "____@#@@@@@#________",
            "____@_@@@_###_1_____", 
            "______@@@____11_____",
            "______@@@____1______",
            "______@@@___________",
            "_@@@@_@@@_@@@@@_____",
            "_@@@@__@__@@@@@_____",
            "____________________",

            ],
        ONSTART:function(){},// what happens when level is started
        levelEX:function(){// extra things add over the level Ex:(an enemy)
        },
    },    
   {
        name:"BLANK",// the name of the level
        spawnPoint:{x:3,y:3},// spawn point in tiles 
        W:20,// level width (in tiles)
        H:20,// level height (in tiles)
        MAP:[//the map of the level
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
        ],
        MAPL1:[//the maps background
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",
            "____________________",

        ],
        ONSTART:function(){},// what happens when level is started
        levelEX:function(){
        }// extra things add over the level Ex:(an enemy)
    },
//    <-- ADD NEW LEVEL HERE
    
];
//+========================================+

// _3_
//+========================================+
//          level start function
//+========================================+
// things that happen when level starts
var levelStartUp = function(){
    if(levels.length!==level+1){
        py=0;
        px=0;
        level+=1;//move to next level
        Gravity=0;//resets gravity & player veiolcity
        PXV=0;PYV=0;//resets player velocity
        //move player to spawnpoint
        px=(20*levels[level].spawnPoint.x)-(playerI.w/2);
        py=(20*levels[level].spawnPoint.y)-(playerI.w/2);
        CP.x=(20*levels[level].spawnPoint.x)-(playerI.w/2);
        CP.y=(20*levels[level].spawnPoint.y)-(playerI.w/2);
        levels[level].ONSTART();//does level onstart function
                
        //sets the scl factor for the level 
        if(ForceScale===0){
            scl=scaleFactor-((levels[level].W+levels[level].H)/50);
        }else{
            scl=ForceScale;    
        }
        transX=(
            (   0-(
                    20/2
                    )*20
                )+(width/4)/(scl)
        );
        transY=(
            (   0-(
                    20/2
                    )*20
                )+(height/2)/(scl)
        );
        MX=px;
        MY=py;
                
            //tests level for errors
        for(var M=0;M<levels.length;M++){
                if(levels[M].H!==levels[M].MAP.length){
                    println("ERROR : level height");
                }
            for(var i=0;i<levels[M].MAP.length;i++){    
                if(levels[M].W!==levels[M].MAP[i].length){
                    println("ERROR : level's "+M+" width on line ["+i+1+"] of MAP");
            }
        }
    }
    }
    else{
        println("missing level ["+(level+1)+"]");
    }
        };
//+========================================+
var PSU=false;
var ExitParticle = function(position) {
  this.position = position.get();
  this.LiveT = 255.0;
  this.size = random(5,15);
 this.sizeA = 5;
 this.MS=false;
ExitParticle.prototype.run = function() {
  noStroke();
  if(!this.MS){this.size+=this.sizeA;}else{this.size-=this.sizeA;}
  if(this.size>500){this.MS=true;
  if(PSU){PSU=false;levelStartUp();}
  }
  
  if(this.size<=20&&this.MS){this.LiveT=0;canMove=true;
  }
  fill(255, 255, 255);
  ellipse(this.position.x, this.position.y, this.size, this.size);
};
ExitParticle.prototype.isDead = function() {
if (this.LiveT < 0) {return true;} else {return false;}
};};
var LavaParticle = function(position) {
this.acceleration = new PVector(0.00, 0.00);
  this.velocity = new PVector(random(-1,1), random(-1,1));
  this.position = position.get();
  this.LiveT = 255.0;
  this.size = random(5,10);
LavaParticle.prototype.run = function() {
  this.velocity.add(this.acceleration);
  this.position.add(this.velocity);
  this.LiveT -= 6;
    pushMatrix();    
          scale(scl);//scales the map
        translate(190-MX,190-MY);//moves map to correct area
        MX=constrain(MX,px-(100/scl),px+(-100/scl));//keep movement within reason
        MY=constrain(MY,py-(50/scl),py+(50/scl));//keep movement within reason
        translate(transX,transY);//moves map from start area 
        
  noStroke();
  fill(133, 133, 133,this.LiveT);
  ellipse(this.position.x, this.position.y, this.size, this.size);
    popMatrix();

};
LavaParticle.prototype.isDead = function() {
if (this.LiveT < 0) {return true;} else {return false;}
};};
// _4_        
//+========================================+
//             Blocks array
//+========================================+
// this is where you add / edit blocks
var Blocks = {
    //=========================================================
    //+========={ L1 blocks are the background blocks }=======+
    //=========================================================
    L1:[
    {
        TileName:"vines",//the Name of the block
        T:"1",//the text that refers to this block in the map array
        Display:function(x,y){// what the block looks like
        fill(20, 168, 35);
        rect(x,y,4,21);
        
        }
    },
    {
        TileName:"air1",//the Name of the block
        T:"_",//the text that refers to this block in the map array
        Display:function(x,y){// what the block looks like
        }
    },
    {
        TileName:"dirt1",//the Name of the block
        T:"#",//the text that refers to this block in the map array
        Display:function(x,y){// what the block looks like
            fill(128, 61, 17);
            rect(x,y,21,21);
        }
        
    },
    {    
        TileName:"stoneBack",
        T:"@",
        Display:function(x,y){
            
            fill(166, 166, 166);
            rect(x,y,21,21);
            
            fill(99, 99, 99);
            rect(x,y,21,2);
            rect(x,y-10,21,2);
            rect(x,y+10,21,2);
            rect(x,y+5,2,10);
            rect(x-10,y-5,2,10);
            rect(x+10,y-5,2,10);
            
            fill(102, 102, 102,200);
            rect(x,y,22,22);
            
        }
    },
    {
        TileName:"cloud",
        T:"C",
        Display:function(x,y){

            // m is the multiplier for the scale of the cloud
            m=0.8

            x= x + px/5;
           

            noStroke();
            fill(255,255,255);
            ellipse(x,y, 150*m, 20*m);
            ellipse(x-35*m,y-5*m,90*m,30*m);
            ellipse(x+35*m,y-5*m,90*m,30*m);
            ellipse(x-20*m,y-25*m,70*m,40*m);
            ellipse(x+25*m,y-25*m,45*m,15*m);
            
            beginShape();
            vertex(x-54*m, y-30*m);
            bezierVertex(x-54*m,y-30*m, x-55*m, y-20*m,x-69*m,y-15*m, x+29*m, y+25*m);
            bezierVertex(x-69*m,y-15*m, x+29*m, y+25*m,x-54*m,y-30*m, x-50*m, y-20*m);
            endShape()
            
            beginShape();
            vertex(x+45*m, y-28*m);
            bezierVertex(x+45*m,y-30*m, x+55*m, y-20*m,x+69*m,y-15*m, x-29*m, y+25*m);
            bezierVertex(x+69*m,y-15*m, x-29*m, y+25*m,x+45*m,y-28*m, x+50*m, y-20*m);
            endShape()
        }
    },

    ],
    //=========================================================
    // +====={ L2 blocks are the blocks the player touchs}====+
    //=========================================================
    L2:[
/**
    {

        TileName:"EXAMPLE",<--the Name of the block
        T:"@",<--the text that refers to this block in the map array
        Soild:true,<--if this block is soild
        onTouch:function(T,B,L,R,A){ <-- what happens when you touch the block
         
         T if top | B if bottem | L if Left | R if right | A if any
         
            if(T){
                Gravity-=jumpPower*(PastYV/3);
            }
        },
        Display:function(x,y){ <-- what the block looks like
             
            fill(68, 255, 51+random(0,50));
            rect(x,y,21,21);    
        }
    },
**/
    {

        TileName:"grassF",//the Name of the block
        T:"g",//the text that refers to this block in the map array
        Soild:false,//if this block is soild
        onTouch:function(T,B,L,R,A){ // what happens when you touch the block
        // T if top | B if bottem | L if Left | R if right | A if any
        },
        Display:function(x,y){// what the block looks like
            fill(103, 204, 26);
            //rect(x,y+8,21,5);
            rect(x,y+9,3,9);
            rect(x-7,y+9,3,10);
            rect(x+7,y+9,3,6);
        }
    },
    {

        TileName:"jump",//the Name of the block
        T:"4",//the text that refers to this block in the map array
        Soild:true,//if this block is soild
        onTouch:function(T,B,L,R,A){ // what happens when you touch the block
        // T if top | B if bottem | L if Left | R if right | A if any
            if(T){
                Gravity-=jumpPower*(PastYV/3);
            }
        },
        Display:function(x,y){// what the block looks like
             
            fill(68, 255, 51+random(0,50));
            rect(x,y,21,21);    
        }
    },
    {

        TileName:"Ladder",//the Name of the block
        T:"L",//the text that refers to this block in the map array
        Soild:false,//if this block is soild
        onTouch:function(T,B,L,R,A){ // what happens when you touch the block
        // T if top | B if bottem | L if Left | R if right | A if any
            if(A){
                Gravity=0;
                if(input[UP]){PYV-=0.5;}
                if(input[DOWN]){PYV+=0.5;}
            }
        },
        Display:function(x,y){// what the block looks like
             
            fill(209, 165, 31);
            rect(x-8,y,3,26);  
            rect(x+8,y,3,26);  
            
            rect(x,y+5,20,3);
            
            rect(x,y-5,20,3);
        }
    },
    {
        TileName:"kill",
        T:"3",//the text that refers to this block in the map array
        Soild:true,//if this block is soild
        onTouch:function(T,B,L,R,A){
         if(A){Php-=25;
         for(var i=0;i<10;i++){
            particlestor.push(new LavaParticle(new PVector(px+10, py+10)));
            }
         }
         if(L){px-=5;PXV-=5;}if(R){px+=5;PXV+=5;}
         if(T){py-=5;Gravity-=5;}if(B){py+=5;Gravity+=5;}


         // its easyer to just move the player out of the world
         // rather then killing them in a diffent function
        },
        Display:function(x,y){
             
            fill(255, 155+random(0,50), 0);
            rect(x,y,21,21);    
        }
    },
    {
        TileName:"air",
        T:"_",//the text that refers to this block in the map array
        Soild:false,//if this block is soild
        onTouch:function(T,B,L,R,A){
        },
        Display:function(x,y){
        }
    },
    {
        TileName:"stone",
        T:"@",
        Soild:true,
        onTouch:function(T,B,L,R,A){
        
        },
        Display:function(x,y){
            
            fill(166, 166, 166);
            rect(x,y,21,21);
            
            fill(99, 99, 99);
            rect(x,y,21,2);
            rect(x,y-10,21,2);
            rect(x,y+10,21,2);
            rect(x,y+5,2,10);
            rect(x-10,y-5,2,10);
            rect(x+10,y-5,2,10);

        }
    },
    {
        TileName:"dirt",
        T:"D",
        Soild:true,
        onTouch:function(T,B,L,R,A){
        
        },
        Display:function(x,y){
            
            fill(168, 77, 16);
            rect(x,y,21,21);
            
            fill(41, 194, 33);
            rect(x,y-8,21,5);
            //rect(x,y-12,3,9);
            //rect(x-7,y-12,3,10);
            //rect(x+7,y-12,3,6);

            point(x,y);


        	temp_x=-10;
        	temp_y=-8;
            fill(41, 194, 33);
            triangle(x+temp_x,y+temp_y,x+temp_x+2,y+temp_y-3,x+temp_x+5,y+temp_y);
           	fill(102, 235, 98);
        	triangle(x+temp_x+3,y+temp_y,x+temp_x+2,y+temp_y-3,x+temp_x+5,y+temp_y);

	        temp_x=-3
            fill(41, 194, 33);
	        triangle(x+temp_x,y+temp_y,x+temp_x+3,y+temp_y-5,x+temp_x+5,y+temp_y);
           	fill(102, 235, 98);
        	triangle(x+temp_x+3,y+temp_y,x+temp_x+3,y+temp_y-5,x+temp_x+5,y+temp_y);

	        temp_x=4
            fill(41, 194, 33);
	        triangle(x+temp_x,y+temp_y,x+temp_x+2,y+temp_y-6,x+temp_x+5,y+temp_y);
           	fill(102, 235, 98);
        	triangle(x+temp_x+3,y+temp_y,x+temp_x+2,y+temp_y-6,x+temp_x+5,y+temp_y);


        }
    },
    {
        TileName:"Basic",
        T:"#",
        Soild:true,
        onTouch:function(T,B,L,R,A){
        
        },
        Display:function(x,y){
            
            fill(168, 77, 16);
            rect(x,y,21,21);
         
        }
    },
    
    {
        TileName:"Water",
        T:"W",
        Soild:false,
        onTouch:function(T,B,L,R,A){
            if(A){Gravity=0.4;canJump=false;
            
                if(input[UP]){PYV-=1;}
            }
        },
        Display:function(x,y){
            
            fill(16, 31, 166,125);
            rect(x,y,20,20);
         
        }
    },
    {
        TileName:"EXIT",
        T:"E",
        Soild:true,
        onTouch:function(T,B,L,R,A){
            if(A&&canMove===true){
            
            levelStartUp();
            

            }
        },
        Display:function(x,y){
            fill(82, 27, 82);
            
            ellipse(x,y,20,20);
            
            fill(255, 0, 255,125);
            noStroke();
            //ellipse(x,y,10+1*(frameCount % 20),10+1*(frameCount %  20));    
            
            fill(0, 0, 0);
            //ellipse(x,y,1*(frameCount %  4),1*(frameCount % 4));    
        }
    },
    {
        TileName:"CP",
        T:"C",
        Soild:false,
        onTouch:function(T,B,L,R,A){
            if(A){
                textAlign(CENTER);
                text("Check Point",BX+10,BY-15);
                CP.x=BX;CP.y=BY;}
        },
        Display:function(x,y){
            fill(255, 255, 255);
            rect(x,y,3,20);  
            
            fill(242, 14, 29);
            rect(x+5,y-6,10,5);  
        }
    },
    {
        TileName:"VILLAN",
        T:"2",
        Soild:true,
        onTouch:function(T,B,L,R,A){

        },
        Display:function(x,y){
            pushMatrix();
            rectMode(CENTER);
            x=x-playerI.w/2;
            y=y-playerI.h/2
            fill(0, 105, 115);
            quad(x,y,x+20,y,x+20,y+20,x,y+20);
            fill(255, 255, 255,240);
            rect(x+6,y+5,5,5);
            rect(x+14,y+5,5,5);

            fill(0, 0, 0,255);
            rect(x+7,y+5,2,2);
            rect(x+14,y+5,2,2);

            fill(0, 0, 0);
            rect(x+10,y+13,8,2); 
            popMatrix();
        }
    },
    ]
    
    };
//+========================================+

// _5_
//+========================================+
//             CONTROLS
//+========================================+    
// this is the games controls function 
var PlayerControls = function(){

if(canMove){
        jumpTimer=constrain(jumpTimer,0,500);
        
        //if player presses up arrow
        if(input[UP]&&canJump===true&&jumpTimer>=20){
            Gravity-=jumpPower;
            canJump=false;
            jumpTimer=0;
        }
        
        //if player presses down arrow
               //if player presses Left/right arrow
        //if not add air friction
        if(input[LEFT]&&canMoveL){
            PXV-=Pspeed;
        }else
        if(input[RIGHT]&&canMoveR){
            PXV+=Pspeed;
        }else{
            if(PXV>0){PXV-=airFriction;}
            if(PXV<0){PXV+=airFriction;}
        }
}
};
//+========================================+

// _6_
//+========================================+
//               PLAYER DISPLAY
//+========================================+
// this function Displays the player
var PlayerDisplay = function(){
    pushMatrix();
    translate((playerI.w/2),0);
    rectMode(CENTER);
    fill(115, 105, 115);
    quad(px+PXV,py,px+20+PXV,py,px+20,py+20,px,py+20);
    fill(255, 255, 255,240);
    rect(px+6+PXV,py+5,5,5);
    rect(px+14+PXV,py+5,5,5);

    fill(0, 0, 0,255);
    rect(px+6+PXV*1.1,py+5+constrain(PYV,-3,3),2,2);
    rect(px+14+PXV*1.1,py+5+constrain(PYV,-3,3),2,2);

    fill(0, 0, 0);
    rect(px+10,py+13,8,2);
    if(PYV>6){rect(px+10,py+13,8,2+constrain(PYV,0,3));}
    popMatrix();
};
//+========================================+

// _7_
//+========================================+
//             collison detecion
//+========================================+
// this the function test collison between player and blocks

var Bdect = function(XV, YV,BW,BH,PW,PH){
    for(var i = 0; i < levels[level].W; i++){//loops through level x
        for(var j = 0; j < levels[level].H; j++){//loops through level y
            for(var o=0; o < Blocks.L2.length; o++){//loop through block array
                if(levels[level].MAP[j][i]===Blocks.L2[o].T){//test if it is the block
                    BX=(i*20);// makes the blockX var
                    BY=(j*20);// makes the blockY var
                    if(//test if player is touching block
                        px+(playerI.w/2)>(BX-(BW/2+PW/2))&&
                        px+(playerI.w/2)<(BX+(BW/2+PW/2))&&
                        py>(BY-(BH/2+PH/2))&&
                        py<(BY+(BH/2+PH/2))
                    ){
                        // player touched any side of the tile
                        if(YV<0){//if player traveling up when they hit the tile
                            if(Blocks.L2[o].Soild){//test to see if block is solid
                                PastYV=PYV;
                                PYV=0;//stops player from jumping
                                canJump = false;//player can't jump
                                Gravity = 1;//makes player fall
                                py=BY+(BH/2)+(PH/2);//put py bellow tile
                                if(debugMode){
                                    fill(194, 188, 188,150);
                                    rect(BX+10,BY+10,20,20);
                                }
                            }
                            Blocks.L2[o].onTouch(false,true,false,false,false);
                            }
                            
                        if(YV>0){//if player traveling down when they hit the tile
                            if(Blocks.L2[o].Soild){//test to see if block is solid
                                PastYV=PYV;
                                PYV=-1;//stop player from falling
                                canJump = true;//the player can now jump
                                Gravity = 0;//resets gravity
                                py=BY-(BH/2)-(PH/2);//puts py ontop of tile
                                PXV/=groundFriction; //adds groundfrition 
                                if(debugMode){
                                    fill(194, 188, 188,150);
                                    rect(BX+10,BY+10,20,20);
                                }   
                            }
                            Blocks.L2[o].onTouch(true,false,false,false,false);
                        }
                        
                        if(XV>0){//if player traveling RIGHT when they hit the tile
                            if(Blocks.L2[o].Soild){//test to see if block is solid
                                PXV=0;//resets X-axis velocity
                                canMoveR=false;//stops player from moveing left
                                px=(BX-(BW/2)-(PW/2))-(PW/2);//makes px on the right side
                                if(debugMode){
                                    fill(194, 188, 188,150);
                                    rect(BX+10,BY+10,20,20);
                                }
                            }
                            Blocks.L2[o].onTouch(false,false,true,false,false);
                        }
                        
                        if(XV<0){//if player traveling LEFT when they hit the tile
                            if(Blocks.L2[o].Soild){//test to see if block is solid
                                PXV=0;//resets X-axis velocity
                                canMoveL=false;//stops player from moveing left
                                px=(BX+(BW/2)+(PW/2))-(PW/2);//makes py on the left side
                                if(debugMode){
                                    fill(194, 188, 188,150);
                                    rect(BX+10,BY+10,20,20);
                                }
                            }
                            Blocks.L2[o].onTouch(false,false,false,true,false);
                        }
                      Blocks.L2[o].onTouch(false,false,false,false,true);
                      
                    }
                }
            }
        }
    }
};
//+========================================+

// _8_
//+========================================+
//                PHYSICS
//+========================================+
// The Games Physics
var PhysX= function(){
    PXV=constrain(PXV,MINXV,MAXXV);//keeps player X velocity within min/max
    PYV=constrain(PYV,MINYV,MAXYV);//keeps player Y velocity within min/max
    jumpTimer+=1;
    PYV=Gravity;// makes player Yaxis velocity the gravity
    Gravity+=GravityPower;// increases gravity
    Gravity=constrain(Gravity,GravityMin,GravityMax);//keeps Gravity within Min/Max
 
    px+=PXV;//adds Xaxis velocity to player
    Bdect(PXV,0,20,20,playerI.w,playerI.h);//tests players Xaxis velocity collision
    py+=PYV;//adds Yaxis velocity to player  
    Bdect(0,PYV,20,20,playerI.w,playerI.h);//tests players Yaxis velocity collision
    
    if(PXV<0){PXV+=XvolSlow;}//slows player down
    if(PXV>0){PXV-=XvolSlow;}//slows player down
    if(PXV<0.1&&PXV>0){PXV=0;}//stops player
    if(PXV>-0.1&&PXV<0){PXV=0;}//stops player
    if(py>1000){Php-=5;}
    if(Php<=0){//if player is out side world the kill them
            PlayerDeaths++;
            Php=100;
            px=CP.x;
            py=CP.y;
            Gravity=0;
            PXV=0;PYV=0;
            MX=px;
            MY=py;

    }
};
//+========================================+

// _9_
//+========================================+
//              Game Render  
//+========================================+
// renders the game
var GameRender = function(){

// Renders background blocks    
if(levels[level].MAPL1!==""){
    for(var i = 0; i < levels[level].W; i++){
        for(var j = 0; j < levels[level].H; j++){
            for(var o=0; o < Blocks.L1.length; o++){
                if(levels[level].MAPL1[j][i]===Blocks.L1[o].T){
                  Blocks.L1[o].Display((i*20)+10,(j*20)+10);
                }
            }
        }
    }
}
    PlayerDisplay();//displays player

// Renders normal blocks
    for(var i = 0; i < levels[level].W; i++){
        for(var j = 0; j < levels[level].H; j++){
            for(var o=0; o < Blocks.L2.length; o++){
                if(levels[level].MAP[j][i]===Blocks.L2[o].T){
                    Blocks.L2[o].Display((i*20)+10,(j*20)+10);
                }
            }
        }
    }
};
//+========================================+

// _0_
//+========================================+
//                DRAW FUNCTON 
//+========================================+
// this is where the magic happens
var debugStor="";
draw = function() {
    //======================================================
    // the background 
    background(127,255, 212);
    
    //======================================================
    pushMatrix();
    
    //the debug storage 
    debugStor="x:"+round(px)+" y:"+round(py)+" xVelocity:"+round(PXV)+" yVelocity:"+1+" G:"+1+"\n FPS:"+FPSCountT+" maps X-Cord:"+round(MX)+" maps Y-Cord:"+round(MY)+" mapScale:"+scl;

        //println(round(px));
        //println(round(MX));

        scale(scl);//scales the map
        translate(190-MX,190-MY);//moves map to correct area
        MX=constrain(MX,px-(100/scl),px+(-100/scl));//keep movement within reason
        MY=constrain(MY,py-(50/scl),py+(50/scl));//keep movement within reason
        translate(transX,transY);//moves map from start area 
        canJump = false;// toggles can jump
        GameRender();//renders game
        PhysX();//runs game physics
        PlayerControls();//runs controls
    
        levels[level].levelEX();//displays levelex function

    popMatrix();
    
        fill(0, 0, 0);
        textSize(10);
        textAlign(CENTER);
        text(levels[level].name,width/2,15);

    
    
    for(var i=0;i<Php/25;i++){
        fill(255, 0, 17);
        ellipse(15+i*25,15,20,20);
    }
    fill(255, 0, 0);
    textSize(20);
    text(PlayerDeaths,width-20,25);
    textSize(10);
    
    canMoveL=true;//toggles can move left
    canMoveR=true;//toggles can move right
     for (var i = particlestor.length-1; i >= 0; i--) {
    var p = particlestor[i];
    p.run();
    if (p.isDead()) {
      particlestor.splice(i, 1);
    }
  }
};
//+========================================+
levelStartUp();