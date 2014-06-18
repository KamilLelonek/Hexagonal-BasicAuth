class @User
  constructor: (json) ->
    @email        = json.email
    @guid         = json.guid
    @avatar_url = json.avatar_url
