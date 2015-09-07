WebFont = require 'webfont'
game = require './game'

WebFont.load
  custom:
    families: ['game-font']
    urls: ['/css/fonts.css']
  loading: game.bootstrap
