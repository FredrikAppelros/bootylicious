Phaser = require 'phaser'

colors = Phaser.Color.HSVColorWheel 0.5, 1
game = null

preload = ->

create = ->
  width = 400
  height = 200
  x = (game.width - width) / 2
  y = (game.height - height) / 2
  style =
    font: '60px game-font'
    fill: '#fff'
    stroke: '#000'
    strokeThickness: 8
    wordWrap: true
    wordWrapWidth: width
  game.add.text x, y, 'Hello, World!', style

update = ->
  idx = Math.floor this.game.time.totalElapsedSeconds() * 100 % colors.length
  c = colors[idx]
  color = Phaser.Color.getColor c.r, c.g, c.b
  game.stage.backgroundColor = color

init = ->
  state =
    preload: preload
    create: create
    update: update

  game = new Phaser.Game 800, 600, Phaser.AUTO, '', state

exports.init = init
