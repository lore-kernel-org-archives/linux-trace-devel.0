Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7653255762
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 17:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0E8C433C8;
	Mon,  8 Jan 2024 17:48:31 +0000 (UTC)
Date: Mon, 8 Jan 2024 12:49:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240108124927.794daa38@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the following APIs:

 tracefs_cpu_open_mapped()
 tracefs_cpu_is_mapped()
 tracefs_cpu_map()
 tracefs_cpu_unmap()

This will allow applications to choose to memory map the tracing ring buffer
if it is supported. This will improve the performance of tracefs_cpu_read()
and tracefs_cpu_read_buf(), but it is not done by default because it will
also hurt the performance of tracefs_cpu_buffered_read() and
tracefs_cpu_buffered_read_buf() as those use splicing, and with the ring
buffer memory mapped, the splice has to do a copy instead of a copyless
subbuffer move.

Since this change relies on the libtraceevent APIs:

   kbuffer_dup()
   kbuffer_subbuffer()
   kbuffer_refresh()
   kbuffer_read_buffer()

Which are available after version 1.8, up the minimum version to 1.8.

Note, the samples and utest rely on:

   tep_get_sub_buffer_data_size()

which is in 1.8.1.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20231228201100.78aae259@rorschach.local.home

- Check for NULL mapping in trace_unmap() and trace_mmap_load_subbuf() and
  error out nicely instead of crashing if it is NULL.

 Documentation/libtracefs-cpu-map.txt | 194 +++++++++++++++++++++++++
 Documentation/libtracefs.txt         |   7 +
 Makefile                             |   3 +-
 include/tracefs-local.h              |   6 +
 include/tracefs.h                    |   7 +
 samples/Makefile                     |   1 +
 src/Makefile                         |   1 +
 src/tracefs-mmap.c                   | 207 +++++++++++++++++++++++++++
 src/tracefs-record.c                 |  61 ++++++++
 9 files changed, 486 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/libtracefs-cpu-map.txt
 create mode 100644 src/tracefs-mmap.c

diff --git a/Documentation/libtracefs-cpu-map.txt b/Documentation/libtracefs-cpu-map.txt
new file mode 100644
index 000000000000..dd5981f32daf
--- /dev/null
+++ b/Documentation/libtracefs-cpu-map.txt
@@ -0,0 +1,194 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_cpu_open_mapped, tracefs_cpu_is_mapped, tracefs_cpu_map, tracefs_cpu_unmap - Memory mapping of the ring buffer
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+bool *tracefs_cpu_is_mapped*(struct tracefs_cpu pass:[*]tcpu);
+int *tracefs_cpu_map*(struct tracefs_cpu pass:[*]tcpu);
+void *tracefs_cpu_unmap*(struct tracefs_cpu pass:[*]tcpu);
+struct tracefs_cpu pass:[*]*tracefs_cpu_open_mapped*(struct tracefs_instance pass:[*]instance,
+					    int cpu, bool nonblock);
+--
+
+DESCRIPTION
+-----------
+If the trace_pipe_raw supports memory mapping, this is usually a more efficient
+method to stream data from the kernel ring buffer than by reading it, as it does
+not require copying the memory that is being read.
+
+If memory mapping is supported by the kernel and the application asks to use the
+memory mapping via either *tracefs_cpu_map()* or by *tracefs_cpu_open_mapped()*
+then the functions *tracefs_cpu_read*(3) and *tracefs_cpu_read_buf*(3) will use
+the mapping directly instead of calling the read system call.
+
+Note, mapping can also slow down *tracefs_cpu_buffered_read*(3) and
+*tracefs_cpu_buffered_read_buf*(3), as those use splice piping and when the
+kernel ring buffer is memory mapped, splice does a copy instead of using the
+ring buffer directly. Thus care must be used when determining to map the
+ring buffer or not, and why it does not get mapped by default.
+
+The *tracefs_cpu_is_mapped()* function will return true if _tcpu_ currently has
+its ring buffer memory mapped and false otherwise. This does not return whether or
+not that the kernel supports memory mapping, but that can usually be determined
+by calling *tracefs_cpu_map()*.
+
+The *tracefs_cpu_map()* function will attempt to map the ring buffer associated
+to _tcpu_ if it is not already mapped.
+
+The *tracefs_cpu_unmap()* function will unmap the ring buffer associated to
+_tcpu_ if it is mapped.
+
+The *tracefs_cpu_open_mapped()* is equivalent to calling *tracefs_cpu_open*(3) followed
+by *tracefs_cpu_map()* on the returned _tcpu_ of *tracefs_cpu_open*(3). Note, this
+will still succeed if the mapping fails, in which case it acts the same as
+*tracefs_cpu_open*(3). If knowing if the mapping succeed or not, *tracefs_cpu_is_mapped()*
+should be called on the return _tcpu_.
+
+RETURN VALUE
+------------
+*tracefs_cpu_is_mapped()* returns true if the given _tcpu_ has its ring buffer
+memory mapped or false otherwise.
+
+*tracefs_cpu_map()* returns 0 on success and -1 on error in mapping. If 0 is
+returned then *tracefs_cpu_is_mapped()* will return true afterward, or false
+if the mapping failed.
+
+*tracefs_cpu_open_mapped()* returns an allocated tracefs_cpu on success of creation
+regardless if it succeed in mapping the ring buffer or not. It returns NULL for
+the same reasons *tracefs_cpu_open*(3) returns NULL. If success of mapping is
+to be known, then calling *tracefs_cpu_is_mapped()* afterward is required.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <ctype.h>
+#include <tracefs.h>
+
+static void read_subbuf(struct tep_handle *tep, struct kbuffer *kbuf)
+{
+	static struct trace_seq seq;
+	struct tep_record record;
+
+	if (seq.buffer)
+		trace_seq_reset(&seq);
+	else
+		trace_seq_init(&seq);
+
+	while ((record.data = kbuffer_read_event(kbuf, &record.ts))) {
+		record.size = kbuffer_event_size(kbuf);
+		kbuffer_next_event(kbuf, NULL);
+		tep_print_event(tep, &seq, &record,
+				"%s-%d %9d\t%s: %s\n",
+				TEP_PRINT_COMM,
+				TEP_PRINT_PID,
+				TEP_PRINT_TIME,
+				TEP_PRINT_NAME,
+				TEP_PRINT_INFO);
+		trace_seq_do_printf(&seq);
+		trace_seq_reset(&seq);
+	}
+}
+
+int main (int argc, char **argv)
+{
+	struct tracefs_cpu *tcpu;
+	struct tep_handle *tep;
+	struct kbuffer *kbuf;
+	bool mapped;
+	int cpu;
+
+	if (argc < 2 || !isdigit(argv[1][0])) {
+		printf("usage: %s cpu\n\n", argv[0]);
+		exit(-1);
+	}
+
+	cpu = atoi(argv[1]);
+
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		perror("Reading trace event formats");
+		exit(-1);
+	}
+
+	tcpu = tracefs_cpu_open_mapped(NULL, cpu, 0);
+	if (!tcpu) {
+		perror("Open CPU 0 file");
+		exit(-1);
+	}
+
+	/*
+	 * If this kernel supports mapping, use normal read,
+	 * otherwise use the piped buffer read.
+	 */
+	mapped = tracefs_cpu_is_mapped(tcpu);
+	if (!mapped)
+		printf("Was not able to map, falling back to buffered read\n");
+	while ((kbuf = mapped ? tracefs_cpu_read_buf(tcpu, true) :
+			tracefs_cpu_buffered_read_buf(tcpu, true))) {
+		read_subbuf(tep, kbuf);
+	}
+
+	kbuf = tracefs_cpu_flush_buf(tcpu);
+	if (kbuf)
+		read_subbuf(tep, kbuf);
+
+	tracefs_cpu_close(tcpu);
+	tep_free(tep);
+
+	return 0;
+}
+--
+
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*tracefs_cpu_open*(3),
+*tracefs_cpu_read*(3),
+*tracefs_cpu_read_buf*(3),
+*tracefs_cpu_buffered_read*(3),
+*tracefs_cpu_buffered_read_buf*(3),
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index b0aaa6222ec7..8dc3ba7386e3 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -138,6 +138,13 @@ Trace stream:
 	ssize_t *tracefs_trace_pipe_print*(struct tracefs_instance pass:[*]_instance_, int _flags_);
 	void *tracefs_trace_pipe_stop*(struct tracefs_instance pass:[*]_instance_);
 
+Memory mapping the ring buffer:
+	bool *tracefs_cpu_is_mapped*(struct tracefs_cpu pass:[*]tcpu);
+	int *tracefs_cpu_map*(struct tracefs_cpu pass:[*]tcpu);
+	void *tracefs_cpu_unmap*(struct tracefs_cpu pass:[*]tcpu);
+	struct tracefs_cpu pass:[*]*tracefs_cpu_open_mapped*(struct tracefs_instance pass:[*]instance,
+						int cpu, bool nonblock);
+
 Trace options:
 	const struct tracefs_options_mask pass:[*]*tracefs_options_get_supported*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_option_is_supported*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
diff --git a/Makefile b/Makefile
index 80076aa2cff3..e915e14b74e6 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,8 @@ export TFS_PATCHLEVEL
 export TFS_EXTRAVERSION
 export TRACEFS_VERSION
 
-LIBTRACEEVENT_MIN_VERSION = 1.3
+# Note, samples and utests need 1.8.1
+LIBTRACEEVENT_MIN_VERSION = 1.8
 
 # taken from trace-cmd
 MAKEFLAGS += --no-print-directory
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 9cae73c8b806..ffc9d33b1796 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -6,6 +6,7 @@
 #ifndef _TRACE_FS_LOCAL_H
 #define _TRACE_FS_LOCAL_H
 
+#include <tracefs.h>
 #include <pthread.h>
 
 #define __hidden __attribute__((visibility ("hidden")))
@@ -116,6 +117,11 @@ int trace_append_filter(char **filter, unsigned int *state,
 			enum tracefs_compare compare,
 			 const char *val);
 
+void *trace_mmap(int fd, struct kbuffer *kbuf);
+void trace_unmap(void *mapping);
+int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf);
+int trace_mmap_read(void *mapping, void *buffer);
+
 struct tracefs_synth *synth_init_from(struct tep_handle *tep,
 				      const char *start_system,
 				      const char *start_event);
diff --git a/include/tracefs.h b/include/tracefs.h
index 989112c851c8..8569171247b7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -693,6 +693,13 @@ int tracefs_snapshot_snap(struct tracefs_instance *instance);
 int tracefs_snapshot_clear(struct tracefs_instance *instance);
 int tracefs_snapshot_free(struct tracefs_instance *instance);
 
+/* Memory mapping of ring buffer */
+bool tracefs_cpu_is_mapped(struct tracefs_cpu *tcpu);
+int tracefs_cpu_map(struct tracefs_cpu *tcpu);
+void tracefs_cpu_unmap(struct tracefs_cpu *tcpu);
+struct tracefs_cpu *tracefs_cpu_open_mapped(struct tracefs_instance *instance,
+					    int cpu, bool nonblock);
+
 /* Mapping vsocket cids to pids using tracing */
 int tracefs_instance_find_cid_pid(struct tracefs_instance *instance, int cid);
 int tracefs_find_cid_pid(int cid);
diff --git a/samples/Makefile b/samples/Makefile
index 77739c8b0aa7..81c8006f823e 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -26,6 +26,7 @@ EXAMPLES += guest
 EXAMPLES += cpu-buf
 EXAMPLES += instances-stat
 EXAMPLES += instances-subbuf
+EXAMPLES += cpu-map
 
 TARGETS :=
 TARGETS += sqlhist
diff --git a/src/Makefile b/src/Makefile
index faa3b25c4002..be81059ce10a 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -16,6 +16,7 @@ OBJS += tracefs-dynevents.o
 OBJS += tracefs-eprobes.o
 OBJS += tracefs-uprobes.o
 OBJS += tracefs-record.o
+OBJS += tracefs-mmap.o
 ifeq ($(VSOCK_DEFINED), 1)
 OBJS += tracefs-vsock.o
 endif
diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
new file mode 100644
index 000000000000..580745325c2c
--- /dev/null
+++ b/src/tracefs-mmap.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ */
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/ioctl.h>
+#include <asm/types.h>
+#include "tracefs-local.h"
+
+struct trace_buffer_meta {
+	unsigned long	entries;
+	unsigned long	overrun;
+	unsigned long	read;
+
+	unsigned long	subbufs_touched;
+	unsigned long	subbufs_lost;
+	unsigned long	subbufs_read;
+
+	struct {
+		unsigned long	lost_events;	/* Events lost at the time of the reader swap */
+		__u32		id;		/* Reader subbuf ID from 0 to nr_subbufs - 1 */
+		__u32		read;		/* Number of bytes read on the reader subbuf */
+	} reader;
+
+	__u32		subbuf_size;		/* Size of each subbuf including the header */
+	__u32		nr_subbufs;		/* Number of subbufs in the ring-buffer */
+
+	__u32		meta_page_size;		/* Size of the meta-page */
+	__u32		meta_struct_len;	/* Len of this struct */
+};
+
+#define TRACE_MMAP_IOCTL_GET_READER		_IO('T', 0x1)
+
+struct trace_mmap {
+	struct trace_buffer_meta	*map;
+	struct kbuffer			*kbuf;
+	void				*data;
+	int				*data_pages;
+	int				fd;
+	int				last_idx;
+	int				last_read;
+	int				meta_len;
+	int				data_len;
+};
+
+/**
+ * trace_mmap - try to mmap the ring buffer
+ * @fd: The file descriptor to the trace_pipe_raw file
+ * @kbuf: The kbuffer to load the subbuffer to
+ *
+ * Will try to mmap the ring buffer if it is supported, and
+ * if not, will return NULL, otherwise it returns a descriptor
+ * to handle the mapping.
+ */
+__hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
+{
+	struct trace_mmap *tmap;
+	int page_size;
+	void *meta;
+	void *data;
+
+	page_size = getpagesize();
+	meta = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (meta == MAP_FAILED)
+		return NULL;
+
+	tmap = calloc(1, sizeof(*tmap));
+	if (!tmap) {
+		munmap(meta, page_size);
+		return NULL;
+	}
+
+	tmap->kbuf = kbuffer_dup(kbuf);
+	if (!tmap->kbuf) {
+		munmap(meta, page_size);
+		free(tmap);
+	}
+
+	tmap->fd = fd;
+
+	tmap->map = meta;
+	tmap->meta_len = tmap->map->meta_page_size;
+
+	if (tmap->meta_len > page_size) {
+		munmap(meta, page_size);
+		meta = mmap(NULL, tmap->meta_len, PROT_READ, MAP_SHARED, fd, 0);
+		if (meta == MAP_FAILED) {
+			kbuffer_free(tmap->kbuf);
+			free(tmap);
+			return NULL;
+		}
+		tmap->map = meta;
+	}
+
+	tmap->data_pages = meta + tmap->meta_len;
+
+	tmap->data_len = tmap->map->subbuf_size * tmap->map->nr_subbufs;
+
+	tmap->data = mmap(NULL, tmap->data_len, PROT_READ, MAP_SHARED,
+			  fd, tmap->meta_len);
+	if (tmap->data == MAP_FAILED) {
+		munmap(meta, tmap->meta_len);
+		kbuffer_free(tmap->kbuf);
+		free(tmap);
+		return NULL;
+	}
+
+	tmap->last_idx = tmap->map->reader.id;
+
+	data = tmap->data + tmap->map->subbuf_size * tmap->last_idx;
+	kbuffer_load_subbuffer(kbuf, data);
+
+	/*
+	 * The page could have left over data on it that was already
+	 * consumed. Move the "read" forward in that case.
+	 */
+	if (tmap->map->reader.read) {
+		int size = kbuffer_start_of_data(kbuf) + tmap->map->reader.read;
+		char tmpbuf[size];
+		kbuffer_read_buffer(kbuf, tmpbuf, size);
+	}
+
+	return tmap;
+}
+
+__hidden void trace_unmap(void *mapping)
+{
+	struct trace_mmap *tmap = mapping;
+
+	if (!tmap)
+		return;
+
+	munmap(tmap->data, tmap->data_len);
+	munmap(tmap->map, tmap->meta_len);
+	kbuffer_free(tmap->kbuf);
+	free(tmap);
+}
+
+__hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
+{
+	struct trace_mmap *tmap = mapping;
+	void *data;
+	int id;
+
+	if (!tmap)
+		return -1;
+
+	id = tmap->map->reader.id;
+	data = tmap->data + tmap->map->subbuf_size * id;
+
+	/*
+	 * If kbuf doesn't point to the current sub-buffer
+	 * just load it and return.
+	 */
+	if (data != kbuffer_subbuffer(kbuf)) {
+		kbuffer_load_subbuffer(kbuf, data);
+		return 1;
+	}
+
+	/*
+	 * Perhaps the reader page had a write that added
+	 * more data.
+	 */
+	kbuffer_refresh(kbuf);
+
+	/* Are there still events to read? */
+	if (kbuffer_curr_size(kbuf))
+		return 1;
+
+	/* See if a new page is ready? */
+	if (ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
+		return -1;
+	id = tmap->map->reader.id;
+	data = tmap->data + tmap->map->subbuf_size * id;
+
+	/*
+	 * If the sub-buffer hasn't changed, then there's no more
+	 * events to read.
+	 */
+	if (data == kbuffer_subbuffer(kbuf))
+		return 0;
+
+	kbuffer_load_subbuffer(kbuf, data);
+	return 1;
+}
+
+__hidden int trace_mmap_read(void *mapping, void *buffer)
+{
+	struct trace_mmap *tmap = mapping;
+	struct kbuffer *kbuf;
+	int ret;
+
+	if (!tmap)
+		return -1;
+
+	kbuf = tmap->kbuf;
+
+	ret = trace_mmap_load_subbuf(mapping, kbuf);
+	/* Return for error or no more events */
+	if (ret <= 0)
+		return ret;
+
+	/* Update the buffer */
+	return kbuffer_read_buffer(kbuf, buffer, tmap->map->subbuf_size);
+}
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index e8be3335070b..f51e18420bc7 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -36,6 +36,7 @@ struct tracefs_cpu {
 	int		splice_read_flags;
 	struct kbuffer	*kbuf;
 	void		*buffer;
+	void		*mapping;
 };
 
 /**
@@ -229,6 +230,31 @@ int tracefs_snapshot_free(struct tracefs_instance *instance)
 	return ret < 0 ? -1 : 0;
 }
 
+/**
+ * tracefs_cpu_open_mapped - open an instance raw trace file and map it
+ * @instance: the instance (NULL for toplevel) of the cpu raw file to open
+ * @cpu: The CPU that the raw trace file is associated with
+ * @nonblock: If true, the file will be opened in O_NONBLOCK mode
+ *
+ * Return a descriptor that can read the tracefs trace_pipe_raw file
+ * for a give @cpu in a given @instance.
+ *
+ * Returns NULL on error.
+ */
+struct tracefs_cpu *
+tracefs_cpu_open_mapped(struct tracefs_instance *instance, int cpu, bool nonblock)
+{
+	struct tracefs_cpu *tcpu;
+
+	tcpu = tracefs_cpu_open(instance, cpu, nonblock);
+	if (!tcpu)
+		return NULL;
+
+	tracefs_cpu_map(tcpu);
+
+	return tcpu;
+}
+
 static void close_fd(int fd)
 {
 	if (fd < 0)
@@ -285,6 +311,28 @@ int tracefs_cpu_read_size(struct tracefs_cpu *tcpu)
 	return tcpu->subbuf_size;
 }
 
+bool tracefs_cpu_is_mapped(struct tracefs_cpu *tcpu)
+{
+	return tcpu->mapping != NULL;
+}
+
+int tracefs_cpu_map(struct tracefs_cpu *tcpu)
+{
+	if (tcpu->mapping)
+		return 0;
+
+	tcpu->mapping = trace_mmap(tcpu->fd, tcpu->kbuf);
+	return tcpu->mapping ? 0 : -1;
+}
+
+void tracefs_cpu_unmap(struct tracefs_cpu *tcpu)
+{
+	if (!tcpu->mapping)
+		return;
+
+	trace_unmap(tcpu->mapping);
+}
+
 static void set_nonblock(struct tracefs_cpu *tcpu)
 {
 	long flags;
@@ -383,6 +431,9 @@ int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 	if (ret <= 0)
 		return ret;
 
+	if (tcpu->mapping)
+		return trace_mmap_read(tcpu->mapping, buffer);
+
 	ret = read(tcpu->fd, buffer, tcpu->subbuf_size);
 
 	/* It's OK if there's no data to read */
@@ -427,6 +478,16 @@ struct kbuffer *tracefs_cpu_read_buf(struct tracefs_cpu *tcpu, bool nonblock)
 {
 	int ret;
 
+	/* If mapping is enabled, just use it directly */
+	if (tcpu->mapping) {
+		ret = wait_on_input(tcpu, nonblock);
+		if (ret <= 0)
+			return NULL;
+
+		ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf);
+		return ret > 0 ? tcpu->kbuf : NULL;
+	}
+
 	if (!get_buffer(tcpu))
 		return NULL;
 
-- 
2.43.0

