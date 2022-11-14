Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FADC43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Nov 2022 20:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiKNUor (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 15:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiKNUoo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 15:44:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE00F007
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 12:44:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BE6261467
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82A0C43144;
        Mon, 14 Nov 2022 20:44:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ougKa-00AD5x-0H;
        Mon, 14 Nov 2022 15:45:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 4/4] libtracefs: Add tracefs_tracing_dir_is_mounted() API
Date:   Mon, 14 Nov 2022 15:45:22 -0500
Message-Id: <20221114204522.2433500-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221114204522.2433500-1-rostedt@goodmis.org>
References: <20221114204522.2433500-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the tracefs_tracing_dir_is_mounted() API that passes in a mount flag
and an address to a char pointer (or NULL). It returns 1 if the
tracing_dir was already mounted and 0 if not. If the mount flag is set,
then it will try to mount it and return -1 if it fails. If path points to
the address of a char*, then it will be set to the path that was mounted,
or was already mounted.

This is useful for wanting to unmount the tracing_dir if the tool was
the one that mounted it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-files.txt | 14 ++++++-
 Documentation/libtracefs.txt       |  1 +
 include/tracefs.h                  |  1 +
 src/tracefs-utils.c                | 62 ++++++++++++++++++++++++------
 4 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index 2a3f5449839d..d22e75900098 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_get_tracing_file, tracefs_put_tracing_file, tracefs_tracing_dir, tracefs_debug_dir, tracefs_set_tracing_dir -
-Find and set locations of trace directory and files.
+tracefs_get_tracing_file, tracefs_put_tracing_file, tracefs_tracing_dir, tracefs_debug_dir, tracefs_set_tracing_dir,
+tracefs_tracing_dir_is_mounted - Find and set locations of trace directory and files.
 
 SYNOPSIS
 --------
@@ -17,6 +17,7 @@ void *tracefs_put_tracing_file*(char pass:[*]_name_);
 const char pass:[*]*tracefs_tracing_dir*(void);
 const char pass:[*]*tracefs_debug_dir*(void);
 int *tracefs_set_tracing_dir*(char pass:[*]_tracing_dir_)
+int *tracefs_tracing_dir_is_mounted*(bool _mount_, const char pass:[**]_path_);
 --
 
 DESCRIPTION
@@ -52,6 +53,12 @@ that it will return where the debugfs file system is mounted. If it
 is not mounted it will try to mount it. The return string must _not_
 be freed.
 
+*tracefs_tracing_dir_is_mounted()* returns 1 if the tracing directory is
+already mounted and 0 if it is not. If _mount_ is true, it will try to
+mount it if it is not, and returns 0 if it succesfully mounted it and -1
+if it did not. If _path_ is set, it will be assigned to the path where it
+mounted it. _path_ is internal and should not be freed.
+
 RETURN VALUE
 ------------
 The *tracefs_set_tracing_dir()* function returns 0 on success, -1 otherwise.
@@ -65,6 +72,9 @@ in case of an error. The returned string must _not_ be freed.
 The *tracefs_debug_dir()* function returns a constant string or NULL
 in case of an error. The returned string must _not_ be freed.
 
+The *tracefs_tracing_dir_is_mounted()* returns 1 if the tracing directory
+is already mounted, 0 if it is not, and -1 on error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 73c4997efeef..cc53388438e5 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -17,6 +17,7 @@ Locations of tracing files and directories:
 	const char pass:[*]*tracefs_tracing_dir*(void);
 	const char pass:[*]*tracefs_debug_dir*(void);
 	int *tracefs_set_tracing_dir*(char pass:[*]_tracing_dir_)
+	int *tracefs_tracing_dir_is_mounted*(bool _mount_, const char pass:[**]_path_);
 
 Trace instances:
 	struct tracefs_instance pass:[*]*tracefs_instance_create*(const char pass:[*]_name_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 5ff0c6f134d3..10f84a25c31e 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -17,6 +17,7 @@ void tracefs_put_tracing_file(char *name);
 const char *tracefs_tracing_dir(void);
 const char *tracefs_debug_dir(void);
 int tracefs_set_tracing_dir(char *tracing_dir);
+int tracefs_tracing_dir_is_mounted(bool mount, const char **path);
 
 /* ftrace instances */
 struct tracefs_instance;
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index a38da6616498..777912e46821 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -85,14 +85,7 @@ static int mount_debugfs(void)
 	return ret;
 }
 
-/**
- * trace_find_tracing_dir - Find tracing directory
- * @debugfs: Boolean to just return the debugfs directory
- *
- * Returns string containing the full path to the system's tracing directory.
- * The string must be freed by free()
- */
-__hidden char *trace_find_tracing_dir(bool debugfs)
+static char *find_tracing_dir(bool debugfs, bool mount)
 {
 	char *debug_str = NULL;
 	char fspath[PATH_MAX+1];
@@ -127,18 +120,19 @@ __hidden char *trace_find_tracing_dir(bool debugfs)
 
 	if (debugfs) {
 		if (strcmp(type, "debugfs") != 0) {
-			if (mount_debugfs() < 0)
+			if (!mount || mount_debugfs() < 0)
 				return NULL;
 			strcpy(fspath, DEBUGFS_PATH);
 		}
 	} else if (strcmp(type, "tracefs") != 0) {
-		if (mount_tracefs() < 0) {
+		if (!mount || mount_tracefs() < 0) {
 			if (debug_str) {
 				strncpy(fspath, debug_str, PATH_MAX);
 				fspath[PATH_MAX] = 0;
 			} else {
-				if (mount_debugfs() < 0) {
-					tracefs_warning("debugfs not mounted, please mount");
+				if (!mount || mount_debugfs() < 0) {
+					if (mount)
+						tracefs_warning("debugfs not mounted, please mount");
 					free(debug_str);
 					return NULL;
 				}
@@ -165,6 +159,50 @@ __hidden char *trace_find_tracing_dir(bool debugfs)
 	return tracing_dir;
 }
 
+/**
+ * tracefs_tracing_dir_is_mounted - test if the tracing dir is already mounted
+ * @mount: Mount it if it is not already mounted
+ * @path: the path to the tracing directory if mounted or was mounted
+ *
+ * Returns 1 if the tracing directory is already mounted and 0 if it is not.
+ * If @mount is set and it fails to mount, it returns -1.
+ *
+ * If path is not NULL, and the tracing directory is or was mounted, it holds
+ * the path to the tracing directory. It must not be freed.
+ */
+int tracefs_tracing_dir_is_mounted(bool mount, const char **path)
+{
+	const char *dir;
+
+	dir = find_tracing_dir(false, false);
+	if (dir) {
+		if (path)
+			*path = dir;
+		return 1;
+	}
+	if (!mount)
+		return 0;
+
+	dir = find_tracing_dir(false, mount);
+	if (!dir)
+		return -1;
+	if (path)
+		*path = dir;
+	return 0;
+}
+
+/**
+ * trace_find_tracing_dir - Find tracing directory
+ * @debugfs: Boolean to just return the debugfs directory
+ *
+ * Returns string containing the full path to the system's tracing directory.
+ * The string must be freed by free()
+ */
+__hidden char *trace_find_tracing_dir(bool debugfs)
+{
+	return find_tracing_dir(debugfs, false);
+}
+
 /**
  * tracefs_set_tracing_dir - Set location of the tracing directory
  * @tracing_dir: full path to the system's tracing directory mount point.
-- 
2.35.1

