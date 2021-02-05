Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ED8C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 07:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B80864F9B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 07:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhBEH5Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 02:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhBEH5X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 02:57:23 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C04C0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Feb 2021 23:56:42 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id sa23so10448057ejb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Feb 2021 23:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SVSD3ki51j+eOYEkPonZ3vppkSF8RUUc+rkEm7WQY3g=;
        b=oLhmeVnPwbif53KoBUc2rZbI736wkorvah8ZBtOR3GTjmPFvSEEK7UKz3EkFyptDnd
         2eQCWUItzcHP4lmrpczqXjk/sB1EZFEnqwJctleZqDIifx6di80Zg85a86EZqVDa92lY
         sc9FwLUIutEQqDyuUfz1wxkax4ITEY6HEZycr2zlW04wqoqbgSX/4NRPg2/T4Uh0BZJt
         gSIBGCTfIGKo2eWyeGurrFz/f9P/Ih8N8pJhgR1JGQd1/vykRCq4GjtQc+6Jnd4td05o
         b1XK2/X25kYldA/Yh85qKI5IcZJe9v4lWyXXK5L/JUBSoiNf3S0EjVvm3HCbKyblZZ1C
         /wHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SVSD3ki51j+eOYEkPonZ3vppkSF8RUUc+rkEm7WQY3g=;
        b=ViaIyI3KEj+8zI9mj8fHObMk5LKhOcREJyY4EWfK/h8LeMlntQY6+/z7zU8QwGBRLp
         rkcS+hadfC9Ue3l1yIUJAWCS3rurhTsXeC1iDkCN5S4QxYyf4Z9XRNKzndyIlsn7aw1s
         Tjcxqr00R9ANy50U5yEpmrHMyk0bhD8n9XHiHNPyDllogGpv7+ksZG+lQOvltwj3a+u/
         dZ6ua7HKUtADOLT51f7QErOtvo8CdphvXAQQf0YV5kz7QQD/W+AjKSszxXgHBH6TsB90
         k0inWdcnYVmSNcdanwuSVAW4LjlpWzvG9ZVRwF48DfgUnz4tHOAZS1lFIdvkHlaWtmf2
         joFA==
X-Gm-Message-State: AOAM532wRJnhh1VGI2q1tsl9O5SPG7XuGYOnBCs8AbBG19FLG0EWcBh8
        +lz27UUpsCyGyIp4gtttu88=
X-Google-Smtp-Source: ABdhPJztK136vuiG4ipejdI/BE1+Zh5EI46fSAzPmS5TSiRWayKyZWMELtyUde8UHYoOJ9ogHh9qgQ==
X-Received: by 2002:a17:906:a106:: with SMTP id t6mr2963804ejy.63.1612511801225;
        Thu, 04 Feb 2021 23:56:41 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ov9sm3581108ejb.53.2021.02.04.23.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 23:56:40 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, douglas.raillard@arm.com
Subject: [PATCH] trace-cmd: Add flags to APIs for opening trace file
Date:   Fri,  5 Feb 2021 09:56:38 +0200
Message-Id: <20210205075638.1283393-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new flag parameter to these APIs, to control how the trace file
is opened and parsed:
  tracecmd_open()
  tracecmd_open_fd()
  tracecmd_open_head()
The first implemented flags control whether the plugins should be loaded
and used when opening the file. These flags replace the global variables,
used for the same purpose. Loading of ftrace function event plugins is
also affected by these flags.

These changes fix the bug reported by Douglas RAILLARD.

Reported-by: Douglas RAILLARD <douglas.raillard@arm.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211255
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtracecmd/libtracecmd-files.3.txt       | 14 ++++++---
 Documentation/libtracecmd/libtracecmd.3.txt   |  2 +-
 include/trace-cmd/trace-cmd.h                 | 11 +++++--
 kernel-shark/src/libkshark.c                  |  2 +-
 .../include/private/trace-cmd-private.h       |  9 ++----
 lib/trace-cmd/test.c                          |  2 +-
 lib/trace-cmd/trace-input.c                   | 29 ++++++++++++-------
 lib/trace-cmd/trace-output.c                  |  2 +-
 lib/trace-cmd/trace-util.c                    |  8 ++---
 tracecmd/include/trace-local.h                |  2 +-
 tracecmd/trace-check-events.c                 |  5 ++--
 tracecmd/trace-hist.c                         |  2 +-
 tracecmd/trace-list.c                         |  4 +--
 tracecmd/trace-mem.c                          |  2 +-
 tracecmd/trace-read.c                         | 11 +++----
 tracecmd/trace-restore.c                      |  2 +-
 tracecmd/trace-split.c                        |  2 +-
 tracecmd/trace-stream.c                       |  2 +-
 18 files changed, 63 insertions(+), 48 deletions(-)

diff --git a/Documentation/libtracecmd/libtracecmd-files.3.txt b/Documentation/libtracecmd/libtracecmd-files.3.txt
index c10d853e..f7bed3be 100644
--- a/Documentation/libtracecmd/libtracecmd-files.3.txt
+++ b/Documentation/libtracecmd/libtracecmd-files.3.txt
@@ -12,9 +12,9 @@ SYNOPSIS
 --
 *#include <trace-cmd.h>*
 
-struct tracecmd_input pass:[*]*tracecmd_open*(const char pass:[*]_file_);
-struct tracecmd_input pass:[*]*tracecmd_open_fd*(int _fd_);
-struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_);
+struct tracecmd_input pass:[*]*tracecmd_open*(const char pass:[*]_file_, int _flags_);
+struct tracecmd_input pass:[*]*tracecmd_open_fd*(int _fd_, int _flags_);
+struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_, int _flags_);
 int *tracecmd_init_data*(struct tracecmd_input pass:[*]_handle_);
 void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
 --
@@ -25,7 +25,13 @@ This set of APIs can be used to open and close a trace file recorded by
 _trace-cmd(1)_ and containing tracing information from ftrace, the official
 Linux kernel tracer. The opened file is represented by a _tracecmd_input_
 structure, all other library APIs that work with the file require a pointer
-to the structure.
+to the structure. The APIs for opening a trace file have a _flag_ input
+parameter, which controls how the file will be opened and parsed. The _flag_
+is a combination of these options:
+
+ TRACECMD_FLAG_LOAD_NO_PLUGINS - Do not load any plugins
+ TRACECMD_FLAG_LOAD_NO_SYSTEM_PLUGINS - Do not load system wide plugins, load only "local only"
+					plugins from user's home directory.
 
 The _tracecmd_open()_ function opens a given trace _file_, parses the
 metadata headers from the file, allocates and initializes а _tracecmd_input_
diff --git a/Documentation/libtracecmd/libtracecmd.3.txt b/Documentation/libtracecmd/libtracecmd.3.txt
index 2eb91f80..14dfeb8d 100644
--- a/Documentation/libtracecmd/libtracecmd.3.txt
+++ b/Documentation/libtracecmd/libtracecmd.3.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 *#include <trace-cmd.h>*
 
 Open and close trace file:
-	struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_);
+	struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_, int _flags_);
 	void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
 
 Read tracing records from a trace file:
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5a1ba6ba..a8334483 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -11,9 +11,14 @@
 
 struct tracecmd_input;
 
-struct tracecmd_input *tracecmd_open_head(const char *file);
-struct tracecmd_input *tracecmd_open(const char *file);
-struct tracecmd_input *tracecmd_open_fd(int fd);
+enum tracecmd_open_flags {
+	TRACECMD_FLAG_LOAD_NO_PLUGINS		= 1 << 0, /* Do not load plugins */
+	TRACECMD_FLAG_LOAD_NO_SYSTEM_PLUGINS	= 1 << 1, /* Do not load system plugins */
+};
+struct tracecmd_input *tracecmd_open_head(const char *file, int flags);
+struct tracecmd_input *tracecmd_open(const char *file, int flags);
+struct tracecmd_input *tracecmd_open_fd(int fd, int flags);
+
 void tracecmd_close(struct tracecmd_input *handle);
 int tracecmd_pair_peer(struct tracecmd_input *handle,
 		       struct tracecmd_input *peer);
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 8f5dcb00..e51a2587 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -141,7 +141,7 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 
 	kshark_free_task_list(kshark_ctx);
 
-	handle = tracecmd_open_head(file);
+	handle = tracecmd_open_head(file, 0);
 	if (!handle)
 		return false;
 
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a08566e6..2657ca64 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -25,7 +25,7 @@
 void tracecmd_parse_cmdlines(struct tep_handle *pevent, char *file, int size);
 void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
 void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
-struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep);
+struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep, int flags);
 
 int *tracecmd_add_id(int *list, int id, int len);
 
@@ -46,9 +46,6 @@ struct hook_list;
 
 /* --- tracecmd plugins --- */
 
-extern int tracecmd_disable_sys_plugins;
-extern int tracecmd_disable_plugins;
-
 enum tracecmd_context {
 	TRACECMD_INPUT,
 	TRACECMD_OUTPUT,
@@ -141,8 +138,8 @@ typedef void (*tracecmd_show_data_func)(struct tracecmd_input *handle,
 typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
 					  struct hook_list *hook, int global);
 
-struct tracecmd_input *tracecmd_alloc(const char *file);
-struct tracecmd_input *tracecmd_alloc_fd(int fd);
+struct tracecmd_input *tracecmd_alloc(const char *file, int flags);
+struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags);
 void tracecmd_ref(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle);
 int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/test.c b/lib/trace-cmd/test.c
index 5622d79c..3db029aa 100644
--- a/lib/trace-cmd/test.c
+++ b/lib/trace-cmd/test.c
@@ -2,6 +2,6 @@
 
 int main()
 {
-	tracecmd_open_head("trace.dat");
+	tracecmd_open_head("trace.dat", 0);
 	return 0;
 }
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7d28254e..6caeb58b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3076,6 +3076,7 @@ struct hook_list *tracecmd_hooks(struct tracecmd_input *handle)
 /**
  * tracecmd_alloc_fd - create a tracecmd_input handle from a file descriptor
  * @fd: the file descriptor for the trace.dat file
+ * @flags: bitmask of enum tracecmd_open_flags
  *
  * Allocate a tracecmd_input handle from a file descriptor and open the
  * file. This tests if the file is of trace-cmd format and allocates
@@ -3087,7 +3088,7 @@ struct hook_list *tracecmd_hooks(struct tracecmd_input *handle)
  * Unless you know what you are doing with this, you want to use
  * tracecmd_open_fd() instead.
  */
-struct tracecmd_input *tracecmd_alloc_fd(int fd)
+struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 {
 	struct tracecmd_input *handle;
 	char test[] = TRACECMD_MAGIC;
@@ -3128,9 +3129,11 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 		goto failed_read;
 
 	/* register default ftrace functions first */
-	tracecmd_ftrace_overrides(handle, &handle->finfo);
+	if (!(flags & TRACECMD_FLAG_LOAD_NO_PLUGINS) &&
+	    !(flags & TRACECMD_FLAG_LOAD_NO_SYSTEM_PLUGINS))
+		tracecmd_ftrace_overrides(handle, &handle->finfo);
 
-	handle->plugin_list = trace_load_plugins(handle->pevent);
+	handle->plugin_list = trace_load_plugins(handle->pevent, flags);
 
 	tep_set_file_bigendian(handle->pevent, buf[0]);
 	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
@@ -3161,6 +3164,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 /**
  * tracecmd_alloc_fd - create a tracecmd_input handle from a file name
  * @file: the file name of the file that is of tracecmd data type.
+ * @flags: bitmask of enum tracecmd_open_flags
  *
  * Allocate a tracecmd_input handle from a given file name and open the
  * file. This tests if the file is of trace-cmd format and allocates
@@ -3172,7 +3176,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
  * Unless you know what you are doing with this, you want to use
  * tracecmd_open() instead.
  */
-struct tracecmd_input *tracecmd_alloc(const char *file)
+struct tracecmd_input *tracecmd_alloc(const char *file, int flags)
 {
 	int fd;
 
@@ -3180,19 +3184,20 @@ struct tracecmd_input *tracecmd_alloc(const char *file)
 	if (fd < 0)
 		return NULL;
 
-	return tracecmd_alloc_fd(fd);
+	return tracecmd_alloc_fd(fd, flags);
 }
 
 /**
  * tracecmd_open_fd - create a tracecmd_handle from the trace.dat file descriptor
  * @fd: the file descriptor for the trace.dat file
+ * @flags: bitmask of enum tracecmd_open_flags
  */
-struct tracecmd_input *tracecmd_open_fd(int fd)
+struct tracecmd_input *tracecmd_open_fd(int fd, int flags)
 {
 	struct tracecmd_input *handle;
 	int ret;
 
-	handle = tracecmd_alloc_fd(fd);
+	handle = tracecmd_alloc_fd(fd, flags);
 	if (!handle)
 		return NULL;
 
@@ -3212,8 +3217,9 @@ fail:
 /**
  * tracecmd_open - create a tracecmd_handle from a given file
  * @file: the file name of the file that is of tracecmd data type.
+ * @flags: bitmask of enum tracecmd_open_flags
  */
-struct tracecmd_input *tracecmd_open(const char *file)
+struct tracecmd_input *tracecmd_open(const char *file, int flags)
 {
 	int fd;
 
@@ -3221,15 +3227,16 @@ struct tracecmd_input *tracecmd_open(const char *file)
 	if (fd < 0)
 		return NULL;
 
-	return tracecmd_open_fd(fd);
+	return tracecmd_open_fd(fd, flags);
 }
 
 /**
  * tracecmd_open_head - create a tracecmd_handle from a given file, read
  *			and parse only the trace headers from the file
  * @file: the file name of the file that is of tracecmd data type.
+ * @flags: bitmask of enum tracecmd_open_flags
  */
-struct tracecmd_input *tracecmd_open_head(const char *file)
+struct tracecmd_input *tracecmd_open_head(const char *file, int flags)
 {
 	struct tracecmd_input *handle;
 	int fd;
@@ -3238,7 +3245,7 @@ struct tracecmd_input *tracecmd_open_head(const char *file)
 	if (fd < 0)
 		return NULL;
 
-	handle = tracecmd_alloc_fd(fd);
+	handle = tracecmd_alloc_fd(fd, flags);
 	if (!handle)
 		return NULL;
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 032c8ff4..c329eeea 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1417,7 +1417,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 		return NULL;
 
 	/* get a input handle from this */
-	ihandle = tracecmd_alloc_fd(fd2);
+	ihandle = tracecmd_alloc_fd(fd2, 0);
 	if (!ihandle)
 		return NULL;
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 9661b266..c286fd77 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -27,8 +27,6 @@
 #define LOCAL_PLUGIN_DIR ".trace-cmd/plugins"
 #define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
-int tracecmd_disable_sys_plugins;
-int tracecmd_disable_plugins;
 static bool debug;
 
 static FILE *logfp;
@@ -335,14 +333,14 @@ static char *get_source_plugins_dir(void)
 }
 
 struct tep_plugin_list*
-trace_load_plugins(struct tep_handle *tep)
+trace_load_plugins(struct tep_handle *tep, int flags)
 {
 	struct tep_plugin_list *list;
 	char *path;
 
-	if (tracecmd_disable_plugins)
+	if (flags & TRACECMD_FLAG_LOAD_NO_PLUGINS)
 		tep_set_flag(tep, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
+	if (flags & TRACECMD_FLAG_LOAD_NO_SYSTEM_PLUGINS)
 		tep_set_flag(tep, TEP_DISABLE_SYS_PLUGINS);
 
 	path = get_source_plugins_dir();
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 7b14c68a..77271712 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -46,7 +46,7 @@ struct pid_record_data {
 
 void show_file(const char *name);
 
-struct tracecmd_input *read_trace_header(const char *file);
+struct tracecmd_input *read_trace_header(const char *file, int flags);
 int read_trace_files(void);
 
 void trace_record(int argc, char **argv);
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index 0fa9082c..a42e9b0e 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -17,6 +17,7 @@ void trace_check_events(int argc, char **argv)
 	int parsing_failures = 0;
 	struct tep_handle *pevent = NULL;
 	struct tep_plugin_list *list = NULL;
+	int open_flags = 0;
 
 	while ((c = getopt(argc-1, argv+1, "+hN")) >= 0) {
 		switch (c) {
@@ -25,7 +26,7 @@ void trace_check_events(int argc, char **argv)
 			usage(argv);
 			break;
 		case 'N':
-			tracecmd_disable_plugins = 1;
+			open_flags |= TRACECMD_FLAG_LOAD_NO_PLUGINS;
 			break;
 		}
 	}
@@ -44,7 +45,7 @@ void trace_check_events(int argc, char **argv)
 	if (!pevent)
 		exit(EINVAL);
 
-	list = trace_load_plugins(pevent);
+	list = trace_load_plugins(pevent, open_flags);
 	ret = tracefs_fill_local_events(tracing, pevent, &parsing_failures);
 	if (ret || parsing_failures)
 		ret = EINVAL;
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index ea9b2bef..3b59ac6f 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -1039,7 +1039,7 @@ void trace_hist(int argc, char **argv)
 	if (!input_file)
 		input_file = DEFAULT_INPUT_FILE;
 
-	handle = tracecmd_alloc(input_file);
+	handle = tracecmd_alloc(input_file, 0);
 	if (!handle)
 		die("can't open %s\n", input_file);
 
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index c9abcd73..f017c938 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -357,7 +357,7 @@ static void show_plugin_options(void)
 
 	trace_seq_init(&s);
 
-	list = trace_load_plugins(pevent);
+	list = trace_load_plugins(pevent, 0);
 	tep_plugin_print_options(&s);
 	trace_seq_do_printf(&s);
 	tep_unload_plugins(list, pevent);
@@ -383,7 +383,7 @@ static void show_plugins(void)
 
 	trace_seq_init(&s);
 
-	list = trace_load_plugins(pevent);
+	list = trace_load_plugins(pevent, 0);
 	tep_print_plugins(&s, "  ", "\n", list);
 
 	trace_seq_do_printf(&s);
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 2eb75a00..3453c3a7 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -550,7 +550,7 @@ void trace_mem(int argc, char **argv)
 	if (!input_file)
 		input_file = DEFAULT_INPUT_FILE;
 
-	handle = tracecmd_alloc(input_file);
+	handle = tracecmd_alloc(input_file, 0);
 	if (!handle)
 		die("can't open %s\n", input_file);
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d07f4efe..cd2b6a06 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1332,13 +1332,13 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	}
 }
 
-struct tracecmd_input *read_trace_header(const char *file)
+struct tracecmd_input *read_trace_header(const char *file, int flags)
 {
 	input_fd = open(file, O_RDONLY);
 	if (input_fd < 0)
 		die("opening '%s'\n", file);
 
-	return tracecmd_alloc_fd(input_fd);
+	return tracecmd_alloc_fd(input_fd, flags);
 }
 
 static void sig_end(int sig)
@@ -1522,6 +1522,7 @@ void trace_report (int argc, char **argv)
 	long long tsoffset = 0;
 	unsigned long long ts2secs = 0;
 	unsigned long long ts2sc;
+	int open_flags = 0;
 	int show_stat = 0;
 	int show_funcs = 0;
 	int show_endian = 0;
@@ -1620,10 +1621,10 @@ void trace_report (int argc, char **argv)
 			show_printk = 1;
 			break;
 		case 'L':
-			tracecmd_disable_sys_plugins = 1;
+			open_flags |= TRACECMD_FLAG_LOAD_NO_SYSTEM_PLUGINS;
 			break;
 		case 'N':
-			tracecmd_disable_plugins = 1;
+			open_flags |= TRACECMD_FLAG_LOAD_NO_PLUGINS;
 			break;
 		case 'n':
 			*nohandler_ptr = malloc(sizeof(struct event_str));
@@ -1768,7 +1769,7 @@ void trace_report (int argc, char **argv)
 		die("Wakeup tracing can only be done on a single input file");
 
 	list_for_each_entry(inputs, &input_files, list) {
-		handle = read_trace_header(inputs->file);
+		handle = read_trace_header(inputs->file, open_flags);
 		if (!handle)
 			die("error reading header for %s", inputs->file);
 
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index d6134acf..98e75733 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -116,7 +116,7 @@ void trace_restore (int argc, char **argv)
 	if (input) {
 		struct tracecmd_input *ihandle;
 
-		ihandle = tracecmd_alloc(input);
+		ihandle = tracecmd_alloc(input, 0);
 		if (!ihandle)
 			die("error reading file %s", input);
 		/* make sure headers are ok */
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 9d347b36..c707a5d5 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -506,7 +506,7 @@ void trace_split (int argc, char **argv)
 	if (!input_file)
 		input_file = default_input_file;
 
-	handle = tracecmd_open(input_file);
+	handle = tracecmd_open(input_file, 0);
 	if (!handle)
 		die("error reading %s", input_file);
 
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index 54c21c78..e230cf89 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -53,7 +53,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 
 	lseek(ofd, 0, SEEK_SET);
 
-	trace_input = tracecmd_alloc_fd(ofd);
+	trace_input = tracecmd_alloc_fd(ofd, 0);
 	if (!trace_input) {
 		close(ofd);
 		goto fail;
-- 
2.29.2

