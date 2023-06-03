Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9A1C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Sat,  3 Jun 2023 09:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjFCJpM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 05:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjFCJpL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 05:45:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFD1E49
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 02:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B3A360ED3
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 09:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E30AC433EF;
        Sat,  3 Jun 2023 09:45:05 +0000 (UTC)
Date:   Sat, 3 Jun 2023 05:44:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH v3] trace-cmd: Check all strdup() return values
Message-ID: <20230603054450.1e83841a@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Used the coccinelle script:

 -------8<------
// find calls to strdup
@call@
expression ptr;
position p;
@@

ptr@p = strdup(...);

// find ok calls to strdup
@ok@
expression ptr;
position call.p;
@@

ptr@p = strdup(...);
... when != ptr
(
 (ptr == NULL || ...)
|
 (ptr != NULL || ...)
|
 (!ptr || ...)
)

// fix bad calls to malloc
@depends on !ok@
expression ptr;
position call.p;
@@

ptr@p = strdup(...);
+ if (ptr == NULL) FIXME;
 ------->8------

With the command: spatch /tmp/strdup.cocci . | patch -p1

to find all the locations that did not check the return value of strdup().
As the coccinelle script adds a FIXME to the text. Then I went through and
updated each location to handle the action appropriately.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes Since v3: http://lore.kernel.org/linux-trace-devel/20230602230109.2b8b9265@rorschach.local.home

 - Fixed typos in error message (

 lib/trace-cmd/trace-input.c        | 12 ++++++++++--
 lib/trace-cmd/trace-msg.c          |  6 ++++++
 lib/trace-cmd/trace-output.c       |  4 ++++
 lib/trace-cmd/trace-timesync-kvm.c |  6 ++++++
 lib/trace-cmd/trace-timesync.c     | 14 ++++++++++++--
 lib/trace-cmd/trace-util.c         |  2 ++
 tracecmd/trace-record.c            | 13 ++++++++++++-
 tracecmd/trace-split.c             |  7 ++++++-
 8 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3dd13ce4..8d176e94 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3665,8 +3665,11 @@ static int handle_buffer_option(struct tracecmd_input *handle,
 	if (!buff->clock)
 		return -1;
 
-	if (*name == '\0' && !handle->trace_clock)
+	if (*name == '\0' && !handle->trace_clock) {
 		handle->trace_clock = strdup(buff->clock);
+		if (!handle->trace_clock)
+			return -1;
+	}
 
 	if (id == TRACECMD_OPTION_BUFFER) {
 		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
@@ -3855,9 +3858,13 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_UNAME:
 			handle->uname = strdup(buf);
+			if (handle->uname == NULL)
+				return -1;
 			break;
 		case TRACECMD_OPTION_VERSION:
 			handle->version = strdup(buf);
+			if (handle->version == NULL)
+				return -1;
 			break;
 		case TRACECMD_OPTION_HOOK:
 			hook = tracecmd_create_event_hook(buf);
@@ -5967,9 +5974,10 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->parent = handle;
 	new_handle->cpustats = NULL;
 	new_handle->hooks = NULL;
-	if (handle->uname)
+	if (handle->uname) {
 		/* Ignore if fails to malloc, no biggy */
 		new_handle->uname = strdup(handle->uname);
+	}
 	tracecmd_ref(handle);
 
 	new_handle->fd = dup(handle->fd);
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 3a555c36..97d6b900 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -1229,6 +1229,8 @@ static int get_trace_req_protos(char *buf, int length,
 	while (i > 0 && j < (count - 1)) {
 		i -= strlen(p) + 1;
 		plist->names[j++] = strdup(p);
+		if (plist->names[j++] == NULL)
+			goto error;
 		p += strlen(p) + 1;
 	}
 
@@ -1593,6 +1595,10 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	*page_size = ntohl(msg.trace_resp.page_size);
 	*trace_id = ntohll(msg.trace_resp.trace_id);
 	*tsync_proto = strdup(msg.trace_resp.tsync_proto_name);
+	if (*tsync_proto == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	*tsync_port = ntohl(msg.trace_resp.tsync_port);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
 	if (!*ports) {
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index eee847e3..7876ed26 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -230,6 +230,7 @@ void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock)
 	if (handle && clock) {
 		free(handle->trace_clock);
 		handle->trace_clock = strdup(clock);
+		/* TODO: report error if failed to allocate */
 	}
 }
 
@@ -882,6 +883,9 @@ static void glob_events(struct tracecmd_output *handle,
 	for (i = 0; i < globbuf.gl_pathc; i++) {
 		file = globbuf.gl_pathv[i];
 		system = strdup(file + events_len + 1);
+		if (system == NULL)
+			/* ?? should we warn? */
+			continue;
 		system = strtok_r(system, "/", &ptr);
 		if (!ptr) {
 			/* ?? should we warn? */
diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index bbef8b60..92f15744 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -231,16 +231,22 @@ static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int i, char *dir_str)
 				snprintf(path, sizeof(path), "%s/%s",
 					 dir_str, entry->d_name);
 				kvm->clock_files[i].offsets = strdup(path);
+				if (kvm->clock_files[i].offsets == NULL)
+					goto error;
 			}
 			if (!strcmp(entry->d_name, KVM_DEBUG_SCALING_FILE)) {
 				snprintf(path, sizeof(path), "%s/%s",
 					 dir_str, entry->d_name);
 				kvm->clock_files[i].scalings = strdup(path);
+				if (kvm->clock_files[i].scalings == NULL)
+					goto error;
 			}
 			if (!strcmp(entry->d_name, KVM_DEBUG_FRACTION_FILE)) {
 				snprintf(path, sizeof(path), "%s/%s",
 					 dir_str, entry->d_name);
 				kvm->clock_files[i].frac = strdup(path);
+				if (kvm->clock_files[i].frac == NULL)
+					goto error;
 			}
 		}
 	}
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 75c27bab..de60fca1 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -764,6 +764,8 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 	tsync->trace_id = trace_id;
 	tsync->loop_interval = loop_interval;
 	tsync->proto_name = strdup(proto_name);
+	if (tsync->proto_name == NULL)
+		goto error;
 
 	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
 	if (!tsync->msg_handle) {
@@ -773,8 +775,11 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 	tsync->guest_pid = guest_pid;
 	tsync->vcpu_count = guest_cpus;
 
-	if (clock)
+	if (clock) {
 		tsync->clock_str = strdup(clock);
+		if (tsync->clock_str == NULL)
+			goto error;
+	}
 	pthread_mutex_init(&tsync->lock, NULL);
 	pthread_cond_init(&tsync->cond, NULL);
 	pthread_barrier_init(&tsync->first_sync, NULL, 2);
@@ -964,9 +969,14 @@ tracecmd_tsync_with_host(int fd, const char *proto, const char *clock,
 		return NULL;
 
 	tsync->proto_name = strdup(proto);
+	if (tsync->proto_name == NULL)
+		goto error;
 	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
-	if (clock)
+	if (clock) {
 		tsync->clock_str = strdup(clock);
+		if (tsync->clock_str == NULL)
+			goto error;
+	}
 
 	tsync->remote_id = remote_id;
 	tsync->local_id = local_id;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index fc61f9d1..06179ba0 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -221,6 +221,8 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent,
 		addr = strtoull(addr_str, NULL, 16);
 		/* fmt still has a space, skip it */
 		printk = strdup(fmt+1);
+		if (printk == NULL)
+			return; /* TODO: return error */
 		line = strtok_r(NULL, "\n", &next);
 		tep_register_print_string(pevent, printk, addr);
 		free(printk);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bae61c14..665b1e4e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -255,6 +255,8 @@ static void add_reset_trigger(const char *file)
 	if (!reset)
 		die("Failed to allocate reset");
 	reset->path = strdup(file);
+	if (reset->path == NULL)
+		die("Failed to allocate path");
 
 	reset->next = reset_triggers;
 	reset_triggers = reset;
@@ -371,8 +373,11 @@ struct buffer_instance *allocate_instance(const char *name)
 	instance = calloc(1, sizeof(*instance));
 	if (!instance)
 		return NULL;
-	if (name)
+	if (name) {
 		instance->name = strdup(name);
+		if (instance->name == NULL)
+			goto error;
+	}
 	if (tracefs_instance_exists(name)) {
 		instance->tracefs = tracefs_instance_create(name);
 		if (!instance->tracefs)
@@ -2970,6 +2975,8 @@ create_event(struct buffer_instance *instance, char *path, struct event_list *ol
 	if (old_event->trigger) {
 		if (check_file_in_dir(path_dirname, "trigger")) {
 			event->trigger = strdup(old_event->trigger);
+			if (event->trigger == NULL)
+				die("Failed to allocate trigger");
 			ret = asprintf(&p, "%s/trigger", path_dirname);
 			if (ret < 0)
 				die("Failed to allocate trigger path for %s", path);
@@ -6651,6 +6658,8 @@ static void parse_record_options(int argc,
 		case OPT_tsoffset:
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--ts-offset");
 			ctx->date2ts = strdup(optarg);
+			if (ctx->date2ts == NULL)
+				die("Failed to allocate ts-offset");
 			if (ctx->data_flags & DATA_FL_DATE)
 				die("Can not use both --date and --ts-offset");
 			ctx->data_flags |= DATA_FL_OFFSET;
@@ -6712,6 +6721,8 @@ static void parse_record_options(int argc,
 			    !tracecmd_compress_is_supported(optarg, NULL))
 				die("Compression algorithm  %s is not supported", optarg);
 			ctx->compression = strdup(optarg);
+			if (ctx->compression == NULL)
+				die("Failed to allocate compression algorithm");
 			break;
 		case OPT_file_ver:
 			if (ctx->curr_cmd != CMD_record && ctx->curr_cmd != CMD_record_agent)
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 1daa847d..037cc419 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -367,6 +367,8 @@ static double parse_file(struct tracecmd_input *handle,
 	int fd;
 
 	output = strdup(output_file);
+	if (output == NULL)
+		die("Failed to allocate output_file");
 	dir = dirname(output);
 	base = basename(output);
 
@@ -542,8 +544,11 @@ void trace_split (int argc, char **argv)
 
 	page_size = tracecmd_page_size(handle);
 
-	if (!output)
+	if (!output) {
 		output = strdup(input_file);
+		if (output == NULL)
+			die("Failed to allocate output");
+	}
 
 	if (!repeat) {
 		output = realloc(output, strlen(output) + 3);
-- 
2.39.2

