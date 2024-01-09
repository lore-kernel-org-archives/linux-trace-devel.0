Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF95611CB3
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 03:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EBBC433C7
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 03:53:58 +0000 (UTC)
Date: Mon, 8 Jan 2024 22:54:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add man pages for tracefs_snapshot_*()
 functions
Message-ID: <20240108225455.5d2f63e2@gandalf.local.home>
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

Add man pages for:

  tracefs_snapshot_snap()
  tracefs_snapshot_clear()
  tracefs_snapshot_free()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-snapshot.txt | 182 ++++++++++++++++++++++++++
 Documentation/libtracefs.txt          |   3 +
 2 files changed, 185 insertions(+)
 create mode 100644 Documentation/libtracefs-snapshot.txt

diff --git a/Documentation/libtracefs-snapshot.txt b/Documentation/libtracefs-snapshot.txt
new file mode 100644
index 0000000..896705c
--- /dev/null
+++ b/Documentation/libtracefs-snapshot.txt
@@ -0,0 +1,182 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_snapshot_snap, tracefs_snapshot_clear, tracefs_snapshot_free -
+API to create, clear and read snapshots
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_snapshot_snap*(struct tracefs_instance pass:[*]instance);
+int *tracefs_snapshot_clear*(struct tracefs_instance pass:[*]instance);
+int *tracefs_snapshot_free*(struct tracefs_instance pass:[*]instance);
+--
+
+DESCRIPTION
+-----------
+The Linux kernel tracing provides a "snapshot" feature. The kernel has two
+ring buffers. One that is written to by the tracing system and another one that
+is the "snapshot" buffer. When a snapshot happens, the two buffers are swapped, and
+the current snapshot buffer becomes the one being written to, and the buffer
+that was being written to becomes the saved snapshot.
+
+Note, the snapshot buffer is allocated the first time it is taken, so it is best
+to take a snapshot at the start before one is needed so that it is allocated
+and a snapshot is ready, then the snapshot will happen immediately.
+
+The *tracefs_snapshot_snap()* will allocate (if not already allocated) the snapshot
+buffer and then take a "snapshot" (swap the main buffer that's being written to with
+the allocated snapshot buffer). It will do this to the given _instance_ buffer or
+the top instance if _instance_ is NULL.
+
+The *tracefs_snapshot_clear()* will erase the content of the snapshot buffer for
+the given _instance_ or the top level instance if _instance_ is NULL.
+
+The *tracefs_snapshot_free()* will free the allocated snapshot for the given _instance_
+or the top level instance if _instance_ is NULL. That is, if another call to
+*tracefs_snapshot_snap()* is done after this, then it will need to allocate
+the snapshot buffer again before it can take a snapshot. This function should
+be used to free up the kernel memory used by hte snapshot buffer when no longer in use.
+
+
+RETURN VALUE
+------------
+The *tracefs_snapshot_snap()*, *tracefs_snapshot_clear()* and the *tracefs_snapshot_free()*
+all return 0 on success and -1 on failure.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <stdio.h>
+#include <tracefs.h>
+
+static int callback(struct tep_event *event, struct tep_record *record, int cpu, void *data)
+{
+	static struct trace_seq seq;
+	struct tep_handle *tep = event->tep;
+
+	if (!seq.buffer)
+		trace_seq_init(&seq);
+
+	trace_seq_reset(&seq);
+
+	tep_print_event(tep, &seq, record, "[%03d] %s-%d %6.1000d\t%s: %s\n",
+				TEP_PRINT_CPU,
+				TEP_PRINT_COMM,
+				TEP_PRINT_PID,
+				TEP_PRINT_TIME,
+				TEP_PRINT_NAME,
+				TEP_PRINT_INFO);
+	trace_seq_do_printf(&seq);
+	return 0;
+}
+
+int main (int argc, char **argv)
+{
+	struct tracefs_instance *instance;
+	struct tep_handle *tep;
+	char *line = NULL;
+	size_t len = 0;
+	int ret;
+
+	instance = tracefs_instance_create("my_snapshots");
+	if (!instance) {
+		perror("creating instance");
+		exit(-1);
+	}
+
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		perror("reading event formats");
+		goto out;
+	}
+
+	/* Make sure the snapshot buffer is allocated */
+	ret = tracefs_snapshot_snap(instance);
+	if (ret < 0)
+		goto out;
+
+	ret = tracefs_event_enable(instance, "sched", NULL);
+	if (ret < 0) {
+		perror("enabling event");
+		goto out;
+	}
+
+	for (;;) {
+		printf("Hit enter without text to take snapshot!\n");
+		printf("Enter any text to display the snapshot\n");
+		printf("Enter 'quit' to exit\n");
+		getline(&line, &len, stdin);
+		ret = tracefs_snapshot_snap(instance);
+		if (ret < 0) {
+			perror("taking snapshot");
+			goto out;
+		}
+		if (!line)
+			break;
+		if (strlen(line) < 2)
+			continue;
+		if (strncmp(line, "quit", 4) == 0)
+			break;
+		tracefs_iterate_snapshot_events(tep, instance, NULL, 0, callback, NULL);
+	}
+
+	free(line);
+
+	tracefs_instance_clear(instance);
+
+ out:
+	tracefs_snapshot_free(instance);
+	tracefs_event_disable(instance, "sched", NULL);
+	tracefs_instance_destroy(instance);
+	tracefs_instance_free(instance);
+
+	exit(0);
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
+*tracefs_iterate_snapshot_events*(3)
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
+Copyright \(C) 2023 Google, LLC. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 8dc3ba7..ae807bb 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -95,6 +95,9 @@ Trace events:
 			       const char pass:[*]_file_);
 
 Snapshot buffer:
+	int *tracefs_snapshot_snap*(struct tracefs_instance pass:[*]instance);
+	int *tracefs_snapshot_clear*(struct tracefs_instance pass:[*]instance);
+	int *tracefs_snapshot_free*(struct tracefs_instance pass:[*]instance);
 	int *tracefs_iterate_snapshot_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_,
 				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
 				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
-- 
2.42.0

