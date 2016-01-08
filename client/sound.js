import load from 'webaudio-buffer-loader'

const ctx = new AudioContext()

let fart, chant

load(['files/fart.mp3', 'files/chant.mp3'], ctx, function(err, buffers) {
  if (err) {
    console.error('oh no it errored', err)
    return
  }

  [fart, chant] = buffers
})

function playSound(ctx, buffer, time) {
  let source = ctx.createBufferSource()
  source.buffer = buffer
  source.connect(ctx.destination)
  source.start(time)
}

let isPlaying = false
export default function play(donePlaying) {
  console.log('wooooo')

  if (isPlaying) {
    return
  }
  isPlaying = true

  playSound(ctx, chant, ctx.currentTime)
  playSound(ctx, fart, ctx.currentTime + chant.duration)
  setTimeout(function() {
    isPlaying = false
    donePlaying()
  }, (chant.duration + fart.duration) * 1000)
}
