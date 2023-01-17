module.exports = {
    apps : [],
    // Deployment Configuration
    deploy : {
      production : {
         "user" : "root",
         "host" : ["my-remote-server.xyz", "...",],
         "ref"  : "origin/master",
         "repo" : "git@github.com:username/repository.git",
         "path" : "/var/www/my-repository",
         "post-setup" : "npm install",
        //  "key": "/path/to/some.pem",
      }
    }
  };

//   pm2 deploy ecosystem.config.js production setup
// The previous command will download the ref of your repo into the specified path, it will run as user on the specified host(s), and finally it will run the post-setup commands.
// And that's it, now you can install your projects wherever yo  need.
// pm2 deploy production revert 1
// pm2 deploy production exec "pm2 reload all"