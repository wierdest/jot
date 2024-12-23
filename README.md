# jot
A Bash script for a command-line logging utility. 

## Overview
`jot` is command-line logging utility.
- it does not use an external editor for writing or reading messages
- it comes with a installer script that automates the creation of this function in your .bashrc:
```
# jot is a logging utility. jot -h for usage info.
jot() {
    "$HOME/jot.sh" "$@"
    history -d $(history 1)
    sed -i '$d' ~/.bash_history
}
```
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
`jot` followed by one of the options:

- -a 'press enter': enter jot log message prompt.
- -s 'keyword' : Search log entries for a specific keyword.
- -r 'n': View -n log entries from the most recent to the oldest.
- -v : View all log entries.
- -c : Clear all log entries.
- -t : View logs from today.
- -y : View logs from yesterday.
- -d : Delete the last log entry.
- -h : Show help information.

## Writing
`jot` asks for a topic if it's your first input:

```
No topic found. Please enter a new topic:

```
- if it's not your first message, it shows you the last topic and present the opportunity to change it:

```
Topic: 'MY FIRST TOPIC'. Add new? Leave it blank to use current...

```
## Reading

`jot` colors the logs according to timestamp. 
- it follows the color convention: YELLOW for most recent, BLUE for less and MAGENTA for older messages.
- there are two ways of viewing messages:
`jot -v` conventions:
    >> most recent: logs within the current hour
    >> less recent: logs within the same day
`jot -r -n` conventions:
    >> most recent: logs within the current hour
    >> less recent: logs within three hours
- 



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