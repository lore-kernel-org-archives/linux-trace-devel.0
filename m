Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11D6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D483F613BC
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhDFEUN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhDFEUM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 00:20:12 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BADCC06174A
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 21:20:05 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i18so9199426wrm.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 21:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iiC305vJEinBdTvxLqzXIsV0JmvXpG4EZ/R99DKfFpE=;
        b=ANkq0HdXIq8h+Tqn6TJepDi91bVvj+BrJUCaLLelAs+E95aJBhOb4S7MzFfuxAoINw
         4iNmtMKWynAyRr9aT94jmTnzQMjpXkhW5fup9rLwRnhP+HKCnmwI6XLl13T6TurCMDDF
         v4W7OS+EXdbbjpTFCJxRJw7GBT1oltH5z21my+nVb8M373Ck2UUBAP4CvusYDjuFUUq4
         tg2kvUk9DApBexoTj3BdNdDQyciw8Xe21qNfn68doQdHyC/uojf7/zJ9JBYAyHTI/8KY
         sJXZRojhyn6CRRy++DZXdMwHsfBblQsfSvR26Kne6ZnnzuaejWce4X+H8VCpytCmMZ0C
         6V8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iiC305vJEinBdTvxLqzXIsV0JmvXpG4EZ/R99DKfFpE=;
        b=HnDFglAGudH8B97UN/AzIiNo4HrSUS3+icMAm3POcFwWYifADpKTPv6P+xcE4X4nEt
         C8LqwCWMt+3r6M7URoO6QIoreivWQiFnSnJPn/VXzIPtR+pqO22hUwsNWU16CniMi8Qv
         iw/4RNp0xS6s2hPTqdQQoYuqbGezTEPR/y6O81f6aeCS9cxTrzv3BVqYAkMSmid1pXjE
         YsvpL2EWzC29Fg56eHmnAqnZbv8u8s1X9w+phxDxa4taouf9a5DH5Q8Sf5+cIkEfLW3U
         xRiZuirh9G05OJOy3kfbcFdcVTMxZzT9k2WYxVD9TwlYD8NupHbBYrAbOvbsLuFHNJSi
         sncA==
X-Gm-Message-State: AOAM531Yhtsmz8j4mauyrt6Ok8VmubDhIZptNz2RNZcyQT8LHPs/gDfv
        81f4dXupo2PVKPeE/w4Alno=
X-Google-Smtp-Source: ABdhPJwbD5cWddhTVUV/tZbDb0+YDfQEEQlpdt1NSEssBpNhkjy+QAYRLpiiXu7NXZJoMriWXY6pdg==
X-Received: by 2002:a5d:6b86:: with SMTP id n6mr31943969wrx.52.1617682804257;
        Mon, 05 Apr 2021 21:20:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j23sm1325337wmo.33.2021.04.05.21.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 21:20:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] libtracefs: Iterate over raw events in sorted order
Date:   Tue,  6 Apr 2021 07:19:58 +0300
Message-Id: <20210406042001.912544-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406042001.912544-1-tz.stoyanov@gmail.com>
References: <20210406042001.912544-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the logic of tracefs_iterate_raw_events(): instead of iterating
in CPU order, walk through the events from all CPU buffers and read the
oldest first.
Fixed the problem with cpu number in the record, passed to the callback
- set the real CPU number instead of 0.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-events.c | 246 +++++++++++++++++++++++++++----------------
 1 file changed, 156 insertions(+), 90 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 825f916..4095665 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -51,120 +51,130 @@ page_to_kbuf(struct tep_handle *tep, void *page, int size)
 	return kbuf;
 }
 
-static int read_kbuf_record(struct kbuffer *kbuf, struct tep_record *record)
+struct cpu_iterate {
+	struct tep_record record;
+	struct tep_event *event;
+	struct kbuffer *kbuf;
+	void *page;
+	int psize;
+	int rsize;
+	int cpu;
+	int fd;
+};
+
+static int read_kbuf_record(struct cpu_iterate *cpu)
 {
 	unsigned long long ts;
 	void *ptr;
 
-	ptr = kbuffer_read_event(kbuf, &ts);
-	if (!ptr || !record)
+	if (!cpu || !cpu->kbuf)
+		return -1;
+	ptr = kbuffer_read_event(cpu->kbuf, &ts);
+	if (!ptr)
 		return -1;
 
-	memset(record, 0, sizeof(*record));
-	record->ts = ts;
-	record->size = kbuffer_event_size(kbuf);
-	record->record_size = kbuffer_curr_size(kbuf);
-	record->cpu = 0;
-	record->data = ptr;
-	record->ref_count = 1;
+	memset(&(cpu->record), 0, sizeof(cpu->record));
+	cpu->record.ts = ts;
+	cpu->record.size = kbuffer_event_size(cpu->kbuf);
+	cpu->record.record_size = kbuffer_curr_size(cpu->kbuf);
+	cpu->record.cpu = cpu->cpu;
+	cpu->record.data = ptr;
+	cpu->record.ref_count = 1;
 
-	kbuffer_next_event(kbuf, NULL);
+	kbuffer_next_event(cpu->kbuf, NULL);
 
 	return 0;
 }
 
-static int
-get_events_in_page(struct tep_handle *tep, void *page,
-		   int size, int cpu,
-		   int (*callback)(struct tep_event *,
-				   struct tep_record *,
-				   int, void *),
-		   void *callback_context)
+int read_next_page(struct tep_handle *tep, struct cpu_iterate *cpu)
 {
-	struct tep_record record;
-	struct tep_event *event;
-	struct kbuffer *kbuf;
-	int id, cnt = 0;
+	cpu->rsize = read(cpu->fd, cpu->page, cpu->psize);
+	if (cpu->rsize <= 0)
+		return -1;
+
+	cpu->kbuf = page_to_kbuf(tep, cpu->page, cpu->rsize);
+	if (!cpu->kbuf)
+		return -1;
+
+	return 0;
+}
+
+int read_next_record(struct tep_handle *tep, struct cpu_iterate *cpu)
+{
+	int id;
+
+	do {
+		while (!read_kbuf_record(cpu)) {
+			id = tep_data_type(tep, &(cpu->record));
+			cpu->event = tep_find_event(tep, id);
+			if (cpu->event)
+				return 0;
+		}
+	} while (!read_next_page(tep, cpu));
+
+	return -1;
+}
+
+static int read_cpu_pages(struct tep_handle *tep, struct cpu_iterate *cpus, int count,
+			  int (*callback)(struct tep_event *,
+					  struct tep_record *,
+					  int, void *),
+			  void *callback_context)
+{
+	bool has_data = false;
 	int ret;
+	int i, j;
 
-	if (size <= 0)
-		return 0;
+	for (i = 0; i < count; i++) {
+		ret = read_next_record(tep, cpus + i);
+		if (!ret)
+			has_data = true;
+	}
 
-	kbuf = page_to_kbuf(tep, page, size);
-	if (!kbuf)
-		return 0;
-
-	ret = read_kbuf_record(kbuf, &record);
-	while (!ret) {
-		id = tep_data_type(tep, &record);
-		event = tep_find_event(tep, id);
-		if (event) {
-			cnt++;
+	while (has_data) {
+		j = count;
+		for (i = 0; i < count; i++) {
+			if (!cpus[i].event)
+				continue;
+			if (j == count || cpus[j].record.ts > cpus[i].record.ts)
+				j = i;
+		}
+		if (j < count) {
 			if (callback &&
-			    callback(event, &record, cpu, callback_context))
+			    callback(cpus[j].event, &(cpus[j].record), cpus[j].cpu, callback_context))
 				break;
+			cpus[j].event = NULL;
+			read_next_record(tep, cpus + j);
+		} else {
+			has_data = false;
 		}
-		ret = read_kbuf_record(kbuf, &record);
 	}
 
-	kbuffer_free(kbuf);
-
-	return cnt;
+	return 0;
 }
 
-/*
- * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
- *				per CPU trace buffers
- * @tep: a handle to the trace event parser context
- * @instance: ftrace instance, can be NULL for the top instance
- * @cpus: Iterate only through the buffers of CPUs, set in the mask.
- *	  If NULL, iterate through all CPUs.
- * @cpu_size: size of @cpus set
- * @callback: A user function, called for each record from the file
- * @callback_context: A custom context, passed to the user callback function
- *
- * If the @callback returns non-zero, the iteration stops - in that case all
- * records from the current page will be lost from future reads
- *
- * Returns -1 in case of an error, or 0 otherwise
- */
-int tracefs_iterate_raw_events(struct tep_handle *tep,
-				struct tracefs_instance *instance,
-				cpu_set_t *cpus, int cpu_size,
-				int (*callback)(struct tep_event *,
-						struct tep_record *,
-						int, void *),
-				void *callback_context)
+static int open_cpu_fies(struct tracefs_instance *instance, cpu_set_t *cpus,
+			 int cpu_size, struct cpu_iterate **all_cpus, int *count)
 {
+	struct cpu_iterate *tmp;
 	unsigned int p_size;
 	struct dirent *dent;
 	char file[PATH_MAX];
-	void *page = NULL;
 	struct stat st;
+	int ret = -1;
+	int fd = -1;
 	char *path;
 	DIR *dir;
-	int ret;
 	int cpu;
-	int fd;
-	int r;
+	int i = 0;
 
-	if (!tep || !callback)
-		return -1;
-
-	p_size = getpagesize();
 	path = tracefs_instance_get_file(instance, "per_cpu");
 	if (!path)
 		return -1;
 	dir = opendir(path);
-	if (!dir) {
-		ret = -1;
-		goto error;
-	}
-	page = malloc(p_size);
-	if (!page) {
-		ret = -1;
-		goto error;
-	}
+	if (!dir)
+		goto out;
+	p_size = getpagesize();
 	while ((dent = readdir(dir))) {
 		const char *name = dent->d_name;
 
@@ -174,32 +184,88 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
 			continue;
 		sprintf(file, "%s/%s", path, name);
-		ret = stat(file, &st);
-		if (ret < 0 || !S_ISDIR(st.st_mode))
+		if (stat(file, &st) < 0 || !S_ISDIR(st.st_mode))
 			continue;
 
 		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
 		fd = open(file, O_RDONLY | O_NONBLOCK);
 		if (fd < 0)
 			continue;
-		do {
-			r = read(fd, page, p_size);
-			if (r > 0)
-				get_events_in_page(tep, page, r, cpu,
-						   callback, callback_context);
-		} while (r > 0);
-		close(fd);
+		tmp = realloc(*all_cpus, (i + 1) * sizeof(struct cpu_iterate));
+		if (!tmp) {
+			close(fd);
+			goto out;
+		}
+		memset(tmp + i, 0, sizeof(struct cpu_iterate));
+		tmp[i].fd = fd;
+		tmp[i].cpu = cpu;
+		tmp[i].page =  malloc(p_size);
+		tmp[i].psize = p_size;
+		*all_cpus = tmp;
+		*count = i + 1;
+		if (!tmp[i++].page)
+			goto out;
 	}
+
 	ret = 0;
 
-error:
+out:
 	if (dir)
 		closedir(dir);
-	free(page);
 	tracefs_put_tracing_file(path);
 	return ret;
 }
 
+/*
+ * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
+ *				per CPU trace buffers
+ * @tep: a handle to the trace event parser context
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @cpus: Iterate only through the buffers of CPUs, set in the mask.
+ *	  If NULL, iterate through all CPUs.
+ * @cpu_size: size of @cpus set
+ * @callback: A user function, called for each record from the file
+ * @callback_context: A custom context, passed to the user callback function
+ *
+ * If the @callback returns non-zero, the iteration stops - in that case all
+ * records from the current page will be lost from future reads
+ * The events are iterated in sorted order, oldest first.
+ *
+ * Returns -1 in case of an error, or 0 otherwise
+ */
+int tracefs_iterate_raw_events(struct tep_handle *tep,
+				struct tracefs_instance *instance,
+				cpu_set_t *cpus, int cpu_size,
+				int (*callback)(struct tep_event *,
+						struct tep_record *,
+						int, void *),
+				void *callback_context)
+{
+	struct cpu_iterate *all_cpus = NULL;
+	int count = 0;
+	int ret;
+	int i;
+
+	if (!tep || !callback)
+		return -1;
+
+	ret = open_cpu_fies(instance, cpus, cpu_size, &all_cpus, &count);
+	if (ret < 0)
+		goto out;
+	ret = read_cpu_pages(tep, all_cpus, count, callback, callback_context);
+
+out:
+	if (all_cpus) {
+		for (i = 0; i < count; i++) {
+			close(all_cpus[i].fd);
+			free(all_cpus[i].page);
+		}
+		free(all_cpus);
+	}
+
+	return ret;
+}
+
 static char **add_list_string(char **list, const char *name, int len)
 {
 	if (!list)
-- 
2.30.2

