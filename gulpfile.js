var gulp = require('gulp');
var ghPages = require('gulp-gh-pages');
 
gulp.task('deploy', function() {
  return gulp.src('./.deploy_git/**/*')
    .pipe(ghPages({remoteUrl:"git@github.com:snowdream/snowdream.github.io.git",branch:"master",message:"Create gh-pages branch via GitHub https://travis-ci.org/"}));
});
  
