Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2D7C3F68F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 15:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E6C2075A
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 15:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUGAdhJH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgAFPlL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 10:41:11 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45914 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgAFPlL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:41:11 -0500
Received: by mail-lj1-f194.google.com with SMTP id j26so51328505ljc.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 07:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmuTKjyjRQWO5Fipht30ZbMXPmsW+J8mNdn7ecMTx4A=;
        b=VUGAdhJH7FrEFBCkaQjC2slK+eYHVdRUec28WmsYGXb9T6MHDYZia0BSxawE4pnLIc
         l3+WM8BAeXPZ5puv4MQuhMZpyzOWapAXIsn271jrOnwQEW1s7xB2v6E7p4/ezCtwsPKS
         zgJnq0N20timUWUkpiZS019K9SznhpC06/FjY1RrkNI3tYbMzm5hrNUlORNCCijCo7qU
         QBo0M3XhSFHA9+UZlgeQ31ZnS8lvKk8pYA9ctt+6GoBQSeZdBq3/hjn4VlGlLjg0d+LF
         W8h5ytnlyFNxf7EDdBbCL6DxZyQdkqIUSaNJgrY6mO8KqGduFYJvY/y6Fwhwh8aiRyLG
         bwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmuTKjyjRQWO5Fipht30ZbMXPmsW+J8mNdn7ecMTx4A=;
        b=GAIfRtIDEZIjjmw0yEYa/CwKHH8VakPjy030zTdRN4yRLuqbf05nHhoDGlCuRC45EO
         VlkKLw04FR4MD/xqhZs1hfPtrQCq6/jCWSiR8F5wJ5di0QzBG7g91wPKWanvH1gfA0vp
         Hsc0Ko0yEQX8/iRHFXvP1LR9piY22aWmE4IL/PxcmwPjJq4fn65QsgFgspRYaooVqjtX
         UZ1GHrcLuq0yzagN++j0O9ljTxhsd/53e9DwlEPuSonApltYFV2RgY1p/W1MQe2uF/Jv
         7gfPnVSqUn0Vmd9JEIEFV76ddSrLA460wp2XK/hmdwdMFShh3xY5w6XxxfcnBhHxwWIS
         v7yw==
X-Gm-Message-State: APjAAAVI2QuJ7OuPJV5MPQdpMZDpL7BvwagU/0c1FGlnJobU+hEIS9gW
        m75Z4u4DRqVbNFy6pAh+ulo=
X-Google-Smtp-Source: APXvYqw4agIDXR8AFfx9TSwpa058ckbVnSiBzn9LjGp466EiZ7JdKxwrVeD2pxSzvlWTF5nrr1UfPw==
X-Received: by 2002:a05:651c:2c7:: with SMTP id f7mr8374002ljo.125.1578325268091;
        Mon, 06 Jan 2020 07:41:08 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u25sm29257677lfk.46.2020.01.06.07.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 07:41:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/5] trace-cmd,kernel-shark: New libtracefs APIs for loading ftrace events
Date:   Mon,  6 Jan 2020 17:40:58 +0200
Message-Id: <20200106154058.60660-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106154058.60660-1-tz.stoyanov@gmail.com>
References: <20200106154058.60660-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The functionality related to loading local ftrace events
to a pet handler is moved from libtracecmd to libtracefs.

The following libtracecmd APIs are removed:
  tracecmd_local_events();
  tracecmd_fill_local_events();

The following new library APIs are introduced:
  tracefs_local_events();
  tracefs_fill_local_events();

The APIs are reimplemented to reuse functionality from
 tracefs_event_systems() and
 tracefs_system_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h        |   4 -
 include/tracefs/tracefs.h            |   4 +
 kernel-shark/src/KsCaptureDialog.cpp |   2 +-
 lib/trace-cmd/trace-util.c           | 228 ---------------------------
 lib/tracefs/tracefs-events.c         | 185 ++++++++++++++++++++++
 tracecmd/trace-check-events.c        |   2 +-
 6 files changed, 191 insertions(+), 234 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 30bb144..da5bd2d 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -24,10 +24,6 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigne
 extern int tracecmd_disable_sys_plugins;
 extern int tracecmd_disable_plugins;
 
-struct tep_handle *tracecmd_local_events(const char *tracing_dir);
-int tracecmd_fill_local_events(const char *tracing_dir,
-			       struct tep_handle *pevent, int *parsing_failures);
-
 int *tracecmd_add_id(int *list, int id, int len);
 
 enum {
diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index c66250c..998671b 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -49,4 +49,8 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 
 char **tracefs_local_plugins(const char *tracing_dir);
 
+struct tep_handle *tracefs_local_events(const char *tracing_dir);
+int tracefs_fill_local_events(const char *tracing_dir,
+			       struct tep_handle *tep, int *parsing_failures);
+
 #endif /* _TRACE_FS_H */
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 49c8755..409eb0e 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -26,7 +26,7 @@ extern "C" {
 
 static inline tep_handle *local_events()
 {
-	return tracecmd_local_events(tracefs_get_tracing_dir());
+	return tracefs_local_events(tracefs_get_tracing_dir());
 }
 
 /**
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 1554e88..795e83d 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -142,17 +142,6 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent,
 	}
 }
 
-/* FIXME: append_file() is duplicated and could be consolidated */
-static char *append_file(const char *dir, const char *name)
-{
-	char *file;
-	int ret;
-
-	ret = asprintf(&file, "%s/%s", dir, name);
-
-	return ret < 0 ? NULL : file;
-}
-
 /**
  * tracecmd_add_id - add an int to the event id list
  * @list: list to add the id to
@@ -183,223 +172,6 @@ int *tracecmd_add_id(int *list, int id, int len)
 	return list;
 }
 
-static int read_file(const char *file, char **buffer)
-{
-	char *buf;
-	int len = 0;
-	int fd;
-	int r;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		return -1;
-
-	buf = malloc(BUFSIZ + 1);
-	if (!buf) {
-		len = -1;
-		goto out;
-	}
-
-	while ((r = read(fd, buf + len, BUFSIZ)) > 0) {
-		len += r;
-		buf = realloc(buf, len + BUFSIZ + 1);
-		if (!buf) {
-			len = -1;
-			goto out;
-		}
-	}
-
-	*buffer = buf;
-	buf[len] = 0;
- out:
-	close(fd);
-
-	return len;
-}
-
-static int load_events(struct tep_handle *pevent, const char *system,
-			const char *sys_dir)
-{
-	struct dirent *dent;
-	struct stat st;
-	DIR *dir;
-	int len = 0;
-	int ret = 0, failure = 0;
-
-	ret = stat(sys_dir, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode))
-		return EINVAL;
-
-	dir = opendir(sys_dir);
-	if (!dir)
-		return errno;
-
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-		char *event;
-		char *format;
-		char *buf;
-
-		if (strcmp(name, ".") == 0 ||
-		    strcmp(name, "..") == 0)
-			continue;
-
-		event = append_file(sys_dir, name);
-		ret = stat(event, &st);
-		if (ret < 0 || !S_ISDIR(st.st_mode))
-			goto free_event;
-
-		format = append_file(event, "format");
-		ret = stat(format, &st);
-		if (ret < 0)
-			goto free_format;
-
-		len = read_file(format, &buf);
-		if (len < 0)
-			goto free_format;
-
-		ret = tep_parse_event(pevent, buf, len, system);
-		free(buf);
- free_format:
-		free(format);
- free_event:
-		free(event);
-		if (ret)
-			failure = ret;
-	}
-
-	closedir(dir);
-	return failure;
-}
-
-static int read_header(struct tep_handle *pevent, const char *events_dir)
-{
-	struct stat st;
-	char *header;
-	char *buf;
-	int len;
-	int ret = -1;
-
-	header = append_file(events_dir, "header_page");
-
-	ret = stat(header, &st);
-	if (ret < 0)
-		goto out;
-
-	len = read_file(header, &buf);
-	if (len < 0)
-		goto out;
-
-	tep_parse_header_page(pevent, buf, len, sizeof(long));
-
-	free(buf);
-
-	ret = 0;
- out:
-	free(header);
-	return ret;
-}
-
-/**
- * tracecmd_local_events - create a pevent from the events on system
- * @tracing_dir: The directory that contains the events.
- *
- * Returns a pevent structure that contains the pevents local to
- * the system.
- */
-struct tep_handle *tracecmd_local_events(const char *tracing_dir)
-{
-	struct tep_handle *pevent = NULL;
-
-	pevent = tep_alloc();
-	if (!pevent)
-		return NULL;
-
-	if (tracecmd_fill_local_events(tracing_dir, pevent, NULL)) {
-		tep_free(pevent);
-		pevent = NULL;
-	}
-
-	return pevent;
-}
-
-/**
- * tracecmd_fill_local_events - Fill a pevent with the events on system
- * @tracing_dir: The directory that contains the events.
- * @pevent: Allocated pevent which will be filled
- * @parsing_failures: return number of failures while parsing the event files
- *
- * Returns whether the operation succeeded
- */
-int tracecmd_fill_local_events(const char *tracing_dir,
-			       struct tep_handle *pevent, int *parsing_failures)
-{
-	struct dirent *dent;
-	char *events_dir;
-	struct stat st;
-	DIR *dir;
-	int ret;
-
-	if (!tracing_dir)
-		return -1;
-	if (parsing_failures)
-		*parsing_failures = 0;
-
-	events_dir = append_file(tracing_dir, "events");
-	if (!events_dir)
-		return -1;
-
-	ret = stat(events_dir, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode)) {
-		ret = -1;
-		goto out_free;
-	}
-
-	dir = opendir(events_dir);
-	if (!dir) {
-		ret = -1;
-		goto out_free;
-	}
-
-	ret = read_header(pevent, events_dir);
-	if (ret < 0) {
-		ret = -1;
-		goto out_free;
-	}
-
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-		char *sys;
-
-		if (strcmp(name, ".") == 0 ||
-		    strcmp(name, "..") == 0)
-			continue;
-
-		sys = append_file(events_dir, name);
-		ret = stat(sys, &st);
-		if (ret < 0 || !S_ISDIR(st.st_mode)) {
-			free(sys);
-			continue;
-		}
-
-		ret = load_events(pevent, name, sys);
-
-		free(sys);
-
-		if (ret && parsing_failures)
-			(*parsing_failures)++;
-	}
-
-	closedir(dir);
-	/* always succeed because parsing failures are not critical */
-	ret = 0;
-
- out_free:
-	free(events_dir);
-
-	return ret;
-}
-
 struct add_plugin_data {
 	int ret;
 	int index;
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index 5d40f06..805db86 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -474,3 +474,188 @@ char **tracefs_local_plugins(const char *tracing_dir)
 
 	return plugins;
 }
+
+static int load_events(struct tep_handle *tep,
+		       const char *tracing_dir, const char *system)
+{
+	int ret = 0, failure = 0;
+	char **events = NULL;
+	struct stat st;
+	int len = 0;
+	int i;
+
+	events = tracefs_system_events(tracing_dir, system);
+	if (!events)
+		return -ENOENT;
+
+	for (i = 0; events[i]; i++) {
+		char *format;
+		char *buf;
+
+		ret = asprintf(&format, "%s/events/%s/%s/format",
+			       tracing_dir, system, events[i]);
+		if (ret < 0) {
+			failure = -ENOMEM;
+			break;
+		}
+
+		ret = stat(format, &st);
+		if (ret < 0)
+			goto next_event;
+
+		len = str_read_file(format, &buf);
+		if (len < 0)
+			goto next_event;
+
+		ret = tep_parse_event(tep, buf, len, system);
+		free(buf);
+next_event:
+		free(format);
+		if (ret)
+			failure = ret;
+	}
+
+	if (events) {
+		for (i = 0; events[i]; i++)
+			free(events[i]);
+		free(events);
+	}
+	return failure;
+}
+
+static int read_header(struct tep_handle *tep, const char *tracing_dir)
+{
+	struct stat st;
+	char *header;
+	char *buf;
+	int len;
+	int ret = -1;
+
+	header = append_file(tracing_dir, "events/header_page");
+
+	ret = stat(header, &st);
+	if (ret < 0)
+		goto out;
+
+	len = str_read_file(header, &buf);
+	if (len < 0)
+		goto out;
+
+	tep_parse_header_page(tep, buf, len, sizeof(long));
+
+	free(buf);
+
+	ret = 0;
+ out:
+	free(header);
+	return ret;
+}
+
+static bool contains(const char *name, const char * const *names)
+{
+	if (!names)
+		return false;
+	for (; *names; names++)
+		if (strcmp(name, *names) == 0)
+			return true;
+	return false;
+}
+
+static int tracecmd_fill_local_events_system(const char *tracing_dir,
+					     struct tep_handle *tep,
+					     const char * const *sys_names,
+					     int *parsing_failures)
+{
+	char **systems = NULL;
+	int ret;
+	int i;
+
+	if (!tracing_dir)
+		tracing_dir = tracefs_get_tracing_dir();
+	if (!tracing_dir)
+		return -1;
+
+	systems = tracefs_event_systems(tracing_dir);
+	if (!systems)
+		return -1;
+
+	ret = read_header(tep, tracing_dir);
+	if (ret < 0) {
+		ret = -1;
+		goto out;
+	}
+
+	if (parsing_failures)
+		*parsing_failures = 0;
+
+	for (i = 0; systems[i]; i++) {
+		if (sys_names && !contains(systems[i], sys_names))
+			continue;
+		ret = load_events(tep, tracing_dir, systems[i]);
+		if (ret && parsing_failures)
+			(*parsing_failures)++;
+	}
+	/* always succeed because parsing failures are not critical */
+	ret = 0;
+out:
+	if (systems) {
+		for (i = 0; systems[i]; i++)
+			free(systems[i]);
+		free(systems);
+	}
+	return ret;
+}
+
+/**
+ * tracecmd_local_events_system - create a tep from the events of the specified subsystem.
+ *
+ * @tracing_dir: The directory that contains the events.
+ * @sys_name: Array of system names, to load the events from.
+ * The last element from the array must be NULL
+ *
+ * Returns a tep structure that contains the tep local to
+ * the system.
+ */
+struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
+						const char * const *sys_names)
+{
+	struct tep_handle *tep = NULL;
+
+	tep = tep_alloc();
+	if (!tep)
+		return NULL;
+
+	if (tracecmd_fill_local_events_system(tracing_dir, tep, sys_names, NULL)) {
+		tep_free(tep);
+		tep = NULL;
+	}
+
+	return tep;
+}
+
+/**
+ * tracefs_local_events - create a tep from the events on system
+ * @tracing_dir: The directory that contains the events.
+ *
+ * Returns a tep structure that contains the teps local to
+ * the system.
+ */
+struct tep_handle *tracefs_local_events(const char *tracing_dir)
+{
+	return tracecmd_local_events_system(tracing_dir, NULL);
+}
+
+/**
+ * tracefs_fill_local_events - Fill a tep with the events on system
+ * @tracing_dir: The directory that contains the events.
+ * @tep: Allocated tep handler which will be filled
+ * @parsing_failures: return number of failures while parsing the event files
+ *
+ * Returns whether the operation succeeded
+ */
+int tracefs_fill_local_events(const char *tracing_dir,
+			       struct tep_handle *tep, int *parsing_failures)
+{
+	return tracecmd_fill_local_events_system(tracing_dir, tep,
+						 NULL, parsing_failures);
+}
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index a8ee60a..d37af67 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -50,7 +50,7 @@ void trace_check_events(int argc, char **argv)
 		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
 
 	list = tep_load_plugins(pevent);
-	ret = tracecmd_fill_local_events(tracing, pevent, &parsing_failures);
+	ret = tracefs_fill_local_events(tracing, pevent, &parsing_failures);
 	if (ret || parsing_failures)
 		ret = EINVAL;
 	tep_unload_plugins(list, pevent);
-- 
2.24.1

