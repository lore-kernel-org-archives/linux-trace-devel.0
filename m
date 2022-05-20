Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA97C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 May 2022 22:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345546AbiETWOW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 May 2022 18:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345456AbiETWOU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 May 2022 18:14:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2E41A076B
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 May 2022 15:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6592361D71
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 May 2022 22:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955D1C385A9
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 May 2022 22:14:14 +0000 (UTC)
Date:   Fri, 20 May 2022 18:14:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add tracefs_debug_dir()
Message-ID: <20220520181412.7f0b6179@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a function that will return where the debugfs file system is mounted
and if it is not mounted it will mount it. This is useful for trace-cmd
as it needs to read the KVM debug offset and multiplier of KVM guests,
and since tracefs_tracing_dir() does the same work to find the tracefs
file system (and may even find where debugfs is), this uses the same
code to accomplish finding the debugfs file system.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-files.txt | 11 +++++++++-
 include/tracefs-local.h            |  2 +-
 include/tracefs.h                  |  1 +
 src/tracefs-hist.c                 |  2 +-
 src/tracefs-instance.c             |  2 +-
 src/tracefs-utils.c                | 35 ++++++++++++++++++++++++++----
 6 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index 13e251ddd465..ab917a6ae451 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_get_tracing_file, tracefs_put_tracing_file, tracefs_tracing_dir -
+tracefs_get_tracing_file, tracefs_put_tracing_file, tracefs_tracing_dir, tracefs_debug_dir -
 Find locations of trace directory and files.
 
 SYNOPSIS
@@ -15,6 +15,7 @@ SYNOPSIS
 char pass:[*]*tracefs_get_tracing_file*(const char pass:[*]_name_);
 void *tracefs_put_tracing_file*(char pass:[*]_name_);
 const char pass:[*]*tracefs_tracing_dir*(void);
+const char pass:[*]*tracefs_debug_dir*(void);
 --
 
 DESCRIPTION
@@ -38,6 +39,11 @@ tracing file system is located, cached and returned. It will mount it,
 if it is not mounted. On any subsequent call the cached path is returned.
 The return string must _not_ be freed.
 
+The *tracefs_debug_dir()* is similar to *tracefs_tracing_dir()* except
+that it will return where the debugfs file system is mounted. If it
+is not mounted it will try to mount it. The return string must _not_
+be freed.
+
 RETURN VALUE
 ------------
 The *tracefs_get_tracing_file()* function returns a string or NULL in case
@@ -46,6 +52,9 @@ of an error. The returned string must be freed with *tracefs_put_tracing_file()*
 The *tracefs_tracing_dir()* function returns a constant string or NULL
 in case of an error. The returned string must _not_ be freed.
 
+The *tracefs_debug_dir()* function returns a constant string or NULL
+in case of an error. The returned string must _not_ be freed.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 926fd02c3d1e..d0ed2abfe5e7 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -50,7 +50,7 @@ void tracefs_warning(const char *fmt, ...);
 
 int str_read_file(const char *file, char **buffer, bool warn);
 char *trace_append_file(const char *dir, const char *name);
-char *trace_find_tracing_dir(void);
+char *trace_find_tracing_dir(bool debugfs);
 
 #ifndef ACCESSPERMS
 #define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
diff --git a/include/tracefs.h b/include/tracefs.h
index 27954a41661b..693860d47a56 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -15,6 +15,7 @@ void tracefs_put_tracing_file(char *name);
 
 /* the returned string must *not* be freed */
 const char *tracefs_tracing_dir(void);
+const char *tracefs_debug_dir(void);
 
 /* ftrace instances */
 struct tracefs_instance;
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index e688eb3c940c..0d113127def9 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -2194,7 +2194,7 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
 		new_event = true;
 	}
 
-	path = trace_find_tracing_dir();
+	path = trace_find_tracing_dir(false);
 	if (!path)
 		goto out_free;
 
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 1493938fa445..249a5c9a3abe 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -334,7 +334,7 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
 	int ret;
 
 	if (!instance) /* Top instance of default system trace directory */
-		return trace_find_tracing_dir();
+		return trace_find_tracing_dir(false);
 
 	if (!instance->name)
 		return strdup(instance->trace_dir);
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 7b1f8164d9ab..22f82afe032b 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -86,11 +86,12 @@ static int mount_debugfs(void)
 
 /**
  * trace_find_tracing_dir - Find tracing directory
+ * @debugfs: Boolean to just return the debugfs directory
  *
  * Returns string containing the full path to the system's tracing directory.
  * The string must be freed by free()
  */
-__hidden char *trace_find_tracing_dir(void)
+__hidden char *trace_find_tracing_dir(bool debugfs)
 {
 	char *debug_str = NULL;
 	char fspath[PATH_MAX+1];
@@ -109,9 +110,11 @@ __hidden char *trace_find_tracing_dir(void)
 		      STR(PATH_MAX)
 		      "s %99s %*s %*d %*d\n",
 		      fspath, type) == 2) {
-		if (strcmp(type, "tracefs") == 0)
+		if (!debugfs && strcmp(type, "tracefs") == 0)
 			break;
 		if (!debug_str && strcmp(type, "debugfs") == 0) {
+			if (debugfs)
+				break;
 			debug_str = strdup(fspath);
 			if (!debug_str) {
 				fclose(fp);
@@ -121,7 +124,13 @@ __hidden char *trace_find_tracing_dir(void)
 	}
 	fclose(fp);
 
-	if (strcmp(type, "tracefs") != 0) {
+	if (debugfs) {
+		if (strcmp(type, "debugfs") != 0) {
+			if (mount_debugfs() < 0)
+				return NULL;
+			strcpy(fspath, DEBUGFS_PATH);
+		}
+	} else if (strcmp(type, "tracefs") != 0) {
 		if (mount_tracefs() < 0) {
 			if (debug_str) {
 				strncpy(fspath, debug_str, PATH_MAX);
@@ -168,10 +177,28 @@ const char *tracefs_tracing_dir(void)
 	if (tracing_dir)
 		return tracing_dir;
 
-	tracing_dir = trace_find_tracing_dir();
+	tracing_dir = trace_find_tracing_dir(false);
 	return tracing_dir;
 }
 
+/**
+ * tracefs_debug_dir - Get debugfs directory path
+ *
+ * Returns string containing the full path to the system's debugfs directory.
+ *
+ * The returned string must *not* be freed.
+ */
+const char *tracefs_debug_dir(void)
+{
+	static const char *debug_dir;
+
+	if (debug_dir)
+		return debug_dir;
+
+	debug_dir = trace_find_tracing_dir(true);
+	return debug_dir;
+}
+
 /**
  * tracefs_get_tracing_file - Get tracing file
  * @name: tracing file name
-- 
2.35.1

