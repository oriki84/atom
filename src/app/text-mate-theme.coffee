_ = require 'underscore'
fs = require 'fs'
Theme = require 'Theme'

module.exports =
class TextMateTheme extends Theme
  constructor: (@path, {settings}) ->
    super
    @rulesets = []
    globalSettings = settings[0]
    @buildGlobalSettingsRulesets(settings[0])
    @buildScopeSelectorRulesets(settings[1..])
    @stylesheets[@path] = @getStylesheet()

  getStylesheet: ->
    lines = []
    for {selector, properties} in @getRulesets()
      lines.push("#{selector} {")
      for name, value of properties
        lines.push "  #{name}: #{value};"
      lines.push("}\n")
    lines.join("\n")

  getRulesets: -> @rulesets

  buildGlobalSettingsRulesets: ({settings}) ->
    { background, foreground, caret, selection } = settings

    @rulesets.push
      selector: '.editor'
      properties:
        'background-color': @translateColor(background)
        'color': @translateColor(foreground)

    @rulesets.push
      selector: '.editor.focused .cursor'
      properties:
        'border-color': @translateColor(caret)

    @rulesets.push
      selector: '.editor.focused .selection .region'
      properties:
        'background-color': @translateColor(selection)

  buildScopeSelectorRulesets: (scopeSelectorSettings) ->
    for { name, scope, settings } in scopeSelectorSettings
      continue unless scope
      @rulesets.push
        comment: name
        selector: @translateScopeSelector(scope)
        properties: @translateScopeSelectorSettings(settings)

  translateScopeSelector: (textmateScopeSelector) ->
    scopes = textmateScopeSelector.split(/\s+/).map (scope) -> '.' + scope
    scopes.join(' ')

  translateScopeSelectorSettings: ({ foreground, background, fontStyle }) ->
    properties = {}

    if fontStyle
      fontStyles = fontStyle.split(/\s+/)
      # properties['font-weight'] = 'bold' if _.contains(fontStyles, 'bold')
      # properties['font-style'] = 'italic' if _.contains(fontStyles, 'italic')
      properties['text-decoration'] = 'underline' if _.contains(fontStyles, 'underline')

    properties['color'] = @translateColor(foreground) if foreground
    properties['background-color'] = @translateColor(background) if background
    properties

  translateColor: (textmateColor) ->
    if textmateColor.length <= 7
      textmateColor
    else
      r = parseInt(textmateColor[1..2], 16)
      g = parseInt(textmateColor[3..4], 16)
      b = parseInt(textmateColor[5..6], 16)
      a = parseInt(textmateColor[7..8], 16)
      a = Math.round((a / 255.0) * 100) / 100

      "rgba(#{r}, #{g}, #{b}, #{a})"
