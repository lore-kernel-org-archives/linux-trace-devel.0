Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B5FC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 502AB2183E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfCVNHt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:07:49 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:36012 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730688AbfCVNHs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 09:07:48 -0400
Received: by mail-wm1-f52.google.com with SMTP id h18so2126659wml.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Mar 2019 06:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GeVYhMhPWB83TmWIY5ySbmKqM72Z/5dmn5F4n+/s8pY=;
        b=a/vOdkGTRSH1L2/XyFfH53uAUNUmSlrLvUuE3MI6xDufGCkoEqgSKEhGLpoOAR5UX8
         P9XJr/9WyHhtGWmY+Q/GaLIZo6b88kY5yP13s3BAXRuEfH98NaeXkuPD94n7PKqblqGP
         EZ+YnXwJc05YmzDAxvQ1n1O/J9MZPGENBYW6s5egk2Se7CkaE38VtFFE3ywcLSp+MmqT
         Kq/lZDKmqGnumy0i4SiJ0FdvJ7oMfnftH8QuGW5u2CwVYSQ72kiklwCbS5a7WKkh4Mhq
         ZQ9I9IQFlAQnqqlUIUpW4ErzouEvmNe7a7nOaJdQ08EHDpQeejrAg3Fe+5iMgq0baXB9
         eT4w==
X-Gm-Message-State: APjAAAUuXsJIdqpIPnr6D0ciKpSHeCf2OLH4lS5ILsgwp5EwnB+sJQRk
        5HlbQ5ie0vXKUvcMzENR59Y=
X-Google-Smtp-Source: APXvYqzfjzcKELAzKH+WADe/rePafH44aEvI9ME+v05LAyulAKGgpO9XstX3GNfC4GR7Fva3Yc/qyA==
X-Received: by 2002:a1c:f61a:: with SMTP id w26mr3214928wmc.70.1553260066878;
        Fri, 22 Mar 2019 06:07:46 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 204sm13010466wmc.1.2019.03.22.06.07.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 06:07:46 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/3] tools/lib/traceevent: Implement new traceevent APIs for accessing struct tep_handler fields
Date:   Fri, 22 Mar 2019 15:07:42 +0200
Message-Id: <20190322130742.13753-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322130742.13753-1-tstoyanov@vmware.com>
References: <20190322130742.13753-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As struct tep_handler definition is not exposed as part of libtraceevent API, its fields
cannot be accessed directly by the library users. This patch implements new APIs, which
can be used to access the struct tep_handler fields:
tep_clear_flag(), tep_test_flag(), tep_set_parsing_failures(), tep_get_parsing_failures()
tep_get_header_page_ts_size(), tep_is_old_format(), tep_set_print_raw() and tep_set_test_filters()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c   | 134 ++++++++++++++++++++++-
 tools/lib/traceevent/event-parse-local.h |   2 +
 tools/lib/traceevent/event-parse.h       |   8 ++
 3 files changed, 140 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 3716a9142aef..112a83f5caa9 100644
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
@@ -51,6 +64,35 @@ void tep_set_flag(struct tep_handle *tep, int flag)
 		tep->flags |= flag;
 }
 
+/**
+ * tep_clear_flag - clear event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag to be cleared
+ *
+ * This clears a tep flag
+ */
+void tep_clear_flags(struct tep_handle *tep, enum tep_flag flag)
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
+ * This checks the state of a tep flag.
+ * true is returned if the flag is set, false
+ * otherwise
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
index aec48f2aea8a..4b64658334de 100644
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
@@ -565,6 +567,12 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
 int tep_is_latency_format(struct tep_handle *pevent);
 void tep_set_latency_format(struct tep_handle *pevent, int lat);
 int tep_get_header_page_size(struct tep_handle *pevent);
+void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
+int tep_get_parsing_failures(struct tep_handle *tep);
+int tep_get_header_page_ts_size(struct tep_handle *tep);
+bool tep_is_old_format(struct tep_handle *pevent);
+void tep_set_print_raw(struct tep_handle *tep, int print_raw);
+void tep_set_test_filters(struct tep_handle *tep, int test_filters);
 
 struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
-- 
2.20.1

