module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      compile:
        files:
          "dist/tendina.js": "src/tendina.coffee"

    uglify:
      target:
        files:
          "dist/tendina.min.js": "dist/tendina.js"

    watch:
      coffee:
        files: ["src/*.coffee"]
        tasks: ["coffee:compile"]
      uglify:
        files: ["dist/tendina.js"]
        tasks: ["uglify:target"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["coffee", "uglify"]