// target _blank
function externallinks() {
 if (!document.getElementsByTagName) return;
 var anchors = document.getElementsByTagName("a");
 for (var i=0; i<anchors.length; i++) {
   var anchor = anchors[i];
   if (anchor.getAttribute("href") &&
       anchor.getAttribute("rel") == "external")
     anchor.target = "_blank";
 }
} 

function getBrowser(){
	return navigator.userAgent;
	//alert(navigator.userAgent); 
}
//open window
function openWindow(url,name,features){
 if (name==null) name='_blank';
 if (features==null) features='';
 window.open(url,name,features); 
}

function popwindow(Page,wh,ht,scr){
if (false)window.close();
 if  (!window.win || win.closed)  win=open(Page,"","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,width="+wh+",height="+ht+"");
 else{
  win.close();   win=open(Page,"","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,width="+wh+",height="+ht+"");
  } 
}

function openFullWindow(url,name) {
	// parameters:	url = URL of the popup window
	var w = screen.availWidth; //fixed width
	var h = screen.availHeight; //fixed height
	//var url = url_full;
	//if(w <= 800) {
	//	url = url_800;
	//}
	leftPosition = 0;		// centering horizontal position to middle of screen
	topPosition = 0;	// centering vertical position to middle of screen
	//if (h<645)
	//{
//		var windowprops = 'width=' + w + ',height=' + h + ',top='+ topPosition +',left='+ leftPosition +',toolbar=no,location=no,directories=no,status=no,scrollbars=yes,menubar=no,resizable=yes'; //set popup window properties
//	} else
//	{
		var windowprops = 'width=' + w + ',height=' + h + ',top='+ topPosition +',left='+ leftPosition +',toolbar=no,location=no,directories=no,status=no,scrollbars=no,menubar=no,resizable=no'; //set popup window properties
//	}
	if (name==null) name='remote';
	var popup = window.open(url,name,windowprops); // open popup window with properties
	//popup.moveTo(0,0)
	popup.resizeTo(w,h);
	//popup.focus(); // focus on window
}

function randomPic(div){
	
  var pic = randomGroup();
	document.getElementById(div).style.background='url('+pic+') no-repeat';
}

function randomGroup(){
    group=new Array();

    group[0] ="./images/2007_a.jpg";
    group[1] ="./images/2007_b.jpg";
    group[2] ="./images/2007_c.jpg";
    group[3] ="./images/2007_d.jpg";
<!--     //alert(group[1]); -->
<!--     //alert(group[2]); -->
<!--     //alert(rand(2)); -->
var _rand=Math.round(Math.random()*(group.length-1));

var rndGroup = group[_rand];
<!--     //alert("rndGroup:"+rndGroup); -->
    return rndGroup;
}



function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}