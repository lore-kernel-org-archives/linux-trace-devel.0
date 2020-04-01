Return-Path: <SRS0=9gE1=5R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A50FC2BA14
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FD8C2078C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YwUhozW6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389437AbgDAQs6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:48:58 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41193 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389798AbgDAQpD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 12:45:03 -0400
Received: by mail-lf1-f68.google.com with SMTP id z23so230946lfh.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Apr 2020 09:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+a7WmHFi8Y44A2xp48evLcwSev/hH0Di+U3VURxDwe8=;
        b=YwUhozW6eDaLfVgIxyds5wwhgLS681Bdi5vf6Px7fYHD0DScUbIYEGjMLb/fNq6PG+
         +zjY3f5f05nWMScta3pCgdVOYV2RVq3I1bVg6INprqb9jbb1jsaJcTcMgftQzkDeIgZx
         UdoHDQ1GlETmm5agBC8riCaHdX0Gt4Ui+pOqwnP6xV9orFItPGCfnVEaZiUft8Tzu7yt
         aVd6NVSfFULib7NkZSIxct/zojFwA/xXiyaTSHScv02Qv+qEcHUC3gpMKGI0uLQs8cI5
         Id1M9pjgNK64KAxD4sSfnA5eCgFoW4ZqPkrAjvMB4QNtwnzDYPVLg1dRzpGmf5JctXfu
         zh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+a7WmHFi8Y44A2xp48evLcwSev/hH0Di+U3VURxDwe8=;
        b=SG3xQdGScHnkOCzJYPrt63gqXZZC7AlEGESRxjJW6MTReEEaeVmbwUhEwjqMVXQDGo
         bLIrCbQ0pOihjGb/WHflPNBFtRkih9ncN3+9wrHpaGeMAaV8GMPT+83Z0i56K6+8Og99
         NvOP6kG+U/urobOXqh+ugpF4BPFLUD0u79s+fTcqNnj6rc9ekgKdcPy7Qlqm5WGEuQg1
         QoclzlUlnwS2xQDj/7lGj9hNYPXLFBZRGDGlLIePZoXpVoBHL48/PWMzdlPAMTsbpl5t
         QqwbMhccr4WIHiiAFy7VgsIFVzz8zvnYWq3dvrUECFEALagJPWAnyd49m5Mu2bvj0HK6
         f0dQ==
X-Gm-Message-State: AGi0PuZ4LdKXX9cnCm8457vR2N7M7nOWgWFtLSWOxDsuNOZ6SbT2DjrR
        H25uTjX/t5/N55Hx/rsQMjY=
X-Google-Smtp-Source: APiQypIW2YwIBCWNOan4iSmFvjx+mc5xodhouiqimse5SayADaoTzzq0CoCEYFoSZozsWzxPpnHo+A==
X-Received: by 2002:a05:6512:203c:: with SMTP id s28mr14686195lfs.49.1585759499676;
        Wed, 01 Apr 2020 09:44:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e4sm1982499lfn.80.2020.04.01.09.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 09:44:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/5] trace-cmd: Add new API to merge two trace files
Date:   Wed,  1 Apr 2020 19:44:49 +0300
Message-Id: <20200401164451.191425-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401164451.191425-1-tz.stoyanov@gmail.com>
References: <20200401164451.191425-1-tz.stoyanov@gmail.com>
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

