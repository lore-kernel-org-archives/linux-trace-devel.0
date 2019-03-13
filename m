Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8030CC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 01:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F427217F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 01:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfCMB2g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 21:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfCMB2f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 21:28:35 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4B6C214AE;
        Wed, 13 Mar 2019 01:28:33 +0000 (UTC)
Date:   Tue, 12 Mar 2019 21:28:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 6/6] trace-cmd: Reafctored reset_max_latency() to
 utilize write_instance_file()
Message-ID: <20190312212722.7556b545@oasis.local.home>
In-Reply-To: <20190311083339.21581-7-tstoyanov@vmware.com>
References: <20190311083339.21581-1-tstoyanov@vmware.com>
 <20190311083339.21581-7-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/7O9c4/TBZl8Um55aCKr2cPN"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

--MP_/7O9c4/TBZl8Um55aCKr2cPN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 11 Mar 2019 10:33:39 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:


> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index bdf0c02..dfbb0cd 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -814,19 +814,49 @@ static void clear_trace(void)
>  	fclose(fp);
>  }
>  
> -static void reset_max_latency(void)
> +static int write_file(const char *file, const char *str, const char *type)
> +{
> +	char buf[BUFSIZ];
> +	int fd;
> +	int ret;
> +
> +	fd = open(file, O_WRONLY | O_TRUNC);
> +	if (fd < 0)
> +		die("opening to '%s'", file);
> +	ret = write(fd, str, strlen(str));
> +	close(fd);
> +	if (ret < 0 && type) {
> +		/* write failed */
> +		fd = open(file, O_RDONLY);
> +		if (fd < 0)
> +			die("writing to '%s'", file);
> +		/* the filter has the error */
> +		while ((ret = read(fd, buf, BUFSIZ)) > 0)
> +			fprintf(stderr, "%.*s", ret, buf);
> +		die("Failed %s of %s\n", type, file);
> +		close(fd);
> +	}
> +	return ret;
> +}
> +
> +static int
> +write_instance_file(struct buffer_instance *instance,
> +		    const char *file, const char *str, const char *type)
>  {
> -	FILE *fp;
>  	char *path;
> +	int ret;
>  
> -	/* reset the trace */
> -	path = tracecmd_get_tracing_file("tracing_max_latency");
> -	fp = fopen(path, "w");
> -	if (!fp)
> -		die("writing to '%s'", path);
> +	path = get_instance_file(instance, file);
> +	ret = write_file(path, str, type);
>  	tracecmd_put_tracing_file(path);
> -	fwrite("0", 1, 1, fp);
> -	fclose(fp);
> +
> +	return ret;

To make this easier to review and understand, I added a change before
patch 4 that moved write_instance_file() up further. This way, there's
a single patch that moves the code. Especially, since you moved it
twice. Sometimes its cleaner to do the move as a separate change.
Especially when you are modifying the change near the move.

I rebased the changes on top of the move, and the result is attached.

-- Steve

--MP_/7O9c4/TBZl8Um55aCKr2cPN
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-trace-cmd-Move-write_instance_file-up-in-file.patch

From cbd567febd2559b055576ec48312fa53f46f76f5 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Tue, 12 Mar 2019 21:13:19 -0400
Subject: [PATCH 1/4] trace-cmd: Move write_instance_file() up in file

To allow for reset_max_latency() and add_filter_pid() to utilize
write_instance_file(), move it up before those functions. It is in a better
location now as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 78 ++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 00dc5ad7..f1f5d29d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -776,6 +776,45 @@ get_instance_dir(struct buffer_instance *instance)
 	return path;
 }
 
+static int write_file(const char *file, const char *str, const char *type)
+{
+	char buf[BUFSIZ];
+	int fd;
+	int ret;
+
+	fd = open(file, O_WRONLY | O_TRUNC);
+	if (fd < 0)
+		die("opening to '%s'", file);
+	ret = write(fd, str, strlen(str));
+	close(fd);
+	if (ret < 0 && type) {
+		/* write failed */
+		fd = open(file, O_RDONLY);
+		if (fd < 0)
+			die("writing to '%s'", file);
+		/* the filter has the error */
+		while ((ret = read(fd, buf, BUFSIZ)) > 0)
+			fprintf(stderr, "%.*s", ret, buf);
+		die("Failed %s of %s\n", type, file);
+		close(fd);
+	}
+	return ret;
+}
+
+static int
+write_instance_file(struct buffer_instance *instance,
+		    const char *file, const char *str, const char *type)
+{
+	char *path;
+	int ret;
+
+	path = get_instance_file(instance, file);
+	ret = write_file(path, str, type);
+	tracecmd_put_tracing_file(path);
+
+	return ret;
+}
+
 static void __clear_trace(struct buffer_instance *instance)
 {
 	FILE *fp;
@@ -1596,45 +1635,6 @@ static void reset_events(void)
 		reset_events_instance(instance);
 }
 
-static int write_file(const char *file, const char *str, const char *type)
-{
-	char buf[BUFSIZ];
-	int fd;
-	int ret;
-
-	fd = open(file, O_WRONLY | O_TRUNC);
-	if (fd < 0)
-		die("opening to '%s'", file);
-	ret = write(fd, str, strlen(str));
-	close(fd);
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
-	return ret;
-}
-
-static int
-write_instance_file(struct buffer_instance *instance,
-		    const char *file, const char *str, const char *type)
-{
-	char *path;
-	int ret;
-
-	path = get_instance_file(instance, file);
-	ret = write_file(path, str, type);
-	tracecmd_put_tracing_file(path);
-
-	return ret;
-}
-
 enum {
 	STATE_NEWLINE,
 	STATE_SKIP,
-- 
2.20.1


--MP_/7O9c4/TBZl8Um55aCKr2cPN
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0002-trace-cmd-Refactore-add_event_pid-to-utilize-write_i.patch

From cd5a23168280917774094eeb77b5a359e4f4a292 Mon Sep 17 00:00:00 2001
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Date: Mon, 11 Mar 2019 10:33:37 +0200
Subject: [PATCH 2/4] trace-cmd: Refactore add_event_pid()to utilize
 write_instance_file()

This patch changes add_event_pid() to utilize write_instance_file() for
writing set_event_pid instance file, instead of directly opening it.

Link: http://lore.kernel.org/linux-trace-devel/20190311083339.21581-5-tstoyanov@vmware.com

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f1f5d29d..801dad24 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1133,30 +1133,25 @@ static void update_sched_events(struct buffer_instance *instance, int pid)
 static int open_instance_fd(struct buffer_instance *instance,
 			    const char *file, int flags);
 
-static void add_event_pid(const char *buf, int len)
+static void add_event_pid(const char *buf)
 {
 	struct buffer_instance *instance;
-	int fd;
 
-	for_all_instances(instance) {
-		fd = open_instance_fd(instance, "set_event_pid", O_WRONLY);
-		write(fd, buf, len);
-		close(fd);
-	}
+	for_all_instances(instance)
+		write_instance_file(instance, "set_event_pid", buf, "event_pid");
 }
 
 static void add_new_filter_pid(int pid)
 {
 	struct buffer_instance *instance;
 	char buf[100];
-	int len;
 
 	add_filter_pid(pid, 0);
-	len = sprintf(buf, "%d", pid);
+	sprintf(buf, "%d", pid);
 	update_ftrace_pid(buf, 0);
 
 	if (have_set_event_pid)
-		return add_event_pid(buf, len);
+		return add_event_pid(buf);
 
 	common_pid_filter = append_pid_filter(common_pid_filter, "common_pid", pid);
 
-- 
2.20.1


--MP_/7O9c4/TBZl8Um55aCKr2cPN
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0004-trace-cmd-Refactore-reset_max_latency-to-utilize-wri.patch

From 7b4254303277ee6c5833f427fea7f00fa161bd74 Mon Sep 17 00:00:00 2001
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Date: Mon, 11 Mar 2019 10:33:39 +0200
Subject: [PATCH 4/4] trace-cmd: Refactore reset_max_latency() to utilize
 write_instance_file()

This patch changes reset_max_latency() to utilize write_instance_file() for
writing set_event_pid instance file, instead of directly opening it. It also
changes the function to work per instance.

Link: http://lore.kernel.org/linux-trace-devel/20190311083339.21581-7-tstoyanov@vmware.com

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fe22ad08..c16abe2f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -853,19 +853,10 @@ static void clear_trace(void)
 	fclose(fp);
 }
 
-static void reset_max_latency(void)
+static void reset_max_latency(struct buffer_instance *instance)
 {
-	FILE *fp;
-	char *path;
-
-	/* reset the trace */
-	path = tracecmd_get_tracing_file("tracing_max_latency");
-	fp = fopen(path, "w");
-	if (!fp)
-		die("writing to '%s'", path);
-	tracecmd_put_tracing_file(path);
-	fwrite("0", 1, 1, fp);
-	fclose(fp);
+	 write_instance_file(instance,
+			     "tracing_max_latency", "0", "max_latency");
 }
 
 static void add_filter_pid(int pid, int exclude)
@@ -1931,6 +1922,14 @@ static int read_tracing_on(struct buffer_instance *instance)
 	return ret;
 }
 
+static void reset_max_latency_instance(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		reset_max_latency(instance);
+}
+
 void tracecmd_enable_tracing(void)
 {
 	struct buffer_instance *instance;
@@ -1941,7 +1940,7 @@ void tracecmd_enable_tracing(void)
 		write_tracing_on(instance, 1);
 
 	if (latency)
-		reset_max_latency();
+		reset_max_latency_instance();
 }
 
 void tracecmd_disable_tracing(void)
@@ -3802,7 +3801,6 @@ static void reset_event_pid(void)
 	add_event_pid("");
 }
 
-
 static void clear_triggers(void)
 {
 	struct buffer_instance *instance;
@@ -4507,6 +4505,7 @@ void trace_reset(int argc, char **argv)
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
+	reset_max_latency_instance();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
-- 
2.20.1


--MP_/7O9c4/TBZl8Um55aCKr2cPN--
