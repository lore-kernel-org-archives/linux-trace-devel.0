Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43638C10F0F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11BD721850
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfDEODj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:03:39 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:50227 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfDEODj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 10:03:39 -0400
Received: by mail-wm1-f46.google.com with SMTP id z11so6879136wmi.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 07:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vONETdYkW1pxsKC8J8pcIO9NAdoe9h6Sh0b73wBYlJQ=;
        b=AA+8FBWHWZlEc1hsntzTBputi2DSf9EgrTUDsieRI7tI9YHXfR3FQ9oRMnlDSimsAK
         HRf2rOstxS1lNYIMzbG8ZiN7N7LPxfc7hQjswKjTZrHMfckzwD7jKkbyshvaG+S4DI8p
         jMo4oPvd1sWjg2VbceyxJwkzVL1bNXnOdwjVZ5VDzeb0xXcV5wXOBNpkF98xnCXr+kNx
         JEIuWJAwVK/Wzh4BKjZYseWEphJDmpHhxOqR4lGY3em4cknzzNO0BT239d+In35zde6w
         SQsfOnm2dXmHh8KWCeXFQB5KsbjsHyeoe8h++m9g3C/FfwTG8L/x1MY9fxTku088j9Xe
         NWuw==
X-Gm-Message-State: APjAAAXTsta8noQi5k//+I8Q+2SO6j96Ez/1CzzeoDchrKd8FYY9vsJQ
        M8Er655coFjFdUfXAFyHqpI=
X-Google-Smtp-Source: APXvYqywDL6V2XUsse3GDUbj5nxHBrWX7YSWq8Hlu8kK/97P/y10ztlxOxzCaFUXcYWV9kvk0JdY5A==
X-Received: by 2002:a1c:ac07:: with SMTP id v7mr8640506wme.49.1554473017457;
        Fri, 05 Apr 2019 07:03:37 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w16sm29604647wrt.84.2019.04.05.07.03.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Apr 2019 07:03:36 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/10] tools lib traceevent: Implement new traceevent APIs for accessing struct tep_handler fields
Date:   Fri,  5 Apr 2019 17:03:24 +0300
Message-Id: <20190405140332.10949-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190405140332.10949-1-tstoyanov@vmware.com>
References: <20190405140332.10949-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As struct tep_handler definition is not exposed as part of libtraceevent
API, its fields cannot be accessed directly by the library users. This
patch implements new APIs, which can be used to access the struct
tep_handler fields:

  tep_get_event()        - retrieves an event pointer at a specific index
  tep_get_first_event()  - is modified to use tep_get_event()
  tep_clear_flag()       - clears a tep handle flag
  tep_test_flag()        - test if a given flag is set
  tep_get_header_timestamp_size() - returns the size of the timestamp stored
                           in the header.
  tep_get_cpus()         - returns the number of CPUs
  tep_is_old_format()    - returns true if data was created by an
                           older kernel with the old data format
  tep_set_print_raw()    - have the output print in the raw format
  tep_set_test_filters() - debugging utility for testing tep filters

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flore.kernel.org%2Flinux-trace-devel%2F20190325145017.30246-4-tstoyanov%40vmware.com&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C418f50a431d443c8298a08d6b7853ba5%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180214904129&amp;sdata=LB7QIw2gJItreIaCu%2B42pOkqYYz0PKWc0p%2Bx3d0z4w0%3D&amp;reserved=0
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flkml.kernel.org%2Fr%2F20190401164343.679629539%40goodmis.org&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C418f50a431d443c8298a08d6b7853ba5%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180214904129&amp;sdata=wzO%2BjuyysGeLLBIeKtIBbr9BEscTW%2BWO5t%2FEgXbgjd0%3D&amp;reserved=0
[ Renamed some newly added "pevent" to "tep" ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 10 +++----
 lib/trace-cmd/trace-input.c      |  2 +-
 lib/traceevent/event-parse-api.c | 49 ++++++++++++++++----------------
 tracecmd/trace-read.c            |  2 +-
 4 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index bdc6101..0ac9e19 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -394,9 +394,9 @@ void tep_print_plugins(struct trace_seq *s,
 /* tep_handle */
 typedef char *(tep_func_resolver_t)(void *priv,
 				    unsigned long long *addrp, char **modp);
-void tep_set_flag(struct tep_handle *tep, enum tep_flag flag);
-void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag);
-int tep_check_flag(struct tep_handle *tep, enum tep_flag flag);
+void tep_set_flag(struct tep_handle *tep, int flag);
+void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag);
+bool tep_test_flag(struct tep_handle *tep, enum tep_flag flags);
 
 static inline int tep_host_bigendian(void)
 {
@@ -559,8 +559,8 @@ void tep_set_latency_format(struct tep_handle *pevent, int lat);
 int tep_get_header_page_size(struct tep_handle *pevent);
 void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
 int tep_get_parsing_failures(struct tep_handle *tep);
-int tep_get_header_page_ts_size(struct tep_handle *tep);
-int tep_is_old_format(struct tep_handle *pevent);
+int tep_get_header_timestamp_size(struct tep_handle *tep);
+bool tep_is_old_format(struct tep_handle *tep);
 void tep_set_print_raw(struct tep_handle *tep, int print_raw);
 void tep_set_test_filters(struct tep_handle *tep, int test_filters);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6938513..643d8ac 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1038,7 +1038,7 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 	struct kbuffer *kbuf = handle->cpu_data[cpu].kbuf;
 
 	/* FIXME: handle header page */
-	if (tep_get_header_page_ts_size(pevent) != 8) {
+	if (tep_get_header_timestamp_size(pevent) != 8) {
 		warning("expected a long long type for timestamp");
 		return -1;
 	}
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index 2c70375..f2e5d18 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -58,39 +58,38 @@ int tep_get_events_count(struct tep_handle *tep)
  *
  * This sets a flag or combination of flags from enum tep_flag
  */
-void tep_set_flag(struct tep_handle *tep, enum tep_flag flag)
+void tep_set_flag(struct tep_handle *tep, int flag)
 {
 	if (tep)
 		tep->flags |= flag;
 }
 
 /**
- * tep_reset_flag - reset event parser flag
+ * tep_clear_flag - clear event parser flag
  * @tep: a handle to the tep_handle
- * @flag: flag, or combination of flags to be reseted
- * can be any combination from enum tep_flag
+ * @flag: flag to be cleared
  *
- * This resets a flag or combination of flags from enum tep_flag
+ * This clears a tep flag
  */
-void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag)
+void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag)
 {
 	if (tep)
 		tep->flags &= ~flag;
 }
 
 /**
- * tep_check_flag - check the state of event parser flag
+ * tep_test_flag - check the state of event parser flag
  * @tep: a handle to the tep_handle
- * @flag: flag, or combination of flags to be checked
- * can be any combination from enum tep_flag
+ * @flag: flag to be checked
  *
- * This checks the state of a flag or combination of flags from enum tep_flag
+ * This returns the state of the requested tep flag.
+ * Returns: true if the flag is set, false otherwise.
  */
-int tep_check_flag(struct tep_handle *tep, enum tep_flag flag)
+bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 {
 	if (tep)
 		return (tep->flags & flag);
-	return 0;
+	return false;
 }
 
 unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
@@ -156,13 +155,13 @@ int tep_get_header_page_size(struct tep_handle *pevent)
 }
 
 /**
- * tep_get_header_page_ts_size - get size of the time stamp in the header page
+ * tep_get_header_timestamp_size - get size of the timestamp in the header page
  * @tep: a handle to the tep_handle
  *
- * This returns size of the time stamp in the header page
+ * This returns size of the timestamp in the header page
  * If @tep is NULL, 0 is returned.
  */
-int tep_get_header_page_ts_size(struct tep_handle *tep)
+int tep_get_header_timestamp_size(struct tep_handle *tep)
 {
 	if (tep)
 		return tep->header_page_ts_size;
@@ -361,15 +360,15 @@ int tep_get_parsing_failures(struct tep_handle *tep)
  * tep_is_old_format - get if an old kernel is used
  * @tep: a handle to the tep_handle
  *
- * This returns 1, if an old kernel is used to generate the tracing events or
- * 0 if a new kernel is used. Old kernels did not have header page info.
- * If @pevent is NULL, 0 is returned.
+ * This returns true, if an old kernel is used to generate the tracing events or
+ * false if a new kernel is used. Old kernels did not have header page info.
+ * If @tep is NULL, false is returned.
  */
-int tep_is_old_format(struct tep_handle *tep)
+bool tep_is_old_format(struct tep_handle *tep)
 {
 	if (tep)
-		return tep->old_format;
-	return 0;
+		return !!(tep->old_format);
+	return false;
 }
 
 /**
@@ -386,13 +385,13 @@ void tep_set_print_raw(struct tep_handle *tep, int print_raw)
 }
 
 /**
- * tep_set_print_raw - set a flag to test a filter string
+ * tep_set_test_filters - set a flag to test a filter string
  * @tep: a handle to the tep_handle
  * @test_filters: the new value of the test_filters flag
  *
- * This sets a flag to fjust test a filter string. If this flag is set,
- * when a filter string is added, then it will print the filters strings
- * that were created and exit.
+ * This sets a flag to test a filter string. If this flag is set, when
+ * tep_filter_add_filter_str() API as called,it will print the filter string
+ * instead of adding it.
  */
 void tep_set_test_filters(struct tep_handle *tep, int test_filters)
 {
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 03c0978..0d16b15 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -798,7 +798,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		tep_print_event_time(pevent, &s, event, record,
 					use_trace_clock);
 		buf[0] = 0;
-		if (use_trace_clock && !tep_check_flag(pevent, TEP_NSEC_OUTPUT))
+		if (use_trace_clock && !tep_test_flag(pevent, TEP_NSEC_OUTPUT))
 			rec_ts = (rec_ts + 500) / 1000;
 		if (last_ts) {
 			diff_ts = rec_ts - last_ts;
-- 
2.20.1

