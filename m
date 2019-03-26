Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EAF1C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 547E220866
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732022AbfCZPne (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:43:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36857 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731897AbfCZPnd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:43:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id h18so13487314wml.1;
        Tue, 26 Mar 2019 08:43:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fANz4yPzPxvm4DgilB+nGjOrA5gmS5bn2wLSTbAX9vc=;
        b=RwYoTyMycAnfCyBP1Kztr6C0Kj1dzjWCuCuy+KQBgjg4pEGBjphtRR4gEly+qH74TN
         i5/Sxsb4CD88J9oOeDMbXC5LNmVkLtmjXlrM1is971BpzuSTeuFY5Rb5T12DSqkxqMXY
         wmMjX9x3GhAPy3REaX0wPATaxEV/kOCo3SjwiaSZ6B1/EA9YN7682MkZWf9NMhvdhOKo
         BAEsyrf0FJH5X95P+7Gkws218IQnfIynhVivRtiSXNh3imw29sksr1U9bu7WnOkJL0th
         5VCSLbYE7CEJGApA+0M0+1cDKkg4Q70hKcsN5NNI035q9KydbHChIDARDlg+nS4ICBCM
         eJOA==
X-Gm-Message-State: APjAAAWphGviH38jCN63zdnu5ZINSr9VoMltXKWPZeQ/kb89DudHW6qz
        jPGRZg1GuHkgun7MCxQT7L8=
X-Google-Smtp-Source: APXvYqw2eeQPAeFI0iUX2aYEjQ8ykBmxP0GbOFD6ff7snl59Tzel57qhU0D9ufAULF5KT0Emj/kHuQ==
X-Received: by 2002:a1c:f606:: with SMTP id w6mr8872085wmc.130.1553615011552;
        Tue, 26 Mar 2019 08:43:31 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n11sm31927685wrt.63.2019.03.26.08.43.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:43:31 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] tools/perf,tools/lib/traceevent: Make traceevent APIs more consistent
Date:   Tue, 26 Mar 2019 17:43:21 +0200
Message-Id: <20190326154328.28718-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326154328.28718-1-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Rename some traceevent APIs for consistency:

tep_pid_is_registered() to tep_is_pid_registered()
tep_file_bigendian() to tep_is_file_bigendian()
  to make the names and return values consistent with other tep_is_... APIs

tep_data_lat_fmt() to tep_data_latency_format()
  to make the name more descriptive

tep_host_bigendian() to tep_is_bigendian()
tep_set_host_bigendian() to tep_set_local_bigendian()
tep_is_host_bigendian() to tep_is_local_bigendian()
  "host" can be confused with VMs, and "local" is about the local
  machine. All tep_is_..._bigendian(struct tep_handle *tep) APIs return
  the saved data in the tep handle, while tep_is_bigendian() returns
  the running machine's endianness.

All tep_is_... functions are modified to return bool value, instead of int.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c | 44 +++++++++++++-------------
 tools/lib/traceevent/event-parse.c     | 26 +++++++--------
 tools/lib/traceevent/event-parse.h     | 16 +++++-----
 tools/lib/traceevent/plugin_kvm.c      |  4 +--
 tools/perf/util/trace-event-read.c     |  2 +-
 tools/perf/util/trace-event.c          |  4 +--
 6 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 2ac8b44854ce..46670bb87051 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -88,7 +88,7 @@ void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag)
 bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 {
 	if (tep)
-		return (tep->flags & flag);
+		return !!(tep->flags & flag);
 	return false;
 }
 
@@ -155,10 +155,10 @@ int tep_get_header_page_size(struct tep_handle *pevent)
 }
 
 /**
- * tep_get_header_timestamp_size - get size of the time stamp in the header page
+ * tep_get_header_timestamp_size - get size of the timestamp in the header page
  * @tep: a handle to the tep_handle
  *
- * This returns size of the time stamp in the header page
+ * This returns size of the timestamp in the header page
  * If @tep is NULL, 0 is returned.
  */
 int tep_get_header_timestamp_size(struct tep_handle *tep)
@@ -249,17 +249,17 @@ void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 }
 
 /**
- * tep_file_bigendian - get if the file is in big endian order
+ * tep_is_file_bigendian - return the endian of the file
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
@@ -276,27 +276,27 @@ void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
 }
 
 /**
- * tep_is_host_bigendian - get if the order of the current host is big endian
+ * tep_is_local_bigendian - return the endian of the saved local machine
  * @pevent: a handle to the tep_handle
  *
- * This gets if the order of the current host is big endian
- * If @pevent is NULL, 0 is returned.
+ * This returns true if the saved local machine in @pevent is big endian.
+ * If @pevent is NULL, false is returned.
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
+ * tep_set_local_bigendian - set the stored local machine endian order
  * @pevent: a handle to the tep_handle
  * @endian: non zero, if the local host has big endian order
  *
- * This sets the order of the local host
+ * This sets the endian order for the local machine.
  */
-void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
+void tep_set_local_bigendian(struct tep_handle *pevent, enum tep_endian endian)
 {
 	if (pevent)
 		pevent->host_bigendian = endian;
@@ -306,14 +306,14 @@ void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
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
index e53c566be55d..f309b6d7e08a 100644
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
@@ -6760,7 +6760,7 @@ struct tep_handle *tep_alloc(void)
 
 	if (pevent) {
 		pevent->ref_count = 1;
-		pevent->host_bigendian = tep_host_bigendian();
+		pevent->host_bigendian = tep_is_bigendian();
 	}
 
 	return pevent;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 93b7d96c5afe..f3b822736d87 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -412,7 +412,7 @@ void tep_set_flag(struct tep_handle *tep, int flag);
 void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag);
 bool tep_test_flag(struct tep_handle *tep, enum tep_flag flags);
 
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
@@ -526,8 +526,8 @@ tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *n
 struct tep_event *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
-void tep_data_lat_fmt(struct tep_handle *pevent,
-		      struct trace_seq *s, struct tep_record *record);
+void tep_data_latency_format(struct tep_handle *pevent,
+			     struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
@@ -561,11 +561,11 @@ int tep_get_long_size(struct tep_handle *pevent);
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
 int tep_get_header_timestamp_size(struct tep_handle *tep);
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

