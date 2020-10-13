Return-Path: <SRS0=fnsP=DU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65268C433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Oct 2020 03:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1910420714
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Oct 2020 03:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgJMDMX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 23:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgJMDMX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 23:12:23 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7548206E5;
        Tue, 13 Oct 2020 00:44:20 +0000 (UTC)
Date:   Mon, 12 Oct 2020 20:44:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 09/20] kernel-shark: Add stream interface for
 trace-cmd data
Message-ID: <20201012204418.3274438e@oasis.local.home>
In-Reply-To: <20201012133523.469040-10-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-10-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Oct 2020 16:35:12 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Here we provide an implementation of the Data stream interface that will
> process the trace-cmd (Ftrace) data. This can be considered the most
> essential change in the transformation of the C API towards version 2.
> However, for the moment we only have stand alone definitions that are not
> made functional yet. The actual integration with the API will be
> introduced in the following patches.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---


> +
> +static ssize_t get_records(struct kshark_context *kshark_ctx,
> +			   struct kshark_data_stream *stream,
> +			   struct rec_list ***rec_list,
> +			   enum rec_type type)
> +{
> +	struct tep_event_filter *adv_filter = NULL;
> +	struct rec_list **temp_next;
> +	struct rec_list **cpu_list;
> +	struct rec_list *temp_rec;
> +	struct tep_record *rec;
> +	ssize_t count, total = 0;
> +	int pid, next_pid, cpu;
> +
> +	cpu_list = calloc(stream->n_cpus, sizeof(*cpu_list));
> +	if (!cpu_list)
> +		return -ENOMEM;
> +
> +	if (type == REC_ENTRY)
> +		adv_filter = get_adv_filter(stream);
> +
> +	for (cpu = 0; cpu < stream->n_cpus; ++cpu) {
> +		count = 0;
> +		cpu_list[cpu] = NULL;
> +		temp_next = &cpu_list[cpu];
> +
> +		rec = tracecmd_read_cpu_first(kshark_get_tep_input(stream), cpu);
> +		while (rec) {
> +			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
> +			if (!temp_rec)
> +				goto fail;
> +
> +			temp_rec->next = NULL;
> +
> +			switch (type) {
> +			case REC_RECORD:
> +				temp_rec->rec = rec;
> +				pid = tep_data_pid(kshark_get_tep(stream), rec);
> +				break;
> +			case REC_ENTRY: {
> +				struct kshark_entry *entry;
> +
> +				if (rec->missed_events) {
> +					/*
> +					 * Insert a custom "missed_events" entry just
> +					 * befor this record.
> +					 */
> +					entry = &temp_rec->entry;
> +					missed_events_action(stream, rec, entry);
> +
> +					entry->stream_id = stream->stream_id;
> +
> +					temp_next = &temp_rec->next;
> +					++count;
> +
> +					/* Now allocate a new rec_list node and comtinue. */
> +					*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
> +				}
> +
> +				entry = &temp_rec->entry;
> +				set_entry_values(stream, rec, entry);
> +
> +				if(entry->event_id == get_sched_switch_id(stream)) {
> +					next_pid = get_next_pid(stream, rec);
> +					if (next_pid >= 0)
> +						register_command(stream, rec, next_pid);
> +				}
> +
> +				entry->stream_id = stream->stream_id;
> +
> +				pid = entry->pid;
> +
> +				/* Apply advanced event filtering. */
> +				if (adv_filter && adv_filter->filters &&
> +				    tep_filter_match(adv_filter, rec) != FILTER_MATCH)
> +					unset_event_filter_flag(kshark_ctx, entry);
> +
> +				free_record(rec);
> +				break;
> +			} /* REC_ENTRY */
> +			}
> +
> +			kshark_hash_id_add(stream->tasks, pid);
> +
> +			temp_next = &temp_rec->next;
> +
> +			++count;
> +			rec = tracecmd_read_data(kshark_get_tep_input(stream), cpu);
> +		}
> +
> +		total += count;
> +	}
> +
> +	*rec_list = cpu_list;
> +	return total;
> +
> + fail:
> +	free_rec_list(cpu_list, stream->n_cpus, type);
> +	return -ENOMEM;
> +}
> +
> +static int pick_next_cpu(struct rec_list **rec_list, int n_cpus,
> +			 enum rec_type type)
> +{
> +	uint64_t ts = 0;
> +	uint64_t rec_ts;
> +	int next_cpu = -1;
> +	int cpu;
> +
> +	for (cpu = 0; cpu < n_cpus; ++cpu) {
> +		if (!rec_list[cpu])
> +			continue;
> +
> +		switch (type) {
> +		case REC_RECORD:
> +			rec_ts = rec_list[cpu]->rec->ts;
> +			break;
> +		case REC_ENTRY:
> +			rec_ts = rec_list[cpu]->entry.ts;
> +			break;
> +		}
> +		if (!ts || rec_ts < ts) {
> +			ts = rec_ts;
> +			next_cpu = cpu;
> +		}
> +	}
> +
> +	return next_cpu;
> +}
> +
> +/**
> + * @brief Load the content of the trace data file asociated with a given
> + *	  Data stream into an array of kshark_entries. This function
> + *	  provides an abstraction of the entries from the raw data
> + *	  that is read, however the "latency" and the "info" fields can be
> + *	  accessed only via the offset into the file. This makes the access
> + *	  to these two fields much slower.
> + *	  If one or more filters are set, the "visible" fields of each entry
> + *	  is updated according to the criteria provided by the filters. The
> + *	  field "filter_mask" of the session's context is used to control the
> + *	  level of visibility/invisibility of the filtered entries.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param kshark_ctx: Input location for context pointer.
> + * @param data_rows: Output location for the trace data. The user is
> + *		     responsible for freeing the elements of the outputted
> + *		     array.
> + *
> + * @returns The size of the outputted data in the case of success, or a
> + *	    negative error code on failure.
> + */
> +ssize_t tepdata_load_entries(struct kshark_data_stream *stream,
> +				struct kshark_context *kshark_ctx,
> +				struct kshark_entry ***data_rows)
> +{
> +	enum rec_type type = REC_ENTRY;
> +	struct kshark_entry **rows;
> +	struct rec_list **rec_list;
> +	ssize_t count, total = 0;
> +
> +	total = get_records(kshark_ctx, stream, &rec_list, type);
> +	if (total < 0)
> +		goto fail;
> +
> +	rows = calloc(total, sizeof(struct kshark_entry *));
> +	if (!rows)
> +		goto fail_free;
> +
> +	for (count = 0; count < total; count++) {
> +		int next_cpu;
> +
> +		next_cpu = pick_next_cpu(rec_list, stream->n_cpus, type);
> +
> +		if (next_cpu >= 0) {
> +			rows[count] = &rec_list[next_cpu]->entry;
> +			rec_list[next_cpu] = rec_list[next_cpu]->next;
> +		}
> +	}
> +
> +	/* There should be no entries left in rec_list. */
> +	free_rec_list(rec_list, stream->n_cpus, type);
> +	*data_rows = rows;
> +
> +	return total;
> +
> + fail_free:
> +	free_rec_list(rec_list, stream->n_cpus, type);
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");
> +	return -ENOMEM;
> +}
> +
> +static ssize_t tepdata_load_matrix(struct kshark_data_stream *stream,
> +				   struct kshark_context *kshark_ctx,
> +				   int16_t **cpu_array,
> +				   int32_t **pid_array,
> +				   int32_t **event_array,
> +				   int64_t **offset_array,
> +				   int64_t **ts_array)
> +{
> +	enum rec_type type = REC_ENTRY;
> +	struct rec_list **rec_list;
> +	ssize_t count, total = 0;
> +	bool status;
> +
> +	total = get_records(kshark_ctx, stream, &rec_list, type);
> +	if (total < 0)
> +		goto fail;
> +
> +	status = kshark_data_matrix_alloc(total, cpu_array,
> +						 pid_array,
> +						 event_array,
> +						 offset_array,
> +						 ts_array);

So if we have a billion events, we'll be allocating more than 5 arrays of a billion items?

Will this scale well?

> +	if (!status)
> +		goto fail_free;
> +
> +	for (count = 0; count < total; count++) {
> +		int next_cpu;
> +
> +		next_cpu = pick_next_cpu(rec_list, stream->n_cpus, type);
> +		if (next_cpu >= 0) {
> +			struct rec_list *rec = rec_list[next_cpu];
> +			struct kshark_entry *e = &rec->entry;
> +
> +			if (offset_array)
> +				(*offset_array)[count] = e->offset;
> +
> +			if (cpu_array)
> +				(*cpu_array)[count] = e->cpu;
> +
> +			if (ts_array)
> +				(*ts_array)[count] = e->ts;
> +
> +			if (pid_array)
> +				(*pid_array)[count] = e->pid;
> +
> +			if (event_array)
> +				(*event_array)[count] = e->event_id;
> +
> +			rec_list[next_cpu] = rec_list[next_cpu]->next;
> +			free(rec);
> +		}
> +	}
> +
> +	/* There should be no entries left in rec_list. */
> +	free_rec_list(rec_list, stream->n_cpus, type);
> +	return total;
> +
> + fail_free:
> +	free_rec_list(rec_list, stream->n_cpus, type);
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");
> +	return -ENOMEM;
> +}
> +
> +/**
> + * @brief Load the content of the trace data file into an array of
> + *	  tep_records. Use this function only if you need fast access
> + *	  to all fields of the record.
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param sd: Data stream identifier.
> + * @param data_rows: Output location for the trace data. Use free_record()
> + *	 	     to free the elements of the outputted array.
> + *
> + * @returns The size of the outputted data in the case of success, or a
> + *	    negative error code on failure.
> + */
> +ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
> +				struct tep_record ***data_rows)
> +{
> +	struct kshark_data_stream *stream;
> +	enum rec_type type = REC_RECORD;
> +	struct rec_list **rec_list;
> +	struct rec_list *temp_rec;
> +	struct tep_record **rows;
> +	struct tep_record *rec;
> +	ssize_t count, total = 0;
> +
> +	if (*data_rows)
> +		free(*data_rows);
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return -EBADF;
> +
> +	total = get_records(kshark_ctx, stream, &rec_list, type);
> +	if (total < 0)
> +		goto fail;
> +
> +	rows = calloc(total, sizeof(struct tep_record *));
> +	if (!rows)
> +		goto fail_free;
> +
> +	for (count = 0; count < total; count++) {
> +		int next_cpu;
> +
> +		next_cpu = pick_next_cpu(rec_list, stream->n_cpus, type);
> +
> +		if (next_cpu >= 0) {
> +			rec = rec_list[next_cpu]->rec;
> +			rows[count] = rec;
> +
> +			temp_rec = rec_list[next_cpu];
> +			rec_list[next_cpu] = rec_list[next_cpu]->next;
> +			free(temp_rec);
> +			/* The record is still referenced in rows */
> +		}
> +	}
> +
> +	/* There should be no records left in rec_list */
> +	free_rec_list(rec_list, stream->n_cpus, type);
> +	*data_rows = rows;
> +	return total;
> +
> + fail_free:
> +	free_rec_list(rec_list, stream->n_cpus, type);
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");
> +	return -ENOMEM;
> +}
> +
> +static const int tepdata_get_event_id(struct kshark_data_stream *stream,
> +				      const struct kshark_entry *entry)
> +{
> +	int event_id = KS_EMPTY_BIN;
> +	struct tep_record *record;
> +
> +	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
> +		event_id = entry->event_id;
> +	} else {
> +		/*
> +		 * The entry has been touched by a plugin callback function.
> +		 * Because of this we do not trust the value of
> +		 * "entry->event_id".
> +		 *
> +		 * Currently the data reading operations are not thread-safe.
> +		 * Use a mutex to protect the access.
> +		 */
> +		pthread_mutex_lock(&stream->input_mutex);
> +
> +		record = tracecmd_read_at(kshark_get_tep_input(stream),
> +					  entry->offset, NULL);
> +
> +		if (record)
> +			event_id = tep_data_type(kshark_get_tep(stream), record);
> +
> +		free_record(record);
> +
> +		pthread_mutex_unlock(&stream->input_mutex);
> +	}
> +
> +	return (event_id == -1)? -EFAULT : event_id;
> +}
> +
> +static char* missed_events_dump(struct kshark_data_stream *stream,
> +				      const struct kshark_entry *entry,
> +				      bool get_info)
> +{
> +	char *buffer;
> +	int size = 0;
> +
> +	if (get_info)
> +		size = asprintf(&buffer, "missed_events=%i",
> +				(int) entry->offset);
> +	else
> +		size = asprintf(&buffer, "missed_events");
> +
> +	if (size > 0)
> +		return buffer;
> +
> +	return NULL;
> +}
> +
> +static char *tepdata_get_event_name(struct kshark_data_stream *stream,
> +				    const struct kshark_entry *entry)
> +{
> +	struct tep_event *event;
> +	char *buffer;
> +
> +	int event_id = stream->interface.get_event_id(stream, entry);
> +	if (event_id == -EFAULT)
> +		return NULL;
> +
> +	if (event_id < 0) {
> +		switch (event_id) {
> +		case KS_EVENT_OVERFLOW:
> +			return missed_events_dump(stream, entry, false);
> +		default:
> +			return NULL;
> +		}
> +	}
> +
> +	/*
> +	 * Currently the data reading operations are not thread-safe.
> +	 * Use a mutex to protect the access.
> +	 */
> +	pthread_mutex_lock(&stream->input_mutex);
> +
> +	event = tep_find_event(kshark_get_tep(stream), event_id);
> +
> +	pthread_mutex_unlock(&stream->input_mutex);
> +
> +	if (!event ||
> +            asprintf(&buffer, "%s/%s", event->system, event->name) <= 0)
> +		return NULL;
> +
> +	return buffer;
> +}
> +
> +static const int tepdata_get_pid(struct kshark_data_stream *stream,
> +				 const struct kshark_entry *entry)
> +{
> +	struct tep_record *record;
> +	int pid = KS_EMPTY_BIN;
> +
> +	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
> +		pid = entry->pid;
> +	} else {
> +		/*
> +		 * The entry has been touched by a plugin callback function.
> +		 * Because of this we do not trust the value of "entry->pid".
> +		 *
> +		 * Currently the data reading operations are not thread-safe.
> +		 * Use a mutex to protect the access.
> +		 */
> +		pthread_mutex_lock(&stream->input_mutex);
> +
> +		record = tracecmd_read_at(kshark_get_tep_input(stream),
> +					  entry->offset, NULL);
> +
> +		if (record)
> +			pid = tep_data_pid(kshark_get_tep(stream), record);
> +
> +		free_record(record);
> +
> +		pthread_mutex_unlock(&stream->input_mutex);
> +	}
> +
> +	return pid;
> +}
> +
> +static char *tepdata_get_task(struct kshark_data_stream *stream,
> +			      const struct kshark_entry *entry)
> +{
> +	int pid = stream->interface.get_pid(stream, entry);
> +	const char *task;
> +	char *buffer;
> +
> +	task = tep_data_comm_from_pid(kshark_get_tep(stream), pid);
> +	if (asprintf(&buffer, "%s", task)  <= 0)
> +		return NULL;
> +
> +	return buffer;
> +}
> +
> +static char *tepdata_get_latency(struct kshark_data_stream *stream,
> +				 const struct kshark_entry *entry)
> +{
> +	struct tep_record *record;
> +	char *buffer;
> +
> +	/* Check if this is a "Missed event" (event_id < 0). */
> +	if (!init_thread_seq() || entry->event_id < 0)
> +		return NULL;
> +
> +	/*
> +	 * Currently the data reading operations are not thread-safe.
> +	 * Use a mutex to protect the access.
> +	 */
> +	pthread_mutex_lock(&stream->input_mutex);
> +
> +	record = tracecmd_read_at(kshark_get_tep_input(stream), entry->offset, NULL);
> +
> +	if (!record)
> +		return NULL;
> +
> +	trace_seq_reset(&seq);
> +	tep_print_event(kshark_get_tep(stream), &seq, record,
> +			"%s", TEP_PRINT_LATENCY);
> +
> +	free_record(record);
> +
> +	pthread_mutex_unlock(&stream->input_mutex);
> +
> +	if (asprintf(&buffer, "%s", seq.buffer)  <= 0)
> +		return NULL;
> +
> +	return buffer;
> +}
> +
> +static char *get_info_str(struct kshark_data_stream *stream,
> +			  struct tep_record *record,
> +			  struct tep_event *event)
> +{
> +	char *pos, *buffer;
> +
> +	if (!init_thread_seq() || !record || !event)
> +		return NULL;
> +
> +	trace_seq_reset(&seq);
> +	tep_print_event(kshark_get_tep(stream), &seq, record,
> +			"%s", TEP_PRINT_INFO);
> +
> +	/*
> +	 * The event info string contains a trailing newline.
> +	 * Remove this newline.
> +	 */
> +	if ((pos = strchr(seq.buffer, '\n')) != NULL)
> +		*pos = '\0';
> +
> +	if (asprintf(&buffer, "%s", seq.buffer)  <= 0)
> +		return NULL;
> +
> +	return buffer;
> +}
> +
> +static char *tepdata_get_info(struct kshark_data_stream *stream,
> +			      const struct kshark_entry *entry)
> +{
> +	struct tep_record *record;
> +	struct tep_event *event;
> +	char *info = NULL;
> +	int event_id;
> +
> +	if (entry->event_id < 0) {
> +		switch (entry->event_id) {
> +		case KS_EVENT_OVERFLOW:
> +			return missed_events_dump(stream, entry, true);
> +		default:
> +			return NULL;
> +		}
> +	}
> +
> +	/*
> +	 * Currently the data reading operations are not thread-safe.
> +	 * Use a mutex to protect the access.
> +	 */
> +	pthread_mutex_lock(&stream->input_mutex);
> +
> +	record = tracecmd_read_at(kshark_get_tep_input(stream), entry->offset, NULL);
> +	if (!record) {
> +		pthread_mutex_unlock(&stream->input_mutex);
> +		return NULL;
> +	}
> +
> +	event_id = tep_data_type(kshark_get_tep(stream), record);
> +	event = tep_find_event(kshark_get_tep(stream), event_id);
> +
> +	if (event)
> +		info = get_info_str(stream, record, event);
> +
> +	free_record(record);
> +
> +	pthread_mutex_unlock(&stream->input_mutex);
> +
> +	return info;
> +}
> +
> +static int *tepdata_get_event_ids(struct kshark_data_stream *stream)
> +{
> +	struct tep_event **events;
> +	int i, *evt_ids;
> +
> +	events = tep_list_events(kshark_get_tep(stream), TEP_EVENT_SORT_SYSTEM);

I believe that tep_list_events() can fail. Need to check.

> +	evt_ids = malloc(stream->n_events * sizeof(*evt_ids));

And need to check evt_ids.

> +
> +	for (i = 0; i < stream->n_events ; ++i)
> +		evt_ids[i] = events[i]->id;
> +
> +	return evt_ids;
> +}
> +
> +static int tepdata_get_field_names(struct kshark_data_stream *stream,
> +				   const struct kshark_entry *entry,
> +				   char ***fields_str)
> +{
> +	struct tep_format_field *field, **fields;
> +	struct tep_event *event;
> +	int i= 0, nr_fields;
> +	char **buffer;
> +
> +	*fields_str = NULL;
> +	event = tep_find_event(kshark_get_tep(stream), entry->event_id);
> +	if (!event)
> +		return 0;
> +
> +	nr_fields = event->format.nr_fields + event->format.nr_common;
> +	buffer = calloc(nr_fields, sizeof(**fields_str));

Need to check buffer.

> +
> +	fields = tep_event_common_fields(event);

And fields.

> +	for (field = *fields; field; field = field->next)
> +		if (asprintf(&buffer[i++], "%s", field->name) <= 0)
> +			goto fail;
> +
> +	free(fields);
> +
> +	fields = tep_event_fields(event);
> +	for (field = *fields; field; field = field->next)
> +		if (asprintf(&buffer[i++], "%s", field->name) <= 0)
> +			goto fail;
> +
> +	free(fields);
> +
> +	*fields_str = buffer;
> +	return nr_fields;
> +
> + fail:
> +	for (i = 0; i < nr_fields; ++i)
> +		free(buffer[i]);
> +
> +	return -EFAULT;
> +}
> +
> +/**
> + * Custom entry info function type. To be user for dumping info for custom
> + * KernelShark entryes.
> + */
> +typedef char *(tepdata_custom_info_func)(struct kshark_data_stream *,
> +					const struct kshark_entry *,
> +					bool);
> +
> +static char* tepdata_dump_custom_entry(struct kshark_data_stream *stream,
> +				       const struct kshark_entry *entry,
> +				       tepdata_custom_info_func info_func)
> +{
> +	char *entry_str;
> +	int size = 0;
> +
> +	size = asprintf(&entry_str, "%" PRIu64 "; %s-%i; CPU %i; ; %s; %s; 0x%x",
> +			entry->ts,
> +			tep_data_comm_from_pid(kshark_get_tep(stream), entry->pid),
> +			entry->pid,
> +			entry->cpu,
> +			info_func(stream, entry, false),
> +			info_func(stream, entry, true),
> +			entry->visible);
> +
> +	if (size > 0)
> +		return entry_str;
> +
> +	return NULL;
> +}
> +
> +/**
> + * @brief Dump into a string the content of one entry. The function allocates
> + *	  a null terminated string and returns a pointer to this string.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param entry: A Kernel Shark entry to be printed.
> + *
> + * @returns The returned string contains a semicolon-separated list of data
> + *	    fields. The user has to free the returned string.
> + */
> +static char *tepdata_dump_entry(struct kshark_data_stream *stream,
> +				const struct kshark_entry *entry)
> +{
> +	char *entry_str, *task, *latency, *event, *info;
> +	struct kshark_context *kshark_ctx = NULL;
> +	int n = 0;
> +
> +	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
> +		return NULL;
> +
> +	if (entry->event_id >= 0) {
> +		if (kshark_get_tep(stream)) {
> +			task = stream->interface.get_task(stream, entry);
> +			latency = stream->interface.get_latency(stream, entry);
> +			event = stream->interface.get_event_name(stream, entry);
> +			info = stream->interface.get_info(stream, entry);
> +
> +			n = asprintf(&entry_str,
> +				     "%i; %" PRIu64 "; %s-%i; CPU %i; %s; %s; %s; 0x%x",
> +				     entry->stream_id,
> +				     entry->ts,
> +				     task,
> +				     stream->interface.get_pid(stream, entry),
> +				     entry->cpu,
> +				     latency,
> +				     event,
> +				     info,
> +				     entry->visible);
> +
> +			free(task);
> +			free(latency);
> +			free(event);
> +			free(info);
> +		} else {
> +			n = asprintf(&entry_str,
> +				     "%i; %li; [UNKNOWN TASK]-%i; CPU %i; ; [UNKNOWN EVENT]; [NO INFO]; 0x%x",
> +				     entry->stream_id,
> +				     entry->ts,
> +				     stream->interface.get_pid(stream, entry),
> +				     entry->cpu,
> +				     entry->visible);
> +		}
> +
> +		if (n < 1)
> +			return NULL;
> +	} else {
> +		switch (entry->event_id) {
> +		case KS_EVENT_OVERFLOW:
> +			entry_str = tepdata_dump_custom_entry(stream, entry,
> +							     missed_events_dump);
> +		default:
> +			return NULL;
> +		}
> +	}
> +
> +	return entry_str;
> +}
> +
> +static const int tepdata_find_event_id(struct kshark_data_stream *stream,
> +				       const char *event_name)
> +{
> +	struct tep_event *event;
> +	char *buffer, *system, *name;
> +
> +	if (asprintf(&buffer, "%s", event_name) < 1)
> +		return -1;
> +
> +	system = strtok(buffer, "/");
> +	name = strtok(NULL, "");
> +	if (!system || !name)
> +		return -1;
> +
> +	event = tep_find_event_by_name(kshark_get_tep(stream), system, name);
> +
> +	free(buffer);
> +
> +	if (!event)
> +		return -1;
> +
> +	return event->id;
> +}
> +
> +static struct tep_format_field *
> +get_evt_field(struct kshark_data_stream *stream,
> +	      int event_id, const char *field_name)
> +{
> +	struct tep_event *event = tep_find_event(kshark_get_tep(stream),
> +						 event_id);
> +	if (!event)
> +		return NULL;
> +
> +	return tep_find_any_field(event, field_name);
> +}
> +
> +/**
> + * @brief  Get the type of a trace record field. For the moment only integer
> + *	   fields are supported.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param entry: Input location for the Kernel Shark entry asociated with thes
> + *		 record.
> + * @param field: The name of the field.
> + *
> + * @returns KS_INTEGER_FIELD in case the field has an integer type. Otherwise
> + *	    KS_INVALIDE_FIELD.
> + */
> +kshark_event_field_format
> +tepdata_get_field_type(struct kshark_data_stream *stream,
> +		       const struct kshark_entry *entry,
> +		       const char *field)
> +{
> +	struct tep_format_field *evt_field;
> +	int mask = ~(TEP_FIELD_IS_SIGNED |
> +		     TEP_FIELD_IS_LONG |
> +		     TEP_FIELD_IS_FLAG);
> +
> +	evt_field = get_evt_field(stream, entry->event_id, field);
> +	if (!evt_field)
> +		return KS_INVALIDE_FIELD;
> +
> +	if (mask & evt_field->flags)
> +		return KS_INVALIDE_FIELD;
> +
> +	return KS_INTEGER_FIELD;
> +}
> +
> +/**
> + * @brief  Get the value of a trace record field.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param rec: Input location for the trace record.
> + * @param field: The name of the field.
> + * @param val: Output location for the field value.
> + *
> + * @returns Returns 0 on success, otherwise a negative error code..
> + */
> +int tepdata_read_record_field(struct kshark_data_stream *stream,
> +			      void *rec,
> +			      const char *field, int64_t *val)
> +{
> +	struct tep_format_field *evt_field;
> +	struct tep_record *record = rec;
> +	int event_id, ret;
> +
> +	if (!record)
> +		return -EFAULT;
> +
> +	event_id = tep_data_type(kshark_get_tep(stream), record);
> +	evt_field = get_evt_field(stream, event_id, field);
> +	if (!evt_field)
> +		return -EINVAL;
> +
> +	ret = tep_read_number_field(evt_field, record->data,
> +				    (unsigned long long *) val);
> +
> +	return ret;
> +}
> +
> +/**
> + * @brief  Get the value of a trace record field.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param entry: Input location for the Kernel Shark entry asociated with thes
> + *		 record.
> + * @param field: The name of the field.
> + * @param val: Output location for the field value.
> + *
> + * @returns Returns 0 on success, otherwise a negative error code.
> + */
> +int tepdata_read_event_field(struct kshark_data_stream *stream,
> +			     const struct kshark_entry *entry,
> +			     const char *field, int64_t *val)
> +{
> +	struct tep_format_field *evt_field;
> +	struct tep_record *record;
> +	int ret;
> +
> +	evt_field = get_evt_field(stream, entry->event_id, field);
> +	if (!evt_field)
> +		return -EINVAL;
> +
> +	record = tracecmd_read_at(kshark_get_tep_input(stream),
> +				  entry->offset, NULL);
> +	if (!record)
> +		return -EFAULT;
> +
> +	ret = tep_read_number_field(evt_field, record->data,
> +				    (unsigned long long *) val);
> +	free_record(record);
> +
> +	return ret;
> +}
> +
> +/** Initialize all methods used by a stream of FTRACE data. */
> +static void kshark_tep_init_methods(struct kshark_data_stream *stream)
> +{
> +	stream->interface.get_pid = tepdata_get_pid;
> +	stream->interface.get_task = tepdata_get_task;
> +	stream->interface.get_event_id = tepdata_get_event_id;
> +	stream->interface.get_event_name = tepdata_get_event_name;
> +	stream->interface.get_latency = tepdata_get_latency;

Since "latency" is a very specific field,  I wonder if we should call
this "aux_field", and have a way to express what to show in the table.
That is, if there's not a "aux_field" defined, it ignores it. Not all
streams may have this.

-- Steve

> +	stream->interface.get_info = tepdata_get_info;
> +	stream->interface.find_event_id = tepdata_find_event_id;
> +	stream->interface.get_all_event_ids = tepdata_get_event_ids;
> +	stream->interface.dump_entry = tepdata_dump_entry;
> +	stream->interface.get_all_field_names = tepdata_get_field_names;
> +	stream->interface.get_event_field_type = tepdata_get_field_type;
> +	stream->interface.read_record_field_int64 = tepdata_read_record_field;
> +	stream->interface.read_event_field_int64 = tepdata_read_event_field;
> +	stream->interface.load_entries = tepdata_load_entries;
> +	stream->interface.load_matrix = tepdata_load_matrix;
> +}
> +
> +/** Find a host stream from the same tracing session, that has guest information */
> +static struct tracecmd_input *
> +kshark_tep_find_merge_peer(struct kshark_context *kshark_ctx,
> +			   struct tracecmd_input *handle)
> +{
> +	struct tracecmd_input *peer_handle = NULL;
> +	struct kshark_data_stream *peer_stream;
> +	unsigned long long trace_id;
> +	int *stream_ids = NULL;
> +	int ret;
> +	int i;
> +
> +	trace_id = tracecmd_get_traceid(handle);
> +	if (!trace_id)
> +		goto out;
> +
> +	stream_ids = kshark_all_streams(kshark_ctx);
> +	if (!stream_ids)
> +		goto out;
> +
> +	for (i = 0; i < kshark_ctx->n_streams - 1; i++) {
> +		peer_stream = kshark_get_data_stream(kshark_ctx, stream_ids[i]);
> +		if (!peer_stream || peer_stream->format != KS_TEP_DATA)
> +			continue;
> +
> +		peer_handle = kshark_get_tep_input(peer_stream);
> +		if (!peer_handle)
> +			continue;
> +
> +		ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
> +						NULL, NULL, NULL);
> +		if (!ret)
> +			break;
> +	}
> +
> +	if (i == kshark_ctx->n_streams)
> +		peer_handle = NULL;
> +
> +out:
> +	free(stream_ids);
> +	return peer_handle;
> +}
> +
> +/** The Process Id of the Idle tasks is zero. */
> +#define LINUX_IDLE_TASK_PID	0
> +
> +static int kshark_tep_stream_init(struct kshark_data_stream *stream,
> +				  struct tracecmd_input *input)
> +{
> +	struct tepdata_handle *tep_handle;
> +	struct tep_event *event;
> +
> +	tep_handle = calloc(1, sizeof(*tep_handle));
> +	if (!tep_handle)
> +		goto fail;
> +
> +	tep_handle->input = input;
> +	tep_handle->tep = tracecmd_get_pevent(tep_handle->input);
> +	if (!tep_handle->tep)
> +		goto fail;
> +
> +	tep_handle->sched_switch_event_id = -EINVAL;
> +	event = tep_find_event_by_name(tep_handle->tep,
> +				       "sched", "sched_switch");
> +	if (event) {
> +		tep_handle->sched_switch_event_id = event->id;
> +
> +		tep_handle->sched_switch_next_field =
> +			tep_find_any_field(event, "next_pid");
> +
> +		tep_handle->sched_switch_comm_field =
> +			tep_find_field(event, "next_comm");
> +	}
> +
> +	stream->n_cpus = tep_get_cpus(tep_handle->tep);
> +	stream->n_events = tep_get_events_count(tep_handle->tep);
> +	stream->idle_pid = LINUX_IDLE_TASK_PID;
> +
> +	tep_handle->advanced_event_filter =
> +		tep_filter_alloc(tep_handle->tep);
> +
> +	kshark_tep_init_methods(stream);
> +
> +	stream->interface.handle = tep_handle;
> +
> +	return 0;
> +
> + fail:
> +	free(tep_handle);
> +	stream->interface.handle = NULL;
> +	return -EFAULT;
> +}
> +
> +/** Initialize the FTRACE data input (from file). */
> +int kshark_tep_init_input(struct kshark_data_stream *stream,
> +			  const char *file)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct tracecmd_input *merge_peer;
> +	struct tracecmd_input *input;
> +
> +	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
> +		return -EEXIST;
> +
> +	/*
> +	 * Turn off function trace indent and turn on show parent
> +	 * if possible.
> +	 */
> +	tep_plugin_add_option("ftrace:parent", "1");
> +	tep_plugin_add_option("ftrace:indent", "0");
> +
> +	input = tracecmd_open_head(file);
> +	if (!input)
> +		return -EEXIST;
> +
> +	/* Find a merge peer from the same tracing session. */
> +	merge_peer = kshark_tep_find_merge_peer(kshark_ctx, input);
> +	if (merge_peer)
> +		tracecmd_pair_peer(input, merge_peer);
> +
> +	/* Read the tracing data from the file. */
> +	if (tracecmd_init_data(input) < 0)
> +		goto fail;
> +
> +	/* Initialize the stream asociated with the main buffer. */
> +	if (kshark_tep_stream_init(stream, input) < 0)
> +		goto fail;
> +
> +	stream->name = strdup("top");
> +
> +	return 0;
> +
> + fail:
> +	tracecmd_close(input);
> +	return -EFAULT;
> +}
> +
> +/** Initialize using the locally available tracing events. */
> +int kshark_tep_init_local(struct kshark_data_stream *stream)
> +{
> +	struct tepdata_handle *tep_handle;
> +
> +	tep_handle = calloc(1, sizeof(*tep_handle));
> +	if (!tep_handle)
> +		return -EFAULT;
> +
> +	tep_handle->tep = tracefs_local_events(tracefs_get_tracing_dir());
> +	if (!tep_handle->tep)
> +		goto fail;
> +
> +	stream->n_events = tep_get_events_count(tep_handle->tep);
> +	stream->n_cpus =  tep_get_cpus(tep_handle->tep);
> +	stream->format = KS_TEP_DATA;
> +	if (asprintf(&stream->file, "Local system") <= 0)
> +		goto fail;
> +
> +	stream->interface.handle = tep_handle;
> +	kshark_tep_init_methods(stream);
> +
> +	return 0;
> +
> + fail:
> +	free(tep_handle);
> +	stream->interface.handle = NULL;
> +	return -EFAULT;
> +}
> +
> +/** Method used to close a stream of FTRACE data. */
> +void kshark_tep_close_interface(struct kshark_data_stream *stream)
> +{
> +	struct tepdata_handle *tep_handle = stream->interface.handle;
> +
> +	if (seq.buffer)
> +		trace_seq_destroy(&seq);
> +
> +	if (tep_handle->advanced_event_filter) {
> +		tep_filter_reset(tep_handle->advanced_event_filter);
> +		tep_filter_free(tep_handle->advanced_event_filter);
> +		tep_handle->advanced_event_filter = NULL;
> +	}
> +
> +	if (tep_handle->input)
> +		tracecmd_close(tep_handle->input);
> +
> +	free(tep_handle);
> +	stream->interface.handle = NULL;
> +}
> +
> +/** Check if the filter any filter is set. */
> +bool kshark_tep_filter_is_set(struct kshark_data_stream *stream)
> +{
> +	struct tep_event_filter *adv_filter = get_adv_filter(stream);
> +
> +	if (adv_filter && adv_filter->filters)
> +		return true;
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Add a filter based on the content of the event.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param filter_str: The definition of the filter.
> + *
> + * @returns 0 if the filter was successfully added or a negative error code.
> + */
> +int kshark_tep_add_filter_str(struct kshark_data_stream *stream,
> +			       const char *filter_str)
> +{
> +	struct tep_event_filter *adv_filter = get_adv_filter(stream);
> +	int ret = tep_filter_add_filter_str(adv_filter, filter_str);
> +
> +	if (ret < 0) {
> +		char error_str[200];
> +		int error_status =
> +			tep_strerror(kshark_get_tep(stream), ret, error_str,
> +				     sizeof(error_str));
> +
> +		if (error_status == 0)
> +			fprintf(stderr, "filter failed due to: %s\n",
> +					error_str);
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * @brief Get a string showing the filter definition.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param event_id: The unique Id of the event type of the filter.
> + *
> + * @returns A string that displays the filter contents. This string must be
> + *	    freed with free(str). NULL is returned if no filter is found or
> + *	    allocation failed.
> + */
> +char *kshark_tep_filter_make_string(struct kshark_data_stream *stream,
> +				    int event_id)
> +{
> +	struct tep_event_filter *adv_filter = get_adv_filter(stream);
> +
> +	return tep_filter_make_string(adv_filter, event_id);
> +}
> +
> +/**
> + * @brief Remove a filter based on the content of the event.
> + *
> + * @param stream: Input location for the FTRACE data stream pointer.
> + * @param event_id: The unique Id of the event type of the filter.
> + *
> + * @return 1: if an event was removed or 0 if the event was not found.
> + */
> +int kshark_tep_filter_remove_event(struct kshark_data_stream *stream,
> +				   int event_id)
> +{
> +	struct tep_event_filter *adv_filter = get_adv_filter(stream);
> +
> +	return tep_filter_remove_event(adv_filter, event_id);
> +}
> +
> +/** Reset all filters based on the content of the event. */
> +void kshark_tep_filter_reset(struct kshark_data_stream *stream)
> +{
> +	return tep_filter_reset(get_adv_filter(stream));
> +}
> +
> +/** Get an array of available tracer plugins. */
> +char **kshark_tracecmd_local_plugins()
> +{
> +	return tracefs_tracers(tracefs_get_tracing_dir());
> +}
> diff --git a/src/libkshark-tepdata.h b/src/libkshark-tepdata.h
> new file mode 100644
> index 00000000..a2bd211e
> --- /dev/null
> +++ b/src/libkshark-tepdata.h
> @@ -0,0 +1,51 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> + */
> +
> +/**
> + *  @file    libkshark-tepdata.h
> + *  @brief   Interface for processing of FTRACE (trace-cmd) data.
> + */
> +
> +#ifndef _KSHARK_TEPDATA_H
> +#define _KSHARK_TEPDATA_H
> +
> +// KernelShark
> +#include "libkshark.h"
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +int kshark_tep_init_input(struct kshark_data_stream *stream,
> +			  const char *file);
> +
> +int kshark_tep_init_local(struct kshark_data_stream *stream);
> +
> +void kshark_tep_close_interface(struct kshark_data_stream *stream);
> +
> +bool kshark_tep_filter_is_set(struct kshark_data_stream *stream);
> +
> +int kshark_tep_add_filter_str(struct kshark_data_stream *stream,
> +			      const char *filter_str);
> +
> +char *kshark_tep_filter_make_string(struct kshark_data_stream *stream,
> +				    int event_id);
> +
> +int kshark_tep_filter_remove_event(struct kshark_data_stream *stream,
> +				   int event_id);
> +
> +void kshark_tep_filter_reset(struct kshark_data_stream *stream);
> +
> +char **kshark_tracecmd_local_plugins();
> +
> +ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
> +				struct tep_record ***data_rows);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif // _KSHARK_TEPDATA_H

