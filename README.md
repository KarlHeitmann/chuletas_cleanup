# OVERVIEW

When I start working on a new project, I always fill up the code with tags, breakpoints and message logs, in order to better
understand what is going on. 

Problem is that often I forgot to erase these comments when committing. That's why I decided to build a small program to parse
the lines of the files that have changed, and if it finds an offense, it will abort the commit and prevent the user by signaling him
the problems. To achieve this, the program must be used as a [git hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

# WHY DON'T USE A LINTER?

Yes, you can use a linter. If you work on a perfectly linted project and on your own toy project. But in real world,
I ain't seen any project that is perfectly linted, without any offenses, and is perfectly styled.

If you want to pass the linter on a dirty file, you will get a lot of noise even if you added one line. Also you will
have to select the file you want to lint, considering that a real world project has hundreds of files, this can produce
many overhead and lazyness to do it.

If you just hook this script into git-hooks, it will do the check every time you want to commit your changes. In addition, it will
analyze only the _changes_ on your files, not the whole file.

# ENHANCEMENTS

My first idea was to write the program in Rust, because it will be _blazingly fast._ Git is a very fast tool, it will be a bummer
to wait too long with an interpreted program for it to finish.

But I am still learning Rust, and right now I need this script ASAP, so I decided to build it in Ruby -my _go to_ language-.
And it will be pretty easy to me to build a working simple solution in a short ammount of time.

If you want to write a version in Rust, just ping me so that I can help you in any way. I want to build a version of this program in Rust
because I think it should be faster. But I don't feel condifent enough to start right now. Need to solve easier problems with that language.
And better understand it's lifetimes, borrows, etc, etc.

# INSTALLATION

Just copy the `main.rb`, add execution permission to your copy, and move it to the folder `.git/hooks/` and call it `pre-commit` the steps
should be something like this:

> cp main.rb pre-commit

> chmod +x pre-commit

> mv pre-commit /path/to/your/cool/project/.git/hooks

# GUIDELINES AND CONTRIBUTION


The architecture is simple. When you run `git commit ...`, just before commiting your changes the script will get hooked and will run.
Upon starting the program will call the OS to launch a subprocess, and this process is `git`. The command sent to git is to show the names
of the files that has differences and are on the stage area. The ones that appear in green when you run `git status`.

These files will be stored in an array, our bad guy will iterate over each of these files, and for every one of them will call again git
but this time will only ask for the changes of that particular file.

Once uppon our ruby program gets the changes for the file, it will parse every line and check for comments that will offend the commit.
I mean, strings that contains the elements found on the `OFFENSES` array. If there is a match, our program will add the offense to a `results` array and return that array to the main function.

If the main function finds that the array is not empty, the program will print the results and exit with status 1. Thus, aborting the commit.
If the results array is not empty, it will exit with status code 0 and will let git continue with the commit process.

Easy and simple. As you can see, this script will make many calls to the OS, which are expensive operations. I thought that git hooks may
be able to pass the diff information to the script. I did a little research and found nothing. If anyone knows a workaround to not use
system calls, it will be a great improvement to the script.

Right now I am taking the complete line diff to search for offenses. I have to put my offensive comments with special characters to catch
them with this script. For example

```ruby
# HACK_ME
# XXX_ME
# ERASE_ME
binding.pry # ERASE_ME
puts "......" # ERASE_ME
```

Maybe it will be better to analyze the code, find out if the line has a comment, and if it has a comment then search for offenses. But
what will you do with multi-line comments? The answer is not so simple. Maybe the way it is written is the right way, and one should
addapt it's debugging comments to being catched by this program.

# TO MY STUDENTS AND PEOPLE WHO WANT TO LEARN MORE

It seems to me that there are not many programs like this. If you want to train yourself in building projects, try to copy this program
and build your own version in another language. You can also change the program to parse the debugging code used for your favorite language.
I encourage you to put comments to guide you when you are reading new code. Find the place you want to change, and put some `puts`, `print`
or `console.log` to see what happens. Use the debugger. Use special tags in comments like `HACK: This is the function
that is called when the user makes login`, so you can use the search tool of your text editor to quickly find the places you need.
VS Code has a great extension that you can use for this: `TODO Tree`. It was originally meant to be used with `# TODO` comments,
but you can use it to quickly navigate in your code using your own tags. In vim you can use the `Ag` command to find them, there are
some cool fuzzy finders that will help you to integrate `the-silver-searcher` or `rip-grp`.


