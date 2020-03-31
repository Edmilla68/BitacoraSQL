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
	return true;
}
