===============================================================================

Some setup and tweaking you must do manually if you haven't yet:

  1. You will need to ensure that you have imagemagick installed on your
     machine. You can verify it is installed by checking the version of the
     mogrify command:
     ```
     $ mogrify --version
     => Version: ImageMagick 6.8.6-3 2013-09-06 Q16 http://www.imagemagick.org
     ```

  2. You will need to adapt your [Devise](https://github.com/plataformatec/devise)
     implementation.

  3. Curate makes use of [Resque](https://github.com/resque/resque) for
     off-loading some of its work. And while you can run Resque inline
     (especially for development and testing), you will most likely need to
     setup a [Redis](http://redis.io/) instance.

  4. Review the available curate generators via `rails g | grep curate -i`. It
     is likely you will want to create your own Curate works.

===============================================================================
