Return-Path: <SRS0=Tl+h=JW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50633 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932569AbeGFMq5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jul 2018 08:46:57 -0400
Received: by mail-wm0-f66.google.com with SMTP id v25-v6so14816452wmc.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Jul 2018 05:46:57 -0700 (PDT)
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180703162432.316240087@goodmis.org>
 <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
 <20180705180544.7210caad@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <415f299e-9cb1-5044-927f-0a653bf0b356@gmail.com>
Date: Fri, 6 Jul 2018 15:46:54 +0300
MIME-Version: 1.0
In-Reply-To: <20180705180544.7210caad@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  6.07.2018 01:05, Steven Rostedt wrote:
> On Wed, 4 Jul 2018 14:39:01 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>>    /**
>>>     * @brief Load the content of the trace data file into an array of
>>>     *	  kshark_entries. This function provides fast loading, however the
>>
>> Actually , after applying the patch for trace-input.c and this patch on
>> top kshark_load_data_entries() becomes slower than
>> kshark_load_data_records(). Just make this clear in the description of
>> the functions.
>>
>>> @@ -521,9 +587,11 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>>>    				struct kshark_entry ***data_rows)
> 
> In my tests, it showed a 30% slowdown. I really didn't like that. So I
> looked at why it was so slow, and it appeared two fold. One, was that I
> was doing a double allocation (allocating for both the rec_list and the
> entry), the other was that holding on to all records still appeared to
> slow things down a bit. Even with the array of storage, it made it
> slow.
> 
> I decided to make it closer to the original but still with helper
> functions. The key was modifying the struct rec_list to be:
> 
> struct rec_list {
> 	union {
> 		struct kshark_entry		entry;
> 		struct {
> 			struct rec_list		*next; /* Matches entry->next */
> 			struct pevent_record	*rec;
> 		};
> 	};
> };
> 
> And creating a enum:
> 
> enum rec_type {
> 	REC_RECORD,
> 	REC_ENTRY,
> };
> 
> 
> That would allow the functions to know what type it was dealing with.
> Will this change affect your numpy work much? You can add a REC_NUMPY
> if needed.
> 
> Try it out and see if it improves things on your end:
> 
I really like this solution. And yes, it improvises the performance.


> Oh, and I pushed my patches.
> 
> -- Steve
> 
> Index: trace-cmd.git/kernel-shark-qt/src/libkshark.c
> ===================================================================
> --- trace-cmd.git.orig/kernel-shark-qt/src/libkshark.c
> +++ trace-cmd.git/kernel-shark-qt/src/libkshark.c
> @@ -503,12 +503,23 @@ static void kshark_set_entry_values(stru
>   /* Quiet warnings over documenting simple structures */
>   //! @cond Doxygen_Suppress
>   struct rec_list {
> -	struct pevent_record	*rec;
> -	struct rec_list		*next;
> +	union {
> +		struct kshark_entry		entry;
> +		struct {
> +			struct rec_list		*next; /* Matches entry->next */
> +			struct pevent_record	*rec;
> +		};
> +	};
>   };
>   //! @endcond
>   
> -static void free_rec_list(struct rec_list **rec_list, int n_cpus)
> +enum rec_type {
> +	REC_RECORD,
> +	REC_ENTRY,
> +};
> +
> +static void free_rec_list(struct rec_list **rec_list, int n_cpus,
> +			  enum rec_type type)
>   {
>   	struct rec_list *temp_rec;
>   	int cpu;
> @@ -517,7 +528,8 @@ static void free_rec_list(struct rec_lis
>   		while (rec_list[cpu]) {
>   			temp_rec = rec_list[cpu];
>   			rec_list[cpu] = temp_rec->next;
> -			free_record(temp_rec->rec);
> +			if (type == REC_RECORD)
> +				free_record(temp_rec->rec);
>   			free(temp_rec);
>   		}
>   	}
> @@ -525,8 +537,9 @@ static void free_rec_list(struct rec_lis
>   }
>   
>   static size_t get_records(struct kshark_context *kshark_ctx,
> -			  struct rec_list ***rec_list)
> +			  struct rec_list ***rec_list, enum rec_type type)
>   {
> +	struct event_filter *adv_filter = NULL;
>   	struct pevent_record *rec;
>   	struct rec_list **temp_next;
>   	struct rec_list **cpu_list;
> @@ -547,12 +560,50 @@ static size_t get_records(struct kshark_
>   
>   		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
>   		while (rec) {
> -			*temp_next = temp_rec = malloc(sizeof(*temp_rec));
> +			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
>   			if (!temp_rec)
>   				goto fail;
>   
> -			temp_rec->rec = rec;
>   			temp_rec->next = NULL;
> +
> +			switch (type) {
> +			case REC_RECORD:
> +				temp_rec->rec = rec;
> +				break;
> +			case REC_ENTRY: {
> +				struct kshark_task_list *task;
> +				struct kshark_entry *entry;
> +				int ret;
> +
> +				if (!adv_filter)
> +					adv_filter = kshark_ctx->advanced_event_filter;

I defined "adv_filter" just as a short version of 
"kshark_ctx->advanced_event_filter", because of the 80 columns limit on 
the length of lines. You can move this outside of the while() loop;

> +				entry = &temp_rec->entry;
> +				kshark_set_entry_values(kshark_ctx, rec, entry);

Maybe the call of kshark_add_task() can be moved to 
kshark_load_data_entries()
Just to be consistent with kshark_load_data_records()

> +				task = kshark_add_task(kshark_ctx, entry->pid);
> +				if (!task) {
> +					free_record(rec);
> +					goto fail;
> +				}
> +
> +				/* Apply event filtering. */
> +				ret = FILTER_NONE;

Opps, I made a bug here. It has to be
				ret = FILTER_MATCH;

> +				if (adv_filter->filters)
> +					ret = pevent_filter_match(adv_filter, rec);
> +
> +				if (!kshark_show_event(kshark_ctx, entry->event_id) ||
> +				    ret != FILTER_MATCH) {
> +					unset_event_filter_flag(kshark_ctx, entry);
> +				}
> +
> +				/* Apply task filtering. */
> +				if (!kshark_show_task(kshark_ctx, entry->pid)) {
> +					entry->visible &= ~kshark_ctx->filter_mask;
> +				}
> +				free_record(rec);
> +				break;
> +			} /* REC_ENTRY */
> +			}
> +
>   			temp_next = &temp_rec->next;
>   
>   			++count;
> @@ -566,13 +617,15 @@ static size_t get_records(struct kshark_
>   	return total;
>   
>    fail:
> -	free_rec_list(cpu_list, n_cpus);
> +	free_rec_list(cpu_list, n_cpus, type);
>   	return -ENOMEM;
>   }
>   

[..]

>   
> Index: trace-cmd.git/kernel-shark-qt/src/libkshark.h
> ===================================================================
> --- trace-cmd.git.orig/kernel-shark-qt/src/libkshark.h
> +++ trace-cmd.git/kernel-shark-qt/src/libkshark.h
> @@ -33,6 +33,9 @@ extern "C" {
>    * info etc.) is available on-demand via the offset into the trace file.
>    */
>   struct kshark_entry {
> +	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
> +	struct kshark_entry *next; /* MUST BE FIRST ENTRY */
> +
Correct, thanks!

Yordan

>   	/**
>   	 * A bit mask controlling the visibility of the entry. A value of OxFF
>   	 * would mean that the entry is visible everywhere. Use
> @@ -60,9 +63,6 @@ struct kshark_entry {
>   	 * started.
>   	 */
>   	uint64_t	ts;
> -
> -	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
> -	struct kshark_entry *next;
>   };
>   
>   /** Size of the task's hash table. */
> 
