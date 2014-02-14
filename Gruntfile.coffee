module.exports = (grunt) ->

  grunt.initConfig
  
    pkg: grunt.file.readJSON('package.json'),

    clean:
      build:
        src: [ 'lib' ]

    coffee:
      buildSources:
        expand: true,
        cwd: 'src',
        src: ['**/*.coffee'],
        dest: 'lib',
        ext: '.js'

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');

  grunt.registerTask('build', ['clean', 'coffee'])
  grunt.registerTask('default', ['build'])