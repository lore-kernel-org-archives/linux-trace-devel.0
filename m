Return-Path: <SRS0=lN8X=JV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:60578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753521AbeGEQfM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jul 2018 12:35:12 -0400
Date: Thu, 5 Jul 2018 12:35:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
Message-ID: <20180705123509.26f1c0c9@gandalf.local.home>
In-Reply-To: <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
References: <20180703162432.316240087@goodmis.org>
        <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 4 Jul 2018 14:39:01 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

Your comment actually had me re-examine the code, and I found a bug.

> >   
> > +struct rec_list {
> > +	struct pevent_record	*rec;
> > +	struct rec_list		*next;
> > +};
> > +
> > +static void free_rec_list(struct rec_list **rec_list, int n_cpus)
> > +{
> > +	struct rec_list *temp_rec;
> > +	int cpu;
> > +
> > +	for (cpu = 0; cpu < n_cpus; ++cpu) {
> > +		while (rec_list[cpu]) {
> > +			temp_rec = rec_list[cpu];
> > +			rec_list[cpu] = temp_rec->next;

I need a:

			free_record(temp_rec->rec);


> > +			free(temp_rec);
> > +		}
> > +	}
> > +	free(rec_list);
> > +}
> > +


> > @@ -521,9 +587,11 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
> >   				struct kshark_entry ***data_rows)
> >   {
> >   	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
> > -	struct kshark_entry **cpu_list, **rows;
> > -	struct kshark_entry *entry, **next;
> >   	struct kshark_task_list *task;
> > +	struct kshark_entry **rows;
> > +	struct kshark_entry *entry;
> > +	struct rec_list **rec_list;
> > +	struct rec_list *temp_rec;
> >   	struct pevent_record *rec;
> >   	int cpu, n_cpus, next_cpu;
> >   	size_t count, total = 0;
> > @@ -533,24 +601,41 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
> >   	if (*data_rows)
> >   		free(*data_rows);
> >   
> > +	total = get_records(kshark_ctx, &rec_list);
> > +	if (total < 0)
> > +		goto fail;
> > +
> > +	rows = calloc(total, sizeof(struct kshark_entry *));
> > +	if(!rows)
> > +		goto fail;
> > +
> >   	n_cpus = tracecmd_cpus(kshark_ctx->handle);
> > -	cpu_list = calloc(n_cpus, sizeof(struct kshark_entry *));
> >   
> > -	for (cpu = 0; cpu < n_cpus; ++cpu) {
> > -		count = 0;
> > -		cpu_list[cpu] = NULL;
> > -		next = &cpu_list[cpu];
> > +	for (count = 0; count < total; count++) {
> > +		ts = 0;
> > +		next_cpu = -1;
> > +		for (cpu = 0; cpu < n_cpus; ++cpu) {
> > +			if (!rec_list[cpu])
> > +				continue;
> >   
> > -		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
> > -		while (rec) {
> > -			*next = entry = malloc(sizeof(struct kshark_entry));
> > +			if (!ts || rec_list[cpu]->rec->ts < ts) {
> > +				ts = rec_list[cpu]->rec->ts;
> > +				next_cpu = cpu;
> > +			}
> > +		}
> > +
> > +		if (next_cpu >= 0) {
> > +			entry = malloc(sizeof(struct kshark_entry));
> >   			if (!entry)
> > -				goto fail;
> > +				goto fail_free;
> > +
> > +			rec = rec_list[next_cpu]->rec;
> > +			rows[count] = entry;
> >   
> >   			kshark_set_entry_values(kshark_ctx, rec, entry);
> >   			task = kshark_add_task(kshark_ctx, entry->pid);
> >   			if (!task)
> > -				goto fail;
> > +				goto fail_free;
> >   
> >   			/* Apply event filtering. */
> >   			ret = FILTER_NONE;
> > @@ -567,47 +652,26 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
> >   				entry->visible &= ~kshark_ctx->filter_mask;
> >   			}
> >   
> > -			entry->next = NULL;
> > -			next = &entry->next;
> > +			temp_rec = rec_list[next_cpu];
> > +			rec_list[next_cpu] = rec_list[next_cpu]->next;
> > +			free(temp_rec);

I should add a comment here:

			/* The record will no longer be referenced */

> >   			free_record(rec);
> > -
> > -			++count;
> > -			rec = tracecmd_read_data(kshark_ctx->handle, cpu);
> > -		}
> > -
> > -		total += count;
> > -	}
> > -
> > -	rows = calloc(total, sizeof(struct kshark_entry *));
> > -	if (!rows)
> > -		goto fail;
> > -
> > -	count = 0;
> > -	while (count < total) {
> > -		ts = 0;
> > -		next_cpu = -1;
> > -		for (cpu = 0; cpu < n_cpus; ++cpu) {
> > -			if (!cpu_list[cpu])
> > -				continue;
> > -
> > -			if (!ts || cpu_list[cpu]->ts < ts) {
> > -				ts = cpu_list[cpu]->ts;
> > -				next_cpu = cpu;
> > -			}
> > -		}
> > -
> > -		if (next_cpu >= 0) {
> > -			rows[count] = cpu_list[next_cpu];
> > -			cpu_list[next_cpu] = cpu_list[next_cpu]->next;
> >   		}
> > -		++count;
> >   	}
> >   
> > -	free(cpu_list);
> > +	free_rec_list(rec_list, n_cpus);
> >   	*data_rows = rows;
> >   	return total;
> >   
> > -fail:
> > + fail_free:
> > +	free_rec_list(rec_list, n_cpus);
> > +	for (count = 0; count < total; count++) {
> > +		if (!rows[count])
> > +			break;
> > +		free(rows[count]);
> > +	}
> > +	free(rows);
> > + fail:
> >   	fprintf(stderr, "Failed to allocate memory during data loading.\n");
> >   	return -ENOMEM;
> >   }
> > @@ -625,82 +689,60 @@ fail:
> >   ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
> >   				struct pevent_record ***data_rows)
> >   {

[..]

> >   	rows = calloc(total, sizeof(struct pevent_record *));
> > -	if (!rows)
> > +	if(!rows)
> >   		goto fail;
> >   
> > -	count = 0;
> > -	while (count < total) {
> > +	n_cpus = tracecmd_cpus(kshark_ctx->handle);
> > +
> > +	for (count = 0; count < total; count++) {
> >   		ts = 0;
> >   		next_cpu = -1;
> >   		for (cpu = 0; cpu < n_cpus; ++cpu) {
> > -			if (!cpu_list[cpu])
> > +			if (!rec_list[cpu])
> >   				continue;
> >   
> > -			if (!ts || cpu_list[cpu]->rec->ts < ts) {
> > -				ts = cpu_list[cpu]->rec->ts;
> > +			if (!ts || rec_list[cpu]->rec->ts < ts) {
> > +				ts = rec_list[cpu]->rec->ts;
> >   				next_cpu = cpu;
> >   			}
> >   		}
> >   
> >   		if (next_cpu >= 0) {
> > -			rows[count] = cpu_list[next_cpu]->rec;
> > -			temp_rec = cpu_list[next_cpu];
> > -			cpu_list[next_cpu] = cpu_list[next_cpu]->next;
> > -			free (temp_rec);
> > -		}
> > +			rec = rec_list[next_cpu]->rec;
> > +			rows[count] = rec;
> >   
> > -		++count;
> > +			pid = pevent_data_pid(kshark_ctx->pevent, rec);
> > +			task = kshark_add_task(kshark_ctx, pid);
> > +			if (!task)
> > +				goto fail;
> > +
> > +			temp_rec = rec_list[next_cpu];
> > +			rec_list[next_cpu] = rec_list[next_cpu]->next;
> > +			free(temp_rec);
> > +			free_record(rec);  
> 
> You have to free only the element of the list.
> The user is responsible for freeing the record.

Right! And I'll replace that with a comment:

			/* The record is still referenced in rows */

Thanks for the review.

-- Steve

> 
> > +		}
> >   	}
> >   
> > -	free(cpu_list);
> > +	free_rec_list(rec_list, n_cpus);
> >   	*data_rows = rows;
> >   	return total;
> >   
> > -fail:
> > + fail:
> >   	fprintf(stderr, "Failed to allocate memory during data loading.\n");
> >   	return -ENOMEM;
> >   }
> >   
