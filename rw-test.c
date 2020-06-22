#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdbool.h>
#include "rw-test.h"

void usage();

int main(int argc, char **argv) {
	int i = 0;
	int fd = 0;
	int c = 0;
	int bufindex = 0;
	size_t ret = 0;
	char *buf;
	char file_name[FILENAMESIZE] = {FILENAME};
	bool bufsync = false;
	bool direct_io = false;
	int iotype = IOREAD | IOWRITE;
	int file_size = FILESIZE;
	int chunk_size = BUFSIZE;
	int num_chunks = 0;
	int iflags = O_WRONLY | O_CREAT;
	int oflags = O_RDONLY | O_EXCL;

	/* analyze Option */
	while((c = getopt(argc, argv, OPTIONSTR)) != -1) {
		switch(c) {
			case 'b':
				bufsync = true;
				break;
			case 'd':
				if(chdir(optarg)) {
					fprintf(stderr, "Can't change to directory \"%s\".\n", optarg);
					usage();
				}
				break;
			case 'f':
				memset(file_name, 0x00, FILENAMESIZE);
				snprintf(file_name, FILENAMESIZE - 1, "%s", optarg);
				break;
			case 's':
				{
					char *sbuf = strdup(optarg);
					char *size = strtok(sbuf, ":");
					file_size = atoi(size);
					char c = size[strlen(size) - 1];
					if(c == 'g' || c == 'G') {
						file_size *= BINPREFIX;
					} else if(c == 'm' || c == 'M') {
						file_size *= 1;
					} else if(c == 'k' || c == 'K') {
						file_size /= BINPREFIX;
					}
					size = strtok(NULL, "");
					if(size)
					{
						int tmp = atoi(size);
						c = size[strlen(size) - 1];
						if(c == 'k' || c == 'K') {
							tmp *= BINPREFIX;
						} else if(c == 'm' || c == 'M') {
							tmp *= (BINPREFIX * BINPREFIX);
						} else if(c == 'g' || c == 'G') {
							tmp *= (BINPREFIX * BINPREFIX * BINPREFIX);
						} 
						chunk_size = tmp;
					}
				}
				break;
			case 't':
				if(strlen(optarg)) {
					c = optarg[0];
					if(c == 'r') {
						iotype = IOREAD;
					} else if(c == 'w') {
						iotype = IOWRITE;
					}
				}
				break;
			case 'D':
				direct_io = true;
				break;
			case '?':
				/* FALLTHROUGH */
			case ':':
				usage();
		}
	}

	posix_memalign( (void **)&buf, BLOCKSIZE, BUFSIZE);
	num_chunks = (BINPREFIX * BINPREFIX) * file_size / chunk_size;
	if(direct_io) {
		iflags = O_DIRECT;
		oflags = O_DIRECT;
	}

	/* Phase: WRITE */
	if(iotype & IOWRITE) {
		fd = open(file_name, iflags, S_IREAD | S_IWRITE);
		if(fd < 0) {
			perror("open");
			exit(EXIT_FAILURE);
		}
		memset(buf, 0, BUFSIZE);
		for(i = 0; i < num_chunks; i++)
		{
			buf[bufindex]++;
			bufindex = (bufindex + 1) % chunk_size;
			ret = write(fd, buf, chunk_size);
			if (ret < 0) {
				perror("write");
				close(fd);
				exit(EXIT_FAILURE);
			}
			if(bufsync)
				fsync(fd);
		}
		close(fd);
	}

	/* Phase: READ  */
	if(iotype & IOREAD) {
		oflags = O_RDWR;
		fd = open(file_name, oflags);
		if(fd < 0) {
			perror("open");
			exit(EXIT_FAILURE);
		}
		memset(buf, 0, BUFSIZE);
		for(i = 0; i < num_chunks; i++)
		{
			ret = read(fd, buf, chunk_size);
			if (ret < 0) {
				perror("read");
				close(fd);
				exit(EXIT_FAILURE);
			}
		}
		close(fd);
	}
}

void usage(void) {
	fprintf(stderr, "Usage: iotest [-d scratch-dir] [-s size(MiB)[:shunk-size(b)]]\n");
	fprintf(stderr, "              [-f filename] [-t read/write] [-b] [-D]\n");
	fprintf(stderr, "\nVersion: %s\n", VERSION);
	exit(EXIT_FAILURE);
}
