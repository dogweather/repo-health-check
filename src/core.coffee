# core.coffee
#
# Application setup that absolutely must come first before other application
# code.

# Create our application's namespace.
App = exports? and exports or @App = {}

# An Octkat instance
# https://github.com/philschatz/octokat.js/
App.octo = new Octokat()
