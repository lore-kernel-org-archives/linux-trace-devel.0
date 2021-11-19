Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2D2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Nov 2021 14:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB30161A79
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Nov 2021 14:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhKSOri (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 09:47:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234402AbhKSOri (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 09:47:38 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628B9615E2;
        Fri, 19 Nov 2021 14:44:36 +0000 (UTC)
Date:   Fri, 19 Nov 2021 09:44:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     <linux-trace-devel@vger.kernel.org>, <kernel@axis.com>
Subject: Re: [PATCH] trace-cmd report: Avoid crash on unknown event
Message-ID: <20211119094434.718922fa@gandalf.local.home>
In-Reply-To: <20211119112420.4826-1-vincent.whitchurch@axis.com>
References: <20211119112420.4826-1-vincent.whitchurch@axis.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Nov 2021 12:24:20 +0100
Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:

> Do not segfault if the event cannot be found for some reason and
> tep_find_event_by_record() returns NULL.
> 
> No extra warning is added since there are others ("UNKNOWN EVENT") which
> already make it clear that something is wrong:
> 
>  kworker/u8:0-7 [003] 1.245773: sched_stat_runtime: comm=kworker/u8:...
> [UNKNOWN EVENT][UNKNOWN EVENT][UNKNOWN EVENT]
>  kworker/u8:0-7 [003] 1.245776: sched_switch: kworker/u8:0:7 [120] W...
> 

I wonder if the following would be a better and more robust approach:

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index f7ffb89e..4b27740a 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -142,12 +142,15 @@ static struct trace_hash wakeup_hash;
 static void print_event_name(struct trace_seq *s, struct tep_event *event)
 {
 	static const char *spaces = "                    "; /* 20 spaces */
+	const char *name;
 	int len;
 
-	trace_seq_printf(s, " %s: ", event->name);
+	name = event ? event->name : "(NULL)";
+
+	trace_seq_printf(s, " %s: ", name);
 
 	/* Space out the event names evenly. */
-	len = strlen(event->name);
+	len = strlen(name);
 	if (len < 20)
 		trace_seq_printf(s, "%.*s", 20 - len, spaces);
 }

-- Steve
