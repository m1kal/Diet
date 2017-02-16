# Diet
An app that allows to record meals and exercises. Web UI using Sinatra and console UI

This is a personal project, the main aim was to practice Ruby and TDD. I got bored before adding all the features, but the current version is functional.

Version 0.2
 - Code cleanup
 - Added `MemSerializer` and `RedisSerializer`
 - Web UI now supports both meals and exercises.
 - Got rid of global variable in Sinatra app, now class variable of `MemSerializer` is used.
 - jQuery is now downloaded from CDN.

Missing features and roadmap:
- Currently UI requires Day object to display the meals. Some kind of `Diet#show` could format the meals for each day.
- Text UI does not support exercises.
- Add GUI using only libraries that are <b>easy to distribute and install</b>
- Web UI might suggest calories for some meals based on history (e.g. one eats the same breakfast every day).
- Add advanced use cases, such as histograms, diet plans, weight tracking, notes.
- Add user and admin panel, allow change of password.
- Admin panel should allow to change storage type and parameters
