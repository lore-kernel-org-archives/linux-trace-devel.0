Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D60FC4360F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1CB920828
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfCSLTb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:19:31 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:33581 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfCSLTb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 07:19:31 -0400
Received: by mail-wr1-f46.google.com with SMTP id q1so4922205wrp.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 04:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CSUfHKTHYtyVXeZsM1nxAYW9oSZdAoexgGC4jYebcg=;
        b=JsYFIEHYcb0tYyBRl6ZmL3OcnAchyriU2qVXIkegHDVbUjHjg9AO0P21LOVwpt2wXe
         ES+ZGRQAtOvN63Mjzt95NW0gdnS3hW1yNIFJhym3NfB3+DJ04C/7jZ0v+vnglysMyyAy
         Hg+EdHRYwQIXnAxY1UFInfBOG3FErFD8YGy4qc15FtMFysls/kNWuyZ7CECisX9Df8eo
         lhWRg79czz3JHcK040is1EFswFcapJGjxb1JDSY3zHqlmKpFJV6ORJraNPHAAUVCv6HU
         IdN53SV3w19gAeNp7/An2/vJbl9Ak+B+PYmcpRRplF1DzduFIA41geVQABMDcmJAOkHt
         l+og==
X-Gm-Message-State: APjAAAXPrcTI5VpWRFiylPFsUimLH2kaDti+V/jKw6KCBiu6HTRh5zbP
        FzIi35OK9jX9P/S00/Zj9YbTbqVq
X-Google-Smtp-Source: APXvYqyWyj2w55zyqpAY/k1nGHKqPBO/EDNAIk86Re6lAn6+OvPMgCvJ7ip6a1zpx4wjgPZSeK+pwA==
X-Received: by 2002:a5d:6384:: with SMTP id p4mr5794123wru.208.1552994369430;
        Tue, 19 Mar 2019 04:19:29 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v12sm3064407wml.29.2019.03.19.04.19.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 04:19:28 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs for accessing struct tep_handler fields
Date:   Tue, 19 Mar 2019 13:19:24 +0200
Message-Id: <20190319111924.17443-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319111924.17443-1-tstoyanov@vmware.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As struct tep_handler definition is not exposed as part of libtraceevent API, its fields
cannot be accessed directly by the library users. This patch implements new APIs, which
can be used to access the struct tep_handler fields:
tep_reset_flag(), tep_check_flag(), tep_set_parsing_failures(), tep_get_parsing_failures()
tep_get_header_page_ts_size(), tep_is_old_format(), tep_set_print_raw() and tep_set_test_filters()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c   | 140 +++++++++++++++++++++--
 tools/lib/traceevent/event-parse-local.h |   2 +
 tools/lib/traceevent/event-parse.h       |  12 +-
 tools/lib/traceevent/plugin_kvm.c        |   2 +-
 4 files changed, 146 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 3716a9142aef..2bd2bf7c499d 100644
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
@@ -45,12 +58,41 @@ int tep_get_events_count(struct tep_handle *tep)
  *
  * This sets a flag or combination of flags from enum tep_flag
  */
-void tep_set_flag(struct tep_handle *tep, int flag)
+void tep_set_flag(struct tep_handle *tep, enum tep_flag flag)
 {
 	if (tep)
 		tep->flags |= flag;
 }
 
+/**
+ * tep_reset_flag - reset event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag, or combination of flags to be reseted
+ * can be any combination from enum tep_flag
+ *
+ * This resets a flag or combination of flags from enum tep_flag
+ */
+void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		tep->flags &= ~flag;
+}
+
+/**
+ * tep_check_flag - check the state of event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag, or combination of flags to be checked
+ * can be any combination from enum tep_flag
+ *
+ * This checks the state of a flag or combination of flags from enum tep_flag
+ */
+int tep_check_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		return (tep->flags & flag);
+	return 0;
+}
+
 unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
 {
 	unsigned short swap;
@@ -113,6 +155,20 @@ int tep_get_header_page_size(struct tep_handle *pevent)
 	return 0;
 }
 
+/**
+ * tep_get_header_page_ts_size - get size of the time stamp in the header page
+ * @tep: a handle to the tep_handle
+ *
+ * This returns size of the time stamp in the header page
+ * If @tep is NULL, 0 is returned.
+ */
+int tep_get_header_page_ts_size(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->header_page_ts_size;
+	return 0;
+}
+
 /**
  * tep_get_cpus - get the number of CPUs
  * @pevent: a handle to the tep_handle
@@ -194,13 +250,13 @@ void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 }
 
 /**
- * tep_file_bigendian - get if the file is in big endian order
+ * tep_is_file_bigendian - get if the file is in big endian order
  * @pevent: a handle to the tep_handle
  *
  * This returns if the file is in big endian order
  * If @pevent is NULL, 0 is returned.
  */
-int tep_file_bigendian(struct tep_handle *pevent)
+int tep_is_file_bigendian(struct tep_handle *pevent)
 {
 	if (pevent)
 		return pevent->file_bigendian;
@@ -273,3 +329,73 @@ void tep_set_latency_format(struct tep_handle *pevent, int lat)
 	if (pevent)
 		pevent->latency_format = lat;
 }
+
+/**
+ * tep_set_parsing_failures - set parsing failures flag
+ * @tep: a handle to the tep_handle
+ * @parsing_failures: the new value of the parsing_failures flag
+ *
+ * This sets flag "parsing_failures" to the given count
+ */
+void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures)
+{
+	if (tep)
+		tep->parsing_failures = parsing_failures;
+}
+
+/**
+ * tep_get_parsing_failures - get the parsing failures flag
+ * @tep: a handle to the tep_handle
+ *
+ * This returns value of flag "parsing_failures"
+ * If @tep is NULL, 0 is returned.
+ */
+int tep_get_parsing_failures(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->parsing_failures;
+	return 0;
+}
+
+/**
+ * tep_is_old_format - get if an old kernel is used
+ * @tep: a handle to the tep_handle
+ *
+ * This returns 1, if an old kernel is used to generate the tracing events or
+ * 0 if a new kernel is used. Old kernels did not have header page info.
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_is_old_format(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->old_format;
+	return 0;
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
+ * tep_set_print_raw - set a flag to test a filter string
+ * @tep: a handle to the tep_handle
+ * @test_filters: the new value of the test_filters flag
+ *
+ * This sets a flag to fjust test a filter string. If this flag is set,
+ * when a filter string is added, then it will print the filters strings
+ * that were created and exit.
+ */
+void tep_set_test_filters(struct tep_handle *tep, int test_filters)
+{
+	if (tep)
+		tep->test_filters = test_filters;
+}
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index 35833ee32d6c..c5c8eb4c4ab7 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -83,6 +83,8 @@ struct tep_handle {
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
 
+	int parsing_failures;
+
 	/* cache */
 	struct tep_event *last_event;
 
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index aec48f2aea8a..f695688f38fd 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -408,7 +408,9 @@ void tep_print_plugins(struct trace_seq *s,
 /* tep_handle */
 typedef char *(tep_func_resolver_t)(void *priv,
 				    unsigned long long *addrp, char **modp);
-void tep_set_flag(struct tep_handle *tep, int flag);
+void tep_set_flag(struct tep_handle *tep, enum tep_flag flag);
+void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag);
+int tep_check_flag(struct tep_handle *tep, enum tep_flag flag);
 
 static inline int tep_host_bigendian(void)
 {
@@ -558,13 +560,19 @@ int tep_get_long_size(struct tep_handle *pevent);
 void tep_set_long_size(struct tep_handle *pevent, int long_size);
 int tep_get_page_size(struct tep_handle *pevent);
 void tep_set_page_size(struct tep_handle *pevent, int _page_size);
-int tep_file_bigendian(struct tep_handle *pevent);
+int tep_is_file_bigendian(struct tep_handle *pevent);
 void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian);
 int tep_is_host_bigendian(struct tep_handle *pevent);
 void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
 int tep_is_latency_format(struct tep_handle *pevent);
 void tep_set_latency_format(struct tep_handle *pevent, int lat);
 int tep_get_header_page_size(struct tep_handle *pevent);
+void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
+int tep_get_parsing_failures(struct tep_handle *tep);
+int tep_get_header_page_ts_size(struct tep_handle *tep);
+int tep_is_old_format(struct tep_handle *pevent);
+void tep_set_print_raw(struct tep_handle *tep, int print_raw);
+void tep_set_test_filters(struct tep_handle *tep, int test_filters);
 
 struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 64b9c25a1fd3..754050eea467 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -389,7 +389,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianness.
 	 */
-	if (tep_file_bigendian(event->pevent) ==
+	if (tep_is_file_bigendian(event->pevent) ==
 	    tep_is_host_bigendian(event->pevent)) {
 
 		trace_seq_printf(s, "%u q%u%s %s%s %spae %snxe %swp%s%s%s",
-- 
2.20.1

