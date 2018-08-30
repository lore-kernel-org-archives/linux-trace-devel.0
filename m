Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbeH3Swz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 14:52:55 -0400
Date: Thu, 30 Aug 2018 10:50:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 7/7] kernel-shark-qt: Add a plugin for sched events.
Message-ID: <20180830105021.635cbf37@gandalf.local.home>
In-Reply-To: <20180829224312.25c7a16e@vmware.local.home>
References: <20180829164224.20677-1-y.karadz@gmail.com>
        <20180829164224.20677-8-y.karadz@gmail.com>
        <20180829224312.25c7a16e@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 29 Aug 2018 22:43:12 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

 +				      const struct kshark_entry *e)
> > +{
> > +	struct plugin_sched_context *plugin_ctx;
> > +	struct tep_record *record;
> > +	unsigned long long val;
> > +
> > +	plugin_ctx = plugin_sched_context_handler;
> > +	record = kshark_read_at(kshark_ctx, e->offset);
> > +
> > +	tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
> > +				 record->data, &val);
> > +	free(record);  
> 
> Records must be freed with:
> 
> 	free_record(record);
> 
> Which also looks like we missed a function that needs to be converted.
> tep_free_record()?

Actually I'm wrong here. Although it should be renamed, but not
tep_free_record(), but tracecmd_free_record() because kshark_read_at()
calls tracecmd_read_at() not tep_read_at(). And "free_record()" is part
of the libtracecmd library not libtraceevent.

Nothing needs to be done about this now.

Sorry for the noise, Ceco.

-- Steve

> 
> or should we have it be free_tep_record(), although, I'm not sure I
> like this breaking from the prefix way.
> 
