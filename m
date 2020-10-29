Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B7AC55178
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 10:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A6320790
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 10:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBGRsMSI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgJ2KKn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgJ2KKk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 06:10:40 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB1EC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 03:10:39 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b8so2123271wrn.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 03:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZBXX/CV6yj1ThfXU0BNa4LTnsajFZppsLNeDKUZlAqo=;
        b=XBGRsMSIBdj6NsORV3rGYbXRnEo1465MsRLLVtiaz5ltMNUQbzcTSs/8HWFSd7M6MW
         hvFbMbvWmZENwkTcfRK8IiSuZq6ubuaoQBsQLdZL3wtK3ZebZCV6g1GignvfbMK9CqRZ
         U7Nos+CQvHlW6QlBa7/S8m3VH/R571I5H1ANf7VFkitRxUqgvyF7S75eWcMQnBtPV/AH
         V7EF0gQY47gpirUvCE6FxXVj08uWXcVwU6GMyjHWGVqsl6sYIkHw2gcxzMawICdMEt4U
         ZfgiAkYm3NjREooSxCyddklSWc8u9xcD3qqhsi6JufUNU0/VRB5o3UFNdElHT0deIW5m
         +99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZBXX/CV6yj1ThfXU0BNa4LTnsajFZppsLNeDKUZlAqo=;
        b=cDwt11+w7WwTvp/+VhBcrAd+oJ1jeGB3VzIlISQpaG5CzEXAC3zbf8pPlVpr72IsOC
         Nx4GtPC+aqCBMc0YIEqJQCrgSpjYCdDD+hy38Pfg9RUCiHTsrhlmgXi3uPYTZTDj6w0W
         55UsjizHdXZEenIYotvTfwWqzt7lMOdGLEiXl6kPKRMUA569H4Hws/TCxo2R0S+fFh7u
         LsT0XpqX2nmvHGcajLbb+tTE1YPlqU9MWqyatH5J2OJBZpXbUX63pNHUoebJlClSrWcZ
         D2Gw/1N0JOqVjEaw3d3M1BRZltuWYNvDYX9EBDn2CJBSep4RQvDJpfaDk634Sai6nr5y
         7reQ==
X-Gm-Message-State: AOAM530nRQfNW2Bg34HJC+ipI9LsylF4ZQsQ07IIRwPO1iFebFcUAFU4
        X1usil1zKa+b00T5UWR0FuUHsT4rDaE=
X-Google-Smtp-Source: ABdhPJygStK7mkbBSOm5hUEOVckM7YM9Ofj/w2RbqMcOHQnrclZHpTVEjxI7gOZ0BrgnVbXS5qh+kQ==
X-Received: by 2002:adf:93c1:: with SMTP id 59mr4468120wrp.369.1603966237821;
        Thu, 29 Oct 2020 03:10:37 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.73.62])
        by smtp.gmail.com with ESMTPSA id z191sm3617105wme.30.2020.10.29.03.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 03:10:37 -0700 (PDT)
Subject: Re: [PATCH v2 07/20] kernel-shark: Add basic methods for Data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-8-y.karadz@gmail.com>
 <20201012201847.1218c974@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d67dd724-abe1-3696-29f7-75358f98df87@gmail.com>
Date:   Thu, 29 Oct 2020 12:10:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012201847.1218c974@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 13.10.20 г. 3:18 ч., Steven Rostedt wrote:
> On Mon, 12 Oct 2020 16:35:10 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>> +static struct kshark_data_stream *kshark_stream_alloc()
>> +{
>> +	struct kshark_data_stream *stream;
>> +
>> +
>> +	return stream;
>> +
>> + fail:
>> +	fprintf(stderr, "Failed to allocate memory for data stream.\n");
> 
> I don't think we need the print. Not if this is a library routine. The
> calloc failure should set the errno that the caller should be able to
> figure out what happened.
> 

Agree. Will be fixed in v3.

>> +	if (stream)
>> +		kshark_stream_free(stream);
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * @brief Add new Data stream.
>> + *
>> + * @param kshark_ctx: Input location for context pointer.
>> + *
>> + * @returns Zero on success or a negative errno code on failure.
>> + */
>> +int kshark_add_stream(struct kshark_context *kshark_ctx)
>> +{
>> +	struct kshark_data_stream *stream;
>> +
>> +	if (kshark_ctx->n_streams == KS_MAX_NUM_STREAMS)
>> +		return -EMFILE;
>> +
>> +	stream = kshark_stream_alloc();
> 
> Need to check for success.

OK. Fix in v3.

> 
>> +	stream->stream_id = kshark_ctx->n_streams;
>> +
>> +	if (pthread_mutex_init(&stream->input_mutex, NULL) != 0) {
>> +		kshark_stream_free(stream);
>> +		return -EAGAIN;

>> +/**
>> + * @brief Get an array containing the Ids of all opened Trace data streams.
>> + * 	  The User is responsible for freeing the array.
>> + *
>> + * @param kshark_ctx: Input location for context pointer.
>> + */
>> +int *kshark_all_streams(struct kshark_context *kshark_ctx)
>> +{
>> +	int *ids, i, count = 0;
>> +
>> +	ids = malloc(kshark_ctx->n_streams * (sizeof(*ids)));
> 
> I think calloc is more appropriate for the above.
> 
> 	ids = calloc(kshark_ctx->n_streams, sizeof(*ids));
> 

Fix in v3.

>> +	if (!ids) {
>> +		fprintf(stderr,
>> +			"Failed to allocate memory for stream array.\n");
> 
> Probably don't need the print.

Fix in v3.

> 
>> +		return NULL;
>> +	}
>> +
>> +	for (i = 0; i < KS_MAX_NUM_STREAMS; ++i)
>> +		if (kshark_ctx->stream[i])
>> +			ids[count++] = i;
> 
> Definitely need the calloc, as malloc doesn't initialize the array to
> zero. Thus some ids[] will not be initialized.
> 
>> +
>> +	return ids;
>> +}
>> +
>>   /**
>>    * @brief Close the trace data file and free the trace data handle.
>>    *
>> @@ -252,6 +399,56 @@ void kshark_free(struct kshark_context *kshark_ctx)
>>   	free(kshark_ctx);
>>   }
>>   
>> +/**
>> + * @brief Get the name of the command/task from its Process Id.
>> + *
>> + * @param sd: Data stream identifier.
>> + * @param pid: Process Id of the command/task.
>> + */
>> +char *kshark_comm_from_pid(int sd, int pid)
> 
> I wonder if we should abstract this further, and call it
> "kshark_name_from_id()", as comm and pid are specific to processes, and
> we may have a stream that will represent something other than processes.
> 

This is just a helper function that wraps the corresponding method of 
the interface. In the future we can add a similar helper/wrapper 
function with different name if we have streams that contain no processes.

However, you are actually making a very good point. It may be even 
better if we abstract the interface itself, instead of trying to have 
more abstract method names. We can keep the existing interface of 
methods unchanged, but in the definition of "struct kshark_data_stream" 
make the interface void*

struct kshark_data_stream {
	/** Data stream identifier. */
	uint8_t			stream_id;

....

	/** List of Plugin's Draw handlers. */
	struct kshark_draw_handler		*draw_handlers;

	/**
	 * Abstract interface of methods used to operate over the data
	 * from a given stream. An implementation must be provided.
	 */
	void	*interface;
};

and then the wrapping functions may look like this

char *kshark_comm_from_pid(int sd, int pid)
{
	struct kshark_data_stream_interface *interface;
	struct kshark_context *kshark_ctx = NULL;
	struct kshark_data_stream *stream;
	struct kshark_entry e;

	if (!kshark_instance(&kshark_ctx))
		return NULL;

	stream = kshark_get_data_stream(kshark_ctx, sd);
	if (!stream)
		return NULL;

	interface = stream->interface;
	if (!interface || !interface->get_task)
		return NULL;

	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
	e.pid = pid;

	return interface->get_task(stream, &e);
}

And in the future we can add more interface implementations and more 
helper functions.

What do you think?

Thanks!
Yordan



>> +{
>> +	struct kshark_context *kshark_ctx = NULL;
>> +	struct kshark_data_stream *stream;
>> +	struct kshark_entry e;
>> +
>> +	if (!kshark_instance(&kshark_ctx))
>> +		return NULL;
>> +
>> +	stream = kshark_get_data_stream(kshark_ctx, sd);
>> +	if (!stream)
>> +		return NULL;
>> +
>> +	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
>> +	e.pid = pid;
>> +
>> +	return stream->interface.get_task(stream, &e);
>> +}
>> +
>> +/**
>> + * @brief Get the name of the event from its Id.
>> + *
>> + * @param sd: Data stream identifier.
>> + * @param event_id: The unique Id of the event type.
>> + */
>> +char *kshark_event_from_id(int sd, int event_id)
>> +{
>> +	struct kshark_context *kshark_ctx = NULL;
>> +	struct kshark_data_stream *stream;
>> +	struct kshark_entry e;
>> +
>> +	if (!kshark_instance(&kshark_ctx))
>> +		return NULL;
>> +
>> +	stream = kshark_get_data_stream(kshark_ctx, sd);
>> +	if (!stream)
>> +		return NULL;
>> +
>> +	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
>> +	e.event_id = event_id;
>> +
>> +	return stream->interface.get_event_name(stream, &e);
>> +}
>> +
>>   static struct kshark_task_list *
>>   kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
>>   {
>> diff --git a/src/libkshark.h b/src/libkshark.h
>> index fe0ba7f2..e299d067 100644
>> --- a/src/libkshark.h
>> +++ b/src/libkshark.h
>> @@ -340,6 +340,12 @@ struct kshark_task_list {
>>   
>>   /** Structure representing a kshark session. */
>>   struct kshark_context {
>> +	/** Array of data stream descriptors. */
>> +	struct kshark_data_stream	**stream;
>> +
>> +	/** The number of data streams. */
>> +	int				n_streams;
>> +
>>   	/** Input handle for the trace data file. */
>>   	struct tracecmd_input	*handle;
>>   
>> @@ -397,6 +403,16 @@ bool kshark_instance(struct kshark_context **kshark_ctx);
>>   
>>   bool kshark_open(struct kshark_context *kshark_ctx, const char *file);
>>   
>> +int kshark_add_stream(struct kshark_context *kshark_ctx);
>> +
>> +struct kshark_data_stream *
>> +kshark_get_data_stream(struct kshark_context *kshark_ctx, int sd);
>> +
>> +struct kshark_data_stream *
>> +kshark_get_stream_from_entry(const struct kshark_entry *entry);
>> +
>> +int *kshark_all_streams(struct kshark_context *kshark_ctx);
>> +
>>   ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>>   				 struct kshark_entry ***data_rows);
>>   
>> @@ -416,6 +432,10 @@ void kshark_close(struct kshark_context *kshark_ctx);
>>   
>>   void kshark_free(struct kshark_context *kshark_ctx);
>>   
>> +char *kshark_comm_from_pid(int sd, int pid);
>> +
>> +char *kshark_event_from_id(int sd, int event_id);
>> +
>>   int kshark_get_pid_easy(struct kshark_entry *entry);
>>   
>>   const char *kshark_get_task_easy(struct kshark_entry *entry);
>> @@ -432,6 +452,157 @@ void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
>>   
>>   char* kshark_dump_entry(const struct kshark_entry *entry);
>>   
>> +static inline int kshark_get_pid(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (!stream)
>> +		return -1;
>> +
>> +	return stream->interface.get_pid(stream, entry);
>> +}
>> +
>> +static inline int kshark_get_event_id(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (!stream)
>> +		return -1;
>> +
>> +	return stream->interface.get_event_id(stream, entry);
>> +}
>> +
>> +static inline int *kshark_get_all_event_ids(struct kshark_data_stream *stream)
>> +{
>> +	return stream->interface.get_all_event_ids(stream);
>> +}
>> +
>> +static inline char *kshark_get_event_name(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (!stream)
>> +		return NULL;
>> +
>> +	return stream->interface.get_event_name(stream, entry);
>> +}
>> +
>> +static inline char *kshark_get_task(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (!stream)
>> +		return NULL;
>> +
>> +	return stream->interface.get_task(stream, entry);
>> +}
>> +
>> +static inline char *kshark_get_latency(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (!stream)
>> +		return NULL;
>> +
>> +	return stream->interface.get_latency(stream, entry);
>> +}
>> +
>> +static inline char *kshark_get_info(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (!stream)
>> +		return NULL;
>> +
>> +	return stream->interface.get_info(stream, entry);
>> +}
>> +
>> +static inline int kshark_read_event_field(const struct kshark_entry *entry,
>> +					  const char* field, int64_t *val)
>> +{
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (!stream)
>> +		return -1;
>> +
>> +	return stream->interface.read_event_field_int64(stream, entry,
>> +							field, val);
>> +}
>> +
>> +/**
>> + * @brief Load the content of the trace data file asociated with a given
>> + *	  Data stream identifie into an array of kshark_entries.
>> + *	  If one or more filters are set, the "visible" fields of each entry
>> + *	  is updated according to the criteria provided by the filters. The
>> + *	  field "filter_mask" of the session's context is used to control the
>> + *	  level of visibility/invisibility of the filtered entries.
>> + *
>> + * @param kshark_ctx: Input location for context pointer.
>> + * @param sd: Data stream identifier.
>> + * @param data_rows: Output location for the trace data. The user is
>> + *		     responsible for freeing the elements of the outputted
>> + *		     array.
>> + *
>> + * @returns The size of the outputted data in the case of success, or a
>> + *	    negative error code on failure.
>> + */
>> +static inline ssize_t kshark_load_entries(struct kshark_context *kshark_ctx,
>> +					  int sd,
>> +					  struct kshark_entry ***data_rows)
>> +{
>> +	struct kshark_data_stream *stream;
>> +
>> +	stream = kshark_get_data_stream(kshark_ctx, sd);
>> +	if (!stream)
>> +		return -EBADF;
>> +
>> +	return stream->interface.load_entries(stream, kshark_ctx, data_rows);
>> +}
>> +
>> +/**
>> + * @brief Load the content of the trace data file asociated with a given
>> + *	  Data stream identifie into a data matrix. The user is responsible
> 
> identifie?
> 
>> + *	  for freeing the outputted data.
>> + *
>> + * @param kshark_ctx: Input location for context pointer.
>> + * @param sd: Data stream identifier.
>> + * @param cpu_array: Output location for the CPU column (array) of the matrix.
>> + * @param event_array: Output location for the Event Id column (array) of the
>> + *		       matrix.
>> + * @param _array: Output location for the  column (array) of the matrix.
>> + * @param offset_array: Output location for the offset column (array) of the
>> + *			matrix.
>> + * @param ts_array: Output location for the time stamp column (array) of the
>> + *		    matrix.
> 
> Hmm, how is this matrix composed? How do each realate, via the ts_array?
> 
> -- Steve
> 
> 
>> + */
>> +static inline ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx,
>> +					 int sd,
>> +					 int16_t **cpu_array,
>> +					 int32_t **pid_array,
>> +					 int32_t **event_array,
>> +					 int64_t **offset_array,
>> +					 int64_t **ts_array)
>> +{
>> +	struct kshark_data_stream *stream;
>> +
>> +	stream = kshark_get_data_stream(kshark_ctx, sd);
>> +	if (!stream)
>> +		return -EBADF;
>> +
>> +	return stream->interface.load_matrix(stream, kshark_ctx, cpu_array,
>> +								 pid_array,
>> +								 event_array,
>> +								 offset_array,
>> +								 ts_array);
>> +}
>> +
>>   /**
>>    * Custom entry info function type. To be user for dumping info for custom
>>    * KernelShark entryes.
> 
