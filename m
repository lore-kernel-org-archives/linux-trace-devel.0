Return-Path: <SRS0=h7mL=QS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB01C169C4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 15:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9CD0222A7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 15:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732723AbfBKPoP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:44:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732902AbfBKOoq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Feb 2019 09:44:46 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07BE220700;
        Mon, 11 Feb 2019 14:44:44 +0000 (UTC)
Date:   Mon, 11 Feb 2019 09:44:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/4] kernel-shark: Consolidate duplicate code of the
 sched_wakeup events
Message-ID: <20190211094433.296d3beb@gandalf.local.home>
In-Reply-To: <9c610142-ee8d-5801-6077-33d7d39acaf9@vmware.com>
References: <20190211011807.714634783@goodmis.org>
        <20190211012153.982548008@goodmis.org>
        <9c610142-ee8d-5801-6077-33d7d39acaf9@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Feb 2019 08:53:16 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

Hi Yordan,

Thanks for reviewing, you pointed out things I expected you to ;-)

> > @@ -139,17 +150,51 @@ static void plugin_register_command(struct kshark_context *kshark_ctx,
> >   			tep_register_comm(kshark_ctx->pevent, comm, pid);
> >   }
> >   
> > -static int plugin_get_rec_wakeup_new_pid(struct tep_record *record)  
> 
> This patch silently removes the "plugin_get_rec_wakeup_new_pid()" 
> function which is the equivalent of "plugin_get_rec_wakeup_pid()", but 
> for "wakeup_new" events. I guess, you are removing 
> "plugin_get_rec_wakeup_new_pid()" here, because it is defined static but 
> in fact there is no reason for "plugin_get_rec_wakeup_pid()" being 
> non-static (this is my mistake). So just to keep everything consistent, 
> please do the removal of "plugin_get_rec_wakeup_new_pid()" in the next 
> patch (together with the removal of "plugin_get_rec_wakeup_pid()").
> 

Actually, I didn't really silently remove it. Without removing it, gcc
would complain that there's a static function not being used, and
that's a no-no for a patch to cause a new warning. It's fine to remove
static functions when removing their users in the code that is being
modified.

Now, I would have also removed plugin_get_rec_wakeup_pid(), but because
that's a global function, it doesn't cause the warning, and may also be
possibly used outside of that file (and by code I'm not working with).

That's why I removed the static one here. It's required because without
doing so, it causes gcc to generate a warning. And the reason for
removing the other function was because it is global outside of the
code that I changed, which requires a separate patch. Now if both were
global, I would be able to remove them together in a separate patch, or
if both were static, I would have removed both here. But since one's
global and one's static, they need to be removed in separate places.

Make sense?

> 
> > +int find_wakeup_pid(struct kshark_context *kshark_ctx, struct kshark_entry *e,
> > +		    struct tep_event *wakeup_event, struct tep_format_field *pid_field)
> >   {
> > -	struct plugin_sched_context *plugin_ctx =
> > -		plugin_sched_context_handler;
> > +	struct tep_record *record;
> >   	unsigned long long val;
> >   	int ret;
> >   
> > -	ret = tep_read_number_field(plugin_ctx->sched_wakeup_new_pid_field,
> > -				    record->data, &val);
> > +	if (!wakeup_event || e->event_id != wakeup_event->id)
> > +		return -1;
> >   
> > -	return ret ? : val;
> > +	record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
> > +	ret = tep_read_number_field(pid_field, record->data, &val);
> > +	free_record(record);
> > +
> > +	if (ret)
> > +		return -1;
> > +
> > +	return val;
> > +}
> > +
> > +static bool wakeup_match_rec_pid(struct plugin_sched_context *plugin_ctx,
> > +				 struct kshark_context *kshark_ctx,
> > +				 struct kshark_entry *e,
> > +				 int pid)
> > +{
> > +	struct tep_event *wakeup_events[] = {
> > +		plugin_ctx->sched_wakeup_event,
> > +		plugin_ctx->sched_wakeup_new_event,
> > +	};
> > +	struct tep_format_field *wakeup_fields[] = {
> > +		plugin_ctx->sched_wakeup_pid_field,
> > +		plugin_ctx->sched_wakeup_new_pid_field,
> > +	};
> > +	int i, wakeup_pid = -1;
> > +
> > +	for (i = 0; i < sizeof(wakeup_events) / sizeof(wakeup_events[0]); i++) {
> > +		wakeup_pid = find_wakeup_pid(kshark_ctx, e, wakeup_events[i], wakeup_fields[i]);
> > +		if (wakeup_pid >= 0)
> > +			break;
> > +	}
> > +
> > +	if (wakeup_pid >= 0 && wakeup_pid == pid)
> > +		return true;
> > +
> > +	return false;
> >   }
> >   
> >   /**
> > @@ -168,31 +213,12 @@ bool plugin_wakeup_match_rec_pid(struct kshark_context *kshark_ctx,
> >   				 int pid)
> >   {
> >   	struct plugin_sched_context *plugin_ctx;
> > -	struct tep_record *record = NULL;
> > -	int wakeup_pid = -1;
> >   
> >   	plugin_ctx = plugin_sched_context_handler;
> >   	if (!plugin_ctx)
> >   		return false;
> >   
> > -	if (plugin_ctx->sched_wakeup_event &&
> > -	    e->event_id == plugin_ctx->sched_wakeup_event->id) {
> > -		record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
> > -		wakeup_pid = plugin_get_rec_wakeup_pid(record);
> > -	}
> > -
> > -	if (plugin_ctx->sched_wakeup_new_event &&
> > -	    e->event_id == plugin_ctx->sched_wakeup_new_event->id) {
> > -		record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
> > -		wakeup_pid = plugin_get_rec_wakeup_new_pid(record);
> > -	}
> > -
> > -	free_record(record);
> > -
> > -	if (wakeup_pid >= 0 && wakeup_pid == pid)
> > -		return true;
> > -
> > -	return false;
> > +	return wakeup_match_rec_pid(plugin_ctx, kshark_ctx, e, pid);
> >   }
> >  
> 
> I see no point in defining "static bool wakeup_match_rec_pid()" and then 
> having "plugin_wakeup_match_rec_pid()" which is doing nothing but just 
> calling this static function.

It's because of the initialization of wakeup_events and wakeup_fields.

	struct tep_event *wakeup_events[] = {
		plugin_ctx->sched_waking_event,
		plugin_ctx->sched_wakeup_event,
		plugin_ctx->sched_wakeup_new_event,
	};
	struct tep_format_field *wakeup_fields[] = {
		plugin_ctx->sched_waking_pid_field,
		plugin_ctx->sched_wakeup_pid_field,
		plugin_ctx->sched_wakeup_new_pid_field,
	};

Which are initialized by the values in plugin_ctx, but plugin_ctx is
not initialized until after the static is set up:

	plugin_ctx = plugin_sched_context_handler;
	if (!plugin_ctx)
		return false;

Thus to handle this case, I simply moved the code into a helper
function, and had the main function just initialize plugin_ctx (return
if NULL), and then call the helper function that can initialize the
arrays on the stack.

Make sense?

-- Steve


> 
> Everything else in this patch series is OK.
> 
> Thank you very much!
> Yordan
> 
> 
> Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> 
> 
> >   /**
> >   

