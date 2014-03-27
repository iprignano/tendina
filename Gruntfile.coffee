module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      compile:
        files:
          "tendina.js": "tendina.coffee"

    uglify:
      target:
        files:
          "tendina.min.js": "tendina.js"

    watch:
      coffee:
        files: ["*.coffee"]
        tasks: ["coffee:compile"]
      uglify:
        files: ["tendina.js"]
        tasks: ["uglify:target"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["coffee", "uglify"]