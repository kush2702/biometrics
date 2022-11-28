// This file contains helper functions to be used by voice-auth.js 

// This method adds the recorded audio to the page so you can listen to it
function addAudioPlayer(blob){	
	var url = URL.createObjectURL(blob);
	var log = document.getElementById('log');

	var audio = document.querySelector('#replay');
	if (audio != null) {audio.parentNode.removeChild(audio);}

	audio = document.createElement('audio');
	audio.setAttribute('id','replay');
	audio.setAttribute('controls','controls');

	var source = document.createElement('source');
	source.src = url;

	audio.appendChild(source);
	log.parentNode.insertBefore(audio, log);
}

// Example phrases
var thingsToRead = [
	"The Moon is a barren, rocky world without air and water. It has dark lava plain on its surface.\n The Moon is filled wit craters. It has no light of its own.\n It gets its light from the Sun. The Moo keeps changing its shape as it moves round the Earth.\n It spins on its axis in 27.3 days stars were named after the Edwin Aldrin were the first ones to set their foot on the Moon on 21 July 1969 They reached the Moon in their space craft named Apollo II.\n",
	"The Ramayana is a story of Lord Rama written by the SageValmiki.\n Lord Rama, the prince of Ayodhya, in order to help his father Dasharatha went to\n exile for fourteen years. His wife, Sita and his younger brother Lakshmana also went with him.\n He went through many difficulties in the forest. One day Ravana, the king of Lanka carried away Sita with him.\n Then, Lord Rama, with the help of Hanumana, defeated and killed Ravana;\n Sita, Rama and Lakshmana returned to Ayod hya after their exile.\n",
	"The Taj Mahal is a beautiful monument built in 1631 by an Emperor\n named Shah Jahan in memory of his wife Mumtaz Mahal.\n It is situated on the banks of river Yamuna at Agra.\n It looks beautiful in the moonlight.\n The Taj Mahal is made up of white marble.\n In front of the monument, there is a \n beautiful garden known as the Charbagh.\n Inside the monument, there are two tombs. These tombs \n are of Shah Jahan and his wife Mumtaz Mahal.\n The Taj Mahal is considered as one of the Seven Wonders\n of the World. Many tourists come to see this\n beautiful structure from different parts of the world.\n",
	"India is an agricultural country. Most of the people live in villages and are farmers.\n They grow cereals, pulses, vegetables and fruits. The farmers lead a tough life. They get up early in the morning and go to the fields.\n They stay and work on the farm late till evening. The farmers usually live in kuchcha houses.\n Though, they work hard they remain poor. \nFarmers eat simple food; wear simple clothes and rear animals like cows, buffaloes and oxen. Without them there would be no cereals for us to eat. They play an important role in the growth and economy of a country.\n",
];


// Key and Endpoint By Microsoft Azure.
var key = "Your-microsoft-azure-key";
var baseApi = "your-microsoft-azure-Endpoint";

// Speaker Recognition API profile configuration - constructs to make management easier
var Profile = class { constructor (name, profileId) { this.name = name; this.profileId = profileId;}};
var VerificationProfile = class { constructor (name, profileId) { this.name = name; this.profileId = profileId; this.remainingEnrollments = 3}};
var profileIds = [];
var verificationProfile = new VerificationProfile();

(function () {
	// Cross browser sound recording using the web audio API
	navigator.getUserMedia = ( navigator.getUserMedia ||
							navigator.webkitGetUserMedia ||
							navigator.mozGetUserMedia ||
							navigator.msGetUserMedia);

	// Really easy way to dump the console logs to the page
	var old = console.log;
	var logger = document.getElementById('log');
	var isScrolledToBottom = logger.scrollHeight - logger.clientHeight <= logger.scrollTop + 1;
    
	console.log = function () {
		for (var i = 0; i < arguments.length; i++) {
			if (typeof arguments[i] == 'object') {
				logger.innerHTML += (JSON && JSON.stringify ? JSON.stringify(arguments[i], undefined, 2) : arguments[i]) + '<br />';
			} else {
				logger.innerHTML += arguments[i] + '<br />';
			}
			if(isScrolledToBottom) logger.scrollTop = logger.scrollHeight - logger.clientHeight;
		}
		old(...arguments);
	}
	console.error = console.log; 
})();
