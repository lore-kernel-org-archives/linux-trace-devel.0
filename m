Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFB8C0015E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jul 2023 15:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjGLPyM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jul 2023 11:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjGLPyM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jul 2023 11:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2F2A2
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jul 2023 08:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 226D661876
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jul 2023 15:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F457C433C7
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jul 2023 15:54:09 +0000 (UTC)
Date:   Wed, 12 Jul 2023 11:54:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add tep_record_is_event() API
Message-ID: <20230712115407.6e123dc7@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a new API tep_record_is_event(). It's becoming a common pattern in
parsing traces, where the code will have:

	int type;

	type = tep_data_type(event->tep, record);
	if (event->id == type) {
		/* do something */
	}

Make it a helper function

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-event_find.txt | 11 ++++++++---
 Documentation/libtraceevent.txt            |  1 +
 include/traceevent/event-parse.h           |  2 ++
 src/event-parse.c                          | 15 +++++++++++++++
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/Documentation/libtraceevent-event_find.txt b/Documentation/libtraceevent-event_find.txt
index 56d76b1023f5..c7602f31c750 100644
--- a/Documentation/libtraceevent-event_find.txt
+++ b/Documentation/libtraceevent-event_find.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_find_event,tep_find_event_by_name,tep_find_event_by_record -
+tep_find_event,tep_find_event_by_name,tep_find_event_by_record, tep_record_is_event -
 Find events by given key.
 
 SYNOPSIS
@@ -15,6 +15,7 @@ SYNOPSIS
 struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_, int _id_);
 struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:[*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
 struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_record_);
+bool *tep_record_is_event*(struct tep_record pass:[*]record, struct tep_event pass:[*]event);
 --
 
 DESCRIPTION
@@ -31,12 +32,16 @@ The *tep_find_event_by_name()* function searches for an event by given
 event _name_, under the system _sys_. If the _sys_ is NULL (not specified),
 the first event with _name_ is returned.
 
-The tep_find_event_by_record()* function searches for an event from a given
+The *tep_find_event_by_record()* function searches for an event from a given
 _record_.
 
+The *tep_record_is_event()* function tests if the given _record_ is of the type
+of the _event_. This is normally used to know if the _record_ being processed is
+of an _event_ where further processing should be done.
+
 RETURN VALUE
 ------------
-All these functions return a pointer to the found event, or NULL if there is no
+All these functions except *tep_record_is_event()* return a pointer to the found event, or NULL if there is no
 such event.
 
 EXAMPLE
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 05027691aa03..2ae6628bd324 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -83,6 +83,7 @@ Event finding:
 	struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_, int _id_);
 	struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:[*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
 	struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_record_);
+	bool *tep_record_is_event*(struct tep_record pass:[*]record, struct tep_event pass:[*]event);
 
 Parsing of event files:
 	int *tep_parse_header_page*(struct tep_handle pass:[*]_tep_, char pass:[*]_buf_, unsigned long _size_, int _long_size_);
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 2171ad730880..e0785f7fe1d4 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -554,6 +554,8 @@ struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *tep, const char *c
 					   struct tep_cmdline *next);
 int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
 
+bool tep_record_is_event(struct tep_record *record, struct tep_event *event);
+
 void tep_print_field_content(struct trace_seq *s, void *data, int size,
 			     struct tep_format_field *field);
 void tep_record_print_fields(struct trace_seq *s,
diff --git a/src/event-parse.c b/src/event-parse.c
index b4191eb17deb..d607556ea1a9 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6872,6 +6872,21 @@ const char *tep_data_comm_from_pid(struct tep_handle *tep, int pid)
 	return comm;
 }
 
+/**
+ * tep_record_is_event - return true if the given record is the given event
+ * @record: The record to see is the @event
+ * @event: The event to test against @record
+ *
+ * Returns true if the record is of the given event, false otherwise
+ */
+bool tep_record_is_event(struct tep_record *record, struct tep_event *event)
+{
+	int type;
+
+	type = tep_data_type(event->tep, record);
+	return event->id == type;
+}
+
 static struct tep_cmdline *
 pid_from_cmdlist(struct tep_handle *tep, const char *comm, struct tep_cmdline *next)
 {
-- 
2.40.1

