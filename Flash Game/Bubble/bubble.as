import flash.events.MouseEvent;
import flash.geom.Point;
import flash.events.TouchEvent;
import flash.display.StageAlign;
import flash.events.NativeWindowBoundsEvent;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.display.StageDisplayState;
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import background;
import title;
import logo;
import waterMachine;
import bubble;
import timeLeft;
import countdown;
import bonusPlayer;
import alert;
import bomp;
import soundTrack;
import PlusSound;
import MinusSound;
import countSound;
import replay;
import PlayBTN;
import Note;


var sound:soundTrack = new soundTrack();
var soundChannel:SoundChannel = new SoundChannel();
soundChannel = sound.play(0, 9999999999999);

var bg:background = new background();
var Title:title = new title();
var contentBubble:MovieClip = new MovieClip();
var Logo:logo = new logo();
var WaterMachine:waterMachine = new waterMachine();
var Countdown:countdown = new countdown();
var TimeLeft:timeLeft = new timeLeft();
var duration:int = 45;
var count:int = duration;
var bonusInfo:alert = new alert();
var BonusPlayer:bonusPlayer = new bonusPlayer();
var leftTimer:Timer = new Timer(1000, duration);
var timer:Timer = new Timer(1500);
var isStart:Boolean = true;
var note:Note = new Note();
note.visible = false;
var btnReplay:replay = new replay();
btnReplay.name = "replay";
btnReplay.visible = false;
var btnPlay:PlayBTN = new PlayBTN();
btnPlay.name = "play";
btnPlay.visible = false;
stage.addChild(bg);
drawContentBubble();
stage.addChild(bonusInfo);
stage.addChild(Title);
stage.addChild(Logo);
stage.addChild(btnReplay);
stage.addChild(btnPlay);
bonusInfo.visible = false;

stage.align = StageAlign.TOP_LEFT;
stage.scaleMode = StageScaleMode.NO_SCALE;
stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeStage);
stage.addEventListener(MouseEvent.CLICK, controlGame);
stage.addEventListener(TouchEvent.TOUCH_TAP, controlGame);

timer.addEventListener(TimerEvent.TIMER, addBubble);	
leftTimer.addEventListener(TimerEvent.TIMER, controlTimeLeft);
leftTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopGame);
setTimeout(function(){objMove(Title, align(Title, "top-left"), 500, 20, 0.04);}, 2000);

function addWaterMachine(e:TimerEvent)
{
	Title.x += Logo.height/2;
	Title.y += Logo.height/2;
	var WMPoint: Point;
	scale(WaterMachine, stage.stageWidth*2/3, stage.stageHeight*8/10, false);
	WMPoint = align(WaterMachine, "bottom-right");
	WaterMachine.x = WMPoint.x;
	WaterMachine.y = WMPoint.y;
	stage.addChild(WaterMachine);
	WaterMachine.play();
	setTimeout(function(){
			   btnPlay.visible = true;
			   note.visible = true;
			   stage.addChild(note);
			   note.gotoAndPlay("enable");}, 2416);
}

function controlTimeLeft(e:TimerEvent):void
{
	count--;
	TimeLeft.time.text = String(count) + " s";
	if(count == 1){
		timer.stop();
	}
	if(count == 5){
		var cSound:countSound = new countSound();
		cSound.play();
	}
}

function stopGame(e:TimerEvent):void
{
	var pt:Point = new Point(0, 0);
	timer.stop();
	leftTimer.stop();
	soundChannel.stop();
	if(e != null)
	{
		while(contentBubble.numChildren > 0)
		{
			contentBubble.removeChildAt(0);
		}		
		setTimeout(function(){bonusInfo.visible = true;}, 10);
	}
	else
	{
		setTimeout(function(){
		var obj:MovieClip;
		var bompSound:BompSound = new BompSound();
		for(var i:int = 0; i < contentBubble.numChildren; i++)
		{
			obj = MovieClip(contentBubble.getChildAt(i));
			try
			{
				if(obj.getChildByName("parentBomp"))
				{
					MovieClip(obj.getChildByName("parentBomp")).obj.bomp.play();
					bompSound.play();
				}
				else if(obj.getChildByName("parentBubble"))
				{
					MovieClip(obj.getChildByName("parentBubble")).obj.bubble.play();
					MovieClip(obj.getChildByName("parentBubble")).obj.bonusValue.play();
				}
			}catch(e:Error){};
		}}, 300);		
		setTimeout(function(){bonusInfo.visible = true;}, 3000);
	}
	TimeLeft.visible = false;
	BonusPlayer.visible = false;
	bonusInfo.value.text = BonusPlayer.value.text;
	scale(bonusInfo, stage.stageWidth/2, stage.stageHeight, false);
	pt = align(bonusInfo, "center");
	bonusInfo.x = pt.x + bonusInfo.width/2;
	bonusInfo.y = pt.y;
	btnReplay.visible = true;
	note.visible = false;
}

function resizeStage(e:NativeWindowBoundsEvent):void
{
	var newPoint:Point;
	// resize background
	scale(bg, stage.stageWidth, stage.stageHeight, true);
	bg.x = stage.stageWidth/2;
	bg.y = stage.stageHeight/2 - (bg.height - stage.stageHeight)/2;
	// resize content bubble
	//scale(contentBubble, stage.stageWidth, stage.stageHeight, true);	
	// resize logo
	Logo.scaleX = Logo.scaleY = 1;
	scale(Logo, stage.stageWidth/8, stage.stageHeight/15, false);
	newPoint = align(Logo, "top-right");
	Logo.x = newPoint.x - Logo.height;
	Logo.y = newPoint.y + Logo.height;
	// resize title
	if(isStart == true)
	{
		setTimeout(function(){isStart = false;}, 2000);
		scale(Title, stage.stageWidth/2, stage.stageHeight/2, false);
		newPoint = align(Title, "center");
		Title.x = newPoint.x;
		Title.y = newPoint.y;
	}
	else
	{		
		scale(Title, stage.stageWidth/4, stage.stageHeight/6, false);
		newPoint = align(Title, "top-left");
		Title.x = newPoint.x + Logo.height/2;
		Title.y = newPoint.y + Logo.height/2;
	}
	// Water machine
	scale(WaterMachine, stage.stageWidth*2/3, stage.stageHeight*8/10, false);
	newPoint = align(WaterMachine, "bottom-right");
	WaterMachine.x = newPoint.x;
	WaterMachine.y = newPoint.y;	
	// countdown
	scale(Countdown, stage.stageWidth/3, stage.stageHeight/3, false);
	newPoint = align(Countdown, "center");
	Countdown.x = newPoint.x;
	Countdown.y = newPoint.y;
	// Timeleft
	scale(TimeLeft, stage.stageWidth/4, stage.stageHeight/6, false);
	newPoint = align(TimeLeft, 'bottom-right');
	TimeLeft.x = newPoint.x - Logo.height/2;
	TimeLeft.y = newPoint.y - Logo.height/2;	
	// BonusPlayer
	scale(BonusPlayer, stage.stageWidth/4, stage.stageHeight/6, false);
	newPoint = align(BonusPlayer, 'bottom-left');
	BonusPlayer.x = newPoint.x + Logo.height/2;
	BonusPlayer.y = newPoint.y - Logo.height/2;
	//btnReplay
	scale(btnReplay, Logo.height*2, Logo.height*2, false);
	btnReplay.x = BonusPlayer.x;
	btnReplay.y = BonusPlayer.y;
	// btnPlay
	scale(btnPlay, Logo.height*2, Logo.height*2, false);
	btnPlay.x = btnReplay.x + 10;
	btnPlay.y = btnReplay.y;
	// Bonus info
	scale(bonusInfo, stage.stageWidth/2, stage.stageHeight, false);
	newPoint = align(bonusInfo, "center");
	bonusInfo.x = newPoint.x + bonusInfo.width/2;
	bonusInfo.y = newPoint.y;
	// Note
	scale(note, stage.stageWidth/3, stage.stageHeight/8, false);
	newPoint = align(note, "bottom-center");
	note.x = newPoint.x;
	note.y = newPoint.y - Logo.height;
}

function scale(object:Object, w:Number, h:Number, outSize:Boolean):void
{
	object.scaleX = object.scaleY = 1;
	var objW:Number = object.width;
	var objH:Number = object.height;
	var scaleValue:Number = w/objW;
	if(outSize == true && h/objH > scaleValue)
	{
		scaleValue = h/objH;
	}
	else if(outSize == false && h/objH < scaleValue)
	{
		scaleValue = h/objH;
	}
	object.scaleX = object.scaleY = scaleValue;
}

function whatever()
{
    setTimeout(setToFullScreen, 1);
}

function setToFullScreen()
{
    stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
    stage.scaleMode = StageScaleMode.NO_SCALE;
	setTimeout(function(){resizeStage(null);}, 10);
}
whatever();

function drawContentBubble()
{
	contentBubble.graphics.beginFill(0xFF0000, 0);
	contentBubble.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
	contentBubble.graphics.endFill();
	contentBubble.name = "contentBubble";
	stage.addChild(contentBubble);
}

function addBubble(e:TimerEvent)
{	
	var Bubble:bubble;
	var Bomp:bomp;
	var nBubble:int = Math.round(stage.stageWidth/140);
	if(nBubble > 10)
	{
		nBubble = 10;
	}
	for(var i:int = 0; i <= nBubble; i++)
	{		
		Bubble = new bubble();
		Bubble.buttonMode = true;
		this.contentBubble.addChild(Bubble);
		// add bomp
		if(Math.round(Math.random()*10) == 1)
		{
			Bomp = new bomp();
			Bomp.buttonMode = true;
			this.contentBubble.addChild(Bomp);
		}
	}
}

function titleAnimation()
{
	Title.scaleX = Title.scaleY = 1;
	scale(Title, stage.stageWidth/2, stage.stageHeight/3, false);
	var point = align(Title, "center");
	Title.x = point.x;
	Title.y = point.y;
	setTimeout(function(){objMove(Title, align(Title, "top-left"), 500, 20);}, 2000);
}

function objMove(obj:Object, endPoint:Point, duration:Number, fps:int = 24, scale:Number = 0.05)
{
	var speed:Point = new Point(0, 0);
	speed.x = (endPoint.x - obj.x)/(duration/fps);
	speed.y = (endPoint.y - obj.y)/(duration/fps);
	var objTimer:Timer = new Timer(fps, duration/fps);
	objTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent){
							  obj.x += speed.x;
							  obj.y += speed.y;
							  obj.scaleX -= scale;
							  obj.scaleY -= scale;
							  });
	objTimer.start();
	objTimer.addEventListener(TimerEvent.TIMER_COMPLETE, addWaterMachine);	
}

function countdownPlay():void
{
	scale(Countdown, stage.stageWidth/3, stage.stageHeight/3, false);
	var cPoint:Point = align(Countdown, "center");
	Countdown.x = cPoint.x;
	Countdown.y = cPoint.y;
	stage.addChild(Countdown);
	var countdownTimer:Timer = new Timer(1000, 4);
	countdownTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent){
									Countdown.txtCountdown.nextFrame();
									});
	countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
									timer.start();
									Countdown.visible = false;
									Countdown.mskCountdown.stop();
									TimeLeft.time.text = String(duration) + " s";
									scale(TimeLeft, stage.stageWidth/4, stage.stageHeight/6, false);
									cPoint = align(TimeLeft, 'bottom-right');
									TimeLeft.x = cPoint.x - Logo.height;
									TimeLeft.y = cPoint.y - Logo.height;
									stage.addChild(TimeLeft);
									leftTimer.start();
									// BonusPlayer
									BonusPlayer.visible = false;
									BonusPlayer.value.text = "0";
									scale(BonusPlayer, stage.stageWidth/4, stage.stageHeight/6, false);
									cPoint = align(BonusPlayer, 'bottom-left');
									BonusPlayer.x = cPoint.x + Logo.height;
									BonusPlayer.y = cPoint.y - Logo.height;
									stage.addChild(BonusPlayer);
									Countdown.visible = false;
									WaterMachine.visible = false;
									});
	countdownTimer.start();
	Countdown.mskCountdown.play();
}

function controlGame(e:Object):void
{
	trace(e.target.name);
	var bonusValue:MovieClip;
	var objParent:MovieClip;
	var plusSound:PlusSound = new PlusSound();
	var minusSound:MinusSound = new MinusSound();
	var bomSound:BompSound = new BompSound();
	switch(e.target.name)
	{
		case "txtValue":
		{
			bonusValue = MovieClip(e.target.parent);
			objParent = MovieClip(bonusValue.parent);
			bonusValue.play();
			objParent.bubble.play();
			if(Number(bonusValue.txtValue.text) > 0)
			{
				minusSound.play();
			}
			else
			{
				plusSound.play();
			}
			BonusPlayer.value.text = String( Number(BonusPlayer.value.text) + Number(bonusValue.txtValue.text));
			break;
		}
		case "bubble":
		{
			plusSound.play();
			minusSound.play();
			objParent = MovieClip(e.target.parent);
			objParent.bubble.play();
			objParent.bonusValue.play();
			if(Number(objParent.bonusValue.txtValue.text) > 0)
			{
				minusSound.play();
			}
			else
			{
				plusSound.play();
			}
			BonusPlayer.value.text = String( Number(BonusPlayer.value.text) + Number(objParent.bonusValue.txtValue.text));
			break;
		}
		case "bomp":
		{
			objParent = MovieClip(e.target.parent);
			objParent.bomp.play();
			bomSound.play();
			BonusPlayer.value.text = "0";
			stopGame(null);
			break;
		}
		case "replay":
		{
			/*bonusInfo.visible = false;
			TimeLeft.visible = true;
			//BonusPlayer.visible = true;
			count = duration;
			TimeLeft.time.text = String(count) + " s";
			BonusPlayer.value.text = "0";
			leftTimer = new Timer(1000, duration);				
			leftTimer.addEventListener(TimerEvent.TIMER, controlTimeLeft);
			leftTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopGame);
			soundChannel = sound.play(0, 99999999);
			leftTimer.start();
			timer.start();*/
			/*var _stage:DisplayObjectContainer = stage as DisplayObjectContainer;
			while (_stage.numChildren > 0) {
   				try{_stage.removeChildAt(0);}catch(e:Error){}
			}*/
			gotoAndPlay(1);
			break;
		}
		case 'play':
		{			
			btnPlay.visible = false;
			WaterMachine.play();
			setTimeout(countdownPlay, 1000);
			break;
		}
	}
}

function align(obj:Object, txtAlign):Point
{
	var pt:Point = new Point(0, 0);
	switch(txtAlign)
	{
		case "left":
		{
			pt.x = 0;
			break;
		}
		case "right":
		{
			pt.x = stage.stageWidth - obj.width;
			break;
		}
		case "center":
		{
			pt.x = (stage.stageWidth - obj.width)/2;
			pt.y = (stage.stageHeight - obj.height)/2;
			break;
		}
		case "top":
		{
			pt.y = 0;
			break;
		}
		case "bottom":
		{
			pt.y = stage.stageHeight - obj.height;
			break;
		}
		case "top-left":
		{
			pt.x = pt.y = 0;
			break;
		}
		case "top-right":
		{
			pt.x = stage.stageWidth - obj.width;
			pt.y = 0;
			break;
		}
		case "bottom-left":
		{
			pt.x = 0;
			pt.y = stage.stageHeight - obj.height;
			break;
		}
		case "bottom-right":
		{
			pt.x = stage.stageWidth - obj.width;
			pt.y = stage.stageHeight - obj.height;
			break;
		}		
		case "bottom-center":
		{
			pt.x = (stage.stageWidth - obj.width)/2;
			pt.y = stage.stageHeight - obj.height;
			break;
		}
		case "center-left":
		{
			pt.x = 0;
			pt.y = (stage.stageHeight - obj.height)/2;
			break;
		}
		case "center-right":
		{
			pt.x = stage.stageWidth - obj.width;
			pt.y = (stage.stageHeight - obj.height)/2;
			break;
		}
	}
	return pt;
}
resizeStage(null);
stop();