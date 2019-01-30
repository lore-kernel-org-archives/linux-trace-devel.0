Return-Path: <SRS0=bjmZ=QG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CBBC282D7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A950E20857
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfA3Koh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:44:37 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53594 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730502AbfA3Koh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jan 2019 05:44:37 -0500
Received: by mail-wm1-f66.google.com with SMTP id d15so21101743wmb.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jan 2019 02:44:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uUa6UOGfwFpW6lYT2yG1h1I9hSAzhtNgvqLBL5MAm2s=;
        b=fs3LYQf9l+qbZ8Cli10PhiLwg3n53+ZHzp0VIKPh0KVbM5PJ5/m96V6MJxOftCy82a
         V04CTcjC9P4mZ1Z04cxapDxMOtxGObjrzBgbrZDrWO1vu9EGuxmXsW3d9R7yJdTFzJUe
         3vNBByST4WyvwmTdn9n7N4i+Co+IN0wGqad+TR2OZ0m/tT+HwmoRvyfqXZmUSLYRh2z+
         lzr9MFMfKzpX27lo3iJwHv75ZZrLdzhm3tnFEkk9ta6ilpF+t3Z1vKhmoArylJnNoNHu
         J2cuAuKkjxkwXgYZ6qRGpJOsJhTu912ZYGhjuJDlnmoYBRWu1ls0JIc47LkJ8chr7qos
         AjVA==
X-Gm-Message-State: AJcUukc8yg/lQKa4GJHO+QE03eww6hke3SwrmHAPVXWPJss/SEYxVOqD
        BwUtcQggp4/Gn49/YIDejrk=
X-Google-Smtp-Source: ALg8bN4tN2GP3SyLqoGws2/rhYeTKvxah9heFU2AFSq0/KKGAx9wFalnZe1L7txAvl5CXWyKBsIVZg==
X-Received: by 2002:a1c:8c13:: with SMTP id o19mr23729321wmd.56.1548845073935;
        Wed, 30 Jan 2019 02:44:33 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w12sm503079wrr.23.2019.01.30.02.44.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 02:44:33 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] trace-cmd: Remove tep_data_event_from_type() API
Date:   Wed, 30 Jan 2019 12:44:25 +0200
Message-Id: <20190130104425.8813-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130104425.8813-1-tstoyanov@vmware.com>
References: <20190130104425.8813-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to make libtraceevent into a proper library, its API
should be straightforward.

After discussion with Steven Rostedt, we decided to remove the
tep_data_event_from_type() API and to replace it with tep_find_event(),
as it does the same.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181201040852.913841066@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h |  1 -
 kernel-shark/src/libkshark.c     |  7 +++----
 lib/traceevent/event-parse.c     | 12 ------------
 python/tracecmd.py               |  8 ++++----
 tracecmd/trace-hist.c            |  4 ++--
 tracecmd/trace-mem.c             |  2 +-
 tracecmd/trace-record.c          |  2 +-
 7 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 2dc5822..bdc6101 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -515,7 +515,6 @@ tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 void tep_data_lat_fmt(struct tep_handle *pevent,
 		      struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
-struct tep_event *tep_data_event_from_type(struct tep_handle *pevent, int type);
 int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 5033e47..6a26f28 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -1187,7 +1187,7 @@ const char *kshark_get_event_name_easy(struct kshark_entry *entry)
 	 * Use a mutex to protect the access.
 	 */
 	pthread_mutex_lock(&kshark_ctx->input_mutex);
-	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
+	event = tep_find_event(kshark_ctx->pevent, event_id);
 	pthread_mutex_unlock(&kshark_ctx->input_mutex);
 
 	if (event)
@@ -1236,7 +1236,7 @@ const char *kshark_get_info_easy(struct kshark_entry *entry)
 
 	data = tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
 	event_id = tep_data_type(kshark_ctx->pevent, data);
-	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
+	event = tep_find_event(kshark_ctx->pevent, event_id);
 	if (event)
 		info = kshark_get_info(kshark_ctx->pevent, data, event);
 
@@ -1330,8 +1330,7 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
 					NULL);
 
-		event = tep_data_event_from_type(kshark_ctx->pevent,
-						 entry->event_id);
+		event = tep_find_event(kshark_ctx->pevent, entry->event_id);
 
 		event_name = event? event->name : "[UNKNOWN EVENT]";
 		lat = kshark_get_latency(kshark_ctx->pevent, data);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 8cdb5a3..ca2989b 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5266,18 +5266,6 @@ int tep_data_type(struct tep_handle *pevent, struct tep_record *rec)
 	return trace_parse_common_type(pevent, rec->data);
 }
 
-/**
- * tep_data_event_from_type - find the event by a given type
- * @pevent: a handle to the pevent
- * @type: the type of the event.
- *
- * This returns the event form a given @type;
- */
-struct tep_event *tep_data_event_from_type(struct tep_handle *pevent, int type)
-{
-	return tep_find_event(pevent, type);
-}
-
 /**
  * tep_data_pid - parse the PID from record
  * @pevent: a handle to the pevent
diff --git a/python/tracecmd.py b/python/tracecmd.py
index 60a0d3e..a6671f6 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -204,7 +204,7 @@ class Trace(object):
         rec = tracecmd_read_data(self._handle, cpu)
         if rec:
             type = tep_data_type(self._pevent, rec)
-            format = tep_data_event_from_type(self._pevent, type)
+            format = tep_find_event(self._pevent, type)
             # rec ownership goes over to Event instance
             return Event(self._pevent, rec, format)
         return None
@@ -216,7 +216,7 @@ class Trace(object):
             return None
         rec, cpu = res
         type = tep_data_type(self._pevent, rec)
-        format = tep_data_event_from_type(self._pevent, type)
+        format = tep_find_event(self._pevent, type)
         # rec ownership goes over to Event instance
         return Event(self._pevent, rec, format)
 
@@ -226,7 +226,7 @@ class Trace(object):
             return None
         rec, cpu = res
         type = tep_data_type(self._pevent, rec)
-        format = tep_data_event_from_type(self._pevent, type)
+        format = tep_find_event(self._pevent, type)
         return Event(self._pevent, rec, format)
 
     def peek_event(self, cpu):
@@ -234,7 +234,7 @@ class Trace(object):
         if rec is None:
             return None
         type = tep_data_type(self._pevent, rec)
-        format = tep_data_event_from_type(self._pevent, type)
+        format = tep_find_event(self._pevent, type)
         # rec ownership goes over to Event instance
         return Event(self._pevent, rec, format)
 
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index bd47163..384a7ff 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -541,7 +541,7 @@ process_event(struct tep_handle *pevent, struct tep_record *record, int type)
 		reset_pending_stack();
 	}
 		
-	event = tep_data_event_from_type(pevent, type);
+	event = tep_find_event(pevent, type);
 	event_name = event->name;
 
 	ret = tep_read_number_field(common_pid_field, record->data, &val);
@@ -952,7 +952,7 @@ static void do_trace_hist(struct tracecmd_input *handle)
 		die("No records found in file");
 
 	ret = tep_data_type(pevent, record);
-	event = tep_data_event_from_type(pevent, ret);
+	event = tep_find_event(pevent, ret);
 
 	long_size = tracecmd_long_size(handle);
 
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 059bf9a..078a61b 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -488,7 +488,7 @@ static void do_trace_mem(struct tracecmd_input *handle)
 		die("No records found in file");
 
 	ret = tep_data_type(pevent, record);
-	event = tep_data_event_from_type(pevent, ret);
+	event = tep_find_event(pevent, ret);
 
 	common_type_field = tep_find_common_field(event, "common_type");
 	if (!common_type_field)
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3034a4b..71a407e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3402,7 +3402,7 @@ find_ts_in_page(struct tep_handle *pevent, void *page, int size)
 			break;
 		free_record(last_record);
 		id = tep_data_type(pevent, record);
-		event = tep_data_event_from_type(pevent, id);
+		event = tep_find_event(pevent, id);
 		if (event) {
 			/* Make sure this is our event */
 			field = tep_find_field(event, "buf");
-- 
2.20.1

