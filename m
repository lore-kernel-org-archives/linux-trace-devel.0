Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17D5C433E2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0C1D21582
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgGBRMi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgGBRMB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:12:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D397320772;
        Thu,  2 Jul 2020 17:12:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jr2kf-004Aop-0z; Thu, 02 Jul 2020 13:11:57 -0400
Message-ID: <20200702171156.888894388@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 02 Jul 2020 13:10:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 1/9] tools lib traceevent: Add API to read time information from kbuffer
References: <20200702171016.178196716@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add the functions kbuffer_subbuf_timestamp() and kbuffer_ptr_delta() to get
the timing data stored in the ring buffer that is used to produced the time
stamps of the records.

This is useful for tools like trace-cmd to be able to display the content of
the read data to understand why the records show the time stamps that they
do.

Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-2-tz.stoyanov@gmail.com

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/kbuffer-parse.c | 28 ++++++++++++++++++++++++++++
 tools/lib/traceevent/kbuffer.h       |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/tools/lib/traceevent/kbuffer-parse.c b/tools/lib/traceevent/kbuffer-parse.c
index 27f3b07fdae8..583db99aee94 100644
--- a/tools/lib/traceevent/kbuffer-parse.c
+++ b/tools/lib/traceevent/kbuffer-parse.c
@@ -546,6 +546,34 @@ int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer)
 	return 0;
 }
 
+/**
+ * kbuffer_subbuf_timestamp - read the timestamp from a sub buffer
+ * @kbuf:      The kbuffer to load
+ * @subbuf:    The subbuffer to read from.
+ *
+ * Return the timestamp from a subbuffer.
+ */
+unsigned long long kbuffer_subbuf_timestamp(struct kbuffer *kbuf, void *subbuf)
+{
+	return kbuf->read_8(subbuf);
+}
+
+/**
+ * kbuffer_ptr_delta - read the delta field from a record
+ * @kbuf:      The kbuffer to load
+ * @ptr:       The record in the buffe.
+ *
+ * Return the timestamp delta from a record
+ */
+unsigned int kbuffer_ptr_delta(struct kbuffer *kbuf, void *ptr)
+{
+	unsigned int type_len_ts;
+
+	type_len_ts = read_4(kbuf, ptr);
+	return ts4host(kbuf, type_len_ts);
+}
+
+
 /**
  * kbuffer_read_event - read the next event in the kbuffer subbuffer
  * @kbuf:	The kbuffer to read from
diff --git a/tools/lib/traceevent/kbuffer.h b/tools/lib/traceevent/kbuffer.h
index ed4d697fc137..5fa8292e341b 100644
--- a/tools/lib/traceevent/kbuffer.h
+++ b/tools/lib/traceevent/kbuffer.h
@@ -49,6 +49,8 @@ int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer);
 void *kbuffer_read_event(struct kbuffer *kbuf, unsigned long long *ts);
 void *kbuffer_next_event(struct kbuffer *kbuf, unsigned long long *ts);
 unsigned long long kbuffer_timestamp(struct kbuffer *kbuf);
+unsigned long long kbuffer_subbuf_timestamp(struct kbuffer *kbuf, void *subbuf);
+unsigned int kbuffer_ptr_delta(struct kbuffer *kbuf, void *ptr);
 
 void *kbuffer_translate_data(int swap, void *data, unsigned int *size);
 
-- 
2.26.2


