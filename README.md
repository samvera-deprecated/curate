Curate ND
=========

This application will be deployed to [curate.nd.edu](http://curate.nd.edu).

It's primary function is to be a self-deposit interface for our institutional digital repository.

The initial use case is for ETDs.

Developers
==========

Installing ClamAV

On OS-X with brew
```
$ env ARCHFLAGS='-arch x86_64' gem install clamav -- --with-clamav-include=/usr/local/Cellar/clamav/0.97.5/include --with-clamav-lib=/usr/local/Cellar/clamav/0.97.5/lib/x86_64/
```