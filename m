Return-Path: <SRS0=Tl+h=JW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:53410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933740AbeGFSVG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jul 2018 14:21:06 -0400
Date: Fri, 6 Jul 2018 14:21:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
Message-ID: <20180706142104.42fa4e36@gandalf.local.home>
In-Reply-To: <415f299e-9cb1-5044-927f-0a653bf0b356@gmail.com>
References: <20180703162432.316240087@goodmis.org>
        <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
        <20180705180544.7210caad@gandalf.local.home>
        <415f299e-9cb1-5044-927f-0a653bf0b356@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 6 Jul 2018 15:46:54 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> >   static size_t get_records(struct kshark_context *kshark_ctx,
> > -			  struct rec_list ***rec_list)
> > +			  struct rec_list ***rec_list, enum rec_type type)
> >   {
> > +	struct event_filter *adv_filter = NULL;
> >   	struct pevent_record *rec;
> >   	struct rec_list **temp_next;
> >   	struct rec_list **cpu_list;
> > @@ -547,12 +560,50 @@ static size_t get_records(struct kshark_
> >   
> >   		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
> >   		while (rec) {
> > -			*temp_next = temp_rec = malloc(sizeof(*temp_rec));
> > +			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
> >   			if (!temp_rec)
> >   				goto fail;
> >   
> > -			temp_rec->rec = rec;
> >   			temp_rec->next = NULL;
> > +
> > +			switch (type) {
> > +			case REC_RECORD:
> > +				temp_rec->rec = rec;
> > +				break;
> > +			case REC_ENTRY: {
> > +				struct kshark_task_list *task;
> > +				struct kshark_entry *entry;
> > +				int ret;
> > +
> > +				if (!adv_filter)
> > +					adv_filter = kshark_ctx->advanced_event_filter;  
> 
> I defined "adv_filter" just as a short version of 
> "kshark_ctx->advanced_event_filter", because of the 80 columns limit on 
> the length of lines. You can move this outside of the while() loop;

I didn't want to put it outside the loop, because I didn't want it to
be required for REC_RECORD. But I think outside the loop, I can just do:

	if (type == REC_ENTRY)
		adv_filter = ....

> 
> > +				entry = &temp_rec->entry;
> > +				kshark_set_entry_values(kshark_ctx, rec, entry);  
> 
> Maybe the call of kshark_add_task() can be moved to 
> kshark_load_data_entries()
> Just to be consistent with kshark_load_data_records()

The problem is that "rec" is freed. That was required as part of the
speed up.

> 
> > +				task = kshark_add_task(kshark_ctx, entry->pid);
> > +				if (!task) {
> > +					free_record(rec);
> > +					goto fail;
> > +				}
> > +
> > +				/* Apply event filtering. */
> > +				ret = FILTER_NONE;  
> 
> Opps, I made a bug here. It has to be
> 				ret = FILTER_MATCH;

Can you send a patch. I don't want this to be a fix. That should be a
separate patch.


> 
> > +				if (adv_filter->filters)
> > +					ret = pevent_filter_match(adv_filter, rec);
> > +
> > +				if (!kshark_show_event(kshark_ctx, entry->event_id) ||
> > +				    ret != FILTER_MATCH) {
> > +					unset_event_filter_flag(kshark_ctx, entry);
> > +				}
> > +
> > +				/* Apply task filtering. */
> > +				if (!kshark_show_task(kshark_ctx, entry->pid)) {
> > +					entry->visible &= ~kshark_ctx->filter_mask;
> > +				}
> > +				free_record(rec);
> > +				break;
> > +			} /* REC_ENTRY */
> > +			}
> > +
> >   			temp_next = &temp_rec->next;
> >   
> >   			++count;
> > @@ -566,13 +617,15 @@ static size_t get_records(struct kshark_
> >   	return total;
> >   
> >    fail:
> > -	free_rec_list(cpu_list, n_cpus);
> > +	free_rec_list(cpu_list, n_cpus, type);
> >   	return -ENOMEM;
> >   }
> >     
> 
> [..]
> 
> >   
> > Index: trace-cmd.git/kernel-shark-qt/src/libkshark.h
> > ===================================================================
> > --- trace-cmd.git.orig/kernel-shark-qt/src/libkshark.h
> > +++ trace-cmd.git/kernel-shark-qt/src/libkshark.h
> > @@ -33,6 +33,9 @@ extern "C" {
> >    * info etc.) is available on-demand via the offset into the trace file.
> >    */
> >   struct kshark_entry {
> > +	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
> > +	struct kshark_entry *next; /* MUST BE FIRST ENTRY */
> > +  
> Correct, thanks!

Yep, this is a common trick I use.

-- Steve

> 
> Yordan
> 
> >   	/**
> >   	 * A bit mask controlling the visibility of the entry. A value of OxFF
> >   	 * would mean that the entry is visible everywhere. Use
> > @@ -60,9 +63,6 @@ struct kshark_entry {
> >   	 * started.
> >   	 */
> >   	uint64_t	ts;
> > -
> > -	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
> > -	struct kshark_entry *next;
> >   };
> >   
> >   /** Size of the task's hash table. */
> >   
