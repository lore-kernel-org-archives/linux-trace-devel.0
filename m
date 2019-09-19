Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4010BC49ED7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 22:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20218217D6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 22:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfISWuk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 18:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404705AbfISWuj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 18:50:39 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67348206C2;
        Thu, 19 Sep 2019 22:50:38 +0000 (UTC)
Date:   Thu, 19 Sep 2019 18:50:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH 4/5] libtraceevent, perf tools: Changes in
 tep_print_event_* APIs
Message-ID: <20190919185036.6fde0c6b@gandalf.local.home>
In-Reply-To: <20190918020530.818038260@goodmis.org>
References: <20190918020334.344561631@goodmis.org>
        <20190918020530.818038260@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 17 Sep 2019 22:03:38 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> 
> Libtraceevent APIs for printing various trace events information are
> complicated, there are complex extra parameters. To control the way
> event information is printed, the user should call a set of functions in
> a specific sequence.
> 
> These APIs are reimplemented to provide a more simple interface for
> printing event information.
> 
> Removed APIs:
> 
>  	tep_print_event_task()
> 	tep_print_event_time()
> 	tep_print_event_data()
> 	tep_event_info()
> 	tep_is_latency_format()
> 	tep_set_latency_format()
> 	tep_data_latency_format()
> 	tep_set_print_raw()
> 
> A new API for printing event information is introduced:
>    void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
> 		        struct tep_record *record, const char *fmt, ...);
> where "fmt" is a printf-like format string, followed by the event
> fields to be printed. Supported fields:
>  TEP_PRINT_PID, "%d" - event PID
>  TEP_PRINT_CPU, "%d" - event CPU
>  TEP_PRINT_COMM, "%s" - event command string
>  TEP_PRINT_NAME, "%s" - event name
>  TEP_PRINT_LATENCY, "%s" - event latency
>  TEP_PRINT_TIME, %d - event time stamp. A divisor and precision
>    can be specified as part of this format string:
>    "%precision.divisord". Example:
>    "%3.1000d" - divide the time by 1000 and print the first 3 digits
>    before the dot. Thus, the time stamp "123456000" will be printed as
>    "123.456"
>  TEP_PRINT_INFO, "%s" - event information.
>  TEP_PRINT_INFO_RAW, "%s" - event information, in raw format.
> 
> Example:
>   tep_print_event(tep, s, record, "%16s-%-5d [%03d] %s %6.1000d %s %s",
> 		  TEP_PRINT_COMM, TEP_PRINT_PID, TEP_PRINT_CPU,
> 		  TEP_PRINT_LATENCY, TEP_PRINT_TIME, TEP_PRINT_NAME, TEP_PRINT_INFO);
> Output:
> 	ls-11314 [005] d.h. 185207.366383 function __wake_up
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: linux-trace-devel@vger.kernel.org
> Cc: Patrick McLean <chutzpah@gentoo.org>
> Link: http://lore.kernel.org/linux-trace-devel/20190801074959.22023-2-tz.stoyanov@gmail.com
> Link: http://lore.kernel.org/lkml/20190805204355.041132030@goodmis.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> [ Added support for trace-cmd trace-read.c ]
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>


I needed to modify this with the following changes:

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 47ec9c21..4207ae6f 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -1103,7 +1103,7 @@ static const char *kshark_get_latency(struct tep_handle *pe,
 		return NULL;
 
 	trace_seq_reset(&seq);
-	tep_data_latency_format(pe, &seq, record);
+	tep_print_event(pe, &seq, record, "%s", TEP_PRINT_LATENCY);
 	return seq.buffer;
 }
 
@@ -1117,7 +1117,7 @@ static const char *kshark_get_info(struct tep_handle *pe,
 		return NULL;
 
 	trace_seq_reset(&seq);
-	tep_event_info(&seq, event, record);
+	tep_print_event(pe, &seq, record, "%s", TEP_PRINT_INFO);
 
 	/*
 	 * The event info string contains a trailing newline.


-- Steve
