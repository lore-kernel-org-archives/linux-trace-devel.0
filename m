Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC97C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Apr 2022 15:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiD1PJz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 11:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiD1PJx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 11:09:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A078126AD3
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 08:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4406161E56
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 15:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F8FC385AE;
        Thu, 28 Apr 2022 15:06:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nk5j2-003JH6-8i;
        Thu, 28 Apr 2022 11:06:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] trace-cmd: Move add_guest_info() into trace-vm.c
Date:   Thu, 28 Apr 2022 11:06:32 -0400
Message-Id: <20220428150635.789051-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428150635.789051-1-rostedt@goodmis.org>
References: <20220428150635.789051-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In preparation for the agent proxy, move add_guest_info() into trace-vm.c
and rename it to trace_add_guest_info(). This will be used by the agent
when acting as a proxy.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-record.c        | 54 +---------------------------------
 tracecmd/trace-vm.c            | 52 ++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 53 deletions(-)

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
index 27c4e7ba6f3f..d4b5d4d6490f 100644
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
index 57dbef8d42e4..281843b223f6 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -386,3 +386,55 @@ int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
 	}
 	return -1;
 }
+
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

