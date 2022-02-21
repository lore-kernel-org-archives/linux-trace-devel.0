Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0896AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 23:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbiBUXPh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 18:15:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiBUXPg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 18:15:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859F46566
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 15:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F5261275
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 23:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547FCC340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 23:15:11 +0000 (UTC)
Date:   Mon, 21 Feb 2022 18:15:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tracecmd: Set default log to INFO and remove unnecessary
 newlines
Message-ID: <20220221181509.7259bb7d@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Set the default logging of trace-cmd report to INFO. This will not affect
the tep functions, as tep will still use whatever its default is. But it
does allow for normal prints to be shown by default.

For example, the version of the file that is being read should be reported
by default as it use to be.

Also remove all the unnecessary newlines that are added to the
tracecmd_info/warning/critical() functions, as they supply the newlines.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-hooks.c  |  2 +-
 lib/trace-cmd/trace-input.c  | 12 ++++++------
 lib/trace-cmd/trace-msg.c    |  6 +++---
 lib/trace-cmd/trace-output.c |  6 +++---
 lib/trace-cmd/trace-plugin.c | 10 +++++-----
 lib/trace-cmd/trace-util.c   |  2 +-
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/lib/trace-cmd/trace-hooks.c b/lib/trace-cmd/trace-hooks.c
index e92ffc3a53c7..a58b5356df59 100644
--- a/lib/trace-cmd/trace-hooks.c
+++ b/lib/trace-cmd/trace-hooks.c
@@ -133,7 +133,7 @@ struct hook_list *tracecmd_create_event_hook(const char *arg)
 				hook->stack = 1;
 				break;
 			default:
-				tracecmd_warning("unknown flag %c\n", flags[i]);
+				tracecmd_warning("unknown flag %c", flags[i]);
 			}
 		}
 	}
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ae3a9bbd01e1..49c1fab898be 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1532,7 +1532,7 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	int index;
 
 	if (!page->ref_count) {
-		tracecmd_critical("Page ref count is zero!\n");
+		tracecmd_critical("Page ref count is zero!");
 		return;
 	}
 
@@ -4168,7 +4168,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	version = read_string(handle);
 	if (!version)
 		goto failed_read;
-	tracecmd_info("version = %s\n", version);
+	tracecmd_info("version = %s", version);
 	ver = strtol(version, NULL, 10);
 	if (!ver && errno)
 		goto failed_read;
@@ -4396,7 +4396,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 		return;
 
 	if (handle->ref <= 0) {
-		tracecmd_warning("tracecmd: bad ref count on handle\n");
+		tracecmd_warning("tracecmd: bad ref count on handle");
 		return;
 	}
 
@@ -5493,7 +5493,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 
 		ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
 		if (ret == (off64_t)-1) {
-			tracecmd_warning("could not seek to buffer %s offset %ld\n",
+			tracecmd_warning("could not seek to buffer %s offset %ld",
 					  buffer->name, buffer->offset);
 			goto error;
 		}
@@ -5507,12 +5507,12 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 			ret = read_cpu_data(new_handle);
 
 		if (ret < 0) {
-			tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
+			tracecmd_warning("failed to read sub buffer %s", buffer->name);
 			goto error;
 		}
 		ret = lseek64(handle->fd, offset, SEEK_SET);
 		if (ret < 0) {
-			tracecmd_warning("could not seek to back to offset %ld\n", offset);
+			tracecmd_warning("could not seek to back to offset %ld", offset);
 			goto error;
 		}
 	} else {
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 4910ed5c3a79..03b853e4368b 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -430,7 +430,7 @@ void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle)
 
 static void error_operation(struct tracecmd_msg *msg)
 {
-	tracecmd_warning("Message: cmd=%d size=%d\n", ntohl(msg->hdr.cmd), ntohl(msg->hdr.size));
+	tracecmd_warning("Message: cmd=%d size=%d", ntohl(msg->hdr.cmd), ntohl(msg->hdr.size));
 }
 
 /*
@@ -460,7 +460,7 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	ret = tracecmd_msg_recv_wait(fd, msg);
 	if (ret < 0) {
 		if (ret == -ETIMEDOUT)
-			tracecmd_warning("Connection timed out\n");
+			tracecmd_warning("Connection timed out");
 		return ret;
 	}
 
@@ -651,7 +651,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 	if (ret < 0) {
 		if (ret == -ETIMEDOUT)
-			tracecmd_warning("Connection timed out\n");
+			tracecmd_warning("Connection timed out");
 		return ret;
 	}
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index de9198a54cea..35c6314ac88f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2277,7 +2277,7 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
 
 	b_offset = get_buffer_file_offset(handle, name);
 	if (!b_offset) {
-		tracecmd_warning("Cannot find description for buffer %s\n", name);
+		tracecmd_warning("Cannot find description for buffer %s", name);
 		return -1;
 	}
 
@@ -2285,7 +2285,7 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
 
 	/* Go to the option data, where will write the offest */
 	if (do_lseek(handle, b_offset, SEEK_SET) == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", b_offset);
+		tracecmd_warning("could not seek to %lld", b_offset);
 		return -1;
 	}
 
@@ -2294,7 +2294,7 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
 
 	/* Go back to end of file */
 	if (do_lseek(handle, current, SEEK_SET) == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", offset);
+		tracecmd_warning("could not seek to %lld", offset);
 		return -1;
 	}
 	return 0;
diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
index 50c800c2f9ac..127771ea8091 100644
--- a/lib/trace-cmd/trace-plugin.c
+++ b/lib/trace-cmd/trace-plugin.c
@@ -108,13 +108,13 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 
 	ret = asprintf(&plugin, "%s/%s", path, file);
 	if (ret < 0) {
-		tracecmd_warning("could not allocate plugin memory\n");
+		tracecmd_warning("could not allocate plugin memory");
 		return;
 	}
 
 	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
 	if (!handle) {
-		tracecmd_warning("could not load plugin '%s'\n%s\n", plugin, dlerror());
+		tracecmd_warning("could not load plugin '%s'\n%s", plugin, dlerror());
 		goto out_free;
 	}
 
@@ -124,14 +124,14 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 
 	func = dlsym(handle, TRACECMD_PLUGIN_LOADER_NAME);
 	if (!func) {
-		tracecmd_warning("could not find func '%s' in plugin '%s'\n%s\n",
+		tracecmd_warning("could not find func '%s' in plugin '%s'\n%s",
 				 TRACECMD_PLUGIN_LOADER_NAME, plugin, dlerror());
 		goto out_free;
 	}
 
 	list = malloc(sizeof(*list));
 	if (!list) {
-		tracecmd_warning("could not allocate plugin memory\n");
+		tracecmd_warning("could not allocate plugin memory");
 		goto out_free;
 	}
 
@@ -256,7 +256,7 @@ load_plugins_hook(struct trace_plugin_context *trace, const char *suffix,
 
 	ret = asprintf(&path, "%s/%s", home, LOCAL_PLUGIN_DIR);
 	if (ret < 0) {
-		tracecmd_warning("could not allocate plugin memory\n");
+		tracecmd_warning("could not allocate plugin memory");
 		return;
 	}
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 2cf8974ef4ee..91e8a30fb90b 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -30,7 +30,7 @@
 #define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
 static bool debug;
-static int log_level = TEP_LOG_CRITICAL;
+static int log_level = TEP_LOG_INFO;
 static FILE *logfp;
 
 const static struct {
-- 
2.34.1

