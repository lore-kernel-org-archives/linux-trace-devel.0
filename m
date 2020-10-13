Return-Path: <SRS0=fnsP=DU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BF8C433E7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Oct 2020 03:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 700FA206F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Oct 2020 03:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgJMD1X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 23:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgJMD1X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 23:27:23 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33C2C208D5;
        Tue, 13 Oct 2020 00:18:49 +0000 (UTC)
Date:   Mon, 12 Oct 2020 20:18:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 07/20] kernel-shark: Add basic methods for Data
 streams
Message-ID: <20201012201847.1218c974@oasis.local.home>
In-Reply-To: <20201012133523.469040-8-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-8-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Oct 2020 16:35:10 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> +static struct kshark_data_stream *kshark_stream_alloc()
> +{
> +	struct kshark_data_stream *stream;
> +
> +	stream = calloc(1, sizeof(*stream));
> +	if (!stream)
> +		goto fail;
> +
> +	stream->show_task_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
> +	stream->hide_task_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
> +
> +	stream->show_event_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
> +	stream->hide_event_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
> +
> +	stream->show_cpu_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
> +	stream->hide_cpu_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
> +
> +	stream->tasks = kshark_hash_id_alloc(KS_TASK_HASH_NBITS);
> +
> +	if (!stream->show_task_filter ||
> +	    !stream->hide_task_filter ||
> +	    !stream->show_event_filter ||
> +	    !stream->hide_event_filter ||
> +	    !stream->tasks) {
> +		    goto fail;
> +	}
> +
> +	stream->format = KS_INVALIDE_DATA;
> +
> +	return stream;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for data stream.\n");

I don't think we need the print. Not if this is a library routine. The
calloc failure should set the errno that the caller should be able to
figure out what happened.

> +	if (stream)
> +		kshark_stream_free(stream);
> +
> +	return NULL;
> +}
> +
> +/**
> + * @brief Add new Data stream.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + *
> + * @returns Zero on success or a negative errno code on failure.
> + */
> +int kshark_add_stream(struct kshark_context *kshark_ctx)
> +{
> +	struct kshark_data_stream *stream;
> +
> +	if (kshark_ctx->n_streams == KS_MAX_NUM_STREAMS)
> +		return -EMFILE;
> +
> +	stream = kshark_stream_alloc();

Need to check for success.

> +	stream->stream_id = kshark_ctx->n_streams;
> +
> +	if (pthread_mutex_init(&stream->input_mutex, NULL) != 0) {
> +		kshark_stream_free(stream);
> +		return -EAGAIN;
> +	}
> +
> +	kshark_ctx->stream[kshark_ctx->n_streams++] = stream;
> +
> +	return stream->stream_id;
> +}
> +
> +/**
> + * @brief Get the Data stream object having given Id.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param sd: Data stream identifier.
> + *
> + * @returns Pointer to a Data stream object if the sream exists. Otherwise
> + *	    NULL.
> + */
> +struct kshark_data_stream *
> +kshark_get_data_stream(struct kshark_context *kshark_ctx, int sd)
> +{
> +	if (sd >= 0 && sd < KS_MAX_NUM_STREAMS)
> +		return kshark_ctx->stream[sd];
> +
> +	return NULL;
> +}
> +
> +/**
> + * @brief Get the Data stream object corresponding to a given entry
> + *
> + * @param entry: Input location for the KernelShark entry.
> + *
> + * @returns Pointer to a Data stream object on success. Otherwise NULL.
> + */
> +struct kshark_data_stream *
> +kshark_get_stream_from_entry(const struct kshark_entry *entry)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return NULL;
> +
> +	return kshark_get_data_stream(kshark_ctx, entry->stream_id);
> +}
> +
> +/**
> + * @brief Get an array containing the Ids of all opened Trace data streams.
> + * 	  The User is responsible for freeing the array.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + */
> +int *kshark_all_streams(struct kshark_context *kshark_ctx)
> +{
> +	int *ids, i, count = 0;
> +
> +	ids = malloc(kshark_ctx->n_streams * (sizeof(*ids)));

I think calloc is more appropriate for the above.

	ids = calloc(kshark_ctx->n_streams, sizeof(*ids));

> +	if (!ids) {
> +		fprintf(stderr,
> +			"Failed to allocate memory for stream array.\n");

Probably don't need the print.

> +		return NULL;
> +	}
> +
> +	for (i = 0; i < KS_MAX_NUM_STREAMS; ++i)
> +		if (kshark_ctx->stream[i])
> +			ids[count++] = i;

Definitely need the calloc, as malloc doesn't initialize the array to
zero. Thus some ids[] will not be initialized.

> +
> +	return ids;
> +}
> +
>  /**
>   * @brief Close the trace data file and free the trace data handle.
>   *
> @@ -252,6 +399,56 @@ void kshark_free(struct kshark_context *kshark_ctx)
>  	free(kshark_ctx);
>  }
>  
> +/**
> + * @brief Get the name of the command/task from its Process Id.
> + *
> + * @param sd: Data stream identifier.
> + * @param pid: Process Id of the command/task.
> + */
> +char *kshark_comm_from_pid(int sd, int pid)

I wonder if we should abstract this further, and call it
"kshark_name_from_id()", as comm and pid are specific to processes, and
we may have a stream that will represent something other than processes.

> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct kshark_data_stream *stream;
> +	struct kshark_entry e;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return NULL;
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return NULL;
> +
> +	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
> +	e.pid = pid;
> +
> +	return stream->interface.get_task(stream, &e);
> +}
> +
> +/**
> + * @brief Get the name of the event from its Id.
> + *
> + * @param sd: Data stream identifier.
> + * @param event_id: The unique Id of the event type.
> + */
> +char *kshark_event_from_id(int sd, int event_id)
> +{
> +	struct kshark_context *kshark_ctx = NULL;
> +	struct kshark_data_stream *stream;
> +	struct kshark_entry e;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return NULL;
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return NULL;
> +
> +	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
> +	e.event_id = event_id;
> +
> +	return stream->interface.get_event_name(stream, &e);
> +}
> +
>  static struct kshark_task_list *
>  kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
>  {
> diff --git a/src/libkshark.h b/src/libkshark.h
> index fe0ba7f2..e299d067 100644
> --- a/src/libkshark.h
> +++ b/src/libkshark.h
> @@ -340,6 +340,12 @@ struct kshark_task_list {
>  
>  /** Structure representing a kshark session. */
>  struct kshark_context {
> +	/** Array of data stream descriptors. */
> +	struct kshark_data_stream	**stream;
> +
> +	/** The number of data streams. */
> +	int				n_streams;
> +
>  	/** Input handle for the trace data file. */
>  	struct tracecmd_input	*handle;
>  
> @@ -397,6 +403,16 @@ bool kshark_instance(struct kshark_context **kshark_ctx);
>  
>  bool kshark_open(struct kshark_context *kshark_ctx, const char *file);
>  
> +int kshark_add_stream(struct kshark_context *kshark_ctx);
> +
> +struct kshark_data_stream *
> +kshark_get_data_stream(struct kshark_context *kshark_ctx, int sd);
> +
> +struct kshark_data_stream *
> +kshark_get_stream_from_entry(const struct kshark_entry *entry);
> +
> +int *kshark_all_streams(struct kshark_context *kshark_ctx);
> +
>  ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>  				 struct kshark_entry ***data_rows);
>  
> @@ -416,6 +432,10 @@ void kshark_close(struct kshark_context *kshark_ctx);
>  
>  void kshark_free(struct kshark_context *kshark_ctx);
>  
> +char *kshark_comm_from_pid(int sd, int pid);
> +
> +char *kshark_event_from_id(int sd, int event_id);
> +
>  int kshark_get_pid_easy(struct kshark_entry *entry);
>  
>  const char *kshark_get_task_easy(struct kshark_entry *entry);
> @@ -432,6 +452,157 @@ void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
>  
>  char* kshark_dump_entry(const struct kshark_entry *entry);
>  
> +static inline int kshark_get_pid(const struct kshark_entry *entry)
> +{
> +	struct kshark_data_stream *stream =
> +		kshark_get_stream_from_entry(entry);
> +
> +	if (!stream)
> +		return -1;
> +
> +	return stream->interface.get_pid(stream, entry);
> +}
> +
> +static inline int kshark_get_event_id(const struct kshark_entry *entry)
> +{
> +	struct kshark_data_stream *stream =
> +		kshark_get_stream_from_entry(entry);
> +
> +	if (!stream)
> +		return -1;
> +
> +	return stream->interface.get_event_id(stream, entry);
> +}
> +
> +static inline int *kshark_get_all_event_ids(struct kshark_data_stream *stream)
> +{
> +	return stream->interface.get_all_event_ids(stream);
> +}
> +
> +static inline char *kshark_get_event_name(const struct kshark_entry *entry)
> +{
> +	struct kshark_data_stream *stream =
> +		kshark_get_stream_from_entry(entry);
> +
> +	if (!stream)
> +		return NULL;
> +
> +	return stream->interface.get_event_name(stream, entry);
> +}
> +
> +static inline char *kshark_get_task(const struct kshark_entry *entry)
> +{
> +	struct kshark_data_stream *stream =
> +		kshark_get_stream_from_entry(entry);
> +
> +	if (!stream)
> +		return NULL;
> +
> +	return stream->interface.get_task(stream, entry);
> +}
> +
> +static inline char *kshark_get_latency(const struct kshark_entry *entry)
> +{
> +	struct kshark_data_stream *stream =
> +		kshark_get_stream_from_entry(entry);
> +
> +	if (!stream)
> +		return NULL;
> +
> +	return stream->interface.get_latency(stream, entry);
> +}
> +
> +static inline char *kshark_get_info(const struct kshark_entry *entry)
> +{
> +	struct kshark_data_stream *stream =
> +		kshark_get_stream_from_entry(entry);
> +
> +	if (!stream)
> +		return NULL;
> +
> +	return stream->interface.get_info(stream, entry);
> +}
> +
> +static inline int kshark_read_event_field(const struct kshark_entry *entry,
> +					  const char* field, int64_t *val)
> +{
> +	struct kshark_data_stream *stream =
> +		kshark_get_stream_from_entry(entry);
> +
> +	if (!stream)
> +		return -1;
> +
> +	return stream->interface.read_event_field_int64(stream, entry,
> +							field, val);
> +}
> +
> +/**
> + * @brief Load the content of the trace data file asociated with a given
> + *	  Data stream identifie into an array of kshark_entries.
> + *	  If one or more filters are set, the "visible" fields of each entry
> + *	  is updated according to the criteria provided by the filters. The
> + *	  field "filter_mask" of the session's context is used to control the
> + *	  level of visibility/invisibility of the filtered entries.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param sd: Data stream identifier.
> + * @param data_rows: Output location for the trace data. The user is
> + *		     responsible for freeing the elements of the outputted
> + *		     array.
> + *
> + * @returns The size of the outputted data in the case of success, or a
> + *	    negative error code on failure.
> + */
> +static inline ssize_t kshark_load_entries(struct kshark_context *kshark_ctx,
> +					  int sd,
> +					  struct kshark_entry ***data_rows)
> +{
> +	struct kshark_data_stream *stream;
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return -EBADF;
> +
> +	return stream->interface.load_entries(stream, kshark_ctx, data_rows);
> +}
> +
> +/**
> + * @brief Load the content of the trace data file asociated with a given
> + *	  Data stream identifie into a data matrix. The user is responsible

identifie?

> + *	  for freeing the outputted data.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param sd: Data stream identifier.
> + * @param cpu_array: Output location for the CPU column (array) of the matrix.
> + * @param event_array: Output location for the Event Id column (array) of the
> + *		       matrix.
> + * @param _array: Output location for the  column (array) of the matrix.
> + * @param offset_array: Output location for the offset column (array) of the
> + *			matrix.
> + * @param ts_array: Output location for the time stamp column (array) of the
> + *		    matrix.

Hmm, how is this matrix composed? How do each realate, via the ts_array?

-- Steve


> + */
> +static inline ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx,
> +					 int sd,
> +					 int16_t **cpu_array,
> +					 int32_t **pid_array,
> +					 int32_t **event_array,
> +					 int64_t **offset_array,
> +					 int64_t **ts_array)
> +{
> +	struct kshark_data_stream *stream;
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return -EBADF;
> +
> +	return stream->interface.load_matrix(stream, kshark_ctx, cpu_array,
> +								 pid_array,
> +								 event_array,
> +								 offset_array,
> +								 ts_array);
> +}
> +
>  /**
>   * Custom entry info function type. To be user for dumping info for custom
>   * KernelShark entryes.

