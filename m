Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C77AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Dec 2022 00:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLIAHY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 19:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiLIAHQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 19:07:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539B276828
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 16:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3C04B826A7
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Dec 2022 00:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589DCC433EF
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Dec 2022 00:07:11 +0000 (UTC)
Date:   Thu, 8 Dec 2022 19:07:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceeevent: Add kbuffer API man pages
Message-ID: <20221208190709.1f1dc458@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The kbuffer API has never been documented. Add the man pages for the
functions that applications are likely to use.

Note, the functions:

  kbuffer_set_old_format
  kbuffer_raw_get
  kbuffer_ptr_delta
  kbuffer_translate_data

Are for internal use by trace-cmd, and really should not be used by other
applications as they are implementation specific. They are exported, so
they should be stable, but lets not encourage their use by documenting how
to use them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtraceevent-kbuffer-create.txt          | 207 +++++++++++++++
 Documentation/libtraceevent-kbuffer-read.txt  | 247 ++++++++++++++++++
 .../libtraceevent-kbuffer-timestamp.txt       | 209 +++++++++++++++
 Documentation/libtraceevent.txt               |  18 ++
 check-manpages.sh                             |  21 +-
 5 files changed, 700 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/libtraceevent-kbuffer-create.txt
 create mode 100644 Documentation/libtraceevent-kbuffer-read.txt
 create mode 100644 Documentation/libtraceevent-kbuffer-timestamp.txt

diff --git a/Documentation/libtraceevent-kbuffer-create.txt b/Documentation/libtraceevent-kbuffer-create.txt
new file mode 100644
index 000000000000..12e5d6cd6b80
--- /dev/null
+++ b/Documentation/libtraceevent-kbuffer-create.txt
@@ -0,0 +1,207 @@
+libtraceevent(3)
+================
+
+NAME
+----
+kbuffer_alloc, kbuffer_free, kbuffer_load_subbuffer, kbuffer_subbuffer_size, kbuffer_start_of_data - Creating of kbuffer element to parse
+the Linux kernel tracing ring buffer
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <kbuffer.h>*
+
+enum kbuffer_endian {
+	KBUFFER_ENDIAN_BIG,
+	KBUFFER_ENDIAN_LITTLE,
+	KBUFFER_ENDIAN_SAME_AS_HOST,
+};
+
+enum kbuffer_long_size {
+	KBUFFER_LSIZE_4,
+	KBUFFER_LSIZE_8,
+	KBUFFER_LSIZE_SAME_AS_HOST,
+};
+
+struct kbuffer;
+struct tep_handle;
+
+struct kbuffer pass:[*]*kbuffer_alloc*(enum kbuffer_long_size _size_, enum kbuffer_endian _endian_);
+void *kbuffer_free*(struct kbuffer pass:[*]_kbuf_);
+int *kbuffer_load_subbuffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuffer_);
+int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf);
+int *kbuffer_start_of_data*(struct kbuffer pass:[*]_kbuf_);
+--
+
+DESCRIPTION
+-----------
+These functions create a _kbuffer_ handle that can be used to parse the raw sub buffers
+of the Linux kernel tracing ring buffer. The ring buffer is found in the tracefs
+directory, and can be retrieved by *tracefs_instance_get_file(3)* at
+*per_cpu/cpuX/trace_pipe_raw* where *X* is replaced by the per CPU number of
+the specified ring buffer. The ring buffer inside the kernel is split up per
+CPU, such that the raw ring buffer must be retrieved per CPU as well.
+
+The *kbuffer_alloc()* will create a descriptor that can be used to manage a sub buffer
+read by the ring buffer. The _size_ parameter denotes what the word size is
+for the given buffer (note, this works from reading raw data from machines other
+than the machine that is calling this function). The _endian_ denotes the endian
+for the machine.
+
+If _endian_ is set to _KBUFFER_ENDIAN_SAME_AS_HOST_ the endian will be set to the same
+as the host endianess, which is useful when the application is reading the
+ring buffer data directly from the same machine it is running on.
+
+If _size_ is set to _KBUFFER_LSIZE_SAME_AS_HOST_, if the word size is 8, it will
+set the kbuffer descriptor to long size of 8. But if the size is 4, then it
+will then perform a *uname(2)* call, and if the _machine_ field has the string "64"
+in it, it will be set to 8 byte long size and not 4 byte. This is because the
+ring buffer long size is dependent on the kernel and not user space.
+
+The *kbuffer_free()* function will free the resources created by *kbuffer_alloc()*.
+
+The *kbuffer_load_subbuffer()* will take a _subbuffer_ which is a raw data blob
+from the tracefs *trace_pipe_raw* file. The Linux tracing ring buffer is broken up
+into sub buffers. Each sub buffer is as stand alone data segment that has all the
+information to split out the individual events and time stamps. This sub buffer
+is what kbuffer uses to walk the events.
+
+The *kbuffer_subbuffer_size()* returns the location of the end of the last event
+on the sub-buffer. It does not return the size of the sub-buffer itself.
+
+The *kbuffer_start_of_data()* function returns the offset of where the actual
+data load of the sub-buffer begins.
+
+RETURN VALUE
+------------
+*kbuffer_alloc()* returns an allocated kbuffer descriptor or NULL on error.
+The returned descriptor must be freed with *kbuffer_free()*
+
+*kbuffer_load_subbuffer()* returns 0 on success and -1 on error.
+
+*kbuffer_subbuffer_size()* returns the index on the subbuffer where the end
+of the last event is located.
+
+*kbuffer_start_of_data()* returns the offset of where the data begins on the
+sub-buffer loaded in _kbuf_.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/stat.h>
+
+#include <kbuffer.h>
+
+int main (int argc, char **argv)
+{
+	unsigned long long ts;
+	struct kbuffer *kbuf;
+	struct stat st;
+	char *buf;
+	void *event;
+	int ret;
+	int fd;
+	int i = 0;
+
+	if (argc < 2) {
+		printf("usage: %s raw-subbuffer-page\n", argv[0]);
+		printf(" Try: dd count=1 bs=4096 if=/sys/kernel/tracing/per_cpu/cpu0/trace_pipe_raw of=/tmp/file\n");
+		exit(0);
+	}
+
+	if (stat(argv[1], &st) < 0) {
+		perror("stat");
+		exit(-1);
+	}
+
+	buf = malloc(st.st_size);
+	if (!buf) {
+		perror("Allocating buffer");
+		exit(-1);
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror(argv[1]);
+		exit(-1);
+	}
+
+	ret = read(fd, buf, st.st_size);
+	if (ret < 0) {
+		perror("Reading buffer");
+		exit(-1);
+	}
+	close(fd);
+
+	kbuf = kbuffer_alloc(KBUFFER_ENDIAN_SAME_AS_HOST,
+			     KBUFFER_LSIZE_SAME_AS_HOST);
+	if (!kbuf) {
+		perror("Creating kbuffer");
+		exit(-1);
+	}
+	ret = kbuffer_load_subbuffer(kbuf, buf);
+	if (ret < 0) {
+		perror("Loading sub bufer");
+		exit(-1);
+	}
+
+	if (kbuffer_subbuffer_size(kbuf) > st.st_size) {
+		fprintf(stderr, "kbuffer is bigger than raw size %d > %ld\n",
+			kbuffer_subbuffer_size(kbuf), st.st_size);
+		exit(-1);
+	}
+
+	printf("Kbuffer data starts at %d\n", kbuffer_start_of_data(kbuf));
+	do {
+		event = kbuffer_read_event(kbuf, &ts);
+		if (event) {
+			printf(" event %3d ts:%lld\n", i++, ts);
+			event = kbuffer_next_event(kbuf, NULL);
+		}
+	} while (event);
+
+	if (!event)
+		printf("Finished sub buffer\n");
+
+	kbuffer_free(kbuf);
+
+	return 0;
+}
+--
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtraceevent*(3), *trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-kbuffer-read.txt b/Documentation/libtraceevent-kbuffer-read.txt
new file mode 100644
index 000000000000..e4eb0f9bdcbe
--- /dev/null
+++ b/Documentation/libtraceevent-kbuffer-read.txt
@@ -0,0 +1,247 @@
+libtraceevent(3)
+================
+
+NAME
+----
+kbuffer_read_event, kbuffer_next_event, kbuffer_missed_events, kbuffer_event_size, kbuffer_curr_size,
+kbuffer_curr_offset, kbuffer_curr_index -
+Functions to read through the kbuffer sub buffer.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <kbuffer.h>*
+
+void pass:[*]*kbuffer_read_event*(struct kbuffer pass:[*]_kbuf_, unsigned long long pass:[*]_ts_);
+void pass:[*]*kbuffer_next_event*(struct kbuffer pass:[*]_kbuf_, unsigned long long pass:[*]_ts_);
+void pass:[*]*kbuffer_read_at_offset*(struct kbuffer pass:[*]_kbuf_, int _offset_, unsigned long long pass:[*]_ts_);
+int *kbuffer_missed_events*(struct kbuffer pass:[*]_kbuf_);
+int *kbuffer_event_size*(struct kbuffer pass:[*]_kbuf_);
+int *kbuffer_curr_size*(struct kbuffer pass:[*]_kbuf_);
+int *kbuffer_curr_offset*(struct kbuffer pass:[*]_kbuf_);
+int *kbuffer_curr_index*(struct kbuffer pass:[*]_kbuf_);
+--
+
+DESCRIPTION
+-----------
+The function *kbuffer_read_event()* reads the next event in the _kbuf_ descriptor
+and if _ts_ is non NULL, will place its timestamp into it. This does not modify the _kbuf_
+descriptor, and calling this function mulitple times will return the same result.
+
+The function *kbuffer_next_event()* will return the next event in the _kbuf_ descriptor.
+It will also set the _ts_ to the timestamp of the returned event. NULL is returned
+if there are no more events and _ts_ will be undefined. Note, if this is called directly
+after a *kbuffer_load_subbuffer()* then it will likely give an unexpected result, as it
+will return the second event and not the first event. Usually this function is only used
+to move to the next event and to know if there's any more events to read, and
+*kbuffer_read_event()* is always called first.
+
+The function *kbuffer_read_at_offset()* returns the event located at a given _offset_ from
+the beginning of the sub-buffer. This offset can be retrieved by *kbuffer_curr_offset()*.
+If _ts_ points to an unsigned long long, then it will be set to the event at the given
+offset's timestamp.
+
+If the sub-buffer had missed events before it, then *kbuffer_missed_events()* will return
+the non zero. If it returns -1, that means there were missed events, but the exact number
+of missed events is unknown. If it returns a positive number, then the number of missed events
+is the return value.
+
+The *kbuffer_event_size()* function returns the size of the data portion of the current event
+(the one that would be returned by *kbuffer_read_event()*.
+
+The *kbuffer_curr_size()* function returns the entire record size of the current event
+(the one that would be returned by *kbuffer_read_event()*. The difference here is that the
+return value includes the size of the event record meta data that is not part of what
+is returned by *kbuffer_read_event()*.
+
+The *kbuffer_curr_offset()* function returns the offset from the beginning of the sub-buffer
+of where the current event's meta data for the record begins. The first event will
+not be at offset zero. This offset can be used to retrieve the event with
+*kbuffer_read_at_offset()*.
+
+The *kbuffer_curr_index()* function returns the index from the beginning of the data
+portion of the sub-buffer where the current evnet's meta data is located.
+The first event will likely be zero, but may not be if there's a timestamp attached to it.
+
+RETURN VALUE
+------------
+*kbuffer_read_event()* returns the event that the _kbuf_ descriptor is currently at,
+or NULL if the last event was passed (by *kbuffer_next_event()*).
+
+*kbuffer_next_event()* returns the next event after the current event or NULL if there
+are no more events.
+
+*kbuffer_read_at_offset()* returns the event at a given _offset_ from the start of
+the sub-buffer stored in _kbuf_, or NULL if there exists no event. Note, _offset_
+only needs to be an offset that lands on the record, or is at the start of it. It does
+not need to be exactly at the beginning of the record.
+
+*kbuffer_missed_events()* returns 0 if there were no missed events before loaded sub-buffer.
+Returns -1 if there were an unknown number of missed events, or if the number of missed events
+is known, that number will be returned.
+
+*kbuffer_event_size()* returns the size of the data payload of the current event of _kbuf_.
+
+*kbuffer_curr_size()* returns the size of the entire record of the current event of _kbuf_.
+This includes the size of the meta data for that record.
+
+*kbuf_curr_offset()* returns the offset of the current record from the beginning of the _kbuf_
+sub-buffer.
+
+*kbuf_curr_index()* returns the index of the current record from the beginning of the _kbuf_
+data section.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/stat.h>
+
+#include <kbuffer.h>
+
+int main (int argc, char **argv)
+{
+	unsigned long long ts;
+	struct kbuffer *kbuf;
+	struct stat st;
+	char *buf;
+	void *event;
+	int save_offset = -1;
+	int record_size;
+	int offset;
+	int index;
+	int size;
+	int ret;
+	int fd;
+	int i = 0;
+
+	if (argc < 2) {
+		printf("usage: %s raw-subbuffer-page\n", argv[0]);
+		printf(" Try: dd count=1 bs=4096 if=/sys/kernel/tracing/per_cpu/cpu0/trace_pipe_raw of=/tmp/file\n");
+		exit(0);
+	}
+
+	if (stat(argv[1], &st) < 0) {
+		perror("stat");
+		exit(-1);
+	}
+
+	buf = malloc(st.st_size);
+	if (!buf) {
+		perror("Allocating buffer");
+		exit(-1);
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror(argv[1]);
+		exit(-1);
+	}
+
+	ret = read(fd, buf, st.st_size);
+	if (ret < 0) {
+		perror("Reading buffer");
+		exit(-1);
+	}
+	close(fd);
+
+	kbuf = kbuffer_alloc(KBUFFER_ENDIAN_SAME_AS_HOST,
+			     KBUFFER_LSIZE_SAME_AS_HOST);
+	if (!kbuf) {
+		perror("Creating kbuffer");
+		exit(-1);
+	}
+	ret = kbuffer_load_subbuffer(kbuf, buf);
+	if (ret < 0) {
+		perror("Loading sub bufer");
+		exit(-1);
+	}
+
+	if (kbuffer_subbuffer_size(kbuf) > st.st_size) {
+		fprintf(stderr, "kbuffer is bigger than raw size %d > %ld\n",
+			kbuffer_subbuffer_size(kbuf), st.st_size);
+		exit(-1);
+	}
+
+	ret = kbuffer_missed_events(kbuf);
+	if (ret) {
+		if (ret > 0)
+			printf("Missed %d events before this buffer\n", ret);
+		else
+			printf("Missed unknown number of events before this buffer\n");
+	}
+	do {
+		event = kbuffer_read_event(kbuf, &ts);
+		if (event) {
+			record_size = kbuffer_curr_size(kbuf);
+			offset = kbuffer_curr_offset(kbuf);
+			index = kbuffer_curr_index(kbuf);
+			size = kbuffer_event_size(kbuf);
+
+			if (i == 20)
+				save_offset = offset;
+			printf(" event %3d ts:%lld\trecord_size:%d size:%d\tindex:%d offset:%d\n",
+			       i++, ts, record_size, size, index, offset);
+			event = kbuffer_next_event(kbuf, NULL);
+		}
+	} while (event);
+
+	if (!event)
+		printf("Finished sub buffer\n");
+
+	if (save_offset > 0) {
+		event = kbuffer_read_at_offset(kbuf, save_offset, &ts);
+		if (!event) {
+			fprintf(stderr, "Funny, can't find event 20 at offset %d\n", save_offset);
+			exit(-1);
+		}
+		record_size = kbuffer_curr_size(kbuf);
+		offset = kbuffer_curr_offset(kbuf);
+		index = kbuffer_curr_index(kbuf);
+		size = kbuffer_event_size(kbuf);
+
+		printf("\n saved event 20 ts:%lld\trecord_size:%d size:%d\tindex:%d offset:%d\n\n",
+		       ts, record_size, size, index, offset);
+	}
+		
+	kbuffer_free(kbuf);
+
+	return 0;
+}
+--
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtraceevent*(3), *trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent-kbuffer-timestamp.txt b/Documentation/libtraceevent-kbuffer-timestamp.txt
new file mode 100644
index 000000000000..a14aed54d717
--- /dev/null
+++ b/Documentation/libtraceevent-kbuffer-timestamp.txt
@@ -0,0 +1,209 @@
+libtraceevent(3)
+================
+
+NAME
+----
+kbuffer_timestamp, kbuffer_subbuf_timestamp -
+Functions that read various data of a kbuffer descriptor
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <kbuffer.h>*
+
+unsigned long long *kbuffer_timestamp*(struct kbuffer pass:[*]_kbuf_);
+unsigned long long *kbuffer_subbuf_timestamp*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuf_);
+--
+
+DESCRIPTION
+-----------
+The function *kbuffer_timestamp()* returns the timestamp of the current event of _kbuf_.
+
+The function *kbuffer_subbuf_timestamp()* returns the timestamp for the sub-buffer
+that was loaded in _kbuf_. This usually is (but not guaranteed to be) the timestamp
+of the first event on the sub-buffer.
+
+The function *kbuffer_start_of_data()* returns the offset of where the delta
+
+RETURN VALUE
+------------
+*kbuffer_read_event()* returns the event that the _kbuf_ descriptor is currently at,
+or NULL if the last event was passed (by *kbuffer_next_event()*).
+
+*kbuffer_next_event()* returns the next event after the current event or NULL if there
+are no more events.
+
+*kbuffer_read_at_offset()* returns the event at a given _offset_ from the start of
+the sub-buffer stored in _kbuf_, or NULL if there exists no event. Note, _offset_
+only needs to be an offset that lands on the record, or is at the start of it. It does
+not need to be exactly at the beginning of the record.
+
+*kbuffer_missed_events()* returns 0 if there were no missed events before loaded sub-buffer.
+Returns -1 if there were an unknown number of missed events, or if the number of missed events
+is known, that number will be returned.
+
+*kbuffer_event_size()* returns the size of the data payload of the current event of _kbuf_.
+
+*kbuffer_curr_size()* returns the size of the entire record of the current event of _kbuf_.
+This includes the size of the meta data for that record.
+
+*kbuf_curr_offset()* returns the offset of the current record from the beginning of the _kbuf_
+sub-buffer.
+
+*kbuf_curr_index()* returns the index of the current record from the beginning of the _kbuf_
+data section.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/stat.h>
+
+#include <kbuffer.h>
+
+int main (int argc, char **argv)
+{
+	unsigned long long ts;
+	struct kbuffer *kbuf;
+	struct stat st;
+	char *buf;
+	void *event;
+	int save_offset = -1;
+	int record_size;
+	int offset;
+	int index;
+	int size;
+	int ret;
+	int fd;
+	int i = 0;
+
+	if (argc < 2) {
+		printf("usage: %s raw-subbuffer-page\n", argv[0]);
+		printf(" Try: dd count=1 bs=4096 if=/sys/kernel/tracing/per_cpu/cpu0/trace_pipe_raw of=/tmp/file\n");
+		exit(0);
+	}
+
+	if (stat(argv[1], &st) < 0) {
+		perror("stat");
+		exit(-1);
+	}
+
+	buf = malloc(st.st_size);
+	if (!buf) {
+		perror("Allocating buffer");
+		exit(-1);
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror(argv[1]);
+		exit(-1);
+	}
+
+	ret = read(fd, buf, st.st_size);
+	if (ret < 0) {
+		perror("Reading buffer");
+		exit(-1);
+	}
+	close(fd);
+
+	kbuf = kbuffer_alloc(KBUFFER_ENDIAN_SAME_AS_HOST,
+			     KBUFFER_LSIZE_SAME_AS_HOST);
+	if (!kbuf) {
+		perror("Creating kbuffer");
+		exit(-1);
+	}
+	ret = kbuffer_load_subbuffer(kbuf, buf);
+	if (ret < 0) {
+		perror("Loading sub bufer");
+		exit(-1);
+	}
+
+	if (kbuffer_subbuffer_size(kbuf) > st.st_size) {
+		fprintf(stderr, "kbuffer is bigger than raw size %d > %ld\n",
+			kbuffer_subbuffer_size(kbuf), st.st_size);
+		exit(-1);
+	}
+
+	ret = kbuffer_missed_events(kbuf);
+	if (ret) {
+		if (ret > 0)
+			printf("Missed %d events before this buffer\n", ret);
+		else
+			printf("Missed unknown number of events before this buffer\n");
+	}
+	do {
+		event = kbuffer_read_event(kbuf, &ts);
+		if (event) {
+			record_size = kbuffer_curr_size(kbuf);
+			offset = kbuffer_curr_offset(kbuf);
+			index = kbuffer_curr_index(kbuf);
+			size = kbuffer_event_size(kbuf);
+
+			if (i == 20)
+				save_offset = offset;
+			printf(" event %3d ts:%lld\trecord_size:%d size:%d\tindex:%d offset:%d\n",
+			       i++, ts, record_size, size, index, offset);
+			event = kbuffer_next_event(kbuf, NULL);
+		}
+	} while (event);
+
+	if (!event)
+		printf("Finished sub buffer\n");
+
+	if (save_offset > 0) {
+		event = kbuffer_read_at_offset(kbuf, save_offset, &ts);
+		if (!event) {
+			fprintf(stderr, "Funny, can't find event 20 at offset %d\n", save_offset);
+			exit(-1);
+		}
+		record_size = kbuffer_curr_size(kbuf);
+		offset = kbuffer_curr_offset(kbuf);
+		index = kbuffer_curr_index(kbuf);
+		size = kbuffer_event_size(kbuf);
+
+		printf("\n saved event 20 ts:%lld\trecord_size:%d size:%d\tindex:%d offset:%d\n\n",
+		       ts, record_size, size, index, offset);
+	}
+		
+	kbuffer_free(kbuf);
+
+	return 0;
+}
+--
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtraceevent*(3), *trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 442a394d1204..05027691aa03 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -175,6 +175,24 @@ Trace sequences:
 	void *trace_seq_terminate*(struct trace_seq pass:[*]_s_);
 	int *trace_seq_do_fprintf*(struct trace_seq pass:[*]_s_, FILE pass:[*]_fp_);
 	int *trace_seq_do_printf*(struct trace_seq pass:[*]_s_);
+
+kbuffer parsing:
+#include <kbuffer.h>
+	struct kbuffer pass:[*]*kbuffer_alloc*(enum kbuffer_long_size _size_, enum kbuffer_endian _endian_);
+	void *kbuffer_free*(struct kbuffer pass:[*]_kbuf_);
+	int *kbuffer_load_subbuffer*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuffer_);
+	int *kbuffer_subbuffer_size*(struct kbuffer pass:[*]_kbuf);
+	int *kbuffer_start_of_data*(struct kbuffer pass:[*]_kbuf_);
+	unsigned long long *kbuffer_timestamp*(struct kbuffer pass:[*]_kbuf_);
+	unsigned long long *kbuffer_subbuf_timestamp*(struct kbuffer pass:[*]_kbuf_, void pass:[*]_subbuf_);
+	void pass:[*]*kbuffer_read_event*(struct kbuffer pass:[*]_kbuf_, unsigned long long pass:[*]_ts_);
+	void pass:[*]*kbuffer_next_event*(struct kbuffer pass:[*]_kbuf_, unsigned long long pass:[*]_ts_);
+	void pass:[*]*kbuffer_read_at_offset*(struct kbuffer pass:[*]_kbuf_, int _offset_, unsigned long long pass:[*]_ts_);
+	int *kbuffer_missed_events*(struct kbuffer pass:[*]_kbuf_);
+	int *kbuffer_event_size*(struct kbuffer pass:[*]_kbuf_);
+	int *kbuffer_curr_size*(struct kbuffer pass:[*]_kbuf_);
+	int *kbuffer_curr_offset*(struct kbuffer pass:[*]_kbuf_);
+	int *kbuffer_curr_index*(struct kbuffer pass:[*]_kbuf_);
 --
 
 DESCRIPTION
diff --git a/check-manpages.sh b/check-manpages.sh
index 06a94f154ff9..85b3b7406864 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -39,14 +39,31 @@ done
 
 DEPRECATED="*tep_print_field*"
 
-sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../include/traceevent/event-parse.h | while read f; do
+# Should not be used by applications, only internal use by trace-cmd
+IGNORE="*kbuffer_set_old_format* *kbuffer_raw_get* *kbuffer_ptr_delta* *kbuffer_translate_data*"
+
+HEADER=event-parse.h
+
+sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../include/traceevent/{event-parse,trace-seq,kbuffer}.h | while read f; do
 	if ! grep -q '\*'${f}'\*' $MAIN_FILE; then
 		if [ "${DEPRECATED/\*$f\*/}" != "${DEPRECATED}" ]; then
 			continue;
 		fi
+		if [ "${IGNORE/\*$f\*/}" != "${IGNORE}" ]; then
+			continue;
+		fi
+		for head in event-parse.h trace-seq.h kbuffer.h; do
+			if grep -q $f ../include/traceevent/$head; then
+				if [ "$HEADER" != "$head" ]; then
+					last=""
+					HEADER=$head
+					break
+				fi
+			fi
+		done
 		if [ "$last" == "" ]; then
 			echo
-			echo "Missing functions from $MAIN_FILE that are in event-parse.h"
+			echo "Missing functions from $MAIN_FILE that are in $HEADER"
 			last=$f
 		fi
 		echo "   ${f}"
-- 
2.35.1

