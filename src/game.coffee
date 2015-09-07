Phaser = require 'phaser'

game = null
colors = Phaser.Color.HSVColorWheel 0.5, 1

fullscreen = false
fsTarget = null

defaultScale = 4

upscaled =
  scale: defaultScale
  canvas: null
  ctx: null
  width: 0
  height: 0

bootstrap = ->
  state =
    init: init
    create: create
    update: update
    render: render

  game = new Phaser.Game 240, 160, Phaser.CANVAS, '', state, false, false

init = ->
  game.canvas.style.display = 'none'

  canvas = Phaser.Canvas.create game.width * upscaled.scale, game.height * upscaled.scale
  Phaser.Canvas.addToDOM canvas

  upscaled.canvas = canvas
  upscaled.ctx = canvas.getContext '2d'
  upscaled.width = canvas.width
  upscaled.height = canvas.height

  Phaser.Canvas.setSmoothingEnabled upscaled.ctx, false

  fsTarget = game.scale.createFullScreenTarget()
  fsTarget.style.width = '0%'
  fsTarget.style.height = '0%'

  parent = canvas.parentNode
  parent.insertBefore fsTarget, canvas
  fsTarget.appendChild canvas

  game.scale.onFullScreenChange.add onFullscreenChange

  game.input.onUp.add toggleFullscreen

create = ->
  style =
    font: '14px game-font'
    fill: '#fff'
    stroke: '#000'
    strokeThickness: 2
  text = game.add.text game.world.centerX, game.world.centerY, 'Hello, World!', style
  text.anchor.x = 0.5
  text.anchor.y = 0.5

update = ->
  idx = Math.floor this.game.time.totalElapsedSeconds() * 100 % colors.length
  c = colors[idx]
  color = Phaser.Color.getColor c.r, c.g, c.b
  game.stage.backgroundColor = color

render = ->
  upscaled.ctx.drawImage game.canvas, 0, 0, game.width, game.height, 0, 0, upscaled.canvas.width, upscaled.canvas.height

toggleFullscreen = ->
  if fullscreen
    document[game.device.cancelFullscreen]()
  else
    fsTarget[game.device.requestFullscreen]()
  fullscreen = !fullscreen

onFullscreenChange = ->
  if fullscreen
    fsTarget.style.width = ''
    fsTarget.style.height = ''
    scaleY = window.innerWidth / game.canvas.width
    scaleX = window.innerHeight / game.canvas.height
    upscaled.scale = Math.floor(Math.min(scaleX, scaleY))
  else
    fsTarget.style.width = '0%'
    fsTarget.style.height = '0%'
    upscaled.scale = defaultScale
  upscaled.canvas.width = game.width * upscaled.scale
  upscaled.canvas.height = game.height * upscaled.scale
  Phaser.Canvas.setSmoothingEnabled upscaled.ctx, false

exports.bootstrap = bootstrap
