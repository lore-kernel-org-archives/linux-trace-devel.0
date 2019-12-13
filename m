Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FA0C3B192
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6F2D24706
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ql1WS5u+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfLMPam (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:42 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:47031 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbfLMPam (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:42 -0500
Received: by mail-lf1-f67.google.com with SMTP id f15so2233699lfl.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4OAxScGxLBQfrSY809oDP9OT/KqAymqrS3+gacjE/c0=;
        b=ql1WS5u++3bxh+YBZ3LLqILztW2dE9D/5zFjpbnY1lh5Rlk7xmGsshfTNxzNL6b/6Y
         WJe4VwQ1l26bqQo27rGYHA58tdt78Lt11jP+M8hKt/lTbjN15Cr2tnSyjYKAwxvD98QV
         QIjdKjMH1m1Ww8UwVMT2041EFDNQLB3JeGJSYMFRfZB79oysfAKrUbYWQXB20VKBci3H
         rhWNXY9A6n4/z+Z8qVzXLMGP8S8lQcuty5BDofKgYQ+1cUgxLYXicEAwICceBlyb/WLV
         X6SV/REzskUpqFbklpy9hnk27DHxVZ1PFERfDTUbCW8cM/OulBO6IpDdZz+G2BfYGeMa
         xUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4OAxScGxLBQfrSY809oDP9OT/KqAymqrS3+gacjE/c0=;
        b=U32fMKCKhQNbav4O53/LzAcNoeIxb97nefJL/N5h5iU2cpgXMxprpPdY37vsxgQ7Gs
         RTFnIv+pWNJMwxjw1snPGRppXbp8tQUBaK+O/CTvC7NDGHQae13kwrUU+9w/x6nK9xPW
         YAX2TzOjlUN537AgIKCuSkryY5u7hg2tQRy71cr1uGONzPLBgyo561XTWXTqCktgrPbE
         rYYyQQ32vq/eZIoQnBHDj3GY/uiuE5lsJwolZGXF3TEE4491NCdrGKj4mOjeayV+rcZ2
         dsmMmqWIlx/brXbWs25AD4knXE48U+YTZGNhH+yDZiG6NB5dxQHL6xJazvttLKPUjJ76
         1vZg==
X-Gm-Message-State: APjAAAUplPJfRTdIrnZxnrzjCcJftl1+PhiekY/wvXvOdfVE7bRLlOQB
        LweRrZK0+/LIPiGThYMVqI4=
X-Google-Smtp-Source: APXvYqyBdUro1vShzvl9xcC4D3lQZGQvFd/kKtPlxcZw8laTEvRw7LX5OoNMY6/cmbj4dngIxtmRNA==
X-Received: by 2002:a19:f80a:: with SMTP id a10mr9609167lff.107.1576251039589;
        Fri, 13 Dec 2019 07:30:39 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:39 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 06/18] trace-cmd: Add new library API for reading ftrace buffers
Date:   Fri, 13 Dec 2019 17:30:17 +0200
Message-Id: <20191213153029.133570-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
The new API can be used to search for a specific event, or sequence of events,
in a ftrace instance.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |   8 +++
 lib/trace-cmd/trace-util.c    | 115 ++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f9ad823..c0b9f4b 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -380,6 +380,14 @@ int tracecmd_alloc_instance_clock(struct tracecmd_instance *instance,
 char *tracecmd_get_instance_clock(struct tracecmd_instance *instance);
 int tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock);
 
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
index 2a121eb..75ec5a3 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1194,3 +1194,118 @@ int tracecmd_write_file(const char *file, const char *str, const char *type)
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
+ * @callback: A user function, called for each record from the file
+ * @callback_context: A custom context, passed to the user callback function
+ *
+ * If the @callback returns non-zero, the iteration stops - in that case all
+ * records from the current page will be lost from future reads
+ *
+ * Returns -1 in case of an error, or 0 otherwise
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

