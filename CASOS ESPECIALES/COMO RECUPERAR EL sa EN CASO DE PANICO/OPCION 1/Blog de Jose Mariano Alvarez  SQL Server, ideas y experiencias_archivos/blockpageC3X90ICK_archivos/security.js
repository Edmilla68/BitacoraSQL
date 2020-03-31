function isSecurity(chkFlag){
	if (chkFlag == "true") return true;
	if (chkFlag == "false") return false;
	return false;
}

function changeH1Class(){
	document.getElementById("blockMessage").className = "security";
}

function writeHeader(){
	if(isSecurity(securityFlag)){
		document.write("Security risk blocked for your protection");
		changeH1Class();
	}
	else{
		document.write("Content blocked by your organization");
	}
}

function writeReason(){
	if(isSecurity(securityFlag)){
		document.write("Sites in this category may pose a security threat to network resources or private information, and are blocked by your organization.");
	}
}

function writeWarning(){
	if(isSecurity(securityFlag)){
		document.write('<span class="warning">Not Recommended</span>');
	}
}

function writeWarning1(){
	if(isSecurity(securityFlag)){
		document.write('This action is not recommended.')
	}
}

function openPopup() {
	parent.document.getElementById('light').innerHTML = document.getElementById('light').innerHTML;
	parent.document.getElementById('light').style.display='block';
	parent.document.getElementById('fade').style.display='block';
	return false;
}

function closePopup() {
	document.getElementById('light').style.display='none';
	document.getElementById('fade').style.display='none';	
	return false;
}

function encode() {
	var _user = document.getElementById("ws-credentials-user");
	var _pass = document.getElementById("ws-credentials-pass");
	var _hddn = document.getElementById("ws-credentials");	
	_hddn.value = "Basic-" + Base64.encode(_user.value + ":" + _pass.value);
	_user.value = '';
	_pass.value = '';
	return true;
}

function encodePW() {
    var _pass = document.getElementById("ws-entered-password");
    var _hddn = document.getElementById("ws-password");
    _hddn.value = "Basic-" + Base64.encode(_pass.value);
    _pass.value = '';
    return true;
}

function goToMoreInfo() {
    // ACEInsight button present - swap it in and hide "More Info" button
    var obj = document.getElementById("site_details_container");
    if (obj) {
        obj.style.display = ""; // Show AceInsight
        document.getElementById("more_info_container").style.display = "none";
    }

    // Show "More Info" frame
    window.open("/cgi-bin/moreBlockInfo.cgi?ws-encdata=" + WS_MOREINFOCGIDATA, "ws_block");
    return false; // Do not submit form
}

function goToSiteDetails() {
	// Open ACEInsight link in new window
	window.open(WS_ACEINSIGHT_LINK_URL, "_blank");
	return false; // Do not submit form
}

function goBack() {
    if (document.getElementById("more_info_container").style.display == "none") {
        document.getElementById("more_info_container").style.display = "";
        var obj = document.getElementById("site_details_container");
        if (obj) {
            obj.style.display = "none";
        }
        return false;
    }

    history.back();

    return false; // Do not submit form
}

function checkQuota(quotaTime) {
    if (quotaTime == 0) {
        document.getElementById("quota-text").style.display = "none";
        document.getElementById("quota-text-no-time").style.display = "";
    }
}
