###HMDTrack
####Setup
The open ended portion of this requires the redis gem and node/npm installed. A version of npm above 0.10.4 is recommended.
There aren't any new tables, just two migrations to the db that involve indexing and removing a column.
```
$ bundle install
$ bundle exec rake db:setup
$ cd node-realtime
$ npm install
```

####Running
The app runs the rails server in part one and uses it as an API for the project contained in node-realtime, which uses sockets and push events through redis to update the page for every client reactively. The node project runs using Express and the frontend uses React, and the socket is run on port 6543. The ports for urls are hardcoded since this is more of a proof of concept (though easily extensible to be a full subscribe model for later use): rails runs on 3000, express on 4567, redis on the default redis port.

The app requires your local machine to have an instance of redis running.

```
$ brew install redis
$ redis-server
```

To run the two servers in "production"

```
$ bundle exec rails s
$ cd node-realtime && npm run start:server:bg
```

The node-realtime project is also configured to use browserify and react hot reloading for development. If you have browserify, lessify, watchify, envify and babel installed globally (npm install [package] -g) you can run the following to enter development mode and make changes to the client JS in real time.

```
$ cd node-realtime && npm run start
```

###Result
If everything goes well, you should be able to edit anything on the rails side and see it automatically update on the node side. You can connect as many clients to localhost:4567 as you want, and any change to an HMD in localhost:3000 should show up simultaneously on all clients.
