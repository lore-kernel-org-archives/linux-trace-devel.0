Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3E910A0A
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417FBC433B8;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKp-00000000EJh-0kDy;
	Thu, 28 Dec 2023 16:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 17/22] libtracefs: Add API to extract ring buffer statistics
Date: Thu, 28 Dec 2023 16:52:12 -0500
Message-ID: <20231228215433.54854-18-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228215433.54854-1-rostedt@goodmis.org>
References: <20231228215433.54854-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the API that reads the tracefs/per_cpu/cpu*/stats

  tracefs_instance_get_stat()
  tracefs_instance_put_stat()
  tracefs_buffer_stat_entries()
  tracefs_buffer_stat_overrun()
  tracefs_buffer_stat_commit_overrun()
  tracefs_buffer_stat_bytes()
  tracefs_buffer_stat_event_timestamp()
  tracefs_buffer_stat_timestamp()
  tracefs_buffer_stat_dropped_events()
  tracefs_buffer_stat_read_events()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-stat.txt | 183 ++++++++++++++++++++
 Documentation/libtracefs.txt                |  12 ++
 include/tracefs-local.h                     |  11 ++
 include/tracefs.h                           |  13 ++
 samples/Makefile                            |   1 +
 src/Makefile                                |   1 +
 src/tracefs-stats.c                         | 162 +++++++++++++++++
 7 files changed, 383 insertions(+)
 create mode 100644 Documentation/libtracefs-instances-stat.txt
 create mode 100644 src/tracefs-stats.c

diff --git a/Documentation/libtracefs-instances-stat.txt b/Documentation/libtracefs-instances-stat.txt
new file mode 100644
index 000000000000..d3bb3c93d9d1
--- /dev/null
+++ b/Documentation/libtracefs-instances-stat.txt
@@ -0,0 +1,183 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_instance_get_stat, tracefs_instance_put_stat, tracefs_buffer_stat_entries, tracefs_buffer_stat_overrun,
+tracefs_buffer_stat_commit_overrun, tracefs_buffer_stat_bytes, tracefs_buffer_stat_event_timestamp,
+tracefs_buffer_stat_timestamp, tracefs_buffer_stat_dropped_events, tracefs_buffer_stat_read_events
+- Handling tracing buffer stats
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_buffer_stat pass:[*]*tracefs_instance_get_stat*(struct tracefs_instance pass:[*]_instance_, int _cpu_);
+void *tracefs_instance_put_stat*(struct tracefs_buffer_stat pass:[*]_tstat_);
+ssize_t *tracefs_buffer_stat_entries*(struct tracefs_buffer_stat pass:[*]_tstat_);
+ssize_t *tracefs_buffer_stat_overrun*(struct tracefs_buffer_stat pass:[*]_tstat_);
+ssize_t *tracefs_buffer_stat_commit_overrun*(struct tracefs_buffer_stat pass:[*]_tstat_);
+ssize_t *tracefs_buffer_stat_bytes*(struct tracefs_buffer_stat pass:[*]_tstat_);
+long long *tracefs_buffer_stat_event_timestamp*(struct tracefs_buffer_stat pass:[*]_tstat_);
+long long *tracefs_buffer_stat_timestamp*(struct tracefs_buffer_stat pass:[*]_tstat_);
+ssize_t *tracefs_buffer_stat_dropped_events*(struct tracefs_buffer_stat pass:[*]_tstat_);
+ssize_t *tracefs_buffer_stat_read_events*(struct tracefs_buffer_stat pass:[*]_tstat_);
+--
+
+DESCRIPTION
+-----------
+This set of functions read and parse the tracefs/per_cpu/cpuX/stats file.
+These files hold the statistics of the per CPU ring buffer, such as how
+many events are in the ring buffer, how many have been read and so on.
+
+The *tracefs_instance_get_stat()* function will read and parse a given statistics
+file for a given _instance_ and _cpu_. As the ring buffer is split into per_cpu buffers,
+the information is only associated to the given _cpu_. The returned tracefs_buffer_stat
+pointer can be used with the other *tracefs_buffer_stat* functions and must be freed with
+*tracefs_instance_put_stat()*.
+
+The *tracefs_instance_put_stat()* will free the resources allocated for the given _stat_
+that was created by *tracefs_instance_get_stat()*.
+
+The *tracefs_buffer_stat_entries()* returns the number of events that are currently
+in the ring buffer associated with _tstat_.
+
+The *tracefs_buffer_stat_overrun()* returns the number of events that were lost by
+the ring buffer writer overrunning the reader.
+
+The *tracefs_buffer_stat_commit_overrun()* returns the number of events that were
+lost because the ring buffer was too small and an interrupt interrupted a lower
+context event being recorded and it added more events than the ring buffer could
+hold. Note this is not a common occurrence and when it happens it means that
+something was not set up properly.
+
+The *tracefs_buffer_stat_bytes()* returns the number of bytes that the current events
+take up. Note, it includes the meta data for the events, but does not include the
+meta data for the sub-buffers.
+
+The *tracefs_buffer_stat_event_timestamp()* returns the timestamp of the last event in the
+ring buffer.
+
+The *tracefs_buffer_stat_timestamp()* returns the current timestamp of the ring buffer.
+Note, it is only read when *tracefs_instance_get_stat()* is called. It will have the
+timestamp of the ring buffer when that function was called.
+
+The *tracefs_buffer_stat_dropped_events()* returns the number of events that were
+dropped if overwrite mode is disabled. It will show the events that were lost because
+the writer caught up to the reader and could not write any more events.
+
+The *tracefs_buffer_stat_read_events()* returns the number of events that were consumed
+by a reader.
+
+
+RETURN VALUE
+------------
+The *tracefs_instance_get_stat()* returns a tracefs_buffer_stat structure that can
+be used to retrieve the statistics via the other functions. It must be freed with
+*tracefs_instance_put_stat()*.
+
+The other functions that return different values from the tracefs_buffer_stat structure
+all return the value, or -1 if the value was not found.
+
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <unistd.h>
+#include <tracefs.h>
+
+int main(int argc, char **argv)
+{
+	char *trace;
+	char buf[1000];
+	int ret;
+	int i;
+
+	for (i = 0; i < sizeof(buf) - 1; i++) {
+		buf[i] = '0' + i % 10;
+	}
+	buf[i] = '\0';
+
+	tracefs_instance_clear(NULL);
+
+	for (i = 0; i < 4; i++) {
+		ret = tracefs_printf(NULL, "%s\n", buf);
+		if (ret < 0)
+			perror("write");
+	}
+
+	trace = tracefs_instance_file_read(NULL, "trace", NULL);
+	printf("%s\n", trace);
+	free(trace);
+
+	for (i = 0; i < sysconf(_SC_NPROCESSORS_CONF); i++) {
+		struct tracefs_buffer_stat *tstat;
+		ssize_t entries, eread;
+
+		tstat = tracefs_instance_get_stat(NULL, i);
+		if (!tstat)
+			continue;
+
+		entries = tracefs_buffer_stat_entries(tstat);
+		eread = tracefs_buffer_stat_read_events(tstat);
+		if (!entries && !eread) {
+			tracefs_instance_put_stat(tstat);
+			continue;
+		}
+
+		printf("CPU: %d\n", i);;
+		printf("\tentries: %zd\n", entries);
+		printf("\toverrun: %zd\n", tracefs_buffer_stat_overrun(tstat));
+		printf("\tcommit_overrun: %zd\n", tracefs_buffer_stat_commit_overrun(tstat));
+		printf("\tbytes: %zd\n", tracefs_buffer_stat_bytes(tstat));
+		printf("\tevent_timestamp: %lld\n", tracefs_buffer_stat_event_timestamp(tstat));
+		printf("\ttimestamp: %lld\n", tracefs_buffer_stat_timestamp(tstat));
+		printf("\tdropped_events: %zd\n", tracefs_buffer_stat_dropped_events(tstat));
+		printf("\tread_events: %zd\n", eread);
+
+		tracefs_instance_put_stat(tstat);
+	}
+}
+--
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
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 70bd8116b2b1..6752ed3c9b98 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -155,6 +155,18 @@ Writing data in the trace buffer:
 Control library logs:
 	int *tracefs_set_loglevel*(enum tep_loglevel _level_);
 
+Read the ring buffer statistics:
+	struct tracefs_buffer_stat pass:[*]*tracefs_instance_get_stat*(struct tracefs_instance pass:[*]_instance_, int _cpu_);
+	void *tracefs_instance_put_stat*(struct tracefs_buffer_stat pass:[*]_tstat_);
+	ssize_t *tracefs_buffer_stat_entries*(struct tracefs_buffer_stat pass:[*]_tstat_);
+	ssize_t *tracefs_buffer_stat_overrun*(struct tracefs_buffer_stat pass:[*]_tstat_);
+	ssize_t *tracefs_buffer_stat_commit_overrun*(struct tracefs_buffer_stat pass:[*]_tstat_);
+	ssize_t *tracefs_buffer_stat_bytes*(struct tracefs_buffer_stat pass:[*]_tstat_);
+	long long *tracefs_buffer_stat_event_timestamp*(struct tracefs_buffer_stat pass:[*]_tstat_);
+	long long *tracefs_buffer_stat_timestamp*(struct tracefs_buffer_stat pass:[*]_tstat_);
+	ssize_t *tracefs_buffer_stat_dropped_events*(struct tracefs_buffer_stat pass:[*]_tstat_);
+	ssize_t *tracefs_buffer_stat_read_events*(struct tracefs_buffer_stat pass:[*]_tstat_);
+
 Dynamic event generic APIs:
 	struct *tracefs_dynevent*;
 	enum *tracefs_dynevent_type*;
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 9e5a568468b4..9cae73c8b806 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -51,6 +51,17 @@ struct tracefs_instance {
 	bool				iterate_keep_going;
 };
 
+struct tracefs_buffer_stat {
+	ssize_t				entries;
+	ssize_t				overrun;
+	ssize_t				commit_overrun;
+	ssize_t				bytes;
+	long long			oldest_ts;
+	long long			now_ts;
+	ssize_t				dropped_events;
+	ssize_t				read_events;
+};
+
 extern const struct tep_format_field common_stacktrace;
 
 extern pthread_mutex_t toplevel_lock;
diff --git a/include/tracefs.h b/include/tracefs.h
index 95bff1f244f9..3ae78d4f3af7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -68,6 +68,19 @@ char **tracefs_instances(const char *regex);
 int tracefs_instance_get_buffer_percent(struct tracefs_instance *instance);
 int tracefs_instance_set_buffer_percent(struct tracefs_instance *instance, int val);
 
+struct tracefs_buffer_stat;
+
+struct tracefs_buffer_stat *tracefs_instance_get_stat(struct tracefs_instance *instance, int cpu);
+void tracefs_instance_put_stat(struct tracefs_buffer_stat *tstat);
+ssize_t tracefs_buffer_stat_entries(struct tracefs_buffer_stat *tstat);
+ssize_t tracefs_buffer_stat_overrun(struct tracefs_buffer_stat *tstat);
+ssize_t tracefs_buffer_stat_commit_overrun(struct tracefs_buffer_stat *tstat);
+ssize_t tracefs_buffer_stat_bytes(struct tracefs_buffer_stat *tstat);
+long long tracefs_buffer_stat_event_timestamp(struct tracefs_buffer_stat *tstat);
+long long tracefs_buffer_stat_timestamp(struct tracefs_buffer_stat *tstat);
+ssize_t tracefs_buffer_stat_dropped_events(struct tracefs_buffer_stat *tstat);
+ssize_t tracefs_buffer_stat_read_events(struct tracefs_buffer_stat *tstat);
+
 bool tracefs_instance_exists(const char *name);
 bool tracefs_file_exists(struct tracefs_instance *instance, const char *name);
 bool tracefs_dir_exists(struct tracefs_instance *instance, const char *name);
diff --git a/samples/Makefile b/samples/Makefile
index 13ad99579ea3..787d28769051 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -24,6 +24,7 @@ EXAMPLES += instances-affinity
 EXAMPLES += cpu
 EXAMPLES += guest
 EXAMPLES += cpu-buf
+EXAMPLES += instances-stat
 
 TARGETS :=
 TARGETS += sqlhist
diff --git a/src/Makefile b/src/Makefile
index 90bd88df44c2..faa3b25c4002 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -10,6 +10,7 @@ OBJS += tracefs-tools.o
 OBJS += tracefs-marker.o
 OBJS += tracefs-kprobes.o
 OBJS += tracefs-hist.o
+OBJS += tracefs-stats.o
 OBJS += tracefs-filter.o
 OBJS += tracefs-dynevents.o
 OBJS += tracefs-eprobes.o
diff --git a/src/tracefs-stats.c b/src/tracefs-stats.c
new file mode 100644
index 000000000000..d43235bc0b38
--- /dev/null
+++ b/src/tracefs-stats.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2023 Google LLC, Steven Rostedt <rostedt@goodmis.org>
+ */
+#include <stdlib.h>
+#include <ctype.h>
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+static long long convert_ts(char *value)
+{
+	long long ts;
+	char *saveptr;
+	char *secs;
+	char *usecs;
+
+	secs = strtok_r(value, ".", &saveptr);
+	if (!secs)
+		return -1LL;
+
+	ts = strtoll(secs, NULL, 0);
+
+	usecs = strtok_r(NULL, ".", &saveptr);
+	if (!usecs)
+		return ts;
+
+	/* Could be in nanoseconds */
+	if (strlen(usecs) > 6)
+		ts *= 1000000000LL;
+	else
+		ts *= 1000000LL;
+
+	ts += strtoull(usecs, NULL, 0);
+
+	return ts;
+}
+
+struct tracefs_buffer_stat *
+tracefs_instance_get_stat(struct tracefs_instance *instance, int cpu)
+{
+	struct tracefs_buffer_stat *tstat;
+	char *saveptr;
+	char *value;
+	char *field;
+	char *path;
+	char *line;
+	char *next;
+	char *buf;
+	int len;
+	int ret;
+
+	ret = asprintf(&path, "per_cpu/cpu%d/stats", cpu);
+	if (ret < 0)
+		return NULL;
+
+	buf = tracefs_instance_file_read(instance, path, &len);
+	free(path);
+
+	if (!buf)
+		return NULL;
+
+	tstat = malloc(sizeof(*tstat));
+	if (!tstat) {
+		free(buf);
+		return NULL;
+	}
+
+	/* Set everything to -1 */
+	memset(tstat, -1, sizeof(*tstat));
+
+	next = buf;
+	while ((line = strtok_r(next, "\n", &saveptr))) {
+		char *save2;
+
+		next = NULL;
+
+		field = strtok_r(line, ":", &save2);
+		if (!field)
+			break;
+
+		value = strtok_r(NULL, ":", &save2);
+		if (!value)
+			break;
+
+		while (isspace(*value))
+			value++;
+
+		if (strcmp(field, "entries") == 0) {
+			tstat->entries = strtoull(value, NULL, 0);
+
+		} else if (strcmp(field, "overrun") == 0) {
+			tstat->overrun = strtoull(value, NULL, 0);
+
+		} else if (strcmp(field, "commit overrun") == 0) {
+			tstat->commit_overrun = strtoull(value, NULL, 0);
+
+		} else if (strcmp(field, "bytes") == 0) {
+			tstat->bytes = strtoull(value, NULL, 0);
+
+		} else if (strcmp(field, "oldest event ts") == 0) {
+			tstat->oldest_ts = convert_ts(value);
+
+		} else if (strcmp(field, "now ts") == 0) {
+			tstat->now_ts = convert_ts(value);
+
+		} else if (strcmp(field, "dropped events") == 0) {
+			tstat->dropped_events = strtoull(value, NULL, 0);
+
+		} else if (strcmp(field, "read events") == 0) {
+			tstat->read_events = strtoull(value, NULL, 0);
+		}
+	}
+	free(buf);
+
+	return tstat;
+}
+
+void tracefs_instance_put_stat(struct tracefs_buffer_stat *tstat)
+{
+	free(tstat);
+}
+
+ssize_t tracefs_buffer_stat_entries(struct tracefs_buffer_stat *tstat)
+{
+	return tstat->entries;
+}
+
+ssize_t tracefs_buffer_stat_overrun(struct tracefs_buffer_stat *tstat)
+{
+	return tstat->overrun;
+}
+
+ssize_t tracefs_buffer_stat_commit_overrun(struct tracefs_buffer_stat *tstat)
+{
+	return tstat->commit_overrun;
+}
+
+ssize_t tracefs_buffer_stat_bytes(struct tracefs_buffer_stat *tstat)
+{
+	return tstat->bytes;
+}
+
+long long tracefs_buffer_stat_event_timestamp(struct tracefs_buffer_stat *tstat)
+{
+	return tstat->oldest_ts;
+}
+
+long long tracefs_buffer_stat_timestamp(struct tracefs_buffer_stat *tstat)
+{
+	return tstat->now_ts;
+}
+
+ssize_t tracefs_buffer_stat_dropped_events(struct tracefs_buffer_stat *tstat)
+{
+	return tstat->dropped_events;
+}
+
+ssize_t tracefs_buffer_stat_read_events(struct tracefs_buffer_stat *tstat)
+{
+	return tstat->read_events;
+}
+
-- 
2.42.0

