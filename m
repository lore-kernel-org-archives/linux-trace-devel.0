Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D911AC6FA8E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 01:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiIVBgl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 21:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIVBgk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 21:36:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781E69E125
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 18:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14401B82183
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 01:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DDEC433C1;
        Thu, 22 Sep 2022 01:36:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obB9m-00DrE8-1Y;
        Wed, 21 Sep 2022 21:37:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     morg@google.com, "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd library: Add tracecmd_follow_event()
Date:   Wed, 21 Sep 2022 21:37:36 -0400
Message-Id: <20220922013737.3302850-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922013737.3302850-1-rostedt@goodmis.org>
References: <20220922013737.3302850-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the tracecmd_follow_event() to make it easier for applications to
have a callback for specific events when calling either
tracecmd_iterate_events() or tracecmd_iterate_events_multi()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h |   8 +++
 lib/trace-cmd/trace-input.c   | 117 ++++++++++++++++++++++++++++++++--
 2 files changed, 119 insertions(+), 6 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 331815b9edc2..dc08b1bcc82f 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -51,6 +51,14 @@ struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *ha
 void tracecmd_set_private(struct tracecmd_input *handle, void *data);
 void *tracecmd_get_private(struct tracecmd_input *handle);
 
+int tracecmd_follow_event(struct tracecmd_input *handle,
+			  const char *system, const char *event_name,
+			  int (*callback)(struct tracecmd_input *handle,
+					  struct tep_event *,
+					  struct tep_record *,
+					  int, void *),
+			  void *callback_data);
+
 int tracecmd_iterate_events(struct tracecmd_input *handle,
 			    cpu_set_t *cpus, int cpu_size,
 			    int (*callback)(struct tracecmd_input *handle,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index cdaa17bd69f9..ce3584eef201 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -43,6 +43,15 @@ struct page_map {
 	int			ref_count;
 };
 
+struct follow_event {
+	struct tep_event	*event;
+	void			*callback_data;
+	int (*callback)(struct tracecmd_input *handle,
+			struct tep_event *,
+			struct tep_record *,
+			int, void *);
+};
+
 struct page {
 	struct list_head	list;
 	off64_t			offset;
@@ -161,6 +170,7 @@ struct tracecmd_input {
 	struct tep_plugin_list	*plugin_list;
 	struct tracecmd_input	*parent;
 	struct tracecmd_filter	*filter;
+	struct follow_event	*followers;
 	unsigned long		file_state;
 	unsigned long long	trace_id;
 	unsigned long long	next_offset;
@@ -173,6 +183,7 @@ struct tracecmd_input {
 	int			cpus;
 	int			start_cpu;
 	int			ref;
+	int			nr_followers;
 	int			nr_buffers;	/* buffer instances */
 	bool			use_trace_clock;
 	bool			read_page;
@@ -2525,6 +2536,88 @@ tracecmd_read_next_data(struct tracecmd_input *handle, int *rec_cpu)
 	return tracecmd_read_data(handle, next_cpu);
 }
 
+/**
+ * tracecmd_follow_event - Add callback for specific events for iterators
+ * @handle: The handle to get a callback from
+ * @system: The system of the event to track
+ * @event_name: The name of the event to track
+ * @callback: The function to call when the event is hit in an iterator
+ * @callback_data: The data to pass to @callback
+ *
+ * This attaches a callback to @handle where if tracecmd_iterate_events()
+ * or tracecmd_iterate_events_multi() is called, that if the specified
+ * event is hit, it will call @callback, with the following parameters:
+ *  @handle: Same handle as passed to this function.
+ *  @event: The event pointer that was found by @system and @event_name.
+ *  @record; The event instance of @event.
+ *  @cpu: The cpu that the event happened on.
+ *  @callback_data: The same as @callback_data passed to the function.
+ *
+ * Note that when used with tracecmd_iterate_events_multi() that @cpu
+ * may be the nth CPU of all handles it is processing, so if the CPU
+ * that the @record is on is desired, then use @record->cpu.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracecmd_follow_event(struct tracecmd_input *handle,
+			  const char *system, const char *event_name,
+			  int (*callback)(struct tracecmd_input *handle,
+					  struct tep_event *,
+					  struct tep_record *,
+					  int, void *),
+			  void *callback_data)
+{
+	struct tep_handle *tep = tracecmd_get_tep(handle);
+	struct follow_event *followers;
+	struct follow_event follow;
+
+	if (!tep) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	follow.event = tep_find_event_by_name(tep, system, event_name);
+	if (!follow.event) {
+		errno = ENOENT;
+		return -1;
+	}
+
+	follow.callback = callback;
+	follow.callback_data = callback_data;
+
+	followers = realloc(handle->followers, sizeof(*followers) *
+			    (handle->nr_followers + 1));
+	if (!followers)
+		return -1;
+
+	handle->followers = followers;
+	followers[handle->nr_followers++] = follow;
+
+	return 0;
+}
+
+static int call_followers(struct tracecmd_input *handle,
+			  struct tep_record *record, int cpu)
+{
+	struct tep_handle *tep = tracecmd_get_tep(handle);
+	struct follow_event *followers = handle->followers;
+	struct tep_event *event;
+	int ret = 0;
+	int i;
+
+	event = tep_find_event_by_record(tep, record);
+	if (!event)
+		return -1;
+
+	for (i = 0; i < handle->nr_followers; i++) {
+		if (handle->followers[i].event == event)
+			ret |= followers[i].callback(handle, event, record,
+						     cpu, followers[i].callback_data);
+	}
+
+	return ret;
+}
+
 /**
  * tracecmd_iterate_events - iterate events over a given handle
  * @handle: The handle to iterate over
@@ -2553,6 +2646,11 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 	int cpu;
 	int ret = 0;
 
+	if (!callback && !handle->nr_followers) {
+		errno = EINVAL;
+		return -1;
+	}
+
 	records = calloc(handle->max_cpu, sizeof(*records));
 	if (!records)
 		return -1;
@@ -2582,12 +2680,14 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 			records[next_cpu] = tracecmd_peek_data(handle, next_cpu);
 
 			if (!handle->filter ||
-			    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH)
-				ret = callback(handle, record, next_cpu, callback_data);
-
+			    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH) {
+				if (handle->nr_followers)
+					ret = call_followers(handle, record, next_cpu);
+				if (!ret && callback)
+					ret = callback(handle, record, next_cpu, callback_data);
+			}
 			tracecmd_free_record(record);
 		}
-
 	} while (next_cpu >= 0 && ret >= 0);
 
 	for (cpu = 0; cpu < handle->max_cpu; cpu++)
@@ -2674,8 +2774,13 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 			records[next_cpu].record = tracecmd_peek_data(handle, cpu);
 
 			if (!handle->filter ||
-			    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH)
-				ret = callback(handle, record, next_cpu, callback_data);
+			    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH) {
+				if (handle->nr_followers)
+					ret = call_followers(handle, record, next_cpu);
+
+				if (!ret && callback)
+					ret = callback(handle, record, next_cpu, callback_data);
+			}
 			tracecmd_free_record(record);
 		}
 
-- 
2.35.1

