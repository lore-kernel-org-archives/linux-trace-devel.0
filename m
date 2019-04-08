Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5992EC10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29DF020883
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfDHPXr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:47 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:42988 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbfDHPXq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:46 -0400
Received: by mail-wr1-f44.google.com with SMTP id g3so16873858wrx.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OxGkoZA853HtQWt5ZKzUTfUHb4bfulZQZez+bRVKELM=;
        b=NZWjKfzYsOeVeFP5eyQAeR8GZ003RAC0KlEapgGkutY7stjlgEYUIjedC0qMmANQNT
         KI0WRnEFKVL0t59eMg+bAb41wlSJ09FbOf8vJQyPkCcxjhm9B96mYMHLkGmqCvyudG1Q
         U4Wp2rYex2TDLtL/WisoqcobF3CAvlLOb11tx3r34RwuaFnn1N+TrCiqSHaYnViYMMfS
         gt0Kp+MrQK69ouHB9AexW+sPSjT1rHRouHTszulVPT5wv7CdH7oncI3OwcE/o7s6DS0E
         gU7vAxNSA27aNmgY5qi22I1GOhqI6fnsSTmkGFiEu1NyrIvcv0KaXGhkLimBaFW0Eshf
         hAKA==
X-Gm-Message-State: APjAAAWVoxit2JTLfclYmz/gmeO0wqUClvYNA3mc87X14mUwhA1AtjjN
        q2bH5NBO4Mtt2Nd9EjYsYU8=
X-Google-Smtp-Source: APXvYqzD62h5lkF6W3Kvb/tsg36xtzHsTRdLfzLe9bgfXe0FZgdCcL4KSet0OpRY6tYe65zyJ2oX8Q==
X-Received: by 2002:adf:c7c8:: with SMTP id y8mr3705889wrg.149.1554737024154;
        Mon, 08 Apr 2019 08:23:44 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:43 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/10] tools lib traceevent: Implement new traceevent APIs for accessing struct tep_handler fields
Date:   Mon,  8 Apr 2019 18:23:32 +0300
Message-Id: <20190408152340.12450-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190408152340.12450-1-tstoyanov@vmware.com>
References: <20190408152340.12450-1-tstoyanov@vmware.com>
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
Link: http://lore.kernel.org/linux-trace-devel/20190325145017.30246-4-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190401164343.679629539@goodmis.org
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

