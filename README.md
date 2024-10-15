# jot
A simple Bash script for a truly minimal command-line logging utility. 

## Overview
`jot` is a truly minimal command-line logging utility.
- it's a very simple Bash script.
- it comes with a installer script that automates the creation of a function
```
# jot is a logging utility. jot -h for usage info.
jot() {
    "$HOME/jot.sh" "$@"
    history -d $(history 1)
    sed -i '$d' ~/.bash_history
}
```

in your ./.bashrc


## Installation
1. Download jot.sh
2. Place it in your $HOME.
2. Make it executable `chmod +x ~/jot.sh`
3. Download the jot-installer.sh
4. Make the installer executable `chmod +x ~/jot-installer.sh`
5. Run the installer `./jot-installer.sh`

Now you can type `jot -h` to find out about usage.

jot creates a jot.txt file in your $HOME, that's where it keeps all your jots.

## Usage

- -a 'press enter': enter jot log message prompt.
- -v : View all log entries.
- -s 'keyword' : Search log entries for a specific keyword.
- -c : Clear all log entries.
- -t : View logs from today.
- -y : View logs from yesterday.
- -d : Delete the last log entry.
- -h : Show help information.

## Example output of jot -v
```
2024-10-12 20:11:36 - Today I created jot.
2024-10-12 20:11:58 - jot is a truly minimalistic command-line personal logging tool.
2024-10-12 20:13:39 - jot does not use any external editor and works as a prompt tool. Although you can add multiple lines, jot philosophy recommends simplicity.
2024-10-12 20:14:22 - jot's core belief is that a useful log is a line-by-line log.
2024-10-12 20:15:07 - jot a minimal quick log journaling command prompt tool written in Bash!
2024-10-12 20:15:43 - jot has a few viewing and searching capabilities that are being constantly enchanced.
2024-10-12 20:16:37 - the idea is to go jot -a and press enter.
2024-10-12 20:17:25 - this will take you to the jot your log message prompt where you will be able to jot your log message.
2024-10-12 20:18:15 - jot provides a searching function using the grep command.
2024-10-12 20:18:44 - just go jot -s <insert search term>
2024-10-12 20:18:55 - and you will see.
2024-10-12 20:28:02 - after a few more adjustments I think it's running pretty smoothly now...
2024-10-12 20:28:34 - jot is working pretty well.
2024-10-12 20:28:56 - I think it might suit my needs well...
2024-10-12 20:29:21 - I hope I get to use it in my work. Or maybe to write poems and stuff.

```