Return-Path: <SRS0=NxYB=W6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC04C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BA1123431
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r3IFC3lN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfICNeu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:34:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36889 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729079AbfICNeu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 09:34:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so17525334wrt.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Sep 2019 06:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmnqcMgO4qWN68jFns4KSCtJ6lJMvztIzKeN5/wCFiw=;
        b=r3IFC3lNLPBUYj4F1odLyjPGZsNcUykmBlDO1pfW4UZK3a3v9FccuOKjTU1JKLCr8m
         jsyR18Pf31ldmAX5TDmoRuuZm8fpeiQEOqCuNY6UL9k/yoqUTYL8Qc4+BLPDGS0eIoqf
         u3e7TNYWX31eKnTcleMSAcy98awHtM5BRFj5hEaGwmbrXb3QLEKN7hOruCYe6AjCQ7Fd
         hT01b0/HpST4f5tZPk9XQ8foAdSQ/4imX11tQHEsBzgETGCkt9hPRtgqS53FHa1i6UDr
         hF0BMVAQgI4lUKWbbHgUKKVgfUKFdkoY5bmLUzwOOYjkeIfV6hPLSwpkGKYT/05yt/FE
         FdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmnqcMgO4qWN68jFns4KSCtJ6lJMvztIzKeN5/wCFiw=;
        b=kfHDdLsWJlI4C5wn6jxNbswik8CgQfeq+p4iYimU96SDU+fNVwC12Rd/gbPuIhQAv2
         7CoLb9DXrKW4Jz5eZnZaRB3yUBOqxaVDOAT8kspez6xzT+xGWcVawcc5VAFQqJf/Bh9o
         JDHq/0M3wvhPLdcObh3vvH6DsOywRUcQCJXXs/X/x0Cicq0fFD09GwsrivP3CG+RlRrZ
         6xhKbrNSfGpoDyNXEBUmNNfmU6VQOYHx0AKBRw9PEJ9/tnBE0+Up//j7kxaebx1F5eLX
         XauQTNodUI1sdzQPxI+DlZ0Bm19spMxbcjO3hfMchCVCfucuocdzYnoHH/GLV4QzDl5I
         3scg==
X-Gm-Message-State: APjAAAWXvnxo8oFPh1KNVX1AiDnjsG3rHjxvue97vi5wlqJwmgc4LyZL
        dPjeP6Nflwp6+PdCsZ10PvJ6ZInJ
X-Google-Smtp-Source: APXvYqyq4TuKmhgWZbsr7wIx6fufZXvA7V4ZgPgqC12/mBSJz9E+dIyyZJfzdXuWMCFzWG4KuyuDOw==
X-Received: by 2002:a5d:51c7:: with SMTP id n7mr41453937wrv.73.1567517687892;
        Tue, 03 Sep 2019 06:34:47 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r16sm33509833wrc.81.2019.09.03.06.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 06:34:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/4] trace-cmd: Move trace-cmd global variable "quiet" to libtracecmd
Date:   Tue,  3 Sep 2019 16:34:42 +0300
Message-Id: <20190903133445.30486-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903133445.30486-1-tz.stoyanov@gmail.com>
References: <20190903133445.30486-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A trace-cmd global variable "quiet" is used from libtracecmd and
should be defined there. A new library APIs are implemented to
access it:
 void tracecmd_set_quiet(int quiet);
 int tracecmd_get_quiet(void);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h           |  3 +++
 lib/trace-cmd/include/trace-cmd-local.h |  2 --
 lib/trace-cmd/trace-output.c            | 28 +++++++++++++++++++++++--
 tracecmd/include/trace-local.h          |  2 --
 tracecmd/trace-cmd.c                    |  2 --
 tracecmd/trace-record.c                 | 15 +++++++++----
 6 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ede510c..f44f7a4 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -57,6 +57,9 @@ struct tracecmd_output;
 struct tracecmd_recorder;
 struct hook_list;
 
+void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet);
+bool tracecmd_get_quiet(struct tracecmd_output *handle);
+
 static inline int tracecmd_host_bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index bad325f..09574db 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -18,8 +18,6 @@
 #define STR(x)	_STR(x)
 #define FILE_VERSION_STRING STR(FILE_VERSION)
 
-extern int quiet;
-
 static ssize_t __do_write(int fd, const void *data, size_t size)
 {
 	ssize_t tot = 0;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1f94346..41932ee 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -53,6 +53,7 @@ struct tracecmd_output {
 	char			*tracing_dir;
 	int			options_written;
 	int			nr_options;
+	bool			quiet;
 	struct list_head 	options;
 	struct tracecmd_msg_handle *msg_handle;
 };
@@ -103,6 +104,29 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
+/**
+ * tracecmd_set_quiet - Set if to print output to the screen
+ * @quiet: If non zero, print no output to the screen
+ *
+ */
+void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet)
+{
+	if (handle)
+		handle->quiet = set_quiet;
+}
+
+/**
+ * tracecmd_get_quiet - Get if to print output to the screen
+ * Returns non zero, if no output to the screen should be printed
+ *
+ */
+bool tracecmd_get_quiet(struct tracecmd_output *handle)
+{
+	if (handle)
+		return handle->quiet;
+	return false;
+}
+
 void tracecmd_output_free(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *option;
@@ -1157,7 +1181,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
-		if (!quiet)
+		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
 				i, (unsigned long long) offsets[i]);
 		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
@@ -1172,7 +1196,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    check_size, sizes[i]);
 			goto out_free;
 		}
-		if (!quiet)
+		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "    %llu bytes in size\n",
 				(unsigned long long)check_size);
 	}
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 7de5dd6..05760d8 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -12,8 +12,6 @@
 #include "trace-cmd.h"
 #include "event-utils.h"
 
-extern int quiet;
-
 /* fix stupid glib guint64 typecasts and printf formats */
 typedef unsigned long long u64;
 
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 4add2e2..30691b6 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -16,8 +16,6 @@
 int silence_warnings;
 int show_status;
 
-int quiet;
-
 void warning(const char *fmt, ...)
 {
 	va_list ap;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7467b47..61457c8 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -80,6 +80,8 @@ static char *host;
 static unsigned int *client_ports;
 static int sfd;
 
+static bool quiet;
+
 /* Max size to let a per cpu file get */
 static int max_kb;
 
@@ -3162,13 +3164,16 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		tracecmd_set_quiet(network_handle, quiet);
 		add_options(network_handle, ctx);
 		tracecmd_write_cpus(network_handle, instance->cpu_count);
 		tracecmd_write_options(network_handle);
 		tracecmd_msg_finish_sending_data(msg_handle);
-	} else
+	} else {
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
 							      listed_events);
+		tracecmd_set_quiet(network_handle, quiet);
+	}
 
 	instance->network_handle = network_handle;
 
@@ -3444,9 +3449,10 @@ static void record_data(struct common_record_context *ctx)
 	if (!local)
 		return;
 
-	if (latency)
+	if (latency) {
 		handle = tracecmd_create_file_latency(output_file, local_cpu_count);
-	else {
+		tracecmd_set_quiet(handle, quiet);
+	} else {
 		if (!local_cpu_count)
 			return;
 
@@ -3478,6 +3484,7 @@ static void record_data(struct common_record_context *ctx)
 		handle = tracecmd_create_init_file_glob(output_file, listed_events);
 		if (!handle)
 			die("Error creating output file");
+		tracecmd_set_quiet(handle, quiet);
 
 		add_options(handle, ctx);
 
@@ -5155,7 +5162,7 @@ static void parse_record_options(int argc,
 			break;
 		case OPT_quiet:
 		case 'q':
-			quiet = 1;
+			quiet = true;
 			break;
 		default:
 			usage(argv);
-- 
2.21.0

