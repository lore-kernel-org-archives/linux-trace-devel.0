Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B5AC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 16:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37F2217F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 16:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfCNQN6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 12:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbfCNQN5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 12:13:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0D57217F5;
        Thu, 14 Mar 2019 16:13:55 +0000 (UTC)
Date:   Thu, 14 Mar 2019 12:13:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools lib traceevent, perf tools: Move struct
 tep_handler definition in a local header file
Message-ID: <20190314121354.42b586ef@gandalf.local.home>
In-Reply-To: <20190314120852.592eed46@gandalf.local.home>
References: <20181010105105.826-1-tstoyanov@vmware.com>
        <20190314120852.592eed46@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Mar 2019 12:08:52 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Please be careful not to do this on backports. If you need to add
> functionality, it needs to be a separate patch so that we can upstream
> it. Otherwise, I get confused to see why the traceevent code is
> different between trace-cmd and linux/tools when all the commits have
> been added.

Tzvetomir,

Can you prepare a new patch to send to tools lib traceevent upstream
that has the following changes in it (plus you the headers need to
updated).

Thanks!

-- Steve

--- ../linux-test.git/tools/lib/traceevent/event-parse-api.c	2019-03-14 09:44:49.355639646 -0400
+++ lib/traceevent/event-parse-api.c	2019-03-14 11:51:15.001665231 -0400
@@ -9,6 +9,22 @@
 #include "event-utils.h"
 
 /**
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
+/**
  * tep_get_first_event - returns the first event in the events array
  * @tep: a handle to the tep_handle
  *
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
@@ -32,7 +45,7 @@
  */
 int tep_get_events_count(struct tep_handle *tep)
 {
-	if(tep)
+	if (tep)
 		return tep->nr_events;
 	return 0;
 }
@@ -43,14 +56,43 @@
  * @flag: flag, or combination of flags to be set
  * can be any combination from enum tep_flag
  *
- * This sets a flag or mbination of flags  from enum tep_flag
-  */
-void tep_set_flag(struct tep_handle *tep, int flag)
+ * This sets a flag or combination of flags from enum tep_flag
+ */
+void tep_set_flag(struct tep_handle *tep, enum tep_flag flag)
 {
-	if(tep)
+	if (tep)
 		tep->flags |= flag;
 }
 
+/**
+ * tep_reset_flag - reset event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag, or combination of flags to be reseted
+ * can be any combination from enum tep_flag
+ *
+ * This resets a flag or combination of flags from enum tep_flag
+ */
+void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		tep->flags &= ~flag;
+}
+
+/**
+ * tep_check_flag - check the state of event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag, or combination of flags to be checked
+ * can be any combination from enum tep_flag
+ *
+ * This checks the state of a flag or combination of flags from enum tep_flag
+ */
+int tep_check_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		return (tep->flags & flag);
+	return 0;
+}
+
 unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
 {
 	unsigned short swap;
@@ -108,12 +150,26 @@
  */
 int tep_get_header_page_size(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->header_page_size_size;
 	return 0;
 }
 
 /**
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
+/**
  * tep_get_cpus - get the number of CPUs
  * @pevent: a handle to the tep_handle
  *
@@ -122,7 +178,7 @@
  */
 int tep_get_cpus(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->cpus;
 	return 0;
 }
@@ -135,7 +191,7 @@
  */
 void tep_set_cpus(struct tep_handle *pevent, int cpus)
 {
-	if(pevent)
+	if (pevent)
 		pevent->cpus = cpus;
 }
 
@@ -148,7 +204,7 @@
  */
 int tep_get_long_size(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->long_size;
 	return 0;
 }
@@ -162,7 +218,7 @@
  */
 void tep_set_long_size(struct tep_handle *pevent, int long_size)
 {
-	if(pevent)
+	if (pevent)
 		pevent->long_size = long_size;
 }
 
@@ -175,7 +231,7 @@
  */
 int tep_get_page_size(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->page_size;
 	return 0;
 }
@@ -189,7 +245,7 @@
  */
 void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 {
-	if(pevent)
+	if (pevent)
 		pevent->page_size = _page_size;
 }
 
@@ -202,7 +258,7 @@
  */
 int tep_file_bigendian(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->file_bigendian;
 	return 0;
 }
@@ -216,7 +272,7 @@
  */
 void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
 {
-	if(pevent)
+	if (pevent)
 		pevent->file_bigendian = endian;
 }
 
@@ -229,7 +285,7 @@
  */
 int tep_is_host_bigendian(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->host_bigendian;
 	return 0;
 }
@@ -243,7 +299,7 @@
  */
 void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
 {
-	if(pevent)
+	if (pevent)
 		pevent->host_bigendian = endian;
 }
 
@@ -256,7 +312,7 @@
  */
 int tep_is_latency_format(struct tep_handle *pevent)
 {
-	if(pevent)
+	if (pevent)
 		return pevent->latency_format;
 	return 0;
 }
@@ -270,6 +326,76 @@
   */
 void tep_set_latency_format(struct tep_handle *pevent, int lat)
 {
-	if(pevent)
+	if (pevent)
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
+ * This returns 1, if an old kernel is used to generate the tracing events or
+ * 0 if a new kernel is used. Old kernels did not have header page info.
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_is_old_format(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->old_format;
+	return 0;
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
