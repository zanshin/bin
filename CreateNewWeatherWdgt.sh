#!/bin/bash

#
#	This is a script by TUAW reader "Harvey" 
# 		http://www.tuaw.com/profile/1854164/
#
#	Who posted it in resonse to this article:
# http://www.tuaw.com/2009/09/27/weather-widget-with-time-updated-for-snow-leopard/
#
#
# It will patch the Weather Widget automatically.
#
# It has been tested under 10.6.1 and is believed to be safe, however
# use it only at your own risk. No warrantee expressed or implied by either
# TUAW, its parent or subsidiary companies, or Harvey.  If you do not
# accept these terms, delete the file and do not use it.
#

WDGT="Weather.wdgt"
OLD=/Library/Widgets
NEW=~/Library/Widgets
# Rename any widgets with the same name out of the way.
if [ -e $NEW/$WDGT ]; then
  if [ -e $NEW/$WDGT.old ]; then
    echo "Refusing to overwrite $NEW/$WDGT.old"'!'
    open $NEW
    exit 1
  fi
  mv $NEW/$WDGT $NEW/$WDGT.old
fi

# Get a copy of Apple's widget
cp -rf $OLD/$WDGT $NEW/$WDGT
# Go the user's widget folder and patch the new version to
# add the changes below.
pushd $NEW
cat - << EOF | patch -p0
diff -urp Weather.wdgt.orig/Weather.css Weather.wdgt/Weather.css
--- Weather.wdgt.orig/Weather.css	2009-09-27 19:06:07.000000000 -0400
+++ Weather.wdgt/Weather.css	2009-09-27 19:05:56.000000000 -0400
@@ -74,15 +74,15 @@ body {
 
 .smallinfo {
 	font-size: 10px;
-	color: rgba(255, 255, 255, .7);
+	color: rgba(255, 255, 255, .85);
 	font-size: 10px;
 }
 
-#high {
+#high-lo {
 	top: 10px;
 }
 
-#lo {
+#updatetime {
 	top: 37px;
 }
 
diff -urp Weather.wdgt.orig/Weather.html Weather.wdgt/Weather.html
--- Weather.wdgt.orig/Weather.html	2009-09-27 19:06:07.000000000 -0400
+++ Weather.wdgt/Weather.html	2009-09-27 19:05:56.000000000 -0400
@@ -66,10 +66,10 @@ license or right is granted, either expr
 				</div>
 			</div>
 			
-			<div id='high' class='text info smallinfo'></div>
+			<div id='high-lo' class='text info smallinfo'></div>
 			<div id='location' class='text info'></div>
 			<div id='clickArea' class="text info"  onclick='goToURL(event);'></div>
-			<div id='lo' class='text info smallinfo'></div>
+			<div id='updatetime' class='text info smallinfo'></div>
 			
 			<div id='temperature'>--</div>
 			<img id='degree' src='Images/degree.png' />
diff -urp Weather.wdgt.orig/Weather.js Weather.wdgt/Weather.js
--- Weather.wdgt.orig/Weather.js	2009-09-27 19:06:07.000000000 -0400
+++ Weather.wdgt/Weather.js	2009-09-27 19:05:56.000000000 -0400
@@ -156,8 +156,10 @@ function updateValuesUnitsChanged()
 		if (c > 0)
 		{
 			var object = lastResults[0];
-			document.getElementById('high').innerText = getLocalizedString('H: ') + convertToCelcius(object.hi) + 'º';
-			document.getElementById('lo').innerText = getLocalizedString('L: ') + convertToCelcius(object.lo) +  'º';
+			document.getElementById('high-lo').innerText = getLocalizedString('H: ')
+				+ convertToCelcius(object.hi) + 'º'
+				+ '/' + getLocalizedString('L: ')
+				+ convertToCelcius(object.lo) + 'º';
 			document.getElementById('temperature').innerText = convertToCelcius(object.now);	
 			
 			
@@ -251,10 +253,35 @@ function getMoonPhaseIcon (phase)
 var lastIcon = null;
 function handleDataFetched (object)
 {
+	// Format the time of the last data refresh 
+	var currentTime = new Date() 
+	var h = currentTime.getHours() 
+	var m = currentTime.getMinutes() 
+	var ampm = 'am'; 
+	// default to am
+	if (h == 12) 
+	{ 
+		// noon 
+		ampm = 'pm'; 
+	} 
+	else if (h == 0) 
+	{ 
+		// midnight 
+		h = 12; 
+	} 
+	else if (h > 12) 
+	{ 
+		h -= 12; 
+		ampm = 'pm'; 
+	} 
+	if (m < 10) { m = '0' + m; } 
+	document.getElementById('updatetime').innerText = h + ':' + m + ' ' + ampm;
+
 	lastResults = new Array;
 	lastResults[0] = {hi:object.hi, lo:object.lo, now:object.temp};
-	document.getElementById('high').innerText = getLocalizedString('H: ') + convertToCelcius(object.hi) + 'º';
-	document.getElementById('lo').innerText = getLocalizedString('L: ') + convertToCelcius(object.lo) +  'º';
+	document.getElementById('high-lo').innerText = getLocalizedString('H: ')
+		+ convertToCelcius(object.hi) + 'º'
+		+ '/' + getLocalizedString('L: ') + convertToCelcius(object.lo) + 'º';
 	updateLocationString(object.city);
 	
 	var fontSize;
EOF

popd

# Open a finder window for the user's widgets
open $NEW

echo "All done! The new version is $NEW/$WDGT"
echo "Double-click it to install."

