Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC225C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 22:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbiBUWSX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 17:18:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiBUWSV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 17:18:21 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D81E624093
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 14:17:44 -0800 (PST)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-fA0w9ciIPpCuAggYa31MgA-1; Mon, 21 Feb 2022 17:17:38 -0500
X-MC-Unique: fA0w9ciIPpCuAggYa31MgA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 773971DDE9;
        Mon, 21 Feb 2022 22:17:37 +0000 (UTC)
Received: from x1.com (unknown [10.22.16.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAB335DB8F;
        Mon, 21 Feb 2022 22:17:34 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Clark Williams <williams@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: [PATCH V2 09/11] rtla/trace: Add trace event filter helpers
Date:   Mon, 21 Feb 2022 23:16:54 +0100
Message-Id: <8846cb46f9b4277b44e523881bbcd0e6b7f31e91.1645481500.git.bristot@kernel.org>
In-Reply-To: <cover.1645481500.git.bristot@kernel.org>
References: <cover.1645481500.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add a set of helper functions to allow rtla tools to filter events
in the trace instance.

Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 tools/tracing/rtla/src/trace.c | 83 ++++++++++++++++++++++++++++++++++
 tools/tracing/rtla/src/trace.h |  3 ++
 2 files changed, 86 insertions(+)

diff --git a/tools/tracing/rtla/src/trace.c b/tools/tracing/rtla/src/trace.c
index 7f8661b2724d..ef44bab0c404 100644
--- a/tools/tracing/rtla/src/trace.c
+++ b/tools/tracing/rtla/src/trace.c
@@ -204,6 +204,8 @@ static void trace_events_free(struct trace_events *events)
 
 		tevent = tevent->next;
 
+		if (free_event->filter)
+			free(free_event->filter);
 		if (free_event->trigger)
 			free(free_event->trigger);
 		free(free_event->system);
@@ -237,6 +239,21 @@ struct trace_events *trace_event_alloc(const char *event_string)
 	return tevent;
 }
 
+/*
+ * trace_event_add_filter - record an event filter
+ */
+int trace_event_add_filter(struct trace_events *event, char *filter)
+{
+	if (event->filter)
+		free(event->filter);
+
+	event->filter = strdup(filter);
+	if (!event->filter)
+		return 1;
+
+	return 0;
+}
+
 /*
  * trace_event_add_trigger - record an event trigger action
  */
@@ -252,6 +269,33 @@ int trace_event_add_trigger(struct trace_events *event, char *trigger)
 	return 0;
 }
 
+/*
+ * trace_event_disable_filter - disable an event filter
+ */
+static void trace_event_disable_filter(struct trace_instance *instance,
+				       struct trace_events *tevent)
+{
+	char filter[1024];
+	int retval;
+
+	if (!tevent->filter)
+		return;
+
+	if (!tevent->filter_enabled)
+		return;
+
+	debug_msg("Disabling %s:%s filter %s\n", tevent->system,
+		  tevent->event ? : "*", tevent->filter);
+
+	snprintf(filter, 1024, "!%s\n", tevent->filter);
+
+	retval = tracefs_event_file_write(instance->inst, tevent->system,
+					  tevent->event, "filter", filter);
+	if (retval < 0)
+		err_msg("Error disabling %s:%s filter %s\n", tevent->system,
+			tevent->event ? : "*", tevent->filter);
+}
+
 /*
  * trace_event_disable_trigger - disable an event trigger
  */
@@ -293,6 +337,7 @@ void trace_events_disable(struct trace_instance *instance,
 	while (tevent) {
 		debug_msg("Disabling event %s:%s\n", tevent->system, tevent->event ? : "*");
 		if (tevent->enabled) {
+			trace_event_disable_filter(instance, tevent);
 			trace_event_disable_trigger(instance, tevent);
 			tracefs_event_disable(instance->inst, tevent->system, tevent->event);
 		}
@@ -302,6 +347,41 @@ void trace_events_disable(struct trace_instance *instance,
 	}
 }
 
+/*
+ * trace_event_enable_filter - enable an event filter associated with an event
+ */
+static int trace_event_enable_filter(struct trace_instance *instance,
+				     struct trace_events *tevent)
+{
+	char filter[1024];
+	int retval;
+
+	if (!tevent->filter)
+		return 0;
+
+	if (!tevent->event) {
+		err_msg("Filter %s applies only for single events, not for all %s:* events\n",
+			tevent->filter, tevent->system);
+		return 1;
+	}
+
+	snprintf(filter, 1024, "%s\n", tevent->filter);
+
+	debug_msg("Enabling %s:%s filter %s\n", tevent->system,
+		  tevent->event ? : "*", tevent->filter);
+
+	retval = tracefs_event_file_write(instance->inst, tevent->system,
+					  tevent->event, "filter", filter);
+	if (retval < 0) {
+		err_msg("Error enabling %s:%s filter %s\n", tevent->system,
+			tevent->event ? : "*", tevent->filter);
+		return 1;
+	}
+
+	tevent->filter_enabled = 1;
+	return 0;
+}
+
 /*
  * trace_event_enable_trigger - enable an event trigger associated with an event
  */
@@ -356,6 +436,9 @@ int trace_events_enable(struct trace_instance *instance,
 			return 1;
 		}
 
+		retval = trace_event_enable_filter(instance, tevent);
+		if (retval)
+			return 1;
 
 		retval = trace_event_enable_trigger(instance, tevent);
 		if (retval)
diff --git a/tools/tracing/rtla/src/trace.h b/tools/tracing/rtla/src/trace.h
index 856b26d93064..51ad344c600b 100644
--- a/tools/tracing/rtla/src/trace.h
+++ b/tools/tracing/rtla/src/trace.h
@@ -6,8 +6,10 @@ struct trace_events {
 	struct trace_events *next;
 	char *system;
 	char *event;
+	char *filter;
 	char *trigger;
 	char enabled;
+	char filter_enabled;
 	char trigger_enabled;
 };
 
@@ -43,4 +45,5 @@ void trace_events_destroy(struct trace_instance *instance,
 int trace_events_enable(struct trace_instance *instance,
 			  struct trace_events *events);
 
+int trace_event_add_filter(struct trace_events *event, char *filter);
 int trace_event_add_trigger(struct trace_events *event, char *trigger);
-- 
2.34.1

