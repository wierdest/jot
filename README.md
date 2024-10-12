# jot
A simple Bash script for a truly minimal command-line logging utility. 

## Overview
`jot` is a truly minimal command-line logging utility.
- it's a very simple Bash script.
- it comes with a installer script that automates the creation of a function
```
# Custom jot function. jot is a logging utility. jot -h for more info.
jot() {
    "/home/andre/jot.sh" "$@"
    history -d $(history 1)
    sed -i '$d' ~/.bash_history
}
```

in your ./.bashrc


## Installation
1. Download jot.sh
2. Place it in your $HOME for ease of use or wherever you like
2. Make it executable `chmod +x ~/jot.sh`
3. Download the jot-installer.sh
4. Make the installer executable `chmod +x ~/jot-installer.sh`
5. Run the installer `./jot-installer.sh`

Now you can type `jot -h` to find out about usage.

## Usage

-a 'log entry' : Add a new log entry.
-v : View all log entries.
-s 'keyword' : Search log entries for a specific keyword.
-c : Clear all log entries.
-t : View logs from today.
-y : View logs from yesterday.
-d : Delete the last log entry.
-h : Show help information.
