Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BA5C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB852183E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfCVNIW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:08:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51506 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730891AbfCVNIU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 09:08:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id 4so2107419wmf.1;
        Fri, 22 Mar 2019 06:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Akk9dRqoKX6onqw6rpntA/NgsNHCjy6Y2LQyc/YfjzI=;
        b=tI0/R3Ri8UHTBX+wLs4aVyui6e1xW3wQhnu5KQcZK4vWL/laSINcf6YStM2ZYTqo23
         TrmaclaIBKk5rsuv3mNF6BBRJd15GOi25A9x4YKDQMQwYC5G492n+F+JGsqyVulEE3Dd
         fbajVdB3LHq1t1lzZ3F1bzNNv3+l57TFKwdYqXZ1rzPgYQcKFXEPFywjfI24nvg+c4wG
         LkWk6nGXRCgWFwyBUhGdXp4PrlPhWVKTfBuQDwoujHFy08QKzWZEWBcoayfk4KMg/2Lk
         jqDrKlXT3PH+2s72LMaCJf89mOZtoS8clxByV2dNSvQcIvvieQeDY/7ZQVo5d/3v+32d
         O3IA==
X-Gm-Message-State: APjAAAWjiXCE562BjwegxIWavRIf60Nep2IoHalptFozns8Kyc65xfCY
        TDJV4+5g+oSKiCGDcuxPaQk=
X-Google-Smtp-Source: APXvYqxZudU/8AuZYuisdcLoc9sethZADlQRXIWuoxXg/82dGJD54UiLW4TPRQ198aUuGbRX1lD36w==
X-Received: by 2002:a1c:7008:: with SMTP id l8mr2885765wmc.63.1553260098116;
        Fri, 22 Mar 2019 06:08:18 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b134sm16929484wmd.26.2019.03.22.06.08.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 06:08:17 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tools/perf,tools/lib/traceevent: Make traceevent APIs more consistent
Date:   Fri, 22 Mar 2019 15:08:16 +0200
Message-Id: <20190322130816.13903-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Rename few traceevent APIs, in order to make it more consistent:
tep_pid_is_registered(), tep_file_bigendian(),
tep_is_latency_format(), tep_get_header_page_ts_size(),
tep_set_host_bigendian(), tep_is_host_bigendian() and
tep_data_lat_fmt()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c | 40 +++++++++++++-------------
 tools/lib/traceevent/event-parse.c     | 26 ++++++++---------
 tools/lib/traceevent/event-parse.h     | 18 ++++++------
 tools/lib/traceevent/plugin_kvm.c      |  4 +--
 tools/perf/util/trace-event-read.c     |  2 +-
 tools/perf/util/trace-event.c          |  4 +--
 6 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 112a83f5caa9..7b17fb1ef30a 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -156,13 +156,13 @@ int tep_get_header_page_size(struct tep_handle *pevent)
 }
 
 /**
- * tep_get_header_page_ts_size - get size of the time stamp in the header page
+ * tep_get_header_timestamp_size - get size of the time stamp in the header page
  * @tep: a handle to the tep_handle
  *
  * This returns size of the time stamp in the header page
  * If @tep is NULL, 0 is returned.
  */
-int tep_get_header_page_ts_size(struct tep_handle *tep)
+int tep_get_header_timestamp_size(struct tep_handle *tep)
 {
 	if (tep)
 		return tep->header_page_ts_size;
@@ -250,17 +250,17 @@ void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 }
 
 /**
- * tep_file_bigendian - get if the file is in big endian order
+ * tep_is_file_bigendian - get if the file is in big endian order
  * @pevent: a handle to the tep_handle
  *
- * This returns if the file is in big endian order
- * If @pevent is NULL, 0 is returned.
+ * This returns true if the file is in big endian order
+ * If @pevent is NULL, false is returned.
  */
-int tep_file_bigendian(struct tep_handle *pevent)
+bool tep_is_file_bigendian(struct tep_handle *pevent)
 {
 	if (pevent)
-		return pevent->file_bigendian;
-	return 0;
+		return (pevent->file_bigendian == TEP_BIG_ENDIAN);
+	return false;
 }
 
 /**
@@ -277,27 +277,27 @@ void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
 }
 
 /**
- * tep_is_host_bigendian - get if the order of the current host is big endian
+ * tep_is_local_bigendian - get if the local order is big endian
  * @pevent: a handle to the tep_handle
  *
- * This gets if the order of the current host is big endian
+ * This gets if the local order is big endian
  * If @pevent is NULL, 0 is returned.
  */
-int tep_is_host_bigendian(struct tep_handle *pevent)
+bool tep_is_local_bigendian(struct tep_handle *pevent)
 {
 	if (pevent)
-		return pevent->host_bigendian;
+		return (pevent->host_bigendian == TEP_BIG_ENDIAN);
 	return 0;
 }
 
 /**
- * tep_set_host_bigendian - set the order of the local host
+ * tep_set_local_bigendian - set the local endian order
  * @pevent: a handle to the tep_handle
  * @endian: non zero, if the local host has big endian order
  *
- * This sets the order of the local host
+ * This sets the local endian order
  */
-void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
+void tep_set_local_bigendian(struct tep_handle *pevent, enum tep_endian endian)
 {
 	if (pevent)
 		pevent->host_bigendian = endian;
@@ -307,14 +307,14 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
  * tep_is_latency_format - get if the latency output format is configured
  * @pevent: a handle to the tep_handle
  *
- * This gets if the latency output format is configured
- * If @pevent is NULL, 0 is returned.
+ * This returns true if the latency output format is configured
+ * If @pevent is NULL, false is returned.
  */
-int tep_is_latency_format(struct tep_handle *pevent)
+bool tep_is_latency_format(struct tep_handle *pevent)
 {
 	if (pevent)
-		return pevent->latency_format;
-	return 0;
+		return !!(pevent->latency_format);
+	return false;
 }
 
 /**
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 69af77896283..7d553a72469b 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -199,23 +199,23 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)
 }
 
 /**
- * tep_pid_is_registered - return if a pid has a cmdline registered
+ * tep_is_pid_registered - return if a pid has a cmdline registered
  * @pevent: handle for the pevent
  * @pid: The pid to check if it has a cmdline registered with.
  *
- * Returns 1 if the pid has a cmdline mapped to it
- * 0 otherwise.
+ * Returns true if the pid has a cmdline mapped to it
+ * false otherwise.
  */
-int tep_pid_is_registered(struct tep_handle *pevent, int pid)
+bool tep_is_pid_registered(struct tep_handle *pevent, int pid)
 {
 	const struct tep_cmdline *comm;
 	struct tep_cmdline key;
 
 	if (!pid)
-		return 1;
+		return true;
 
 	if (!pevent->cmdlines && cmdline_init(pevent))
-		return 0;
+		return false;
 
 	key.pid = pid;
 
@@ -223,8 +223,8 @@ int tep_pid_is_registered(struct tep_handle *pevent, int pid)
 		       sizeof(*pevent->cmdlines), cmdline_cmp);
 
 	if (comm)
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
 /*
@@ -5171,7 +5171,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 }
 
 /**
- * tep_data_lat_fmt - parse the data for the latency format
+ * tep_data_latency_format - parse the data for the latency format
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @record: the record to read from
@@ -5180,8 +5180,8 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
  * need rescheduling, in hard/soft interrupt, preempt count
  * and lock depth) and places it into the trace_seq.
  */
-void tep_data_lat_fmt(struct tep_handle *pevent,
-		      struct trace_seq *s, struct tep_record *record)
+void tep_data_latency_format(struct tep_handle *pevent,
+			     struct trace_seq *s, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
 	static int check_migrate_disable = 1;
@@ -5530,7 +5530,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 	}
 
 	if (pevent->latency_format) {
-		tep_data_lat_fmt(pevent, s, record);
+		tep_data_latency_format(pevent, s, record);
 	}
 
 	if (use_usec_format) {
@@ -6758,7 +6758,7 @@ struct tep_handle *tep_alloc(void)
 
 	if (pevent) {
 		pevent->ref_count = 1;
-		pevent->host_bigendian = tep_host_bigendian();
+		pevent->host_bigendian = tep_is_bigendian();
 	}
 
 	return pevent;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 4b64658334de..960aef7340e4 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -412,7 +412,7 @@ void tep_set_flag(struct tep_handle *tep, int flag);
 void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag);
 bool tep_check_flags(struct tep_handle *tep, enum tep_flag flags);
 
-static inline int tep_host_bigendian(void)
+static inline int tep_is_bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
 	unsigned int val;
@@ -440,7 +440,7 @@ int tep_register_function(struct tep_handle *pevent, char *name,
 			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 			      unsigned long long addr);
-int tep_pid_is_registered(struct tep_handle *pevent, int pid);
+bool tep_is_pid_registered(struct tep_handle *pevent, int pid);
 
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			  struct tep_event *event,
@@ -525,8 +525,8 @@ tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *n
 struct tep_event *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
-void tep_data_lat_fmt(struct tep_handle *pevent,
-		      struct trace_seq *s, struct tep_record *record);
+void tep_data_latency_format(struct tep_handle *pevent,
+			     struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
@@ -560,16 +560,16 @@ int tep_get_long_size(struct tep_handle *pevent);
 void tep_set_long_size(struct tep_handle *pevent, int long_size);
 int tep_get_page_size(struct tep_handle *pevent);
 void tep_set_page_size(struct tep_handle *pevent, int _page_size);
-int tep_file_bigendian(struct tep_handle *pevent);
+bool tep_is_file_bigendian(struct tep_handle *pevent);
 void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian);
-int tep_is_host_bigendian(struct tep_handle *pevent);
-void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
-int tep_is_latency_format(struct tep_handle *pevent);
+bool tep_is_local_bigendian(struct tep_handle *pevent);
+void tep_set_local_bigendian(struct tep_handle *pevent, enum tep_endian endian);
+bool tep_is_latency_format(struct tep_handle *pevent);
 void tep_set_latency_format(struct tep_handle *pevent, int lat);
 int tep_get_header_page_size(struct tep_handle *pevent);
 void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
 int tep_get_parsing_failures(struct tep_handle *tep);
-int tep_get_header_page_ts_size(struct tep_handle *tep);
+int tep_get_header_timestamp_size(struct tep_handle *tep);
 bool tep_is_old_format(struct tep_handle *pevent);
 void tep_set_print_raw(struct tep_handle *tep, int print_raw);
 void tep_set_test_filters(struct tep_handle *tep, int test_filters);
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 64b9c25a1fd3..688e5d97d7a7 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -389,8 +389,8 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianness.
 	 */
-	if (tep_file_bigendian(event->pevent) ==
-	    tep_is_host_bigendian(event->pevent)) {
+	if (tep_is_file_bigendian(event->pevent) ==
+	    tep_is_local_bigendian(event->pevent)) {
 
 		trace_seq_printf(s, "%u q%u%s %s%s %spae %snxe %swp%s%s%s",
 				 role.level,
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index efe2f58cff4e..48d53d8e3e16 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -442,7 +442,7 @@ ssize_t trace_report(int fd, struct trace_event *tevent, bool __repipe)
 
 	tep_set_flag(pevent, TEP_NSEC_OUTPUT);
 	tep_set_file_bigendian(pevent, file_bigendian);
-	tep_set_host_bigendian(pevent, host_bigendian);
+	tep_set_local_bigendian(pevent, host_bigendian);
 
 	if (do_read(buf, 1) < 0)
 		goto out;
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index cbe0dd758e3a..01b9d89bf5bf 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -40,7 +40,7 @@ int trace_event__init(struct trace_event *t)
 
 static int trace_event__init2(void)
 {
-	int be = tep_host_bigendian();
+	int be = tep_is_bigendian();
 	struct tep_handle *pevent;
 
 	if (trace_event__init(&tevent))
@@ -49,7 +49,7 @@ static int trace_event__init2(void)
 	pevent = tevent.pevent;
 	tep_set_flag(pevent, TEP_NSEC_OUTPUT);
 	tep_set_file_bigendian(pevent, be);
-	tep_set_host_bigendian(pevent, be);
+	tep_set_local_bigendian(pevent, be);
 	tevent_initialized = true;
 	return 0;
 }
-- 
2.20.1

