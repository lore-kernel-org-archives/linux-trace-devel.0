Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644B61097B
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE52C433B7;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKp-00000000EJd-0dHh;
	Thu, 28 Dec 2023 16:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 16/22] libtracefs: Add tracefs_load_headers() API
Date: Thu, 28 Dec 2023 16:52:11 -0500
Message-ID: <20231228215433.54854-17-rostedt@goodmis.org>
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

Sometimes the only thing that is needed from the tracefs directory is how to
parse the sub-buffers. The tracefs_fill_local_events() has a lot of overhead
as it reads pretty much everything. But if the only thing needed is the
header file parsing, add this helper function to do it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-events-tep.txt |  7 ++++++-
 Documentation/libtracefs.txt            |  1 +
 include/tracefs.h                       |  2 ++
 src/tracefs-events.c                    | 22 ++++++++++++++++++++++
 src/tracefs-record.c                    |  9 +--------
 5 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
index 22d3dd5fdfd0..ba46532a8db1 100644
--- a/Documentation/libtracefs-events-tep.txt
+++ b/Documentation/libtracefs-events-tep.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_local_events, tracefs_local_events_system, tracefs_fill_local_events,
-tracefs_load_cmdlines -
+tracefs_load_cmdlines, tracefs_load_headers -
 Initialize a tep handler with trace events from the local system.
 
 SYNOPSIS
@@ -17,6 +17,7 @@ struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir
 struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
 int *tracefs_load_cmdlines*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_);
+int *tracefs_load_headers*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_);
 --
 
 DESCRIPTION
@@ -55,6 +56,10 @@ The *tracefs_load_cmdlines()* does just that. The _tracing_dir_ is
 the directory of the mount point to load from, or NULL to use the
 mount point of the tracefs file system.
 
+The *tracefs_load_headers()* will reade the "header_page" of the events
+directory that will update the _tep_ handle with information on how to parse the
+tracing ring buffer sub-buffer.
+
 RETURN VALUE
 ------------
 The *tracefs_local_events()* and *tracefs_local_events_system()* functions
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 273423cecf4a..70bd8116b2b1 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -80,6 +80,7 @@ Trace events:
 	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
 	int *tracefs_load_cmdlines*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_);
+	int *tracefs_load_headers*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_);
 	char pass:[*]*tracefs_event_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
 			     const char pass:[*]_file_);
 	char pass:[*]*tracefs_event_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
diff --git a/include/tracefs.h b/include/tracefs.h
index 31aba92d9a16..95bff1f244f9 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -180,6 +180,8 @@ int tracefs_fill_local_events(const char *tracing_dir,
 
 int tracefs_load_cmdlines(const char *tracing_dir, struct tep_handle *tep);
 
+int tracefs_load_headers(const char *tracing_dir, struct tep_handle *tep);
+
 char *tracefs_get_clock(struct tracefs_instance *instance);
 
 enum tracefs_option_id {
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 2e87f9aa3af7..413c2df19998 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -1216,6 +1216,28 @@ int tracefs_load_cmdlines(const char *tracing_dir, struct tep_handle *tep)
 	return load_saved_cmdlines(tracing_dir, tep, true);
 }
 
+/**
+ * tracefs_load_headers - load just the headers into a tep handle
+ * @tracing_dir: The directory to load from (NULL to figure it out)
+ * @tep: The tep handle to load the headers into.
+ *
+ * Updates the @tep handle with the event and sub-buffer header
+ * information.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracefs_load_headers(const char *tracing_dir, struct tep_handle *tep)
+{
+	int ret;
+
+	if (!tracing_dir)
+		tracing_dir = tracefs_tracing_dir();
+
+	ret = read_header(tep, tracing_dir);
+
+	return ret < 0 ? -1 : 0;
+}
+
 static int fill_local_events_system(const char *tracing_dir,
 				    struct tep_handle *tep,
 				    const char * const *sys_names,
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index bfeae18fd77f..1eede996631d 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -110,10 +110,8 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 	struct tep_handle *tep;
 	struct kbuffer *kbuf;
 	char path[128];
-	char *buf;
 	int mode = O_RDONLY;
 	int subbuf_size;
-	int len;
 	int ret;
 	int fd;
 
@@ -131,12 +129,7 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 		goto fail;
 
 	/* Get the size of the page */
-	buf = tracefs_instance_file_read(NULL, "events/header_page", &len);
-	if (!buf)
-		goto fail;
-
-	ret = tep_parse_header_page(tep, buf, len, sizeof(long));
-	free(buf);
+	ret = tracefs_load_headers(NULL, tep);
 	if (ret < 0)
 		goto fail;
 
-- 
2.42.0

