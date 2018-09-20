Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbeITTd3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 15:33:29 -0400
Date: Thu, 20 Sep 2018 09:49:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] kernel-shark-qt: Add Plugin event handlers to
 session.
Message-ID: <20180920094952.151f38a5@gandalf.local.home>
In-Reply-To: <b5cbf76c-38d1-0c88-d455-18ba9833dcb2@gmail.com>
References: <20180919143657.19472-1-y.karadz@gmail.com>
        <20180919143657.19472-3-y.karadz@gmail.com>
        <20180919232432.52be5d1b@vmware.local.home>
        <b5cbf76c-38d1-0c88-d455-18ba9833dcb2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 20 Sep 2018 16:29:00 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 20.09.2018 06:24, Steven Rostedt wrote:
> >> static size_t get_records(struct kshark_context *kshark_ctx,
> >>   			  struct rec_list ***rec_list, enum rec_type type)
> >>   {
> >> +	struct kshark_event_handler *evt_handler;
> >>   	struct event_filter *adv_filter;
> >>   	struct kshark_task_list *task;
> >>   	struct tep_record *rec;
> >> @@ -608,6 +618,17 @@ static size_t get_records(struct kshark_context *kshark_ctx,
> >>   
> >>   				entry = &temp_rec->entry;
> >>   				kshark_set_entry_values(kshark_ctx, rec, entry);
> >> +
> >> +				/* Execute all plugin-provided actions (if any). */
> >> +				evt_handler = kshark_ctx->event_handlers;
> >> +				while ((evt_handler = find_event_handler(evt_handler,
> >> +									 entry->event_id))) {
> >> +					evt_handler->event_func(kshark_ctx, rec, entry);
> >> +
> >> +					if ((evt_handler = evt_handler->next))  
> > Please break the above if, to remove the assignment. It's just easier
> > to read. That is:
> > 
> > 					event_handler = event_hanndler->next;
> > 					if (event_handler)  
> >> +						entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
> >> +				}
> >> +  
> 
> Actually this is a bug (typo). I meant to have

 :-)

That's actually one of the reasons the combination is looked down upon
in the Linux kernel. It's more likely to hide bugs from reviewers.

-- Steve

> 
> 					evt_handler = evt_handler->next;
> 					if (!evt_handler)
> 						entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
> 
> This way the KS_PLUGIN_UNTOUCHED flag gets unset only once and it is 
> guaranteed that the value of the bit cannot be changed by the plugin 
> callback function.
> 
