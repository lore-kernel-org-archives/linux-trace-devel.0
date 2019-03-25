Return-Path: <SRS0=I4ei=R4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C19BC10F03
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE9820811
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbfCYOuZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:50:25 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:44897 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729273AbfCYOuY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 10:50:24 -0400
Received: by mail-wr1-f43.google.com with SMTP id y7so6385958wrn.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Mar 2019 07:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JzCTNxrgTqH+dxyDMUFW4umtOt4X5pQ5OQYVb6+cpQU=;
        b=a0KVHwQ83L0bimMKXoMa0DPF4v85oRprQ3SF7ipAfnZgFs0ZwbiVoxoyods1LMazYj
         jmpo1nxN/w/r5VqKFLJc7pRBBYv5SrTcGSHLZ+gGwF+SGPiPfRa4vapCo5U+WI2AJ7nB
         rSIbv2VuoM0yTgI/VszUtk3fNtL/tgBVbSP38jOcDKYuw4lXYoT+mYcDaqkprzjlqtu2
         ACG3kdZeGIo4JTM0Ud2CAEb3ki4zERBJ9qNru2OdD91nby1NcwR7MXMu+QWEsXVwgyTW
         Ltv/Km4FIOpqwkO3gA+jUVT7lalKogqdcd5yoIfmTHjigIQrjCHqKvStKHemqQy1G/15
         FDhg==
X-Gm-Message-State: APjAAAUYBiNS9EMpe38hskjA5KSpV7ikJflTIn2YT2zmcNTQ8xk+rzKi
        Oklb8IGSuTFEM1Jhizx9HfdB8+qi
X-Google-Smtp-Source: APXvYqzHICQgXsSwBHbrG0uaARkBjSxWoiEZXnN4kPNYIRHozV9dtmmV/tU+74Zj16Zf+PedxaLqSA==
X-Received: by 2002:adf:8367:: with SMTP id 94mr17061030wrd.46.1553525422338;
        Mon, 25 Mar 2019 07:50:22 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 61sm24687595wre.50.2019.03.25.07.50.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:50:21 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/3] tools/lib/traceevent: Implement new traceevent APIs for accessing struct tep_handler fields
Date:   Mon, 25 Mar 2019 16:50:17 +0200
Message-Id: <20190325145017.30246-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190325145017.30246-1-tstoyanov@vmware.com>
References: <20190325145017.30246-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As struct tep_handler definition is not exposed as part of libtraceevent API, its fields
cannot be accessed directly by the library users. This patch implements new APIs, which
can be used to access the struct tep_handler fields:

tep_get_event() - retrieves an event pointer at a specific index
tep_get_first_event() is modified to use tep_get_event()
tep_clear_flag() - clears a tep handle flag
tep_test_flag() - test if a given flag is set
tep_get_header_timestamp_size() - returns the size of the timestamp stored in the header.
tep_get_cpus() - returns the number of CPUs
tep_is_old_format() - returns true if data was created by an
                      older kernel with the old data format
tep_set_print_raw() - have the output print in the raw format
tep_set_test_filters() - debugging utility for testing tep filters

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c | 106 ++++++++++++++++++++++++-
 tools/lib/traceevent/event-parse.h     |   6 ++
 2 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 3716a9142aef..36672b9e18e0 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -8,6 +8,22 @@
 #include "event-parse-local.h"
 #include "event-utils.h"
 
+/**
+ * tep_get_event - returns the event with the given index
+ * @tep: a handle to the tep_handle
+ * @index: index of the requested event, in the range 0 .. nr_events
+ *
+ * This returns pointer to the element of the events array with the given index
+ * If @tep is NULL, or @index is not in the range 0 .. nr_events, NULL is returned.
+ */
+struct tep_event *tep_get_event(struct tep_handle *tep, int index)
+{
+	if (tep && tep->events && index < tep->nr_events)
+		return tep->events[index];
+
+	return NULL;
+}
+
 /**
  * tep_get_first_event - returns the first event in the events array
  * @tep: a handle to the tep_handle
@@ -17,10 +33,7 @@
  */
 struct tep_event *tep_get_first_event(struct tep_handle *tep)
 {
-	if (tep && tep->events)
-		return tep->events[0];
-
-	return NULL;
+	return tep_get_event(tep, 0);
 }
 
 /**
@@ -51,6 +64,34 @@ void tep_set_flag(struct tep_handle *tep, int flag)
 		tep->flags |= flag;
 }
 
+/**
+ * tep_clear_flag - clear event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag to be cleared
+ *
+ * This clears a tep flag
+ */
+void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		tep->flags &= ~flag;
+}
+
+/**
+ * tep_test_flag - check the state of event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag to be checked
+ *
+ * This returns the state of the requested tep flag.
+ * Returns: true if the flag is set, false otherwise.
+ */
+bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		return (tep->flags & flag);
+	return false;
+}
+
 unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
 {
 	unsigned short swap;
@@ -113,6 +154,20 @@ int tep_get_header_page_size(struct tep_handle *pevent)
 	return 0;
 }
 
+/**
+ * tep_get_header_timestamp_size - get size of the time stamp in the header page
+ * @tep: a handle to the tep_handle
+ *
+ * This returns size of the time stamp in the header page
+ * If @tep is NULL, 0 is returned.
+ */
+int tep_get_header_timestamp_size(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->header_page_ts_size;
+	return 0;
+}
+
 /**
  * tep_get_cpus - get the number of CPUs
  * @pevent: a handle to the tep_handle
@@ -273,3 +328,46 @@ void tep_set_latency_format(struct tep_handle *pevent, int lat)
 	if (pevent)
 		pevent->latency_format = lat;
 }
+
+/**
+ * tep_is_old_format - get if an old kernel is used
+ * @tep: a handle to the tep_handle
+ *
+ * This returns true, if an old kernel is used to generate the tracing events or
+ * false if a new kernel is used. Old kernels did not have header page info.
+ * If @pevent is NULL, false is returned.
+ */
+bool tep_is_old_format(struct tep_handle *tep)
+{
+	if (tep)
+		return !!(tep->old_format);
+	return false;
+}
+
+/**
+ * tep_set_print_raw - set a flag to force print in raw format
+ * @tep: a handle to the tep_handle
+ * @print_raw: the new value of the print_raw flag
+ *
+ * This sets a flag to force print in raw format
+ */
+void tep_set_print_raw(struct tep_handle *tep, int print_raw)
+{
+	if (tep)
+		tep->print_raw = print_raw;
+}
+
+/**
+ * tep_set_test_filters - set a flag to test a filter string
+ * @tep: a handle to the tep_handle
+ * @test_filters: the new value of the test_filters flag
+ *
+ * This sets a flag to test a filter string. If this flag is set, when
+ * tep_filter_add_filter_str() API as called,it will print the filter string
+ * instead of adding it.
+ */
+void tep_set_test_filters(struct tep_handle *tep, int test_filters)
+{
+	if (tep)
+		tep->test_filters = test_filters;
+}
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index aec48f2aea8a..6e1d493738b4 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -409,6 +409,8 @@ void tep_print_plugins(struct trace_seq *s,
 typedef char *(tep_func_resolver_t)(void *priv,
 				    unsigned long long *addrp, char **modp);
 void tep_set_flag(struct tep_handle *tep, int flag);
+void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag);
+bool tep_check_flags(struct tep_handle *tep, enum tep_flag flags);
 
 static inline int tep_host_bigendian(void)
 {
@@ -565,6 +567,10 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
 int tep_is_latency_format(struct tep_handle *pevent);
 void tep_set_latency_format(struct tep_handle *pevent, int lat);
 int tep_get_header_page_size(struct tep_handle *pevent);
+int tep_get_header_timestamp_size(struct tep_handle *tep);
+bool tep_is_old_format(struct tep_handle *pevent);
+void tep_set_print_raw(struct tep_handle *tep, int print_raw);
+void tep_set_test_filters(struct tep_handle *tep, int test_filters);
 
 struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
-- 
2.20.1

