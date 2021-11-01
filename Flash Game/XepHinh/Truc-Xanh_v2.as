import flash.events.MouseEvent;
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
import flash.text.TextField;
import flash.display.MovieClip;
import parentContent;
import background;
import title;
import logo;
import waterMachine;
import timeLeft;
import countdown;
import selectSound.mp3;
import countSound;
import replay;
import PlayBTN;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;

var trueIcons:Array = new Array();
var iconSelected:MovieClip = null;
var Content:parentContent = new parentContent();
var bg:background = new background();
var Title:title = new title();
var Logo:logo = new logo();
var WaterMachine:waterMachine = new waterMachine();
var Countdown:countdown = new countdown();
var TimeLeft:timeLeft = new timeLeft();
var sound:soundTrack = new soundTrack();
var soundChannel:SoundChannel = new SoundChannel();
soundChannel = sound.play(0, 9999999999999);
var soundTimer:countSound = new countSound();
var soundTimerChanel:SoundChannel = new SoundChannel();
var duration:int = 30;
var maxIcon:int = 3;
var count:int = duration;
var alertInfo:alert = new alert();
var leftTimer:Timer = new Timer(1000, duration);
var timer:Timer = new Timer(1000);
var isStart:Boolean = true;
var btnReplay:replay = new replay();
btnReplay.name = "replay";
var btnPlay:PlayBTN = new PlayBTN();
btnPlay.name = "play";
btnPlay.visible = false;
btnReplay.visible = false;
TimeLeft.visible = false;
alertInfo.visible = false;
stage.addChild(bg);
stage.addChild(Content);
stage.addChild(alertInfo);
stage.addChild(btnReplay);
stage.addChild(btnPlay);
stage.addChild(Title);
stage.addChild(Logo);
stage.addChild(TimeLeft);

stage.align = StageAlign.TOP_LEFT;
stage.scaleMode = StageScaleMode.NO_SCALE;
stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeStage);

leftTimer.addEventListener(TimerEvent.TIMER, controlTimeLeft);
leftTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopGame);
setTimeout(function(){objMove(Title, align(Title, "top-left"), 500, 20, 0.04);}, 2000);

function addWaterMachine(e:TimerEvent)
{
	Title.x += Logo.height/2;
	Title.y += Logo.height/2;
	var WMPoint: Point;
	scale(WaterMachine, stage.stageWidth*2/3, stage.stageHeight*8/10, false);
	WMPoint = align(WaterMachine, "bottom-center");
	WaterMachine.x = WMPoint.x;
	WaterMachine.y = WMPoint.y;
	stage.addChild(WaterMachine);
	WaterMachine.play();
	setTimeout(function(){
			   	btnPlay.visible = true;			   
				stage.addEventListener(MouseEvent.CLICK, selectedContent);
				stage.addEventListener(TouchEvent.TOUCH_TAP,selectedContent);}, 4300);
}

function controlTimeLeft(e:TimerEvent):void
{
	count--;
	TimeLeft.time.text = String(count) + " s";
	if(count == 1){
		timer.stop();
	}	
	if(count == 5){
		soundTimerChanel = soundTimer.play();
	}
}

function stopGame(e:TimerEvent):void
{
	var pt:Point = new Point(0, 0);
	Content.gotoAndStop(1);
	TimeLeft.visible = false;
	btnReplay.visible = true;
	soundTimerChanel.stop();
	leftTimer.stop();
	if(trueIcons.length < maxIcon)//gameover
	{
		alertInfo.gotoAndStop('gameOver');
	}
	else //Winer
	{
		alertInfo.gotoAndStop('winner');
		var trueIcon:Object;
		for(var i:int = 0; i < alertInfo.numChildren; i++)
		{
			trueIcon = alertInfo.getChildAt(i);
			if(trueIcon.name.length >= 8 && trueIcon.name.substr(0, 8) == "trueIcon")
			{
				MovieClip(trueIcon).gotoAndStop(trueIcons[0]);
				MovieClip(trueIcon).visible = true;
				trueIcons.splice(0, 1);
				if(trueIcons.length <= 0){
					break;
				}
			}
		}
		for(var j:int = 2; j <= maxIcon; j++){
			alertInfo.getChildByName("trueIcon" + String(j)).y = alertInfo.getChildByName("trueIcon" + String(j-1)).y + alertInfo.getChildByName("trueIcon" + String(j-1)).height + 10;
		}
		/*alertInfo.trueIcon2.y = alertInfo.trueIcon1.y + alertInfo.trueIcon1.height + 10;
		alertInfo.trueIcon3.y = alertInfo.trueIcon2.y + alertInfo.trueIcon2.height + 10;*/
	}
	scale(alertInfo, stage.stageWidth, stage.stageHeight*8/10, false);
	pt = align(alertInfo, "center");
	alertInfo.x = pt.x;
	alertInfo.y = pt.y;
	alertInfo.visible = true;		
	stage.addEventListener(MouseEvent.CLICK, selectedContent);
	stage.addEventListener(TouchEvent.TOUCH_TAP,selectedContent);
}

function resizeStage(e:NativeWindowBoundsEvent):void
{
	var newPoint:Point;
	// resize background
	scale(bg, stage.stageWidth, stage.stageHeight, true);
	bg.x = stage.stageWidth/2;
	bg.y = stage.stageHeight/2 - (bg.height - stage.stageHeight)/2;
	// resize content	
	scale(Content, stage.stageWidth*9/10, stage.stageHeight*7/10, false);
	newPoint = align(Content, "center");
	Content.x = newPoint.x;
	Content.y = newPoint.y + stage.stageHeight/20;
	// resize logo
	Logo.scaleX = Logo.scaleY = 1;
	scale(Logo, stage.stageWidth/8, stage.stageHeight/15, false);
	newPoint = align(Logo, "top-right");
	Logo.x = newPoint.x - Logo.height;
	Logo.y = newPoint.y + Logo.height;
	//btnReplay
	scale(btnReplay, Logo.height*2, Logo.height*2, false);
	newPoint = align(btnReplay, "bottom-left");
	btnReplay.x = newPoint.x + Logo.height;
	btnReplay.y = newPoint.y - Logo.height;
	// btnPlay
	scale(btnPlay, stage.stageWidth/5, stage.stageHeight/15, false);
	btnPlay.x = btnReplay.x + 10;
	btnPlay.y = btnReplay.y;
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
	scale(WaterMachine, stage.stageWidth/2, stage.stageHeight*8/10, false);
	newPoint = align(WaterMachine, "bottom-center");
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
	TimeLeft.x = newPoint.x - Logo.height;
	TimeLeft.y = newPoint.y - Logo.height;	
	// Bonus info
	scale(alertInfo, stage.stageWidth, stage.stageHeight, false);
	newPoint = align(alertInfo, "center");
	alertInfo.x = newPoint.x;
	alertInfo.y = newPoint.y;
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

function titleAnimation()
{
	Title.scaleX = Title.scaleY = 1;
	scale(Title, stage.stageWidth/2, stage.stageHeight/3, false);
	var point = align(Title, "center");
	Title.x = point.x;
	Title.y = point.y;
	setTimeout(function(){
			   point = align(Title, "top-left");
			   point.x += Logo.height/2;
			   point.y += Logo.height/2;
			   objMove(Title, point, 500, 20);}, 2000);
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
									Content.play();
									setTimeout(showIcon, 4500);
									Countdown.visible = false;
									Countdown.mskCountdown.stop();
									Countdown.visible = false;
									WaterMachine.visible = false;
									});
	countdownTimer.start();
	Countdown.mskCountdown.play();
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

function selectedContent(e:Object)
{
	var selectItem = (e.target);
	var selectAudio:selectSound.mp3 = new selectSound.mp3();
	switch (e.target.name)
	{
		case 'icon' :
			{
				
				break;


			};
		case 'content' :
			{
				selectAudio.play();
				MovieClip(selectItem).play();
				setTimeout(function(){controlGame(MovieClip(selectItem));}, 10);
				break;


			};
		case 'value' :
			{
				selectAudio.play();
				MovieClip(TextField(selectItem).parent).play();
				setTimeout(function(){controlGame(MovieClip(TextField(selectItem).parent));}, 10);
				break;


		}
		case 'replay':
		{
			/*alertInfo.visible = false;
			count = duration;
			TimeLeft.time.text = String(count) + " s";
			leftTimer = new Timer(1000, duration);				
			leftTimer.addEventListener(TimerEvent.TIMER, controlTimeLeft);
			leftTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopGame);
			stage.removeEventListener(MouseEvent.CLICK, selectedContent);
			stage.removeEventListener(TouchEvent.TOUCH_TAP,selectedContent);
			Content.play();soundChannel = sound.play(0, 99999999);
			setTimeout(hideIcon, 10000);
			trueIcons = new Array();
			iconSelected = null;*/
			leftTimer.removeEventListener(TimerEvent.TIMER, controlTimeLeft);
			leftTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopGame);
			gotoAndPlay(1);
			break;
		}
		case 'play1':
		{			
			maxIcon = 3;
			stage.removeEventListener(MouseEvent.CLICK, selectedContent);
			stage.removeEventListener(TouchEvent.TOUCH_TAP,selectedContent);
			btnPlay.visible = false;
			WaterMachine.play();
			setTimeout(countdownPlay, 1000);
			break;
		}
		case 'play2':
		{	
			maxIcon = 4;
			stage.removeEventListener(MouseEvent.CLICK, selectedContent);
			stage.removeEventListener(TouchEvent.TOUCH_TAP,selectedContent);
			btnPlay.visible = false;
			WaterMachine.play();
			setTimeout(countdownPlay, 1000);
			break;
		}
		case 'play3':
		{	
			maxIcon = 5;
			stage.removeEventListener(MouseEvent.CLICK, selectedContent);
			stage.removeEventListener(TouchEvent.TOUCH_TAP,selectedContent);
			btnPlay.visible = false;
			WaterMachine.play();
			setTimeout(countdownPlay, 1000);
			break;
		}
	}
};

function controlGame(obj:MovieClip):void
{
	if(obj.currentLabel == 'active')
	{
		MovieClip(obj.parent).gotoAndPlay('show');
		if(iconSelected != null && iconSelected.parent.name != obj.parent.name)
		{
			trace("show");
			obj.gotoAndStop("inactive");
			iconSelected.gotoAndStop("inactive");
			MovieClip(obj.parent).gotoAndPlay('show');
			//MovieClip(iconSelected.parent).gotoAndPlay('show');
			// check true selected image
			if(MovieClip(obj.parent).icon.currentFrame == MovieClip(iconSelected.parent).icon.currentFrame)
			{
				trace("yes");				
				var trueSelectSound:trueSound = new trueSound();
				trueSelectSound.play();
				trueIcons.push(MovieClip(obj.parent).icon.currentFrame);
				if(trueIcons.length == maxIcon)
				{
					stage.removeEventListener(MouseEvent.CLICK, selectedContent);
					stage.removeEventListener(TouchEvent.TOUCH_TAP,selectedContent);
					setTimeout(function(){stopGame(null);}, 1000);
				}
				iconSelected = null;
			}
			else
			{
				trace("no");
				var faleSelectSound:falseSound = new falseSound();
				faleSelectSound.play();
				stage.removeEventListener(MouseEvent.CLICK, selectedContent);
				stage.removeEventListener(TouchEvent.TOUCH_TAP,selectedContent);
				setTimeout(function(){
				MovieClip(obj.parent).gotoAndPlay('hide');
				MovieClip(iconSelected.parent).gotoAndPlay('hide');
				iconSelected = null;
				stage.addEventListener(MouseEvent.CLICK, selectedContent);
				stage.addEventListener(TouchEvent.TOUCH_TAP,selectedContent);}, 1000);
			}
		}
		else
		{
			iconSelected = obj;
		}
	}
}
function showIcon():void
{
	var _icon:Object;
	var children:MovieClip;
	for(var i:int = 0; i < Content.numChildren; i++)
	{
		_icon = Content.getChildAt(i);
		if(_icon.name != 'bgContent')
		{			
			children = MovieClip(MovieClip(_icon).getChildByName(String(i)));
			children.gotoAndPlay('show');
		}
	}
	setTimeout(hideIcon, 2000);
}

function hideIcon():void
{
	var _icon:Object;
	var children:MovieClip;
	for(var i:int = 0; i < Content.numChildren; i++)
	{
		_icon = Content.getChildAt(i);
		if(_icon.name != 'bgContent')
		{			
			children = MovieClip(MovieClip(_icon).getChildByName(String(i)));
			children.gotoAndPlay('hide');
		}
	}
	setTimeout(function(){stage.addEventListener(MouseEvent.CLICK, selectedContent);
			   				stage.addEventListener(TouchEvent.TOUCH_TAP,selectedContent);
			   				soundChannel.stop();
							TimeLeft.time.text = String(duration) + " s";
							scale(TimeLeft, stage.stageWidth/4, stage.stageHeight/6, false);
							var tPoint:Point;
							tPoint = align(TimeLeft, 'bottom-right');
							TimeLeft.x = tPoint.x - Logo.height;
							TimeLeft.y = tPoint.y - Logo.height;
							TimeLeft.visible = true;
							leftTimer.start();}, 800);
}
stop();