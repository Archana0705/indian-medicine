// accessibility.js

function adjustFontSize(change) {
    const currentSize = parseInt(window.getComputedStyle(document.body).fontSize);
    if (change === 0) {
        document.body.style.fontSize = '16px';
    } else {
        document.body.style.fontSize = (currentSize + change) + 'px';
    }
}

function toggleDarkMode() {
    document.body.classList.toggle('dark-mode');
}

function toggleSpeech() {
    const text = document.body.innerText;
    const utterance = new SpeechSynthesisUtterance(text);
    window.speechSynthesis.speak(utterance);
}
