PusherClient = require('pusher-node-client').PusherClient
Player = require('player')
notifier = require('node-notifier')

player_start = new Player("https://s3.amazonaws.com/karaoke_resume/music.mp3")
player_finish = new Player("https://s3.amazonaws.com/karaoke_resume/finite.mp3")


pusher_client = new PusherClient
  appId: (process.env.PUSHER_APP_ID or app_id)
  key: (process.env.PUSHER_KEY or pusher_key)
  secret: (process.env.PUSHER_SECRET or pusher_secret)

pres = null

pusher_client.on 'connect', () ->
  pres = pusher_client.subscribe("deploy", {user_id: "system"})

  pres.on 'success', () ->

    pres.on 'start', (data) ->
      console.log "deploy started"
      player_start.play()
      notifier.notify
        title: "DEPLOYMENT START"
        message: "triggered by #{data.author}"

    pres.on 'finish', (data) ->
      player_start.stop()

      player_finish.play()
      player_finish.on 'playend', (item) ->
        player_finish.stop()

      console.log "deploy finished"
      notifier.notify
        title: "DEPLOYMENT FINISH"
        message: "finished in #{data.time}"

pusher_client.connect()
