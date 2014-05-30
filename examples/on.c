/*
 *	watch an event file. When a change is found (via mtime) run a specified command.
 *
 *	on owner.eventname command [ args ]
 */

#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#ifndef PATH_MAX
#define PATH_MAX 16384
#endif

static double mtime(const char* path);
static void die(const char* msg);
static void sys(const char* cmd, char** args);

int main(int argc, char** argv) {
	const char* argv0 = *argv++;
	const char* path = 0;
	char** command = 0;
  
	while(*argv) {
		if(!path) { path = *argv++; continue; }
		if(!command) { command = argv; break; }
	}

	if(!path) {
		fprintf(stderr, "Usage: %s path [ command [ args .. ] ]\n", argv0);
		exit(1);
	}

	double recent_mtime = mtime(path);
	fprintf(stderr, "mtime: %.3f\n", recent_mtime);

	while(1) {
		usleep(50 * 1000);
		double old_mtime = recent_mtime;
		recent_mtime = mtime(path);
		fprintf(stderr, "mtime: %.3f\n", recent_mtime);
		if(recent_mtime == old_mtime) continue;

		if(command)
			sys(*command, command);
		else
			printf("%s\n", path);
		
#ifdef ON_MODE_ONCE
		exit(0);
#endif
	}
}

static void sys(const char* cmd, char** args) {
	if(!cmd) cmd = args[0];

	pid_t child_pid = fork();
	if(child_pid < 0)
		die("fork");

	if (child_pid == 0) /* fork() returns 0 for the child process */
	{
		execvp(cmd, (char**)args);
		die(cmd);
	}

	int status;
	wait(&status); /* wait for child to exit, and store child's exit status */

	if(WEXITSTATUS(status) != 0) {
		fprintf(stderr, "%s exited with error %d.\n", cmd, WEXITSTATUS(status));
		exit(WEXITSTATUS(status));
	}
}

#ifdef __APPLE__

static double mtime(const char* path) {
	struct stat st;
	if(stat(path, &st) == -1) return -1;
	struct timespec mtime = st.st_mtimespec;
	return mtime.tv_sec + mtime.tv_nsec / 1000000000.0;
}

#endif

static void die(const char* what)
{
	perror(what);
	exit(1);
}
