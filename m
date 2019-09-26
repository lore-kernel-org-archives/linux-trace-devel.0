Return-Path: <SRS0=C+o5=XV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DF2C4360C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Sep 2019 00:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4900B217F4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Sep 2019 00:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569458303;
	bh=vIuleCgUXyBjkxSyzlNnvFLymIcgXelFVVSDsUzdmbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JRgZ4VYLQ+O6rE9BWspmnyEAM1MITr9dl2bWJU1E1lALRId368bmTEsANNpeA4CxA
	 CqLYbE4G6HRoEjxNGgW+a0pHGJPNGFuS89PGhZkC6r8HvphvYFvgwzHls8qg6WmcVa
	 ULPqbbcFwvvxOB890gdHdIZxIBZBnju9B62d3+gc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388092AbfIZAdn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 20:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfIZAdm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 20:33:42 -0400
Received: from quaco.localdomain (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 546D2222C1;
        Thu, 26 Sep 2019 00:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569458021;
        bh=vIuleCgUXyBjkxSyzlNnvFLymIcgXelFVVSDsUzdmbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IL0s1i+uAy8UVRx+cIh12G5JCaKAQ9b3GyuBNSiQQz7XrKf8IC4Kqx5iJNxbE3wYI
         lN8IgdWUMPYqqjWASXQo35D33JAlve4kjPs5NsXz6rkiGvZtbVgrMB9GtyXBheYrMb
         efrpavxHLNDHaDB35J7TRSOnIrzr283mNhAkD3Is=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/66] libtraceevent: Man pages fix, changes in event printing APIs
Date:   Wed, 25 Sep 2019 21:31:48 -0300
Message-Id: <20190926003244.13962-11-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926003244.13962-1-acme@kernel.org>
References: <20190926003244.13962-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

APIs for printing various trace event information were redesigned to be
more simple. However, the main libtraceevent man page was not updated
with those changes. The documentation is updated to describe the new
event print API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190808113636.13299-3-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/lkml/20190919212541.869643036@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../lib/traceevent/Documentation/libtraceevent.txt  | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/lib/traceevent/Documentation/libtraceevent.txt
index 00519503c8de..d530a7ce8fb2 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -26,15 +26,12 @@ Management of tep handler data structure and access of its members:
 	void *tep_set_long_size*(struct tep_handle pass:[*]_tep_, int _long_size_);
 	int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
-	bool *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
-	void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_);
 	int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
 	bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
 	int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);
 
 Register / unregister APIs:
-	int *tep_register_trace_clock*(struct tep_handle pass:[*]_tep_, const char pass:[*]_trace_clock_);
 	int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
 	int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event_handler_func _func_, void pass:[*]_context_);
 	int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handler_func func, void pass:[*]_context_);
@@ -57,14 +54,7 @@ Event related APIs:
 	int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
 	struct tep_event pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass:[*]_tep_, enum tep_event_sort_type _sort_type_);
 	struct tep_event pass:[*]pass:[*]*tep_list_events_copy*(struct tep_handle pass:[*]_tep_, enum tep_event_sort_type _sort_type_);
-
-Event printing:
-	void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
-	void *tep_print_event_data*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
-	void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
-	void *tep_print_event_task*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
-	void *tep_print_event_time*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]record, bool _use_trace_clock_);
-	void *tep_set_print_raw*(struct tep_handle pass:[*]_tep_, int _print_raw_);
+	void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, const char pass:[*]_fmt_, _..._);
 
 Event finding:
 	struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_, int _id_);
@@ -116,7 +106,6 @@ Filter management:
 	int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struct tep_event_filter pass:[*]_filter2_);
 
 Parsing various data from the records:
-	void *tep_data_latency_format*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_);
 	int *tep_data_type*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
 	int *tep_data_pid*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
 	int *tep_data_preempt_count*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
-- 
2.21.0

