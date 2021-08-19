Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1791C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 12:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFF161152
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 12:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhHSMya (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhHSMy3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 08:54:29 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E79C16112D;
        Thu, 19 Aug 2021 12:53:52 +0000 (UTC)
Date:   Thu, 19 Aug 2021 08:53:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: Re: [PATCH v7 08/10] tracing: Add a probe that attaches to trace
 events
Message-ID: <20210819085346.414aa10f@oasis.local.home>
In-Reply-To: <20210819192258.7e39bafa8084417d96a8244e@kernel.org>
References: <20210819041321.105110033@goodmis.org>
        <20210819041842.485382601@goodmis.org>
        <20210819192258.7e39bafa8084417d96a8244e@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Aug 2021 19:22:58 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Hi Steve,
> 
> Thanks for updating.
> 
> On Thu, 19 Aug 2021 00:13:29 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +static bool find_event_probe(const char *group, const char *event)
> > +{
> > +	struct trace_eprobe *ep;
> > +	struct dyn_event *ev;
> > +	bool ret = false;
> > +
> > +	/*
> > +	 * Must grab the event_mutex to prevent the list from being modified
> > +	 * by other probes. But the event_probe being only created via the
> > +	 * dynamic_events file, is only added under the dyn_event_ops_mutex,
> > +	 * which is currently held. There is no race between this check and
> > +	 * adding the new probe.  
> 
> This is not correct, as I said in the previous mail. The dynamic event has

Actually the above is correct, because it states that it wont race with
another event probe. You are correct in that it does not protect
against racing against other events. And if you look at the check
below, it only looks at eprobes:

	if (ev->ops != &eprobe_dyn_event_ops)
		continue;

> 2 lists, one is for the "kind of" dynamic event (dyn_event_ops), and
> the other one is for the dynamic events itself. The "dyn_event_ops_mutex"
> is protecting only "dyn_event_ops", and the dynamic event list is ptotected
> by the "event_mutex". (This is described in the trace_dynevent.c)
> So holding event_mutex is correct.
> 
> > +	 */
> > +	mutex_lock(&event_mutex);
> > +	for_each_dyn_event(ev) {
> > +		if (ev->ops != &eprobe_dyn_event_ops)
> > +			continue;
> > +		ep = to_trace_eprobe(ev);
> > +		if (strcmp(ep->tp.event->class.system, group) == 0 &&
> > +		    strcmp(ep->tp.event->call.name, event) == 0) {
> > +			ret = true;
> > +			break;
> > +		}
> > +	}
> > +	mutex_lock(&event_mutex);
> > +
> > +	return ret;
> > +}
> > +
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
> > +	if (argc < 2 || argv[0][0] != 'e')
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
> > +	/* Check if the name already exists */
> > +	if (find_event_probe(group, event))
> > +		return -EEXIST;  
> 
> Hmm, there is a window between checking the name confliction here, ...

For non eprobes, you are correct.

> 
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
> > +		trace_probe_log_set_index(i + 2);
> > +		ret = trace_eprobe_tp_update_arg(ep, argv, i);
> > +		if (ret)
> > +			goto error;
> > +	}
> > +	ret = traceprobe_set_print_fmt(&ep->tp, PROBE_PRINT_EVENT);
> > +	if (ret < 0)
> > +		goto error;
> > +	init_trace_eprobe_call(ep);
> > +	mutex_lock(&event_mutex);
> > +	ret = trace_probe_register_event_call(&ep->tp);
> > +	if (ret) {
> > +		mutex_unlock(&event_mutex);
> > +		goto error;
> > +	}  
> 
> ... and register it here.
> 
> Between the existance check and the registration, someone can register
> same name event probe. So I recommend you to do it as;

Actually they can't because eprobes are only created by this function,
and this is only called by trace_dynevent.c:

static int create_dyn_event(const char *raw_command)
{
	struct dyn_event_operations *ops;
	int ret = -ENODEV;

	if (raw_command[0] == '-' || raw_command[0] == '!')
		return dyn_event_release(raw_command, NULL);

	mutex_lock(&dyn_event_ops_mutex); <===================	Lock taken here
	list_for_each_entry(ops, &dyn_event_ops_list, list) {
		ret = ops->create(raw_command); <=============	This function called here
		if (!ret || ret != -ECANCELED)
			break;
	}
	mutex_unlock(&dyn_event_ops_mutex); <=================	Lock released
	if (ret == -ECANCELED)
		ret = -EINVAL;

	return ret;
}

But kprobes and uprobes can be created outside this loop.

So my current logic protects against duplicate eprobes, but does not
protect against kprobes or uprobes with the same name.


> 
> static int register_event_probe(ep)
> {
> 	init_trace_eprobe_call(ep);
> 	mutex_lock(&event_mutex);
> 	if (find_event_probe(group, event))
> 		ret = -EEXIST;
> 		goto out;
> 	}
> 
> 	ret = trace_probe_register_event_call(&ep->tp);
> 	if (ret)
> 		goto out;
> 	ret = dyn_event_add(&ep->devent, &ep->tp.event->call);
> 	mutex_unlock(&event_mutex);
> out:
> 	return ret;
> }
> 
> Anyway, I will send a patch for fixing related issue. If you don't care
> the name collision between eprobes or other events, you can just apply it.
> Then trace_probe_register_event_call() will reject the same name event.

Thanks, I'll take a look at it, and try to incorporate it.

I'll pull in all the patches that you have already acked into my
linux-next queue, and then only send out those that are still under
review.

-- Steve
