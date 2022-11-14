Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9A0C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Nov 2022 20:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbiKNUoq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 15:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbiKNUon (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 15:44:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E6A60DD
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 12:44:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 381566144C
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5D6C433B5;
        Mon, 14 Nov 2022 20:44:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ougKa-00AD5r-09;
        Mon, 14 Nov 2022 15:45:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/4] libtracefs: Add tracefs_instance_get_buffer_size() API
Date:   Mon, 14 Nov 2022 15:45:20 -0500
Message-Id: <20221114204522.2433500-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221114204522.2433500-1-rostedt@goodmis.org>
References: <20221114204522.2433500-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the function tracefs_instance_get_buffer_size() to return the size of
the ring buffer.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-utils.txt | 14 +++++---
 Documentation/libtracefs.txt                 |  1 +
 include/tracefs.h                            |  1 +
 src/tracefs-instance.c                       | 37 ++++++++++++++++++++
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
index a79cc3447d80..9bec8a9163cd 100644
--- a/Documentation/libtracefs-instances-utils.txt
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -3,9 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_instance_get_name, tracefs_instance_get_trace_dir,
-tracefs_instances_walk, tracefs_instance_exists -
-Helper functions for working with tracing instances.
+tracefs_instance_get_name, tracefs_instance_get_trace_dir, tracefs_instances_walk, tracefs_instance_exists,
+tracefs_instance_get_buffer_size - Helper functions for working with tracing instances.
 
 SYNOPSIS
 --------
@@ -17,7 +16,7 @@ const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_
 const char pass:[*]*tracefs_instance_get_trace_dir*(struct tracefs_instance pass:[*]_instance_);
 int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
 bool *tracefs_instance_exists*(const char pass:[*]_name_);
-
+size_t *tracefs_instance_get_buffer_size*(struct tracefs_instance pass:[*]_instance_, int _cpu_);
 --
 
 DESCRIPTION
@@ -39,6 +38,10 @@ called for the top top instance.
 The *tracefs_instance_exists()* function checks if an instance with the given
 _name_ exists in the system.
 
+The *tracefs_instace_get_buffer_size()* returns the size of the ring buffer. If _cpu_
+is negative, it returns the total size of all the per CPU ring buffers, otherwise
+it returns the size of the per CPU ring buffer for _cpu_.
+
 RETURN VALUE
 ------------
 The *tracefs_instance_get_name()* returns a string or NULL in case of the top
@@ -53,6 +56,9 @@ if the iteration was stopped by the _callback_, or -1 in case of an error.
 The *tracefs_instance_exists()* returns true if an instance with the given _name_
 exists in the system or false otherwise.
 
+The *tracefs_instance_get_buffer_size()* returns the size of the ring buffer depending on
+the _cpu_ value passed in, or -1 on error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index e02974004ef8..3b485a018ed4 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -45,6 +45,7 @@ Trace instances:
 	char pass:[*]*tracefs_instance_get_affinity*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_instance_get_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
 	char pass:[*]*tracefs_instance_get_affinity_raw*(struct tracefs_instance pass:[*]_instance_);
+	size_t *tracefs_instance_get_buffer_size*(struct tracefs_instance pass:[*]_instance_, int _cpu_);
 
 Trace events:
 	char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
diff --git a/include/tracefs.h b/include/tracefs.h
index f2524b07501d..3391debccc80 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -55,6 +55,7 @@ char *tracefs_instance_get_affinity(struct tracefs_instance *instance);
 char *tracefs_instance_get_affinity_raw(struct tracefs_instance *instance);
 int tracefs_instance_get_affinity_set(struct tracefs_instance *instance,
 				      cpu_set_t *set, size_t set_size);
+ssize_t tracefs_instance_get_buffer_size(struct tracefs_instance *instance, int cpu);
 char **tracefs_instances(const char *regex);
 
 bool tracefs_instance_exists(const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 249a5c9a3abe..206f8c99cf36 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -363,6 +363,43 @@ const char *tracefs_instance_get_name(struct tracefs_instance *instance)
 	return NULL;
 }
 
+/**
+ * tracefs_instance_get_buffer_size - return the buffer size of the ring buffer
+ * @instance: The instance to get the buffer size from
+ * @cpu: if less that zero, will return the total size, otherwise the cpu size
+ *
+ * Returns the buffer size. If @cpu is less than zero, it returns the total size
+ * of the ring buffer otherwise it returs the size of the buffer for the given
+ * CPU.
+ *
+ * Returns -1 on error.
+ */
+ssize_t tracefs_instance_get_buffer_size(struct tracefs_instance *instance, int cpu)
+{
+	unsigned long long size;
+	char *path;
+	char *val;
+	int ret;
+
+	if (cpu < 0) {
+		val = tracefs_instance_file_read(instance, "buffer_total_size_kb", NULL);
+	} else {
+		ret = asprintf(&path, "per_cpu/cpu%d/buffer_size_kb", cpu);
+		if (ret < 0)
+			return ret;
+
+		val = tracefs_instance_file_read(instance, path, NULL);
+		free(path);
+	}
+
+	if (!val)
+		return -1;
+
+	size = strtoull(val, NULL, 0);
+	free(val);
+	return size;
+}
+
 /**
  * tracefs_instance_get_trace_dir - return the top trace directory, where the instance is confuigred
  * @instance: ftrace instance
-- 
2.35.1

