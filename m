Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA16C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 04:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKOEII (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 23:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKOEIG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 23:08:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A8810B65
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:07:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F430B8074D
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDCBC433B5;
        Tue, 15 Nov 2022 04:07:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ounFX-00AJ6i-2M;
        Mon, 14 Nov 2022 23:08:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 1/4] libtracefs: Use tracefs_cpu_read() for tracefs_iterate_raw_events()
Date:   Mon, 14 Nov 2022 23:08:35 -0500
Message-Id: <20221115040838.2456632-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115040838.2456632-1-rostedt@goodmis.org>
References: <20221115040838.2456632-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that there's an API for reading the raw events, use that for
tracefs_iterate_raw_events() instead of open coding the reading. It should
also make it more efficient as it can use pipes as well.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 106 +++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 54 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 57b22964f893..592b1a01fea4 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -21,14 +21,13 @@
 #include "tracefs-local.h"
 
 struct cpu_iterate {
+	struct tracefs_cpu *tcpu;
 	struct tep_record record;
 	struct tep_event *event;
 	struct kbuffer *kbuf;
 	void *page;
 	int psize;
-	int rsize;
 	int cpu;
-	int fd;
 };
 
 static int read_kbuf_record(struct cpu_iterate *cpu)
@@ -60,9 +59,21 @@ int read_next_page(struct tep_handle *tep, struct cpu_iterate *cpu)
 {
 	enum kbuffer_long_size long_size;
 	enum kbuffer_endian endian;
+	int r;
 
-	cpu->rsize = read(cpu->fd, cpu->page, cpu->psize);
-	if (cpu->rsize <= 0)
+	if (!cpu->tcpu)
+		return -1;
+
+	r = tracefs_cpu_buffered_read(cpu->tcpu, cpu->page, true);
+	/*
+	 * tracefs_cpu_buffered_read() only reads in full subbuffer size,
+	 * but this wants partial buffers as well. If the function returns
+	 * empty (-1 for EAGAIN), try tracefs_cpu_read() next, as that can
+	 * read partially filled buffers too, but isn't as efficient.
+	 */
+	if (r <= 0)
+		r = tracefs_cpu_read(cpu->tcpu, cpu->page, true);
+	if (r <= 0)
 		return -1;
 
 	if (!cpu->kbuf) {
@@ -82,8 +93,8 @@ int read_next_page(struct tep_handle *tep, struct cpu_iterate *cpu)
 	}
 
 	kbuffer_load_subbuffer(cpu->kbuf, cpu->page);
-	if (kbuffer_subbuffer_size(cpu->kbuf) > cpu->rsize) {
-		tracefs_warning("%s: page_size > %d", __func__, cpu->rsize);
+	if (kbuffer_subbuffer_size(cpu->kbuf) > r) {
+		tracefs_warning("%s: page_size > %d", __func__, r);
 		return -1;
 	}
 
@@ -147,64 +158,51 @@ static int read_cpu_pages(struct tep_handle *tep, struct cpu_iterate *cpus, int
 static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 			  int cpu_size, struct cpu_iterate **all_cpus, int *count)
 {
+	struct tracefs_cpu *tcpu;
 	struct cpu_iterate *tmp;
-	unsigned int p_size;
-	struct dirent *dent;
-	char file[PATH_MAX];
-	struct stat st;
-	int ret = -1;
-	int fd = -1;
-	char *path;
-	DIR *dir;
+	int nr_cpus;
 	int cpu;
 	int i = 0;
 
-	path = tracefs_instance_get_file(instance, "per_cpu");
-	if (!path)
-		return -1;
-	dir = opendir(path);
-	if (!dir)
-		goto out;
-	p_size = getpagesize();
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
+	*all_cpus = NULL;
 
-		if (strlen(name) < 4 || strncmp(name, "cpu", 3) != 0)
-			continue;
-		cpu = atoi(name + 3);
+	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
 			continue;
-		sprintf(file, "%s/%s", path, name);
-		if (stat(file, &st) < 0 || !S_ISDIR(st.st_mode))
-			continue;
-
-		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
-		fd = open(file, O_RDONLY | O_NONBLOCK);
-		if (fd < 0)
-			continue;
-		tmp = realloc(*all_cpus, (i + 1) * sizeof(struct cpu_iterate));
+		tcpu = tracefs_cpu_open(instance, cpu, true);
+		tmp = realloc(*all_cpus, (i + 1) * sizeof(*tmp));
 		if (!tmp) {
-			close(fd);
-			goto out;
+			i--;
+			goto error;
 		}
-		memset(tmp + i, 0, sizeof(struct cpu_iterate));
-		tmp[i].fd = fd;
-		tmp[i].cpu = cpu;
-		tmp[i].page =  malloc(p_size);
-		tmp[i].psize = p_size;
+
 		*all_cpus = tmp;
-		*count = i + 1;
-		if (!tmp[i++].page)
-			goto out;
-	}
 
-	ret = 0;
+		memset(tmp + i, 0, sizeof(*tmp));
 
-out:
-	if (dir)
-		closedir(dir);
-	tracefs_put_tracing_file(path);
-	return ret;
+		if (!tcpu)
+			goto error;
+
+		tmp[i].tcpu = tcpu;
+		tmp[i].cpu = cpu;
+		tmp[i].psize = tracefs_cpu_read_size(tcpu);
+		tmp[i].page =  malloc(tmp[i].psize);
+
+		if (!tmp[i++].page)
+			goto error;
+	}
+	*count = i;
+	return 0;
+ error:
+	tmp = *all_cpus;
+	for (; i >= 0; i--) {
+		tracefs_cpu_close(tmp[i].tcpu);
+		free(tmp[i].page);
+	}
+	free(tmp);
+	*all_cpus = NULL;
+	return -1;
 }
 
 static bool top_iterate_keep_going;
@@ -236,7 +234,7 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 {
 	bool *keep_going = instance ? &instance->pipe_keep_going :
 				      &top_iterate_keep_going;
-	struct cpu_iterate *all_cpus = NULL;
+	struct cpu_iterate *all_cpus;
 	int count = 0;
 	int ret;
 	int i;
@@ -257,7 +255,7 @@ out:
 	if (all_cpus) {
 		for (i = 0; i < count; i++) {
 			kbuffer_free(all_cpus[i].kbuf);
-			close(all_cpus[i].fd);
+			tracefs_cpu_close(all_cpus[i].tcpu);
 			free(all_cpus[i].page);
 		}
 		free(all_cpus);
-- 
2.35.1

