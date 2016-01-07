import Elm from './src/Main.elm'

const container = document.querySelector('.container')
const elmApp = Elm.embed(Elm.Main, container)


const soundCache = {}
function playSound(soundName) {
  console.log('soundName is', soundName)
  if (soundCache[soundName]) {
    soundCache[soundName].play()
    return
  }

  try {
    const sound = new Audio(soundName)
    soundCache[soundName] = sound
    sound.play()
  } catch (e) {
    console.error(e)
  }
}

elmApp.ports.playSound.subscribe(playSound)
