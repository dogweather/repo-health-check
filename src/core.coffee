# core.coffee
#
# Application setup that absolutely must come first before other application
# code.

# Create our application's namespace.
App = exports? and exports or @App = {}

# An Octkat instance
# https://github.com/philschatz/octokat.js/
#
# This initial instance is unauthenticated and will allow the user to begin
# using the API immediately. We "authenticate" the user by simply creating a new
# Octokat instance with username and password.
App.octo = new Octokat()
