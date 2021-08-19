Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9C7C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 03:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C3261104
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 03:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbhHSDis (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237366AbhHSDih (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 23:38:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4AB461100;
        Thu, 19 Aug 2021 03:38:01 +0000 (UTC)
Date:   Wed, 18 Aug 2021 23:37:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 7/7] tracing: Add a probe that attaches to trace
 events
Message-ID: <20210818233757.686cd7c8@oasis.local.home>
In-Reply-To: <20210819112920.a2fbfdc812967c2743953fd0@kernel.org>
References: <20210817034255.421910614@goodmis.org>
        <20210817035028.190000494@goodmis.org>
        <20210819112920.a2fbfdc812967c2743953fd0@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Aug 2021 11:29:20 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> On Mon, 16 Aug 2021 23:43:02 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
> > 
> > A new dynamic event is introduced: event probe. The event is attached
> > to an existing tracepoint and uses its fields as arguments. The user
> > can specify custom format string of the new event, select what tracepoint
> > arguments will be printed and how to print them.
> > An event probe is created by writing configuration string in
> > 'dynamic_events' ftrace file:
> >  e:[SNAME/]ENAME SYSTEM/EVENT [FETCHARGS]	- Set an event probe  
> 
> Just a small comment. This ENAME is actually optional.
> 
> >  -:SNAME/ENAME					- Delete an event probe
> > 
> > Where:
> >  SNAME	- System name, if omitted 'eprobes' is used.
> >  ENAME	- Name of the new event in SNAME, mandatory.  
> 
> Ditto.

Will updated.

> See __trace_eprobe_create(), it generates the event name from
> the "SYSTEM_EVENT". (BTW, what happen if we have 2 different event
> probe on the same event with same name?)

I'll have to check. We should try to avoid that.

> 
> >  SYSTEM	- Name of the system, where the tracepoint is defined, mandatory.
> >  EVENT	- Name of the tracepoint event in SYSTEM, mandatory.
> >  FETCHARGS - Arguments:
> >   <name>=$<field>[:TYPE] - Fetch given filed of the tracepoint and print
> > 			   it as given TYPE with given name. Supported
> > 			   types are:
> > 	                    (u8/u16/u32/u64/s8/s16/s32/s64), basic type
> >         	            (x8/x16/x32/x64), hexadecimal types
> > 			    "string", "ustring" and bitfield.
> > 
> > Example, attach an event probe on openat system call and print name of the
> > file that will be opened:
> >  echo "e:esys/eopen syscalls/sys_enter_openat file=\$filename:string" >> dynamic_events
> > A new dynamic event is created in events/esys/eopen/ directory. It
> > can be deleted with:
> >  echo "-:esys/eopen" >> dynamic_events
> > 
> > Filters, triggers and histograms can be attached to the new event, it can
> > be matched in synthetic events. There is one limitation - an event probe
> > can not be attached to kprobe, uprobe or another event probe.
> > 
> > Link: https://lkml.kernel.org/r/20210812145805.2292326-1-tz.stoyanov@gmail.com
> > 
> > Co-developed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---  
> [...]
> > +static struct trace_event_call *
> > +find_and_get_event(const char *system, const char *event_name)
> > +{
> > +	struct trace_event_call *tp_event;
> > +	const char *name;
> > +
> > +	list_for_each_entry(tp_event, &ftrace_events, list) {
> > +		/* Skip other probes and ftrace events */
> > +		if ((tp_event->flags & TRACE_EVENT_FL_IGNORE_ENABLE) ||
> > +		    (tp_event->flags & TRACE_EVENT_FL_KPROBE) ||
> > +		    (tp_event->flags & TRACE_EVENT_FL_UPROBE) ||
> > +		    (tp_event->flags & TRACE_EVENT_FL_EPROBE))  
> 
> Maybe it is better to define a bitmask for it instead of testing
> different bit many times.

Doh! Of course!

> 
> [...]
> > +static int __trace_eprobe_create(int argc, const char *argv[])
> > +{
> > +	/*
> > +	 * Argument syntax:
> > +	 *      e[:[GRP/]ENAME] SYSTEM.EVENT [FETCHARGS]
> > +	 * Fetch args:
> > +	 *  <name>=$<field>[:TYPE]
> > +	 */
> > +	const char *event = NULL, *group = EPROBE_EVENT_SYSTEM;
> > +	const char *sys_event = NULL, *sys_name = NULL;
> > +	struct trace_event_call *event_call;
> > +	struct trace_eprobe *ep = NULL;
> > +	char buf1[MAX_EVENT_NAME_LEN];
> > +	char buf2[MAX_EVENT_NAME_LEN];
> > +	int ret = 0;
> > +	int i;
> > +
> > +	if (argc < 2)
> > +		return -ECANCELED;
> > +
> > +	trace_probe_log_init("event_probe", argc, argv);
> > +
> > +	event = strchr(&argv[0][1], ':');
> > +	if (event) {
> > +		event++;
> > +		ret = traceprobe_parse_event_name(&event, &group, buf1,
> > +						  event - argv[0]);
> > +		if (ret)
> > +			goto parse_error;
> > +	} else {
> > +		strscpy(buf1, argv[1], MAX_EVENT_NAME_LEN);
> > +		sanitize_event_name(buf1);
> > +		event = buf1;
> > +	}
> > +	if (!is_good_name(event) || !is_good_name(group))
> > +		goto parse_error;
> > +
> > +	sys_event = argv[1];
> > +	ret = traceprobe_parse_event_name(&sys_event, &sys_name, buf2,
> > +					  sys_event - argv[1]);
> > +	if (ret || !sys_name)
> > +		goto parse_error;
> > +	if (!is_good_name(sys_event) || !is_good_name(sys_name))
> > +		goto parse_error;
> > +
> > +	mutex_lock(&event_mutex);
> > +	event_call = find_and_get_event(sys_name, sys_event);
> > +	ep = alloc_event_probe(group, event, event_call, argc - 2);
> > +	mutex_unlock(&event_mutex);
> > +
> > +	if (IS_ERR(ep)) {
> > +		ret = PTR_ERR(ep);
> > +		/* This must return -ENOMEM, else there is a bug */
> > +		WARN_ON_ONCE(ret != -ENOMEM);
> > +		goto error;	/* We know ep is not allocated */
> > +	}
> > +
> > +	argc -= 2; argv += 2;
> > +	/* parse arguments */
> > +	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
> > +		ret = trace_eprobe_tp_update_arg(ep, argv, i);
> > +		if (ret)
> > +			goto error;
> > +	}
> > +	ret = traceprobe_set_print_fmt(&ep->tp, PROBE_PRINT_EVENT);
> > +	if (ret < 0)
> > +		goto error;
> > +	init_trace_eprobe_call(ep);
> > +	mutex_lock(&event_mutex);  
> 
> Here, you don't check the event name collision. Since the kprobe event
> supports multiprobe event, it checks the collision by itself.
> See register_trace_kprobe().
> BTW, I found another issue on the name collision. Let me fix it.

I'm thinking of adding this above before taking the event_mutex:

	/* Check if the name already exists */
	if (find_event_probe(group, event))
		return -EEXIST;

Where I have:

static bool find_event_probe(const char *group, const char *event)
{
	struct dyn_event *ev;
	struct trace_eprobe *ep;

	for_each_dyn_event(ev) {
		if (ev->ops != &eprobe_dyn_event_ops)
			continue;
		
		ep = to_trace_eprobe(ev);
		if (strcmp(ep->tp.event->class.system, group) == 0 &&
		    strcmp(ep->tp.event->call.name, event) == 0)
			return true;
	}
	return false;
}

Cheers,

-- Steve


> 
> > +	ret = trace_probe_register_event_call(&ep->tp);
> > +	if (ret) {
> > +		mutex_unlock(&event_mutex);
> > +		goto error;
> > +	}
> > +	ret = dyn_event_add(&ep->devent, &ep->tp.event->call);
> > +	mutex_unlock(&event_mutex);
> > +	return ret;
> > +parse_error:
> > +	ret = -EINVAL;
> > +error:
> > +	trace_event_probe_cleanup(ep);
> > +	return ret;
> > +}  
> 
> Thank you,

