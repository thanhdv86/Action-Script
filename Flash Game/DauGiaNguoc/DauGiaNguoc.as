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
import functionName;
import timeLeft;
import countdown;
import selectSound.mp3;
import countSound;
import replay;
import PlayBTN;
import InputBTN;
import WinerBTN;
import ExportBTN;
import soundControl;
import shadow;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.filesystem.File;
import flash.filesystem.FileStream;
import flash.filesystem.FileMode;
import fl.data.DataProvider;
import fl.controls.dataGridClasses.DataGridColumn;
import flash.events.Event;
import flash.net.FileReference;
import flash.display.NativeWindow;

var trueIcons:Array = new Array();
var iconSelected:MovieClip = null;
var Content:parentContent = new parentContent();
var bg:background = new background();
var Title:title = new title();
var Logo:logo = new logo();
var FunctionName:functionName = new functionName();
var TimeLeft:timeLeft = new timeLeft();
var btnSound:soundControl = new soundControl();
btnSound.name = "sound";
var sound:soundTrack = new soundTrack();
var soundChannel:SoundChannel = new SoundChannel();
soundChannel = sound.play(0, 9999999999999);
btnSound.gotoAndStop("on");
var strEndTime:String = "";
var duration:int = 30;
var maxIcon:int = 4;
var count:int = duration;
var frmInfo:form = new form();
frmInfo.name = "frmInfo";
var leftTimer:Timer;
var isStart:Boolean = true;
var btnReplay:replay = new replay();
btnReplay.name = "replay";
var btnPlay:PlayBTN = new PlayBTN();
btnPlay.name = "play";
var btnInput:InputBTN = new InputBTN();
btnInput.name = "input";
var btnWiner:WinerBTN = new WinerBTN();
btnWiner.name = "winer";
var btnExport:ExportBTN = new ExportBTN();
btnExport.name = "export";
var mcShadow:shadow = new shadow();
mcShadow.name = "shadow";
var price:Number = 5000000;
var indexWiner:int = -1;
var arrPerson:Array = new Array();
var countPerson:Number = 0;
var fileData = null;
var fileName:String = "";
var hasHeaders:Boolean = true;
mcShadow.visible = false;
btnSound.visible = false;
btnExport.buttonMode = true;
btnExport.visible = false;
btnWiner.visible = false;
btnInput.visible = false;
btnPlay.visible = false;
btnReplay.visible = false;
TimeLeft.visible = false;
frmInfo.visible = false;
FunctionName.visible = false;
stage.addChild(bg);
stage.addChild(Content);
stage.addChild(FunctionName);
stage.addChild(btnReplay);
stage.addChild(btnPlay);
stage.addChild(btnInput);
stage.addChild(btnWiner);
stage.addChild(btnExport);
stage.addChild(btnSound);
stage.addChild(TimeLeft);
stage.addChild(mcShadow);
stage.addChild(frmInfo);
stage.addChild(Title);
stage.addChild(Logo);

stage.align = StageAlign.TOP_LEFT;
stage.scaleMode = StageScaleMode.NO_SCALE;
stage.nativeWindow.addEventListener(Event.CLOSING, saveData);
stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeStage);

setTimeout(function(){objMove(Title, align(Title, "top-left"), 500, 20, 0.04);}, 2000);
soundChannel.addEventListener(Event.SOUND_COMPLETE,loopSound);
function loopSound(e:Event)
{
	soundChannel = sound.play(0,99999999999999);
}
function addFunctionName(e:TimerEvent)
{
	Title.x += Logo.height/2;
	Title.y += Logo.height/2;
	var WMPoint: Point;
	scale(FunctionName, stage.stageWidth, stage.stageHeight*2/3, true);
	WMPoint = align(FunctionName, "bottom-center");
	FunctionName.x = WMPoint.x;
	FunctionName.y = WMPoint.y;
	FunctionName.visible = true;
	FunctionName.play();
	setTimeout(function(){			
				createArrayList();
			   	frmInfo.visible = true;
				frmInfo.gotoAndStop("start");	
				viewShadow();
				stage.addEventListener(MouseEvent.CLICK, selectedContent);
				stage.addEventListener(TouchEvent.TOUCH_TAP,selectedContent);}, 1000);
}

function stopGame(e:TimerEvent):void
{
	TimeLeft.time.text = "";
	TimeLeft.visible = btnInput.visible = frmInfo.visible = false;
	if(countPerson > 0)
	{
		btnWiner.visible = true;
		btnExport.visible = true;
	}
}

function resizeStage(e:NativeWindowBoundsEvent):void
{
	var newPoint:Point;
	// resize background
	scale(bg, stage.stageWidth, stage.stageHeight, true);
	bg.x = stage.stageWidth/2;
	bg.y = stage.stageHeight/2 - (bg.height - stage.stageHeight)/2;
	// resize mcShadow
	mcShadow.x = mcShadow.y = 0;
	mcShadow.width = stage.stageWidth;
	mcShadow.height = stage.stageHeight;
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
	// btnPlay
	scale(btnPlay, stage.stageWidth/8, stage.stageWidth/8, false);
	newPoint = align(btnPlay, "bottom-left");
	btnPlay.x = newPoint.x + Logo.height;
	btnPlay.y = newPoint.y - Logo.height/2;
	// btnWiner
	scale(btnWiner, stage.stageWidth/3, stage.stageWidth/8, false);
	btnWiner.x = btnPlay.x;
	btnWiner.y = btnPlay.y;
	// btnInput
	scale(btnInput, stage.stageWidth/8, stage.stageWidth/8, false);
	btnInput.x = btnPlay.x;
	btnInput.y = btnPlay.y - btnWiner.height;
	// btnWiner
	scale(btnExport, stage.stageWidth/18, stage.stageWidth/18, false);
	newPoint = align(btnExport, "bottom-right");
	btnExport.x = newPoint.x - Logo.height;
	btnExport.y = newPoint.y - Logo.height;
	//btnReplay
	scale(btnReplay, Logo.height*2, Logo.height*2, false);
	newPoint = align(btnReplay, "bottom-right");
	btnReplay.x = newPoint.x - Logo.height - btnExport.width - 10;
	btnReplay.y = newPoint.y - Logo.height;
	//btnSound
	scale(btnSound, Logo.height*2, Logo.height*2, false);
	newPoint = align(btnSound, "bottom-right");
	btnSound.x = btnReplay.x - btnReplay.width - 10;
	btnSound.y = btnReplay.y;
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
	scale(FunctionName, stage.stageWidth, stage.stageHeight*2/3, true);
	newPoint = align(FunctionName, "bottom-center");
	FunctionName.x = newPoint.x;
	FunctionName.y = newPoint.y;
	// Timeleft
	scale(TimeLeft, stage.stageWidth/4, stage.stageHeight/6, false);
	newPoint = align(TimeLeft, 'bottom-right');
	TimeLeft.x = newPoint.x - Logo.height;
	TimeLeft.y = newPoint.y - Logo.height;	
	// Form info
	scale(frmInfo, stage.stageWidth*2/3, stage.stageHeight*2/3, false);
	newPoint = align(frmInfo, "center");
	frmInfo.x = newPoint.x;
	frmInfo.y = newPoint.y;
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
	objTimer.addEventListener(TimerEvent.TIMER_COMPLETE, addFunctionName);
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
	trace(e.target.name);
	var selectItem = (e.target);
	var selectAudio:selectSound.mp3 = new selectSound.mp3();
	switch (e.target.name)
	{
		case 'btnCancel' :
			{
				frmInfo.visible = false;
				mcShadow.visible = false;
				break;
			};
		case 'btnOK' :
			{
				//Input data
				setTimeout(function(){
						   if(frmInfo.frmInput.txtAlert.text == "")
						   {
							   inputDataPerson();
							   frmInfo.visible = false;
							   mcShadow.visible = false;
						   }}, 10);
				break;
			}	
		case 'replay':
		{
			soundChannel.stop();
			gotoAndPlay(1);
			break;
		}
		case 'play':
		{			
			frmInfo.visible = true;
			frmInfo.gotoAndStop("start");
			break;
		}
		case 'openData':
		{
			openFileDialog(MouseEvent(e));
			break;
		}
		case 'newData':
		{	
			if(frmInfo.frmStart.txtFileName.text != "" && frmInfo.frmStart.txtFileName.text != "Nhập tên file mới")
			{
				saveFileDiag(MouseEvent(e));
			}
			break;
		}
		case 'input':
		{
			frmInfo.gotoAndStop("input");
			frmInfo.frmInput.clearData();
			frmInfo.visible = true;
			viewShadow();
			break;
		}
		case 'winer':
		{
			if(countPerson > 0)
				{
				if(indexWiner == -1)
				{
					frmInfo.gotoAndStop("selectDate");
					frmInfo.frmSelectDate.clearData();
				}
				else
				{
					showWiner();
				}
				frmInfo.visible = true;
				viewShadow();
			}
			break;
		}
		case 'btnDauGia':
		{
			if(frmInfo.frmSelectDate.txtAlert.text == "")
			{
				showWiner();
				btnInput.visible = false;
				viewShadow();
			}
			break;
		}
		case 'btnViewInfo':
		{
			showWiner();
			break;
		}
		case 'btnDestroy':
		{
			arrPerson[dateSelect][indexWiner].splice(0, 1);
			indexWiner = -1;
			countPerson--;
			if(countPerson <= 0)
			{
				btnWiner.visible = false;
			}
			frmInfo.visible = false;
			mcShadow.visible = false;
			break;
		}
		case 'export':
		{			
			exportDataToCSV();
			break;
		}
		case 'sound':
		{			
			if(MovieClip(selectItem).currentLabel == "on")
			{
				soundChannel.removeEventListener(Event.SOUND_COMPLETE,loopSound);
				this.soundChannel.stop();
				MovieClip(selectItem).gotoAndStop('off');
			}
			else
			{
				this.soundChannel = this.sound.play(0, 9999999999);
				MovieClip(selectItem).gotoAndStop('on');
				soundChannel.addEventListener(Event.SOUND_COMPLETE,loopSound);
			}
			break;
		}
	}
};

function viewShadow()
{
	mcShadow.x = mcShadow.y = 0;
	mcShadow.width = stage.stageWidth;
	mcShadow.height = stage.stageHeight;
	mcShadow.visible = true;
}

function inputDataPerson()
{
	var selectPrice:int = int(frmInfo.frmInput.txtPrice.text);
	var selectDay:String = (frmInfo.frmInput.cbDay.selectedIndex == -1)?"":frmInfo.frmInput.cbDay.selectedItem.label;
	var index:int = 0;
	while(index < strday.length && strday[index].toUpperCase() != selectDay.toUpperCase())
	{
		index++;
	}
	trace("index = " + index);
	arrPerson[index][selectPrice][arrPerson[index][selectPrice].length] = new Array(frmInfo.frmInput.txtName.text, frmInfo.frmInput.txtPhoneNumber.text);
	countPerson++;
	saveData(null);
}

function createArrayList()
{
	var index:int = 0;
	while(index <= 6)
	{
		arrPerson[index] = new Array();
		for(var i:int = 1 ; i <= Math.floor(price/1000); i++)
		{
			arrPerson[index][i] = new Array();
		}
		index = index + 6;
	}
}

function exportDataToCSV()
{
	var stt:int = 1; var date:Date = new Date();
	var data:String = "STT;HỌ TÊN;SỐ ĐIỆN THOẠI;GIÁ ĐẤU;NGÀY ĐẤU GIÁ\n";
	var index:int = 0;
	while(index <= 6)
	{
		for(var i:int = 1; i <= Math.floor(price/1000); i++)
		{
			for(var j:int = 0; j < arrPerson[index][i].length; j++)
			{
				data += stt + ";" + arrPerson[index][i][j][0] + ";" + arrPerson[index][i][j][1] + ";" + String(i*1000) + ";" + strday[index] + "\n";
				stt++;
			}
		}
		index = index + 6;
	}
	trace(Math.floor(price/1000));
	trace(arrPerson.length);
	var csvFile:File = File.documentsDirectory.resolvePath("data" + date.time + ".csv");
	trace(csvFile.exists);
	var fs:FileStream = new FileStream();    
	fs.open( csvFile, FileMode.WRITE);    
	fs.writeByte(239); //0xEF
  	fs.writeByte(187);  //0xBB
  	fs.writeByte(191); //0xBF
	fs.writeUTFBytes(data);                  
	fs.close();  
	csvFile.openWithDefaultApplication();
}

function saveData(e:Event)
{
	var stt:int = 1; var date:Date = new Date();	
	var data:String = "STT;HỌ TÊN;SỐ ĐIỆN THOẠI;GIÁ ĐẤU;NGÀY ĐẤU GIÁ\n";
	var index:int = 0;
	while(index <= 6)
	{
		for(var i:int = 1; i <= Math.floor(price/1000); i++)
		{
			for(var j:int = 0; j < arrPerson[index][i].length; j++)
			{
				data += stt + ";" + arrPerson[index][i][j][0] + ";" + arrPerson[index][i][j][1] + ";" + String(i*1000) + ";" + strday[index] + "\n";
				stt++;
			}
		}
		index = index + 6;
	}
	var csvFile:File = File.documentsDirectory.resolvePath("temp" + date.time + ".csv");
	trace(csvFile.exists);
	var fs:FileStream = new FileStream();    
	fs.open(csvFile, FileMode.WRITE);    
	fs.writeByte(239); //0xEF
  	fs.writeByte(187);  //0xBB
  	fs.writeByte(191); //0xBF
	fs.writeUTFBytes(data);             
	fs.close(); 
	
	if(fileName != "")
	{
		csvFile.moveToAsync(File.documentsDirectory.resolvePath(fileName), true);
		frmInfo.visible = false;
	}
	else if(fileData != null)
	{
		csvFile.moveToAsync(File.documentsDirectory.resolvePath(fileData.nativePath), true);
	}
	btnInput.visible = true;
	btnWiner.visible = true;
}

function showWiner()
{
	var index:int = 0;
	if(dateSelect == -1)
	{
		while(index < strday.length && strday[index].toUpperCase() != String(frmInfo.frmSelectDate.cbDay.selectedItem.label).toUpperCase())
		{
			index++;
		}
	}
	else
	{
		index = dateSelect;
	}
	if(arrPerson[index] != null)
	{
		dateSelect = index;
		if(indexWiner == -1)
		{
			for(var i:int = 1; i < arrPerson[index].length; i++)
			{
				if(arrPerson[index][i].length == 1)//is winer
				{
					indexWiner = i;
					animationSeachData(indexWiner);
					break;
				}
			}
		}
		else
		{
			frmInfo.gotoAndStop('winer');
			frmInfo.frmWiner.txtName.text = arrPerson[index][indexWiner][0][0];
			frmInfo.frmWiner.txtPhoneNumber.text = arrPerson[index][indexWiner][0][1];
			frmInfo.frmWiner.txtPrice.text = String(indexWiner*1000) + " VNĐ";
			frmInfo.visible = true;
		}
	}
}

function animationSeachData(indexWiner:int)
{
	var arrTemp:Array = new Array();
	var index:int = 0;
	for(var i:int = 1; i < arrPerson[dateSelect].length; i++)
	{
		for(var j:int = 0; j < arrPerson[dateSelect][i].length; j++)
		{
			arrTemp[index] = new Array();
			arrTemp[index][0] = arrPerson[dateSelect][i][j][0];
			arrTemp[index][1] = String(i*1000) + " VNĐ";
			index++;
		}
		if(arrPerson[dateSelect][i].length == 1)
		{
			break;
		}
	}
	var timer:Timer = new Timer(500, arrTemp.length);
	index = 0;
	frmInfo.gotoAndStop("search");
	frmInfo.frmSearch.clearData();
	frmInfo.visible = true;
	timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent){
						   frmInfo.frmSearch.txtInfo.text = arrTemp[index][0] + "   " + arrTemp[index][1];
						   index++;
						   });
	timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent){
						   frmInfo.frmSearch.btnViewInfo.visible = frmInfo.frmSearch.btnCancel.visible = true;
						   frmInfo.frmSearch.effect.play();
						   frmInfo.frmSearch.txtChucMung.visible = true;
						   });
	timer.start();
}

function saveFileDiag(e:MouseEvent):void
{
	fileData = new FileReference();	
	fileData = File.documentsDirectory.resolvePath(frmInfo.frmStart.txtFileName.text + ".csv");
	fileData.browseForDirectory("Tạo mới dữ liệu");
	fileData.addEventListener(Event.SELECT, selectPath);
}

function openFileDialog(e:MouseEvent):void
{
	fileData = new File();	
	var csvFileTypes:FileFilter = new FileFilter("CSV File (*.csv)", "*.csv");	
	fileData.browseForOpen("Mở file dữ liệu", [csvFileTypes]);
	fileData.addEventListener(Event.SELECT, selectFile);
}

function selectPath(e:Event)
{
	fileName = fileData.nativePath + String.fromCharCode(92) + frmInfo.frmStart.txtFileName.text + ".csv";
	saveData(e);	
	btnReplay.visible = btnExport.visible = btnSound.visible = true;
	mcShadow.visible = false;
}

function selectFile(e:Event):void
{
	fileData.addEventListener(Event.COMPLETE, loadFile);
	fileData.load();
}

function loadFile(e:Event):void
{
	trace(fileData.data.toString());
	trace(fileData.nativePath);
	var myData:String = fileData.data.toString();
	var myDataRows:Array = myData.split("\n");
	var startInd:int = (hasHeaders) ? 1 : 0;
	for (var i:int = startInd; i < myDataRows.length-startInd; i++)
	{
		var arrCell = new Array();
		arrCell = myDataRows[i].split(";");
		var index:int = 0;
		while(index < strday.length && strday[index].toUpperCase() != String(arrCell[4]).toUpperCase())
		{
			index++;
		}
		arrPerson[index][int(arrCell[3]/1000)][arrPerson[index][int(arrCell[3]/1000)].length] = new Array(String(arrCell[1]), String(arrCell[2]));
		countPerson++;
	}
	frmInfo.visible = false;
	mcShadow.visible = false;
	btnInput.visible = btnWiner.visible = true;	
	btnReplay.visible = btnExport.visible = btnSound.visible = true;
}

var d:Date = new Date();
var dateSelect:int = -1;
var strday = new Array("Chủ nhật","Thứ hai", "Thứ ba", "Thứ tư", "Thứ năm", "Thứ sáu", "Thứ bảy");
trace(strday[d.day]);
stop();