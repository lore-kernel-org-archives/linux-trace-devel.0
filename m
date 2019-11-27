Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A2AC432C3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCD3620722
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NK4yteiB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfK0OC7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:02:59 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45411 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfK0OC7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:02:59 -0500
Received: by mail-lj1-f193.google.com with SMTP id n21so24574380ljg.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MDo/x8wn/ceP5KxNTdkVSVvKxX8fmIwrAlEm4BRjP/4=;
        b=NK4yteiBuU6LnjIP5wcBeMva2fjrWkSrQFebfs04cyodCGNISL/sQ53zGwqrUJX9pV
         RtQSg6Hq2Qs0wYqlTdIdMOECR+LvcZmZqFsqzVJxFvMxPBlr/kSCDLluhrNXgWd5mVME
         i+6oyUwSZf+gHz5Dw48wWN3f4nzRii+ZOvflvVZv8Zzawo+9qeR44cS6GmQCvecg5sYH
         rxi2ztuHNOwLKtSDwn5hCygK7oFksZKeNoO0+5Oa7tkxPtgvBXAx2pfQKJP1Ilz39RQp
         xnrWL3nRV3Y8C/1Q0VMdrt/d/pJqvGr5PKaHwS4MHnm49D2SrPDSBagQC9spEtptY1q2
         OPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MDo/x8wn/ceP5KxNTdkVSVvKxX8fmIwrAlEm4BRjP/4=;
        b=FAC4dsZLEb4IPOJbZZJxqOGFt6XcZPaWEFqrNEWFVLx+iBDpqAbTLSM6LWi6qXAs1r
         DwunYpTdmL6CmrY9UApA9eAQYlKJsc69QO32Sz212FKube3+u5JUjSKKpf90szAlM/dM
         KeehWWfuXhFja6m8mOlDdQNfnTAb7nHJGkeiEhCNV+Vufzzmdara6l2p18knFeHvKCHw
         AkChtmg/6aFZWgFVA0g2XbUyoL3vSTJ8vEcrG0HrN/mgYO8WZZ3b0P3lhcVtZDM/PrKC
         CPpOCO0XsKWvDyCyHUJIkDhmjv9Zp20nAr9NUyNqAlHLdOGSqsUNirjSOMfaii7R/RTE
         LB3w==
X-Gm-Message-State: APjAAAVslYUo8kRPGHy2yldba4qrswLKwQO6ZJMcpARHvR00vFWPY07I
        atQMgLYPw3egNuscaiWiFpU=
X-Google-Smtp-Source: APXvYqwzZqMVX9h9cR8g/ov5CyyEejWRtVHqaG4SRNJ8dDQ2pASVGF0l6Eu6aaFQGsm1xXD+d14vJA==
X-Received: by 2002:a05:651c:289:: with SMTP id b9mr31825766ljo.80.1574863376588;
        Wed, 27 Nov 2019 06:02:56 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:02:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 06/19] trace-cmd: Add new library API for reading ftrace buffers
Date:   Wed, 27 Nov 2019 16:02:34 +0200
Message-Id: <20191127140247.258766-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new libtracecmd API is introduced:

	int tracecmd_iterate_raw_events(struct tep_handle *tep,
					struct tracecmd_instance *instance,
					int (*callback)(struct tep_event *,
						   	struct tep_record *,
						   	int, void *context),
					void *callback_context);

It reads events from trace_pipe_raw, per cpu ftrace buffer, and calls a user
callback for each of them. The API is instance aware.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |   8 +++
 lib/trace-cmd/trace-util.c    | 114 ++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5d4292e..831bb1a 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -380,6 +380,14 @@ char *tracecmd_read_instance_file(struct tracecmd_instance *instance,
 
 void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock);
 
+int tracecmd_iterate_raw_events(struct tep_handle *tep,
+				struct tracecmd_instance *instance,
+				   int (*callback)(struct tep_event *,
+						   struct tep_record *,
+						   int, void *context),
+				void *callback_context);
+
+
 
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 1d90ed6..ee6f48a 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1182,3 +1182,117 @@ int tracecmd_write_file(const char *file, const char *str, const char *type)
 	}
 	return ret;
 }
+
+static int
+get_events_in_page(struct tep_handle *tep, void *page,
+		   int size, int cpu,
+		   int (*callback)(struct tep_event *,
+				   struct tep_record *,
+				   int, void *),
+		   void *callback_context)
+{
+	struct tep_record *last_record = NULL;
+	struct tep_event *event = NULL;
+	struct tep_record *record;
+	int id, cnt = 0;
+
+	if (size <= 0)
+		return 0;
+
+	while (true) {
+		event = NULL;
+		record = tracecmd_read_page_record(tep, page, size,
+						   last_record);
+		if (!record)
+			break;
+		free_record(last_record);
+		id = tep_data_type(tep, record);
+		event = tep_find_event(tep, id);
+		if (event && callback) {
+			if (callback(event, record, cpu, callback_context))
+				break;
+		}
+		last_record = record;
+	}
+	free_record(last_record);
+
+	return cnt;
+}
+
+/*
+ * tracecmd_iterate_raw_events - Iterate through events in trace_pipe_raw
+ *				 per CPU trace files
+ * @tep: a handle to the trace event parser context
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @callback: A user function, called for each record from the file.
+ * @callback_context: A custom context, passed to the user callback function
+ *
+ * If the @callback returns non-zero, the iteration stops.
+ *
+ * Returns -1 in case of an error, or 0 otherwise.
+ */
+int tracecmd_iterate_raw_events(struct tep_handle *tep,
+				struct tracecmd_instance *instance,
+				int (*callback)(struct tep_event *,
+						struct tep_record *,
+						int, void *),
+				void *callback_context)
+{
+	unsigned int p_size;
+	struct dirent *dent;
+	char file[PATH_MAX];
+	void *page = NULL;
+	struct stat st;
+	char *path;
+	DIR *dir;
+	int ret;
+	int cpu;
+	int fd;
+	int r;
+
+	p_size = getpagesize();
+	path = tracecmd_get_instance_file(instance, "per_cpu");
+	if (!path)
+		return -1;
+	dir = opendir(path);
+	if (!dir) {
+		ret = -1;
+		goto error;
+	}
+	page = malloc(p_size);
+	if (!page) {
+		ret = -1;
+		goto error;
+	}
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+
+		if (strlen(name) < 4 || strncmp(name, "cpu", 3) != 0)
+			continue;
+		cpu = atoi(name + 3);
+		sprintf(file, "%s/%s", path, name);
+		ret = stat(file, &st);
+		if (ret < 0 || !S_ISDIR(st.st_mode))
+			continue;
+
+		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
+		fd = open(file, O_RDONLY | O_NONBLOCK);
+		if (fd < 0)
+			continue;
+		do {
+			r = read(fd, page, p_size);
+			if (r > 0)
+				get_events_in_page(tep, page, r, cpu,
+						   callback, callback_context);
+		} while (r > 0);
+		close(fd);
+	}
+	ret = 0;
+
+error:
+	if (dir)
+		closedir(dir);
+	free(page);
+	tracecmd_put_tracing_file(path);
+	return ret;
+}
-- 
2.23.0

