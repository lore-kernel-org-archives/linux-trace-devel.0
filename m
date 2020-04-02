Return-Path: <SRS0=JQUT=5S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD50C2BA15
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 10:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5460B20784
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 10:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="in6uwhiH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387997AbgDBK6m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 06:58:42 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44583 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387476AbgDBK6l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 06:58:41 -0400
Received: by mail-lj1-f196.google.com with SMTP id p14so2705905lji.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Apr 2020 03:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+a7WmHFi8Y44A2xp48evLcwSev/hH0Di+U3VURxDwe8=;
        b=in6uwhiHHKne6zSOxNWYeI6dq+45UMhJrSeJG391JE0w4Fm2yVBtnAPWDOxdfpg+9s
         dwnyetNUh4AOdr7sPDT0pA0JuJzLb/c4WGTvzrgs7POTOiqm58WRJ63JBp0jEFK8csf9
         4Bhx5EbIPqN8WLoH4OR6CE9RIGEoShDtCHez1ilNLfbr4itbkQGQY6NvWbEu07LjJU3i
         veA39NtpSQ9aGxae2JKJayLWzaZsmpajLYUyG6aENHSpGLJWs9GRWfYAtrGvTosrbNtK
         KmSY5mnVCvO7xZDaLGF0+2N9Xo+lmB2avHi0bF7P1ffEXNePyw3fRN6mfybKFvR1Swmu
         Q3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+a7WmHFi8Y44A2xp48evLcwSev/hH0Di+U3VURxDwe8=;
        b=Vc8ugzqVbc6Jd2S2ZZrEaQDuZqlJHtM2amtD+eS86YtNFF/wlSy/qJ1sFP/r0SzwQg
         qKulDie/Dx7luHvuPrAIE+ag+Gn2GfIlUDxA/PmR/hfUyBtkOHQn2PEDmBzHyg7C1HjG
         43H8xcpAqwbGruz8sCvNPBXVQc6xwecuo/VME+AlfwgJRgfxpRuUmgEF3WjMVfKgq7gc
         gk7tZIZt0OrRD4CXYYHFNbtbRW2iibEm1UQx3bmNw4Q08zKO9zVpSZuJHUFVIBD0weth
         B1RfhoBnMk0ZCvGq129yOoFbz0VAZLR52VMa7UvRJfS6xZDYre3FhMr9nvBmrbdeLvG0
         tzyQ==
X-Gm-Message-State: AGi0PuYOck0kE69cAf2o6j8VNLBd7C77EC+T8CZ8Ti8zTaV467ovRAex
        PMnDeOKep3DicSBeAb4U66k=
X-Google-Smtp-Source: APiQypKFoqVq/bwaz0MydMeMQKU4qKJALGVjqa95QGX5DEr7JxqE51Y+VG8+aTCmYcdshikyx8OpVg==
X-Received: by 2002:a2e:8954:: with SMTP id b20mr1605515ljk.176.1585825118508;
        Thu, 02 Apr 2020 03:58:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c2sm3779803lfb.43.2020.04.02.03.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 03:58:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/5] trace-cmd: Add new API to merge two trace files
Date:   Thu,  2 Apr 2020 13:58:29 +0300
Message-Id: <20200402105831.263753-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402105831.263753-1-tz.stoyanov@gmail.com>
References: <20200402105831.263753-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API
   struct tracecmd_input *tracecmd_open_merge(const char *file, const char *primary_file);
can be used to open a trace file and adjust its timestamps to the
primary_file, if both were recorded in one tracing session.
A tracecmd_input handler to the file is allocated and returned.
The timestamps of all events are adjusted according to the time synchronization data,
recorded in the file.
The API checks if the tracing session from the both files match.
In case they do not match, the timestamps are not corrected.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  1 +
 lib/trace-cmd/trace-input.c   | 89 +++++++++++++++++++++++++++++------
 2 files changed, 76 insertions(+), 14 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 3d2d9ae1..4a68eee1 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -142,6 +142,7 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
 struct tracecmd_input *tracecmd_alloc(const char *file);
 struct tracecmd_input *tracecmd_alloc_fd(int fd);
 struct tracecmd_input *tracecmd_open(const char *file);
+struct tracecmd_input *tracecmd_open_merge(const char *file, const char *primary_file);
 struct tracecmd_input *tracecmd_open_fd(int fd);
 void tracecmd_ref(struct tracecmd_input *handle);
 void tracecmd_close(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 347a595f..e02cb879 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -96,8 +96,9 @@ struct guest_trace_info {
 };
 
 struct host_trace_info {
-	unsigned long long	trace_id;
+	unsigned long long	peer_trace_id;
 	bool			sync_enable;
+	struct tracecmd_input	*peer_data;
 	int			cpu_count;
 	struct ts_offset_cpu	*cpu_time_offsets;
 };
@@ -2225,10 +2226,33 @@ error:
 	return -1;
 }
 
+static void tsync_check_enable(struct tracecmd_input *handle)
+{
+	struct host_trace_info	*host = &handle->host;
+	struct guest_trace_info *guest;
+
+	host->sync_enable = false;
+
+	if (!host->peer_data || !host->peer_data->guest ||
+	    !host->cpu_count || !host->cpu_time_offsets)
+		return;
+	if (host->peer_trace_id != host->peer_data->trace_id)
+		return;
+	guest = host->peer_data->guest;
+	while (guest) {
+		if (guest->trace_id == handle->trace_id)
+			break;
+		guest = guest->next;
+	}
+	if (!guest)
+		return;
+
+	host->sync_enable = true;
+}
+
 static int tsync_offset_load(struct tracecmd_input *handle,
 			      char *buf, int buf_size, int cpus)
 {
-	struct host_trace_info *host = &handle->host;
 	int count, cpu;
 	int ret;
 	int i;
@@ -2257,8 +2281,6 @@ static int tsync_offset_load(struct tracecmd_input *handle,
 		buf += ret;
 	}
 
-	if (host->cpu_count)
-		host->sync_enable = true;
 	return 0;
 }
 
@@ -2272,6 +2294,11 @@ static void trace_tsync_offset_free(struct host_trace_info *host)
 	free(host->cpu_time_offsets);
 	host->cpu_time_offsets = NULL;
 	host->cpu_count = 0;
+
+	if (host->peer_data) {
+		tracecmd_close(host->peer_data);
+		host->peer_data = NULL;
+	}
 }
 
 static int trace_pid_map_cmp(const void *a, const void *b)
@@ -2585,8 +2612,8 @@ static int handle_options(struct tracecmd_input *handle)
 			 */
 			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
 				break;
-			handle->host.trace_id = tep_read_number(handle->pevent,
-								buf, 8);
+			handle->host.peer_trace_id = tep_read_number(handle->pevent,
+								     buf, 8);
 			cpus = tep_read_number(handle->pevent, buf + 8, 4);
 			tsync_offset_load(handle, buf + 12, size - 12, cpus);
 			break;
@@ -2659,6 +2686,8 @@ static int handle_options(struct tracecmd_input *handle)
 
 	handle->cpustats = cpustats;
 
+	tsync_check_enable(handle);
+
 	return 0;
 }
 
@@ -3192,11 +3221,8 @@ struct tracecmd_input *tracecmd_alloc(const char *file)
 	return tracecmd_alloc_fd(fd);
 }
 
-/**
- * tracecmd_open_fd - create a tracecmd_handle from the trace.dat file descriptor
- * @fd: the file descriptor for the trace.dat file
- */
-struct tracecmd_input *tracecmd_open_fd(int fd)
+static struct tracecmd_input *tracecmd_open_fd_ext(int fd,
+						   struct tracecmd_input *merge)
 {
 	struct tracecmd_input *handle;
 	int ret;
@@ -3204,7 +3230,7 @@ struct tracecmd_input *tracecmd_open_fd(int fd)
 	handle = tracecmd_alloc_fd(fd);
 	if (!handle)
 		return NULL;
-
+	handle->host.peer_data = merge;
 	if (tracecmd_read_headers(handle) < 0)
 		goto fail;
 
@@ -3218,6 +3244,15 @@ fail:
 	return NULL;
 }
 
+/**
+ * tracecmd_open_fd - create a tracecmd_handle from the trace.dat file descriptor
+ * @fd: the file descriptor for the trace.dat file
+ */
+struct tracecmd_input *tracecmd_open_fd(int fd)
+{
+	return tracecmd_open_fd_ext(fd, NULL);
+}
+
 /**
  * tracecmd_open - create a tracecmd_handle from a given file
  * @file: the file name of the file that is of tracecmd data type.
@@ -3230,7 +3265,33 @@ struct tracecmd_input *tracecmd_open(const char *file)
 	if (fd < 0)
 		return NULL;
 
-	return tracecmd_open_fd(fd);
+	return tracecmd_open_fd_ext(fd, NULL);
+}
+
+/**
+ * tracecmd_open_merge - create a tracecmd_handle from a given file and
+ * @file: the file name of the file that is of tracecmd data type.
+ */
+struct tracecmd_input *tracecmd_open_merge(const char *file,
+					   const char *primary_file)
+{
+	struct tracecmd_input *primary = NULL;
+	int fd;
+
+	if (!primary_file)
+		return tracecmd_open(file);
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return NULL;
+
+	primary = tracecmd_open(primary_file);
+	if (!primary) {
+		close(fd);
+		return NULL;
+	}
+
+	return tracecmd_open_fd_ext(fd, primary);
 }
 
 /**
@@ -3812,7 +3873,7 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
  */
 unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
 {
-	return handle->host.trace_id;
+	return handle->host.peer_trace_id;
 }
 
 /**
-- 
2.25.1

