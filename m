Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4817CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiENCz2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44EA34A03D
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0DC6B83259
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79053C36AE2;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XM2-9v;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 02/26] trace-cmd: Move add_guest_info() into trace-vm.c
Date:   Fri, 13 May 2022 22:47:32 -0400
Message-Id: <20220514024756.1319681-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In preparation for the agent proxy, move add_guest_info() into trace-vm.c
and rename it to trace_add_guest_info(). This will be used by the agent
when acting as a proxy.

Also comment the function to state what it does and what it records into
the trace.dat option.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-record.c        | 54 +-----------------------------
 tracecmd/trace-vm.c            | 61 ++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 53 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index e3fec1319880..f3b805fa7bad 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -339,6 +339,7 @@ bool trace_have_guests_pid(void);
 void read_qemu_guests(void);
 int get_guest_pid(unsigned int guest_cid);
 int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
+void trace_add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance);
 
 /* moved from trace-cmd.h */
 void tracecmd_remove_instances(void);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a22935263625..67ad1208f90c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4297,58 +4297,6 @@ static void append_buffer(struct tracecmd_output *handle,
 	}
 }
 
-static void
-add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
-{
-	struct trace_guest *guest;
-	const char *name;
-	char *buf, *p;
-	int size;
-	int pid;
-	int i;
-
-	if (is_network(instance)) {
-		name = instance->name;
-	} else {
-		guest = trace_get_guest(instance->cid, NULL);
-		if (!guest)
-			return;
-		name = guest->name;
-	}
-
-	size = strlen(name) + 1;
-	size += sizeof(long long);	/* trace_id */
-	size += sizeof(int);		/* cpu count */
-	size += instance->cpu_count * 2 * sizeof(int);	/* cpu,pid pair */
-
-	buf = calloc(1, size);
-	if (!buf)
-		return;
-	p = buf;
-	strcpy(p, name);
-	p += strlen(name) + 1;
-
-	memcpy(p, &instance->trace_id, sizeof(long long));
-	p += sizeof(long long);
-
-	memcpy(p, &instance->cpu_count, sizeof(int));
-	p += sizeof(int);
-	for (i = 0; i < instance->cpu_count; i++) {
-		pid = -1;
-		if (!is_network(instance)) {
-			if (i < guest->cpu_max)
-				pid = guest->cpu_pid[i];
-		}
-		memcpy(p, &i, sizeof(int));
-		p += sizeof(int);
-		memcpy(p, &pid, sizeof(int));
-		p += sizeof(int);
-	}
-
-	tracecmd_add_option(handle, TRACECMD_OPTION_GUEST, size, buf);
-	free(buf);
-}
-
 static void
 add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
 {
@@ -4679,7 +4627,7 @@ static void record_data(struct common_record_context *ctx)
 
 		for_all_instances(instance) {
 			if (is_guest(instance))
-				add_guest_info(handle, instance);
+				trace_add_guest_info(handle, instance);
 		}
 
 		if (ctx->tsc2nsec.mult) {
diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 57dbef8d42e4..47f8d96a4015 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -386,3 +386,64 @@ int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
 	}
 	return -1;
 }
+
+/**
+ * trace_add_guest_info - Add the guest info into the trace file option
+ * @handle: The file handle that the guest info option is added to
+ * @instance: The instance that that represents the guest
+ *
+ * Adds information about the guest from the @instance into an option
+ * for the @instance. It records the trace_id, the number of CPUs,
+ * as well as the PIDs of the host that represent the CPUs.
+ */
+void
+trace_add_guest_info(struct tracecmd_output *handle, struct buffer_instance *instance)
+{
+	struct trace_guest *guest;
+	const char *name;
+	char *buf, *p;
+	int size;
+	int pid;
+	int i;
+
+	if (is_network(instance)) {
+		name = instance->name;
+	} else {
+		guest = trace_get_guest(instance->cid, NULL);
+		if (!guest)
+			return;
+		name = guest->name;
+	}
+
+	size = strlen(name) + 1;
+	size += sizeof(long long);	/* trace_id */
+	size += sizeof(int);		/* cpu count */
+	size += instance->cpu_count * 2 * sizeof(int);	/* cpu,pid pair */
+
+	buf = calloc(1, size);
+	if (!buf)
+		return;
+	p = buf;
+	strcpy(p, name);
+	p += strlen(name) + 1;
+
+	memcpy(p, &instance->trace_id, sizeof(long long));
+	p += sizeof(long long);
+
+	memcpy(p, &instance->cpu_count, sizeof(int));
+	p += sizeof(int);
+	for (i = 0; i < instance->cpu_count; i++) {
+		pid = -1;
+		if (!is_network(instance)) {
+			if (i < guest->cpu_max)
+				pid = guest->cpu_pid[i];
+		}
+		memcpy(p, &i, sizeof(int));
+		p += sizeof(int);
+		memcpy(p, &pid, sizeof(int));
+		p += sizeof(int);
+	}
+
+	tracecmd_add_option(handle, TRACECMD_OPTION_GUEST, size, buf);
+	free(buf);
+}
-- 
2.35.1

