Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFEAC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 20:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CAC61352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 20:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbhDLU27 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 16:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238681AbhDLU26 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 16:28:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B6B611C9
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Apr 2021 20:28:40 +0000 (UTC)
Date:   Mon, 12 Apr 2021 16:28:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Free the allocated kbuffer in
 tracefs_interate_raw_events()
Message-ID: <20210412162838.544b3265@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When reading the ring buffers, a kbuffer is allocated and assigned to be
able to parse out the raw events from the kernel buffer. But it is never
freed and causes leaked memory.

Consolidate page_to_kbuf() into read_next_page(), and instead of
allocating the kbuffer descriptor each time, simply reload it with the new
page.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 57 +++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 3a6196b..3e08571 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -20,37 +20,6 @@
 #include "tracefs.h"
 #include "tracefs-local.h"
 
-static struct kbuffer *
-page_to_kbuf(struct tep_handle *tep, void *page, int size)
-{
-	enum kbuffer_long_size long_size;
-	enum kbuffer_endian endian;
-	struct kbuffer *kbuf;
-
-	if (tep_is_file_bigendian(tep))
-		endian = KBUFFER_ENDIAN_BIG;
-	else
-		endian = KBUFFER_ENDIAN_LITTLE;
-
-	if (tep_get_header_page_size(tep) == 8)
-		long_size = KBUFFER_LSIZE_8;
-	else
-		long_size = KBUFFER_LSIZE_4;
-
-	kbuf = kbuffer_alloc(long_size, endian);
-	if (!kbuf)
-		return NULL;
-
-	kbuffer_load_subbuffer(kbuf, page);
-	if (kbuffer_subbuffer_size(kbuf) > size) {
-		tracefs_warning("%s: page_size > size", __func__);
-		kbuffer_free(kbuf);
-		kbuf = NULL;
-	}
-
-	return kbuf;
-}
-
 struct cpu_iterate {
 	struct tep_record record;
 	struct tep_event *event;
@@ -88,13 +57,34 @@ static int read_kbuf_record(struct cpu_iterate *cpu)
 
 int read_next_page(struct tep_handle *tep, struct cpu_iterate *cpu)
 {
+	enum kbuffer_long_size long_size;
+	enum kbuffer_endian endian;
+
 	cpu->rsize = read(cpu->fd, cpu->page, cpu->psize);
 	if (cpu->rsize <= 0)
 		return -1;
 
-	cpu->kbuf = page_to_kbuf(tep, cpu->page, cpu->rsize);
-	if (!cpu->kbuf)
+	if (!cpu->kbuf) {
+		if (tep_is_file_bigendian(tep))
+			endian = KBUFFER_ENDIAN_BIG;
+		else
+			endian = KBUFFER_ENDIAN_LITTLE;
+
+		if (tep_get_header_page_size(tep) == 8)
+			long_size = KBUFFER_LSIZE_8;
+		else
+			long_size = KBUFFER_LSIZE_4;
+
+		cpu->kbuf = kbuffer_alloc(long_size, endian);
+		if (!cpu->kbuf)
+			return -1;
+	}
+
+	kbuffer_load_subbuffer(cpu->kbuf, cpu->page);
+	if (kbuffer_subbuffer_size(cpu->kbuf) > cpu->rsize) {
+		tracefs_warning("%s: page_size > %d", __func__, cpu->rsize);
 		return -1;
+	}
 
 	return 0;
 }
@@ -256,6 +246,7 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 out:
 	if (all_cpus) {
 		for (i = 0; i < count; i++) {
+			kbuffer_free(all_cpus[i].kbuf);
 			close(all_cpus[i].fd);
 			free(all_cpus[i].page);
 		}
-- 
2.29.2

