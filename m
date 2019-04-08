Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA40C10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEFA420883
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfDHPXv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42510 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbfDHPXv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id g3so16874197wrx.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3wHNMz+nh2DJcCB88azndUqTvBaRP1+++ZUV6BJ9oiA=;
        b=ScR1B0L1PRRsh1GK4vKJDAx5tng+JaLLV4gIkW8VJGW8m2LflYzpKazZsI2vV47vBp
         nKQTBaaoDTtfMvfomSU+Q9NCJ0GMuyk1LDortB0v7Gqr5BTQ25dpUfhYWM8ulMPXOEMz
         jBmkIuhwX8TOqXsWZWvZPdqNtlUh5xETcxyYNmmkcm8QZ3XTF9gnOhACw7wHmYjlpuK6
         MnI7Y0OsCNisYrh2J4EFHHqbFNoXWFwdlpu+SvOLESKMB7+Cno3kZKnFdRlGIXMG7Wji
         FL4KGDoH6gM83GRBnS0AMVJIsRaGMRTxEON9CvVhGFDDZBaM17w1ImJs9g6WoRtJ5Qiy
         CkWA==
X-Gm-Message-State: APjAAAX+nX2Y0tBznmNDYCAyfFaAuOt0xaJPAqzoIbByk6YMMh4GuFsn
        Hes8pcdOpIl+p+8Wy20kzztAriPT
X-Google-Smtp-Source: APXvYqzjos/tWeOZsvykl3Kah0qI0Yty0yB3Tz//vwITrKR8ZsJvX6Q5gUuDxd/km9KCZJb0ceyVtw==
X-Received: by 2002:adf:9c91:: with SMTP id d17mr18247956wre.285.1554737029060;
        Mon, 08 Apr 2019 08:23:49 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:48 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/10] tools tools, tools lib traceevent: Make traceevent APIs more consistent
Date:   Mon,  8 Apr 2019 18:23:36 +0300
Message-Id: <20190408152340.12450-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190408152340.12450-1-tstoyanov@vmware.com>
References: <20190408152340.12450-1-tstoyanov@vmware.com>
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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20190327141946.4353-2-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190401164344.288624897@goodmis.org
[ Removed some extra parenthesis around return statements ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 16 ++++++++--------
 lib/trace-cmd/trace-input.c      | 10 +++++-----
 lib/traceevent/event-parse-api.c | 32 ++++++++++++++++----------------
 lib/traceevent/event-parse.c     | 28 ++++++++++++++--------------
 plugins/plugin_kvm.c             |  4 ++--
 python/tracecmd.py               |  2 +-
 tracecmd/trace-output.c          |  2 +-
 tracecmd/trace-read.c            |  4 ++--
 tracecmd/trace-split.c           |  2 +-
 9 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 12cbed0..f8a5461 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -398,7 +398,7 @@ void tep_set_flag(struct tep_handle *tep, int flag);
 void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag);
 bool tep_test_flag(struct tep_handle *tep, enum tep_flag flags);
 
-static inline int tep_host_bigendian(void)
+static inline int tep_is_bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
 	unsigned int val;
@@ -426,7 +426,7 @@ int tep_register_function(struct tep_handle *pevent, char *name,
 			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 			      unsigned long long addr);
-int tep_pid_is_registered(struct tep_handle *pevent, int pid);
+bool tep_is_pid_registered(struct tep_handle *pevent, int pid);
 
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			  struct tep_event *event,
@@ -512,8 +512,8 @@ tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *n
 struct tep_event *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
-void tep_data_lat_fmt(struct tep_handle *pevent,
-		      struct trace_seq *s, struct tep_record *record);
+void tep_data_latency_format(struct tep_handle *pevent,
+			     struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
@@ -550,11 +550,11 @@ int tep_get_long_size(struct tep_handle *pevent);
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
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 643d8ac..d5ee371 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1610,7 +1610,7 @@ tracecmd_translate_data(struct tracecmd_input *handle,
 	memset(record, 0, sizeof(*record));
 
 	record->ref_count = 1;
-	if (tep_is_host_bigendian(pevent) == tep_file_bigendian(pevent))
+	if (tep_is_local_bigendian(pevent) == tep_is_file_bigendian(pevent))
 		swap = 0;
 	record->data = kbuffer_translate_data(swap, ptr, &length);
 	record->size = length;
@@ -1652,7 +1652,7 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
 	enum kbuffer_endian endian;
 	void *ptr;
 
-	if (tep_file_bigendian(pevent))
+	if (tep_is_file_bigendian(pevent))
 		endian = KBUFFER_ENDIAN_BIG;
 	else
 		endian = KBUFFER_ENDIAN_LITTLE;
@@ -2257,7 +2257,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
 	else
 		long_size = KBUFFER_LSIZE_4;
 
-	if (tep_file_bigendian(handle->pevent))
+	if (tep_is_file_bigendian(handle->pevent))
 		endian = KBUFFER_ENDIAN_BIG;
 	else
 		endian = KBUFFER_ENDIAN_LITTLE;
@@ -2466,7 +2466,7 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
 	else
 		long_size = KBUFFER_LSIZE_4;
 
-	if (tep_file_bigendian(handle->pevent))
+	if (tep_is_file_bigendian(handle->pevent))
 		endian = KBUFFER_ENDIAN_BIG;
 	else
 		endian = KBUFFER_ENDIAN_LITTLE;
@@ -2636,7 +2636,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	handle->plugin_list = tracecmd_load_plugins(handle->pevent);
 
 	tep_set_file_bigendian(handle->pevent, buf[0]);
-	tep_set_host_bigendian(handle->pevent, tracecmd_host_bigendian());
+	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
 
 	do_read_check(handle, buf, 1);
 	handle->long_size = buf[0];
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index fb49d1b..13d65a8 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -249,16 +249,16 @@ void tep_set_page_size(struct tep_handle *pevent, int _page_size)
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
+		return (pevent->file_bigendian == TEP_BIG_ENDIAN);
 	return 0;
 }
 
@@ -276,13 +276,13 @@ void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
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
 		return pevent->host_bigendian;
@@ -290,13 +290,13 @@ int tep_is_host_bigendian(struct tep_handle *pevent)
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
 		return pevent->latency_format;
-	return 0;
+	return false;
 }
 
 /**
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index a17f4f8..969f259 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -199,23 +199,23 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)
 }
 
 /**
- * tep_pid_is_registered - return if a pid has a cmdline registered
- * @pevent: handle for the pevent
+ * tep_is_pid_registered - return if a pid has a cmdline registered
+ * @pevent: a handle to the trace event parser context
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
@@ -5172,7 +5172,7 @@ out_failed:
 }
 
 /**
- * tep_data_lat_fmt - parse the data for the latency format
+ * tep_data_latency_format - parse the data for the latency format
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @record: the record to read from
@@ -5181,8 +5181,8 @@ out_failed:
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
@@ -5532,7 +5532,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 	}
 
 	if (pevent->latency_format) {
-		tep_data_lat_fmt(pevent, s, record);
+		tep_data_latency_format(pevent, s, record);
 	}
 
 	if (use_usec_format) {
@@ -6827,7 +6827,7 @@ struct tep_handle *tep_alloc(void)
 
 	if (pevent) {
 		pevent->ref_count = 1;
-		pevent->host_bigendian = tep_host_bigendian();
+		pevent->host_bigendian = tep_is_bigendian();
 	}
 
 	return pevent;
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index ddac21a..e23b513 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -386,8 +386,8 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianness.
 	 */
-	if (tep_file_bigendian(event->pevent) ==
-	    tep_is_host_bigendian(event->pevent)) {
+	if (tep_is_file_bigendian(event->pevent) ==
+	    tep_is_local_bigendian(event->pevent)) {
 
 		trace_seq_printf(s, "%u/%u q%u%s %s%s %spge %snxe",
 				 role.level,
diff --git a/python/tracecmd.py b/python/tracecmd.py
index a6671f6..677c0f2 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -166,7 +166,7 @@ class PEvent(object):
 
     @cached_property
     def file_endian(self):
-        if tep_file_bigendian(self._pevent):
+        if tep_is_file_bigendian(self._pevent):
             return '>'
         return '<'
 
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 1c2e92c..33d6ce3 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -808,7 +808,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		/* Use the pevent of the ihandle for later writes */
 		handle->pevent = tracecmd_get_pevent(ihandle);
 		tep_ref(pevent);
-		if (tep_file_bigendian(pevent))
+		if (tep_is_file_bigendian(pevent))
 			buf[0] = 1;
 		else
 			buf[0] = 0;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 0d16b15..52fa1bd 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1700,8 +1700,8 @@ void trace_report (int argc, char **argv)
 
 		if (show_endian) {
 			printf("file is %s endian and host is %s endian\n",
-				tep_file_bigendian(pevent) ? "big" : "little",
-				tep_is_host_bigendian(pevent) ? "big" : "little");
+				tep_is_file_bigendian(pevent) ? "big" : "little",
+				tep_is_local_bigendian(pevent) ? "big" : "little");
 			return;
 		}
 
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 6043e97..d27b3c6 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -64,7 +64,7 @@ static int create_type_len(struct tep_handle *pevent, int time, int len)
 			bigendian = 1;
 	}
 
-	if (tep_file_bigendian(pevent))
+	if (tep_is_file_bigendian(pevent))
 		time |= (len << 27);
 	else
 		time = (time << 5) | len;
-- 
2.20.1

