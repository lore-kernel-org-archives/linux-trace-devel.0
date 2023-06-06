Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F01C77B73
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Jun 2023 01:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbjFFBmU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 21:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjFFBmT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 21:42:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948EB110
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Jun 2023 18:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3154362C3D
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 01:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F993C433EF;
        Tue,  6 Jun 2023 01:42:16 +0000 (UTC)
Date:   Mon, 5 Jun 2023 21:42:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add tracefs_kprobe_destory() API
Message-ID: <20230605214214.2289969d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently the only way to remove kprobes from the system via tracefs that
was created by tracefs_kprobe_raw() or tracefs_ketprobe_all is with the
big hammer of tracefs_dynevent_destroy_all(), as removing a single kprobe
requires having the tracefs_dynevent descriptor for it (which the raw
functions do not return).

Add tracefs_kprobe_destroy() that will remove an individual kprobe or
kretprobe that was created by one of the raw functions.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-kprobes.txt | 14 +++++++++++--
 include/tracefs.h                    |  2 ++
 samples/Makefile                     |  2 ++
 src/tracefs-kprobes.c                | 30 ++++++++++++++++++++++++++++
 utest/tracefs-utest.c                | 18 ++++++++++++++++-
 5 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index 593ef9ee11fb..f03b096778a5 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -3,8 +3,9 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_kprobe_alloc, tracefs_kretprobe_alloc, tracefs_kprobe_raw, tracefs_kretprobe_raw -
-Allocate, get, and create kprobes
+tracefs_kprobe_alloc, tracefs_kretprobe_alloc, tracefs_kprobe_raw, tracefs_kretprobe_raw,
+tracefs_kprobe_destroy -
+Allocate, get, create, and remove kprobes
 
 SYNOPSIS
 --------
@@ -22,6 +23,8 @@ int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_
 			 const char pass:[*]_addr_, const char pass:[*]_format_);
 int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
 			    const char pass:[*]_addr_, const char pass:[*]_format_);
+int *tracefs_kprobe_destroy*(const char pass:[*]_system_, const char pass:[*]_event_,
+			   const char pass:[*]_addr_, const char pass:[*]_format_, bool _force_);
 --
 
 DESCRIPTION
@@ -49,6 +52,9 @@ document.
 creates a kretprobe instead of a kprobe. The difference is also described
 in the Linux kernel source in the Documentation/trace/kprobetrace.rst file.
 
+*tracefs_kprobe_destroy*() will destroy a specific kprobe or kretprobe created by
+*tracefs_kprobe_raw*() or *tracefs_kretprobe_raw*() with the same parameters.
+
 RETURN VALUE
 ------------
 
@@ -61,6 +67,10 @@ tracefs_dynevent structure, describing the probe. This pointer must be freed by
 *tracefs_dynevent_free*(3). Note, this only allocates a descriptor representing the kprobe. It does
 not modify the running system.
 
+The *tracefs_kprobe_destroy*() returns 0 on success or -1 on error if it was not able to
+successful destory (or find) the kprobe or kretprobe.
+
+
 ERRORS
 ------
 The following errors are for all the above calls:
diff --git a/include/tracefs.h b/include/tracefs.h
index 7c442e47204d..269b119ffc2a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -325,6 +325,8 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
+int tracefs_kprobe_destroy(const char *system, const char *event,
+			   const char *addr, const char *format, bool force);
 
 enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_NORMAL = 0,
diff --git a/samples/Makefile b/samples/Makefile
index fa88ffc75b1d..d782e8f79424 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -63,6 +63,8 @@ $(EXAMPLES): $(patsubst %,$(sdir)/%,$(TARGETS))
 #
 # $(bdir)/XX.o: $(bdir)/XX.c
 #	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+$(bdir)/kprobes.o: $(bdir)/kprobes.c
+	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 $(bdir)/%.o: $(bdir)/%.c
 	$(call do_sample_obj,$@,$^)
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index a8c016376118..5c50b21753e6 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -196,3 +196,33 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 {
 	return kprobe_raw(TRACEFS_DYNEVENT_KRETPROBE, system, event, addr, format);
 }
+
+/**
+ * tracefs_kprobe_destroy - Remove an individual kprobe or kretprobe
+ * @system: The system of the kprobe to remove (could be NULL)
+ * @event: The event of the kprobe or kretprobe to remove
+ * @addr: The address used to create the kprobe
+ * @format: The format used to create the kprobe
+ * @force: If true, try to disable the kprobe/kretprobe first
+ *
+ * This removes the kprobe or kretprobe that was created by
+ * tracefs_kprobe_raw() or tracefs_kretprobe_raw().
+ *
+ * Returns 0 on success and -1 otherwise.
+ */
+int tracefs_kprobe_destroy(const char *system, const char *event,
+			   const char *addr, const char *format, bool force)
+{
+	struct tracefs_dynevent *kp;
+	int ret;
+
+	kp = tracefs_kprobe_alloc(system, event, addr, format);
+	if (!kp)
+		return -1;
+
+	ret = tracefs_dynevent_destroy(kp, force);
+
+	tracefs_dynevent_free(kp);
+
+	return ret;
+}
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index cd2304474089..398c94368e66 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1368,7 +1368,23 @@ static void test_kprobes_instance(struct tracefs_instance *instance)
 	tracefs_dynevent_list_free(devents);
 	devents = NULL;
 
-	destroy_dynevents(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE);
+	/* Try destroying all the events using tracefs_kprobe_destroy */
+	for (i = 0; i < kprobe_count; i++) {
+		ret = tracefs_kprobe_destroy(ktests[i].system, ktests[i].event,
+					     ktests[i].address, ktests[i].format, true);
+		CU_TEST(ret == 0);
+		get_dynevents_check(TRACEFS_DYNEVENT_KPROBE, kprobe_count - (i + 1));
+	}
+	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE, 0);
+
+	for (i = 0; i < kretprobe_count; i++) {
+		ret = tracefs_kprobe_destroy(kretests[i].system, kretests[i].event,
+					     kretests[i].address, kretests[i].format, true);
+		CU_TEST(ret == 0);
+		get_dynevents_check(TRACEFS_DYNEVENT_KRETPROBE, kretprobe_count - (i + 1));
+	}
+	get_dynevents_check(TRACEFS_DYNEVENT_KRETPROBE, 0);
+
 	free(dkretprobe);
 	free(dkprobe);
 	tep_free(tep);
-- 
2.39.2

