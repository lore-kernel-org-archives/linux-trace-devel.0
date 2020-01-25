Return-Path: <SRS0=v841=3O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCCEC32771
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jan 2020 02:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53F482073B
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jan 2020 02:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387699AbgAYCuf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Jan 2020 21:50:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387709AbgAYCue (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Jan 2020 21:50:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F8E2075D
        for <linux-trace-devel@vger.kernel.org>; Sat, 25 Jan 2020 02:50:33 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1ivBWq-000toy-GC
        for linux-trace-devel@vger.kernel.org; Fri, 24 Jan 2020 21:50:32 -0500
Message-Id: <20200125025032.384557311@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 24 Jan 2020 21:50:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd: Remove error processing from write_file() use error_log
 instead
References: <20200125025008.757057369@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When write_file() fails to write the contents given to it, it reads the file
it tried to write to and prints that. This doesn't work for all intsance
files, and newer kernels now have an "error_log" that is written to when
something fails.

Move the processing of reading the file out of write_file() and check if
error_log exists, and read from that when possible, and then default back to
the file if error_log does not exist.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 135 +++++++++++++++++++++++++++++++++-------
 1 file changed, 114 insertions(+), 21 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index efa7f8787bb7..bfe4f7976cc2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -790,28 +790,16 @@ static int set_ftrace(int set, int use_proc)
 	return 0;
 }
 
-static int write_file(const char *file, const char *str, const char *type)
+static int write_file(const char *file, const char *str)
 {
-	char buf[BUFSIZ];
-	int fd;
 	int ret;
+	int fd;
 
 	fd = open(file, O_WRONLY | O_TRUNC);
 	if (fd < 0)
 		die("opening to '%s'", file);
 	ret = write(fd, str, strlen(str));
 	close(fd);
-	if (ret < 0 && type) {
-		/* write failed */
-		fd = open(file, O_RDONLY);
-		if (fd < 0)
-			die("writing to '%s'", file);
-		/* the filter has the error */
-		while ((ret = read(fd, buf, BUFSIZ)) > 0)
-			fprintf(stderr, "%.*s", ret, buf);
-		die("Failed %s of %s\n", type, file);
-		close(fd);
-	}
 	return ret;
 }
 
@@ -1949,9 +1937,112 @@ static int find_trigger(const char *file, char *buf, int size, int fields)
 	return len;
 }
 
+static char *read_file(const char *file)
+{
+	char stbuf[BUFSIZ];
+	char *buf = NULL;
+	int size = 0;
+	char *nbuf;
+	int fd;
+	int r;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return NULL;
+
+	do {
+		r = read(fd, stbuf, BUFSIZ);
+		if (r <= 0)
+			continue;
+		nbuf = realloc(buf, size+r+1);
+		if (!nbuf) {
+			free(buf);
+			buf = NULL;
+			break;
+		}
+		buf = nbuf;
+		memcpy(buf+size, stbuf, r);
+		size += r;
+	} while (r > 0);
+
+	close(fd);
+	if (r == 0 && size > 0)
+		buf[size] = '\0';
+
+	return buf;
+}
+
+static void read_error_log(const char *log)
+{
+	char *buf, *line;
+	char *start = NULL;
+	char *p;
+
+	buf = read_file(log);
+	if (!buf)
+		return;
+
+	line = buf;
+
+	/* Only the last lines have meaning */
+	while ((p = strstr(line, "\n")) && p[1]) {
+		if (line[0] != ' ')
+			start = line;
+		line = p + 1;
+	}
+
+	if (start)
+		printf("%s", start);
+
+	free(buf);
+}
+
+static void show_error(const char *file, const char *type)
+{
+	struct stat st;
+	char *path = strdup(file);
+	char *p;
+	int ret;
+
+	if (!path)
+		die("Could not allocate memory");
+
+	p = strstr(path, "tracing");
+	if (p) {
+		if (strncmp(p + sizeof("tracing"), "instances", sizeof("instances") - 1) == 0) {
+			p = strstr(p + sizeof("tracing") + sizeof("instances"), "/");
+			if (!p)
+				goto read_file;
+		} else {
+			p += sizeof("tracing") - 1;
+		}
+		ret = asprintf(&p, "%.*s/error_log", (int)(p - path), path);
+		if (ret < 0)
+			die("Could not allocate memory");
+		ret = stat(p, &st);
+		if (ret < 0) {
+			free(p);
+			goto read_file;
+		}
+		read_error_log(p);
+		goto out;
+	}
+
+ read_file:
+	p = read_file(path);
+	if (p)
+		printf("%s", p);
+
+ out:
+	printf("Failed %s of %s\n", type, file);
+	free(path);
+	return;
+}
+
 static void write_filter(const char *file, const char *filter)
 {
-	write_file(file, filter, "filter");
+	if (write_file(file, filter) < 0)
+		show_error(file, "filter");
 }
 
 static void clear_filter(const char *file)
@@ -1961,12 +2052,14 @@ static void clear_filter(const char *file)
 
 static void write_trigger(const char *file, const char *trigger)
 {
-	write_file(file, trigger, "trigger");
+	if (write_file(file, trigger) < 0)
+		show_error(file, "trigger");
 }
 
 static void write_func_filter(const char *file, const char *trigger)
 {
-	write_file(file, trigger, "function filter");
+	if (write_file(file, trigger) < 0)
+		show_error(file, "function filter");
 }
 
 static void clear_trigger(const char *file)
@@ -2059,7 +2152,7 @@ static void update_reset_files(void)
 		reset_files = reset->next;
 
 		if (!keep)
-			write_file(reset->path, reset->reset, "reset");
+			write_file(reset->path, reset->reset);
 		free(reset->path);
 		free(reset->reset);
 		free(reset);
@@ -4193,7 +4286,7 @@ static unsigned long long find_time_stamp(struct tep_handle *tep)
 }
 
 
-static char *read_file(char *file, int *psize)
+static char *read_top_file(char *file, int *psize)
 {
 	return tracefs_instance_file_read(top_instance.tracefs, file, psize);
 }
@@ -4231,7 +4324,7 @@ static char *get_date_to_ts(void)
 
 	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
 
-	buf = read_file("events/header_page", &size);
+	buf = read_top_file("events/header_page", &size);
 	if (!buf)
 		goto out_pevent;
 	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
@@ -4596,7 +4689,7 @@ static void check_plugin(const char *plugin)
 	if (strcmp(plugin, "nop") == 0)
 		return;
 
-	buf = read_file("available_tracers", NULL);
+	buf = read_top_file("available_tracers", NULL);
 	if (!buf)
 		die("No plugins available");
 
-- 
2.24.1


