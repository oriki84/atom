$ = require 'jquery'
fs = require 'fs'
Theme = require 'theme'

describe "TextMateTheme", ->
  describe "@load(name)", ->
    it "applies the theme's stylesheet to the current window", ->
      themePath = require.resolve(fs.join('fixtures', 'test.tmTheme'))
      spyOn window, 'applyStylesheet'
      theme = Theme.load(themePath)
      expect(window.applyStylesheet).toHaveBeenCalledWith(themePath, theme.getStylesheet())
      theme.deactivate()

describe "AtomTheme", ->
  describe "@load(name)", ->
    it "Loads and applies css from package.json in the correct order", ->
      themePath = require.resolve(fs.join('fixtures', 'test-atom-theme'))

      expect($(document.body).css("padding-top")).not.toBe("101px")
      expect($(document.body).css("padding-right")).not.toBe("102px")
      expect($(document.body).css("padding-bottom")).not.toBe("103px")
      theme = Theme.load(themePath)
      expect($(document.body).css("padding-top")).toBe("101px")
      expect($(document.body).css("padding-right")).toBe("102px")
      expect($(document.body).css("padding-bottom")).toBe("103px")

      theme.deactivate()
