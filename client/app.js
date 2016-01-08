import Elm from './src/Main.elm'

import playSound from './sound'

const container = document.querySelector('.container')
const elmApp = Elm.embed(Elm.Main, container, {done: true})

function donePlaying() {
  elmApp.ports.done.send(true)
}

function play(soundName) {
  playSound(donePlaying)
}

elmApp.ports.stuff.subscribe(play)
