Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E92C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A1A2072F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JuzILT0m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgDIN2b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:31 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46573 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDIN2a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:30 -0400
Received: by mail-lf1-f66.google.com with SMTP id m19so5864556lfq.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJZh6z5MGcvmL6GZTJ3Pls8s+XUreyQ74hJQRMmS4RA=;
        b=JuzILT0mGrHhAw0AVUlvUHzGxh+aMkapHuShqHG/KIEnRtFh3GxjPjIUrbY+HBfPzS
         MoWsbY5Q+EB0uF8x3qwygoxrxF7PlAZtMlrbiH3p5dmBidRCfjT3AedK9S1bDIUHo+M0
         rAl/Bx8jQB1oMOs3vGqL3mZfSPJ0WfRxV7O1/RdCfDm/wTMnV1nU2G9luiU7Bp46+XPN
         a8u3OSKGYOjnuPI7trFfedwLuodq3cyIIjndjZjSWyVAMen41YrYt4flT6g4vunRKnPk
         Ql4I874KBh5zgy+7MZiHsk55Oaaw3BdDreT5HJg0Itq6cLyyZH0A9LEAhAqeqyuPJG4n
         lfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJZh6z5MGcvmL6GZTJ3Pls8s+XUreyQ74hJQRMmS4RA=;
        b=G9WytJSriMzNfnFKlfPEpxVx0mpEP4RkG2w0bQ7GXtjECSbsvdPfekl5CAmw5vdjad
         Vj0Vy1jr43sYXPiU/YBD3cPMf5fUY20fxy1cvVYksX0cweVSMI+q6xt5WBa03oo/jsfp
         WjcB4sDRIKiCBrVQ2ifxKC85O3PxOyHf+RIN4TYFQK1G793EaxjzITC7XmVMNcarMBqk
         9zG4dkc2Mb/LrM590obmrCSQRjVF2pVAa1civ2w5JKFvbcatPvBEvlFYk8b7YCWUIHLf
         PiCz4tLH2i0omZ7pD24R2QXsp231EVSx5aPGQRvHfzd6I0lWZYHnq7haPIUyqzh0Yp46
         uHLA==
X-Gm-Message-State: AGi0PuaDgoOhzmRFZpqT9CuM7qR5jopvo73vydSjwP1fNN/CYWrQ9pz+
        NYemIfPYkPYOw4OoujyVMVg=
X-Google-Smtp-Source: APiQypL/9RKFpKGHBepn40M1cZuaF3InVs1jYCBL0XO4K2KRKGK92kJq6TNZAKt6zrLxUQ/HwMBebA==
X-Received: by 2002:ac2:5333:: with SMTP id f19mr7974329lfh.203.1586438908807;
        Thu, 09 Apr 2020 06:28:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 64sm15237121ljj.41.2020.04.09.06.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Move reading of trace.dat options to tracecmd_read_headers()
Date:   Thu,  9 Apr 2020 16:28:24 +0300
Message-Id: <20200409132825.79475-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409132825.79475-1-tz.stoyanov@gmail.com>
References: <20200409132825.79475-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The options section from trace.dat file is logically part of trace headers.
In some use cases it is useful first to read all headers from the file,
analyze the information and do some processing, before reading the tracing
data. In the current implementation, reading of options is just before
reading the tracing data.
Moved the reading of options and a CPU count from read_cpu_data() to
tracecmd_read_headers(). This allows to implement APIs for trace.dat
file reading on stages - headers stage and tracing data stage.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  1 +
 lib/trace-cmd/trace-input.c   | 89 +++++++++++++++++++++++------------
 2 files changed, 61 insertions(+), 29 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 595919d5..3f96bbde 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -119,6 +119,7 @@ enum {
 	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
 	TRACECMD_FL_LATENCY		= (1 << 2),
 	TRACECMD_FL_IN_USECS		= (1 << 3),
+	TRACECMD_FL_FLYRECORD		= (1 << 4),
 };
 
 struct tracecmd_ftrace {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f04528ae..ee9bfb52 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -141,6 +141,8 @@ struct tracecmd_input {
 
 __thread struct tracecmd_input *tracecmd_curr_thread_handle;
 
+static int read_options_type(struct tracecmd_input *handle);
+
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag)
 {
 	handle->flags |= flag;
@@ -747,6 +749,19 @@ int tracecmd_get_parsing_failures(struct tracecmd_input *handle)
 	return 0;
 }
 
+static int read_cpus(struct tracecmd_input *handle)
+{
+	unsigned int cpus;
+
+	if (read4(handle, &cpus) < 0)
+		return -1;
+
+	handle->cpus = cpus;
+	tep_set_cpus(handle->pevent, handle->cpus);
+
+	return 0;
+}
+
 /**
  * tracecmd_read_headers - read the header information from trace.dat
  * @handle: input handle for the trace.dat file
@@ -784,6 +799,12 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 	if (read_and_parse_cmdlines(handle) < 0)
 		return -1;
 
+	if (read_cpus(handle) < 0)
+		return -1;
+
+	if (read_options_type(handle) < 0)
+		return -1;
+
 	tep_set_long_size(handle->pevent, handle->long_size);
 
 	return 0;
@@ -2576,23 +2597,13 @@ static int handle_options(struct tracecmd_input *handle)
 	return 0;
 }
 
-static int read_cpu_data(struct tracecmd_input *handle)
+static int read_options_type(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
-	enum kbuffer_long_size long_size;
-	enum kbuffer_endian endian;
-	unsigned long long size;
-	unsigned long long max_size = 0;
-	unsigned long long pages;
 	char buf[10];
-	int cpus;
-	int cpu;
 
 	if (do_read_check(handle, buf, 10))
 		return -1;
 
-	cpus = handle->cpus;
-
 	/* check if this handles options */
 	if (strncmp(buf, "options", 7) == 0) {
 		if (handle_options(handle) < 0)
@@ -2602,17 +2613,41 @@ static int read_cpu_data(struct tracecmd_input *handle)
 	}
 
 	/*
-	 * Check if this is a latency report or not.
+	 * Check if this is a latency report or flyrecord.
 	 */
-	if (strncmp(buf, "latency", 7) == 0) {
+	if (strncmp(buf, "latency", 7) == 0)
 		handle->flags |= TRACECMD_FL_LATENCY;
+	else if (strncmp(buf, "flyrecord", 9) == 0)
+		handle->flags |= TRACECMD_FL_FLYRECORD;
+	else
+		return -1;
+
+	return 0;
+}
+
+static int read_cpu_data(struct tracecmd_input *handle)
+{
+	struct tep_handle *pevent = handle->pevent;
+	enum kbuffer_long_size long_size;
+	enum kbuffer_endian endian;
+	unsigned long long size;
+	unsigned long long max_size = 0;
+	unsigned long long pages;
+	int cpus;
+	int cpu;
+
+	/*
+	 * Check if this is a latency report or not.
+	 */
+	if (handle->flags & TRACECMD_FL_LATENCY)
 		return 1;
-	}
 
 	/* We expect this to be flyrecord */
-	if (strncmp(buf, "flyrecord", 9) != 0)
+	if (!(handle->flags & TRACECMD_FL_FLYRECORD))
 		return -1;
 
+	cpus = handle->cpus;
+
 	handle->cpu_data = malloc(sizeof(*handle->cpu_data) * handle->cpus);
 	if (!handle->cpu_data)
 		return -1;
@@ -2795,15 +2830,8 @@ static int read_and_parse_trace_clock(struct tracecmd_input *handle,
 int tracecmd_init_data(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
-	unsigned int cpus;
 	int ret;
 
-	if (read4(handle, &cpus) < 0)
-		return -1;
-	handle->cpus = cpus;
-
-	tep_set_cpus(pevent, handle->cpus);
-
 	ret = read_cpu_data(handle);
 	if (ret < 0)
 		return ret;
@@ -3579,25 +3607,28 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	if (ret < 0) {
 		warning("could not seek to buffer %s offset %ld\n",
 			buffer->name, buffer->offset);
-		tracecmd_close(new_handle);
-		return NULL;
+		goto error;
 	}
 
-	ret = read_cpu_data(new_handle);
+	ret = read_options_type(new_handle);
+	if (!ret)
+		ret = read_cpu_data(new_handle);
 	if (ret < 0) {
 		warning("failed to read sub buffer %s\n", buffer->name);
-		tracecmd_close(new_handle);
-		return NULL;
+		goto error;
 	}
 
 	ret = lseek64(handle->fd, offset, SEEK_SET);
 	if (ret < 0) {
 		warning("could not seek to back to offset %ld\n", offset);
-		tracecmd_close(new_handle);
-		return NULL;
+		goto error;
 	}
 
 	return new_handle;
+
+error:
+	tracecmd_close(new_handle);
+	return NULL;
 }
 
 int tracecmd_is_buffer_instance(struct tracecmd_input *handle)
-- 
2.25.1

