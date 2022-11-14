Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAF2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Nov 2022 20:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbiKNUot (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 15:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237426AbiKNUoq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 15:44:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BE160CD
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 12:44:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B444B81260
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2829C433C1;
        Mon, 14 Nov 2022 20:44:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ougKa-00AD5u-0D;
        Mon, 14 Nov 2022 15:45:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 3/4] libtracefs: Add tracefs_instance_set_buffer_size() API
Date:   Mon, 14 Nov 2022 15:45:21 -0500
Message-Id: <20221114204522.2433500-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221114204522.2433500-1-rostedt@goodmis.org>
References: <20221114204522.2433500-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add functionality that sets the ring buffer size.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-utils.txt | 10 +++++++-
 Documentation/libtracefs.txt                 |  1 +
 include/tracefs.h                            |  1 +
 src/tracefs-instance.c                       | 27 ++++++++++++++++++++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
index 9bec8a9163cd..bc8c9a7bf8e9 100644
--- a/Documentation/libtracefs-instances-utils.txt
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_instance_get_name, tracefs_instance_get_trace_dir, tracefs_instances_walk, tracefs_instance_exists,
-tracefs_instance_get_buffer_size - Helper functions for working with tracing instances.
+tracefs_instance_get_buffer_size, tracefs_instance_set_buffer_size - Helper functions for working with tracing instances.
 
 SYNOPSIS
 --------
@@ -17,6 +17,7 @@ const char pass:[*]*tracefs_instance_get_trace_dir*(struct tracefs_instance pass
 int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
 bool *tracefs_instance_exists*(const char pass:[*]_name_);
 size_t *tracefs_instance_get_buffer_size*(struct tracefs_instance pass:[*]_instance_, int _cpu_);
+int *tracefs_instance_set_buffer_size*(struct tracefs_instance pass:[*]_instance_, size_t _size_, int _cpu_);
 --
 
 DESCRIPTION
@@ -42,6 +43,11 @@ The *tracefs_instace_get_buffer_size()* returns the size of the ring buffer. If
 is negative, it returns the total size of all the per CPU ring buffers, otherwise
 it returns the size of the per CPU ring buffer for _cpu_.
 
+The *tracefs_instance_set_buffer_size()* function sets the size of the ring buffer.
+If _cpu_ is negative, then it sets all the per CPU ring buffers to _size_ (note
+the total size is the number of CPUs * _size_). If _cpu_ is specified, then it only
+sets the size of the per CPU ring buffer.
+
 RETURN VALUE
 ------------
 The *tracefs_instance_get_name()* returns a string or NULL in case of the top
@@ -59,6 +65,8 @@ exists in the system or false otherwise.
 The *tracefs_instance_get_buffer_size()* returns the size of the ring buffer depending on
 the _cpu_ value passed in, or -1 on error.
 
+The *tracefs_instance_set_buffer_size()* returns zero on success and -1 on error.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 3b485a018ed4..73c4997efeef 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -46,6 +46,7 @@ Trace instances:
 	int *tracefs_instance_get_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
 	char pass:[*]*tracefs_instance_get_affinity_raw*(struct tracefs_instance pass:[*]_instance_);
 	size_t *tracefs_instance_get_buffer_size*(struct tracefs_instance pass:[*]_instance_, int _cpu_);
+	int *tracefs_instance_set_buffer_size*(struct tracefs_instance pass:[*]_instance_, size_t _size_, int _cpu_);
 
 Trace events:
 	char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 3391debccc80..5ff0c6f134d3 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -56,6 +56,7 @@ char *tracefs_instance_get_affinity_raw(struct tracefs_instance *instance);
 int tracefs_instance_get_affinity_set(struct tracefs_instance *instance,
 				      cpu_set_t *set, size_t set_size);
 ssize_t tracefs_instance_get_buffer_size(struct tracefs_instance *instance, int cpu);
+int tracefs_instance_set_buffer_size(struct tracefs_instance *instance, size_t size, int cpu);
 char **tracefs_instances(const char *regex);
 
 bool tracefs_instance_exists(const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 206f8c99cf36..6905f61ff929 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -400,6 +400,33 @@ ssize_t tracefs_instance_get_buffer_size(struct tracefs_instance *instance, int
 	return size;
 }
 
+int tracefs_instance_set_buffer_size(struct tracefs_instance *instance, size_t size, int cpu)
+{
+	char *path;
+	char *val;
+	int ret;
+
+	ret = asprintf(&val, "%zd", size);
+	if (ret < 0)
+		return ret;
+
+	if (cpu < 0) {
+		ret = tracefs_instance_file_write(instance, "buffer_size_kb", val);
+	} else {
+		ret = asprintf(&path, "per_cpu/cpu%d/buffer_size_kb", cpu);
+		if (ret < 0) {
+			free(val);
+			return ret;
+		}
+
+		ret = tracefs_instance_file_write(instance, path, "val");
+		free(path);
+	}
+	free(val);
+
+	return ret < 0 ? -1 : 0;
+}
+
 /**
  * tracefs_instance_get_trace_dir - return the top trace directory, where the instance is confuigred
  * @instance: ftrace instance
-- 
2.35.1

