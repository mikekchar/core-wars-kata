# One Pomodoro A Day - A Core Wars Kata

This is the project page for an experiment in doing a very long
kata (30-40 hours), working an average of only 25 minutes per
day.  See below for a better description of what I am doing, and
why I am doing it.

## Structure of this repository

The `master` branch of this repository contains only the tools
I used to do the kata.  If you wish to do the same kata (or a different
kata using the same tools), you can easily fork this project and
branch off from `master`.

Each pomodoro session (approximately 25 minutes of work) is checked into
it's own branch.  The first session is branch `first`, the second is
`second`, etc.  The most recent branch is always merged into
the `gh-pages` branch, so if you simply want to look at the most recent
code, that's the place to look.

I have recorded every pomodoro session using a tool called
[Asciinema](https://asciinema.org).  You can view these sessions
by going to the [project page](https://mikekchar.github.io/core-wars-kata).
The speed of replay can be adjusted by using the '<' and '>' keys.
I have found that by increasing the speed, you can comfortably watch
a 25 minute pomodoro in as little as 5 minutes.

## What is One Pomodoro A Day?

<em>One Pomodoro A Day</em> is an attempt to do a very long kata
in manageable chunks.  If you are not familiar with the concept of
a kata, it is a term taken from Japanese martial arts and refers
to a form that one executes in order to practice.  The term was
coined by Dave Thomas [here](http://codekata.com).

One of the downsides of doing a kata as practice is that it is
necessarily limited.  Usually it is a task that last 30 minutes
or so.  Trying to explore larger problems of requirements gathering
and program design is much more difficult because ordinarily
people don't have time to devote themselves to a large project
for an extended period of time.  Enter the pomodoro technique.

[The pomodoro technique](https://wikipedia.org/wiki/Pomodoro_Technique)
is a time management method for splitting up your task into
small chunks of time (usually 25 minutes), separated by short
breaks.  The chunks of time are called <em>pomodoros</em>.  My
approach in this experiment is to try to do a very long kata
(approximately 30-40 hours), doing an average of one pomodoro
a day.  I use [Asciinema](https:asciinema.org) to record each
pomodoro session so that I can review it later.

## What is Core Wars?

Core Wars is a game devised by computer scientist A. K. Dewdney
in 1984.  It was first described in an article in Scientific
American and became relatively popular in the late 1980s and
early 1990s with computer programmers.  From the original article:

  Two computer programs in their native habitat -- the memory
  chips of a digital computer -- stalk each other from address to
  address.  Sometimes they go scouting for the enemy; sometimes
  they lay down a barrage of numeric bombs; sometimes they copy
  themselves out of danger or stop to repair damage.  This is the
  game I call Core War.  It is unlike almost all other computer
  games in that people do not play at all!  The contending programs
  are written by people, of course, but once a battle is under
  way the creator of a program can do nothing but watch helplessly
  as the product of hours spent in design and implementation either
  lives or dies on the screen.  The outcome depends entirely on
  which program is hit first in a vulnerable area.

Core Wars is quite nostalgic for me as, after reading the original
article, I rushed to write my own implementation of the game.
I remember starting on a Friday evening and working every waking
hour so that I could have it functional by Sunday night.  It was
a crude implementation with numerous bugs, but it was very fun
to play.

I have often thought, "How long would it take me to
write Core Wars now".  It's been almost 30 years since
I first implemented it and I hope I have improved
a considerable amount.  The old me probably edges the
new me in raw mental horse power, but I should have
a trick or two up my sleeve now.

## Using the tools for your own kata

The tools checked into the `master` branch can be used to do your
own kata (even to implement Core Wars yourself and compare your
kata to mine!).

### Scripts

There are 3 scripts in the `scripts` directory:

  - geometry
  - record
  - start-tmux

`geometry` will tell you the geometry of your terminal application.
Asciinema works well using a geometry of 80x25 and I recommend using
that.  All of my recordings are done at that size.  It takes some
practice to get used to working with such a small screen, but it's
good for building memory skills about the structure of your code.

`record` will start a [tmux](https://tmux.github.io) session,
a [thyme pomodoro timer](http://hughbien.com/thyme), and start and
asciinema recording.  `record` takes one argument: the name of the
asciinema file to record.  I usually invoke it like:

```sh
record sessions/5.ascii
```

This will create 2 files: the `5.ascii` file that has the asciinema
recording, and also a `5.ascii.json` file that contains a transformed
version that can be used on the webpage.  Unfortunately, the program
that transforms the file currently only works on Linux.  This is
a limitation of asciinema which I hope will be fixed some time.

In order for the `record` script to work, you have to install asciinema
and place it in your executable path.  I have built and included
the conversion script that creates the converted version (that can
be displayed by the asciinema web plugin) in the
`third-party/asciinema-convert` directory.  This was built from the
asciinema source package.  Unfortunately, asciinema is not really packaged
up to be used easily, so I had to resort to this approach.

The `record` script also uses the `thyme` pomodoro timer.  You need
to install it using Ruby's bundler gem.  Once you have installed
bundler with `gem install bundler` you simply need to do
`bundle install` to get set up.  However, the pomodoro timer will still
not show up in your tmux session unless you add it to your `.tmux.conf`.
I use the following:

```
# thyme integration
set-option -g status-left '#(cat ~/.thyme-tmux) |#S| '
set-option -g status-interval 30
set-option -g status-left-length 20
```

The final script is `start-tmux`.  This is called by the `record` script
to start up tmux.  This opens up some default windows and makes a couple
of specific key bindings that I use for the kata.  You can modify it to
suit your needs.
