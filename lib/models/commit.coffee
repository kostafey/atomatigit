ListItemModel = require './list-item-model'
error_model = require '../error-model'

module.exports =
class Commit extends ListItemModel
  repo: ->
    @get "repo"

  commit_id: ->
    @get "id"

  short_id: ->
    @commit_id().substr(0, 6)

  author_name: ->
    @get("author").name

  short_commit_message: ->
    message = @get "message"
    message = message.split("\n")[0]
    if message.length > 80
      message = message.substr(0, 80) + "..."
    message

  reset_to: ->
    atom.confirm
      message: "Soft-reset head to #{@short_id()}?"
      detailedMessage: @get("message")
      buttons:
        "Reset": =>
          @repo().git "reset #{@commit_id()}", @error_callback
          @trigger "repo:reload"
        "Cancel": null

  hard_reset_to: ->
    atom.confirm
      message: "Do you REALLY want to HARD-reset head to #{@short_id()}?"
      detailedMessage: "Commit message: \"#{@get("message")}\""
      buttons:
        "Cancel": null
        "Reset": =>
          @repo().git "reset --hard #{@commit_id()}", @error_callback
          @trigger "repo:reload"

  error_callback: (e)=>
    error_model.set_message "#{e}" if e
    @trigger "repo:reload"