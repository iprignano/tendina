module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      compile:
        files:
          "lib/tendina.js": "src/tendina.coffee"

    uglify:
      target:
        files:
          "lib/tendina.min.js": "lib/tendina.js"

    watch:
      coffee:
        files: ["src/*.coffee"]
        tasks: ["coffee:compile"]
      uglify:
        files: ["lib/tendina.js"]
        tasks: ["uglify:target"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["coffee", "uglify"]