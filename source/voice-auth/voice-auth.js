const profileEndpoint = `${baseApi}/speaker/verification/v2.0/text-independent/profiles`;
const enrolProfileEndpoint = (profileId) => `${baseApi}/speaker/verification/v2.0/text-independent/profiles/${profileId}/enrollments?ignoreMinLength=false`;
const verifyProfileEndpoint = (profileId) => `${baseApi}/speaker/verification/v2.0/text-independent/profiles/${profileId}/verify`;

//-- Speaker Verification methods
// 1. Start the browser listening, listen for 6 seconds, pass the audio stream to "createProfile"
function enrolProfile(){
	navigator.getUserMedia({audio: true}, function(stream){
		console.log('I\'m listening... just start talking for a few seconds...');
		console.log('Maybe read this: \n' + thingsToRead[Math.floor(Math.random() * thingsToRead.length)]);
		onMediaSuccess(stream, createProfile, 6);
	}, onMediaError);
	
}

// createProfile calls the profile endpoint to get a profile Id, then calls enrollProfileAudioForVerification
function createProfile(blob){
	
	// just check if we've already fully enrolled this profile
	if (verificationProfile && verificationProfile.profileId) 
	{
		if (verificationProfile.remainingEnrollmentsSpeechLength == 0)
		{
			console.log("Verification enrollment already completed");
			return;
		} 
		else 
		{
			//console.log("Verification enrollment time remaining of earlier :" + verificationProfile.remainingEnrollmentsSpeechLength);
			console.log("A Speaker Identified Speak Again");
			enrolAudio(blob, verificationProfile.profileId);
			
			return;
		}
	}

	var request = new XMLHttpRequest();
	request.open("POST", profileEndpoint, true);
	request.setRequestHeader('Content-Type','application/json');
	request.setRequestHeader('Ocp-Apim-Subscription-Key', key);

	request.onload = function () {
		console.log(request.responseText);
		var json = JSON.parse(request.responseText);
		var profileId = json.profileId;
		verificationProfile.profileId = profileId;

		// Now we can enrol this profile with the profileId
		enrolAudio(blob, profileId);
	};

	request.send(JSON.stringify({'locale' :'en-us'}));
}

// enrolAudio enrols the recorded audio with the new profile Id
function enrolAudio(blob, profileId){
	addAudioPlayer(blob);

	if (profileId == undefined)
	{
		console.log("Failed to create a profile for verification; try again");
		return;
	}
	  
	var request = new XMLHttpRequest();
	request.open("POST", enrolProfileEndpoint(profileId), true);
	request.setRequestHeader('Ocp-Apim-Subscription-Key', key);
	request.onload = function () {
		console.log('enrolling');
		console.log(request.responseText);

		var json = JSON.parse(request.responseText);

		verificationProfile.remainingEnrollmentsSpeechLength = json.remainingEnrollmentsSpeechLength;
		if (verificationProfile.remainingEnrollmentsSpeechLength == 0) 
		{
			console.log("Verification should be enabled!")
		}
	};
  
	request.send(blob);
}

// 2. Start the browser listening, listen for 4 seconds, pass the audio stream to "verify"
function listen(){
	if (verificationProfile.profileId){
		console.log('I\'m listening... just start talking for a few seconds...');
		console.log('Maybe read this: \n' + thingsToRead[Math.floor(Math.random() * thingsToRead.length)]);
		navigator.getUserMedia({audio: true}, function(stream){onMediaSuccess(stream, verify, 6)}, onMediaError);
	} else {
		console.log('No verification profile enrolled yet! Click the other button...');
	}
}

// 3. Take the audio and send it to the verification endpoint for the current profile Id
function verify(blob){
	addAudioPlayer(blob);
  
	var request = new XMLHttpRequest();
	request.open("POST", verifyProfileEndpoint(verificationProfile.profileId), true);
	
	request.setRequestHeader('Content-Type','application/json');
	request.setRequestHeader('Ocp-Apim-Subscription-Key', key);
  
	request.onload = function () {
		console.log('verifying profile');

		// Was it a match?
		console.log(JSON.parse(request.responseText));
	};
  
	request.send(blob);
}
