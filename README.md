# Diet
An app that allows to record meals and excercises. Web UI using Sinatra and console UI

This is a personal project, the main aim was to practice Ruby and TDD. I got bored before adding all the features, but the current version is functional.

Missing features and roadmap:
- Add alternative storage - Serializer using some kind of database.
- Currently UI requires Day object to display the meals. Some kind of `Diet#show` could format the meals for each day.
- none of the two UIs support excercises.
- Web UI uses a global variable. Maybe I am using session incorrectly?
- Add GUI using only libraries that are <b>easy to distribute and install</b>
- Web UI might suggest calories for some meals based on history (e.g. one eats the same breakfast every day).
- Add advanced use cases, such as histograms, diet plans, weight tracking, notes.
- Add user and admin panel, allow change of password.
