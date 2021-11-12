Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70912C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 12:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 582CE60F70
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 12:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhKLMiw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Nov 2021 07:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234977AbhKLMiu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Nov 2021 07:38:50 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16F3860F70;
        Fri, 12 Nov 2021 12:36:00 +0000 (UTC)
Date:   Fri, 12 Nov 2021 07:35:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v6 01/12] libtracefs: New APIs for dynamic events
Message-ID: <20211112073558.128df1cf@gandalf.local.home>
In-Reply-To: <CAPpZLN5qS=Og8gJJi8xuL-VTUNT3kUC-m8JjVn_DQmQo+MdC=Q@mail.gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
        <20211108080404.55814-2-tz.stoyanov@gmail.com>
        <20211111173332.1aab03c5@gandalf.local.home>
        <CAPpZLN5qS=Og8gJJi8xuL-VTUNT3kUC-m8JjVn_DQmQo+MdC=Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Nov 2021 07:04:36 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Hi Steven,
> 
> On Fri, Nov 12, 2021 at 12:33 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > After applying these patches, I tested sqlhist and it's broken.
> >
> > What I do is:
> >
> > (as root)
> >  # mkdir /tmp/tracing
> >  # cp -a /sys/kernel/tracing/events /tmp/tracing
> >
> > (as my user)
> >  $ ./sqlhist -t /tmp/tracing/ -n waking 'select start.pid,
> >     (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid'
> >
> > Which prints nothing, but before applying the patches, I would have this:
> >
> > echo 'waking s32 pid; u64 delta;' > /sys/kernel/tracing/synthetic_events
> > echo 'hist:keys=pid:__arg_15772_1=pid,__arg_15772_2=common_timestamp.usecs' > /sys/kernel/tracing/events/sched/sched_waking/trigger
> > echo 'hist:keys=next_pid:pid=$__arg_15772_1,delta=common_timestamp.usecs-$__arg_15772_2:onmatch(sched.sched_waking).trace(waking,$pid,$delta)' > /sys/kernel/tracing/events/sched/sched_switch/trigger
> >
> > Debugging it, I found that it's due to this change.
> >  
> 
> I totally missed the custom trace dir use case. The dynevents APIs
> should be extended with additional parameter, to handle that use case.
> I see two ways to do this:
>  1. Passing a tracefs_instance* parameter to those APIs. This can be
> NULL for top instance in default tracing directory, or allocated with:
>     tracefs_instance_alloc("/tmp/tracing/", NULL) - for the instance
> in a custom tracing directory.
>    This approach adds flexibility to work with any non default
> instance. It also resolves that question with the instance needed by
> the histograms configuration.
>  2. Passing a string parameter with custom trace directory path, or
> NULL for default system trace directory.
> 
> Those APIs should be extended with that additional parameter:


No, it does not. This is an internal issue, let's not burden the users with
extra information they need to manage.

The problem goes away with the following patch:

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index f525e8d..f2a6c8d 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -41,16 +41,14 @@ struct dyn_events_desc {
 	int (*parse)(struct dyn_events_desc *desc, const char *group,
 				char *line, struct tracefs_dynevent **ret_dyn);
 } dynevents[] = {
-	{TRACEFS_DYNEVENT_KPROBE, NULL, "p", dyn_generic_del, dyn_generic_parse},
-	{TRACEFS_DYNEVENT_KRETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
-	{TRACEFS_DYNEVENT_UPROBE, NULL, "p", dyn_generic_del, dyn_generic_parse},
-	{TRACEFS_DYNEVENT_URETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
-	{TRACEFS_DYNEVENT_EPROBE, NULL, "e", dyn_generic_del, dyn_generic_parse},
-	{TRACEFS_DYNEVENT_SYNTH, NULL, "s", dyn_synth_del, dyn_synth_parse},
+	{TRACEFS_DYNEVENT_KPROBE, KPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_KRETPROBE, KPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_UPROBE, UPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_URETPROBE, UPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_EPROBE, SYNTH_EVENTS, "e", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_SYNTH, "", "s", dyn_synth_del, dyn_synth_parse},
 };
 
-
-
 static int dyn_generic_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
 {
 	char *str;
@@ -282,19 +280,6 @@ static void init_devent_desc(void)
 			dynevents[i].file = DYNEVENTS_EVENTS;
 		return;
 	}
-
-	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
-		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_KPROBE)].file = KPROBE_EVENTS;
-		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_KRETPROBE)].file = KPROBE_EVENTS;
-	}
-	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
-		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_UPROBE)].file = UPROBE_EVENTS;
-		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_URETPROBE)].file = UPROBE_EVENTS;
-	}
-	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
-		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].file = SYNTH_EVENTS;
-		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].prefix = "";
-	}
 }
 
 static struct dyn_events_desc *get_devent_desc(enum tracefs_dynevent_type type)


Let the if the files do not exist, then let the failure happen when the the
user tries to create the event in the system. The external directory is
only for reading, not for creating.

-- Steve
