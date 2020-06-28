#ifndef _RW_TEST_H_
#define _RW_TEST_H_

/* FILE/buffer size defined */
#define FILESIZE	(1LU)             //    1 MiB
#define BUFSIZE		(4LU * (1 << 10)) // 4096 Byte
#define BLOCKSIZE	(1LU << 9)        //  512 Byte
#define BINPREFIX	(1LU << 10)       // 1024 Byte
#define FILENAMESIZE	256

/* read/write test */
#define IOREAD (1U << 0)
#define IOWRITE (1U << 1)

/* program metadata */
#define OPTIONSTR	"bd:f:s:t:Dq"
#define VERSION "0.1"
#define FILENAME	"FILE0000.TXT"

#endif
