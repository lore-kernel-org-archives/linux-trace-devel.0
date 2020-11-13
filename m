Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FE7C388F7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 13:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB502222F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 13:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HeK3oydI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgKMNz5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 08:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgKMNz4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 08:55:56 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F024C0613D1
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Nov 2020 05:55:56 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id cw8so13508598ejb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Nov 2020 05:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R9ZPNXXM+DTe9L03U+Y97WftAYZRdDLLcabqAm4QnsE=;
        b=HeK3oydIcvtWwi8r024ZuDrKN18zXqoQyOl0vjrgl3p7M7zmUZomJ/DO+IS5Ywy26i
         OTPJHwFXEhudyBI9kVfxtmR5+vVMrzVbd21Tq7pqWFxezD2gLCzmiQvT4iByhzP28eOL
         u+o05NhjbESsWeIKQVXe5uYeWezudmh3PFE1SYI+xaX8/3uGO5OGrTzqICa5H9MNDb5y
         uauCYNanC0s7tZJJl+Xj34uw2kDbDwJMKXW4+gt6Dtvil0SbVCs21Vory/QU+S2Q0rdH
         OaimJ8qHELMfrwl2IvI2zKyxELVeT19yH5j3eVbnGlpuJcAlvHFp3aeazR2ldEDULXgl
         YWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R9ZPNXXM+DTe9L03U+Y97WftAYZRdDLLcabqAm4QnsE=;
        b=OhqtjvgZ53cSnP/cCzNHZnsPaj/XCPQJQMRUtTs6JKSP8qbADNHltnwzYRJjxdYBLa
         q61tNZ0MF2bsayiYYcCnWs/v24CLA3POTRBBbOYf+87ksOmKEeKyGrzWSaFPhcz7c1xw
         UAgVRZWrKUCwoilQ8lDnEJBy38H7g/jzeJtZhHGMSTQsrzmPawodBIHBHbxlRHAmNWEH
         KIpa89jfg2YgCiQLShVrTiO24soDcowGNAJrV7wRxGF1VPcqye07P+PgHi0tipBKBlti
         6gyVanxIzq1Lkf3KAfWMcmopgvZN6vowd5cCwsv2DhlJsSbaeZl2cFsiMbhIT3q3CZKe
         4P7w==
X-Gm-Message-State: AOAM530YWCoQg0w8P+PQMe3mjchYLen39hPHUqhAti74hHnmqu0wfJMi
        SMkBnsr8PQ91fSZS6vD9rqy8hy4bEc4=
X-Google-Smtp-Source: ABdhPJygYKpyBzUZOM6HKitG5/sNQqQeBX4H+8j2pA3CedqMu7BAdufaYje28dXhp11/qOfCrDo6cQ==
X-Received: by 2002:a17:906:c096:: with SMTP id f22mr1924127ejz.488.1605275754574;
        Fri, 13 Nov 2020 05:55:54 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id dk8sm3633923ejb.109.2020.11.13.05.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 05:55:54 -0800 (PST)
Subject: Re: [PATCH v3 06/20] kernel-shark: Add basic methods for Data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201112142358.36821-1-y.karadz@gmail.com>
 <20201112142358.36821-7-y.karadz@gmail.com>
 <20201112161720.425de3b8@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <8c4de7e5-a818-2435-59a1-632e2c74737f@gmail.com>
Date:   Fri, 13 Nov 2020 15:55:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112161720.425de3b8@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 12.11.20 г. 23:17 ч., Steven Rostedt wrote:
> On Thu, 12 Nov 2020 16:23:44 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> +/**
>> + * @brief Add new Data stream.
>> + *
>> + * @param kshark_ctx: Input location for context pointer.
>> + *
>> + * @returns Zero on success or a negative errno code on failure.
>> + */


Yes, you are right. It must look like this


#define KS_MAX_STREAM_ID	INT16_MAX

>> +int kshark_add_stream(struct kshark_context *kshark_ctx)
>> +{
>> +	struct kshark_data_stream *stream;
>> +	int new_stream;
>> +

	if(kshark_ctx->stream_info.next_free_stream_id > KS_MAX_STREAM_ID)
		return ENODEV;

>> +	if (kshark_ctx->stream_info.next_free_stream_id ==
>> +	    kshark_ctx->stream_info.array_size) {
>> +		printf("realloc %i\n", 2 * kshark_ctx->stream_info.array_size);
> 
>   Some left over debugging? ^^^
> 
> Also, you probably want a check to make sure that you don't get bigger than
> KS_DEFAULT_NUM_STRINGS, otherwise the stream id wont fit into event id.
> 
> Oh, and KS_DEFAULT_NUM_STRINGS probably needs to be increased to the new
> max stream id.
> 
> 
>> +		struct kshark_data_stream **streams_tmp;
>> +
>> +		streams_tmp = realloc(kshark_ctx->stream,
>> +				      2 * kshark_ctx->stream_info.array_size * sizeof(*kshark_ctx->stream));
>> +		if (!streams_tmp)
>> +			return -ENOMEM;
>> +
>> +		kshark_ctx->stream = streams_tmp;
>> +		kshark_ctx->stream_info.array_size *= 2;
>> +	}
>> +
>> +	stream = kshark_stream_alloc();
>> +	if (!stream)
>> +		return -ENOMEM;
>> +
>> +	if (pthread_mutex_init(&stream->input_mutex, NULL) != 0) {
>> +		kshark_stream_free(stream);
>> +		return -EAGAIN;
>> +	}
>> +
>> +	if (kshark_ctx->stream_info.next_free_stream_id >
>> +	    kshark_ctx->stream_info.max_stream_id) {
>> +		new_stream = ++kshark_ctx->stream_info.max_stream_id;
>> +
>> +		kshark_ctx->stream_info.next_free_stream_id = new_stream + 1;
>> +
>> +		kshark_ctx->stream[new_stream] = stream;
>> +		stream->stream_id = new_stream;
>> +	} else {
>> +		new_stream = kshark_ctx->stream_info.next_free_stream_id;
>> +
>> +		kshark_ctx->stream_info.next_free_stream_id =
>> +			index_from_ptr(kshark_ctx->stream[new_stream]);
>> +
>> +		kshark_ctx->stream[new_stream] = stream;
>> +		stream->stream_id = new_stream;
>> +	}
>> +
>> +	kshark_ctx->n_streams++;
>> +
>> +	return stream->stream_id;
>> +}
>> +
>> +/**
>> + * @brief Remove Data stream.
>> + *
>> + * @param kshark_ctx: Input location for context pointer.
>> + * @param sd: Data stream identifier.
>> + *
>> + * @returns Zero on success or a negative errno code on failure.
>> + */
>> +int kshark_remove_stream(struct kshark_context *kshark_ctx, int sd)
>> +{
>> +	struct kshark_data_stream *stream;
>> +
>> +	stream = kshark_get_data_stream(kshark_ctx, sd);
>> +	if (!stream)
>> +		return -EFAULT;
>> +
>> +	kshark_stream_free(stream);
>> +	kshark_ctx->stream[sd] =
>> +		index_to_ptr(kshark_ctx->stream_info.next_free_stream_id);
>> +	kshark_ctx->stream_info.next_free_stream_id = sd;
>> +	kshark_ctx->n_streams--;
>> +
>> +	return 0;
>> +}
>> +
>> +static bool kshark_is_valid_stream(void *ptr)
>> +{
>> +	unsigned long p = (unsigned long) ptr;
>> +	bool v = !((p & ~INDEX_MASK) == INVALID_STREAM_MASK);
>> +
>> +	return p && v;
>> +}
>> +
>> +/**
>> + * @brief Get the Data stream object having given Id.
>> + *
>> + * @param kshark_ctx: Input location for context pointer.
>> + * @param sd: Data stream identifier.
>> + *
>> + * @returns Pointer to a Data stream object if the sream exists. Otherwise
>> + *	    NULL.
>> + */
>> +struct kshark_data_stream *
>> +kshark_get_data_stream(struct kshark_context *kshark_ctx, int sd)
>> +{
>> +	if (sd >= 0 && sd < KS_DEFAULT_NUM_STREAMS)
> 
> The above should probably be:
> 	if (sd >= 0 && sd <= kshark_ctx->stream_info.max_stream_id)
> 

Correct. In fact KS_DEFAULT_NUM_STREAMS sould not be defined in this 
patch but in [10/20].

> Because the array is not of KS_DEFAULT_NUM_STREAMS in size, if sd is
> greater than max_stream_id and less then KS_DEFAULT_NUM_STREAMS this code
> will access non allocated memory.
> 
>> +		if (kshark_ctx->stream[sd] &&
>> +		    kshark_is_valid_stream(kshark_ctx->stream[sd]))
>> +			return kshark_ctx->stream[sd];
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * @brief Get the Data stream object corresponding to a given entry
>> + *
>> + * @param entry: Input location for the KernelShark entry.
>> + *
>> + * @returns Pointer to a Data stream object on success. Otherwise NULL.
>> + */
>> +struct kshark_data_stream *
>> +kshark_get_stream_from_entry(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_context *kshark_ctx = NULL;
>> +
>> +	if (!kshark_instance(&kshark_ctx))
>> +		return NULL;
>> +
>> +	return kshark_get_data_stream(kshark_ctx, entry->stream_id);
>> +}
>> +
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
>> +	ids = calloc(kshark_ctx->n_streams, (sizeof(*ids)));
>> +	if (!ids)
>> +		return NULL;
>> +
>> +	for (i = 0; i <= kshark_ctx->stream_info.max_stream_id; ++i)
>> +		if (kshark_ctx->stream[i] &&
>> +		    kshark_is_valid_stream(kshark_ctx->stream[i]))
>> +			ids[count++] = i;
>> +
>> +	return ids;
>> +}
>>   /**
>>    * @brief Close the trace data file and free the trace data handle.
>>    *
>> @@ -252,6 +484,474 @@ void kshark_free(struct kshark_context *kshark_ctx)
>>   	free(kshark_ctx);
>>   }
>>   
>> +/* Quiet warnings over documenting simple defs. */
>> +//! @cond Doxygen_Suppress
>> +
>> +#define BROKEN_STREAM(stream) (!stream || !stream->interface)
>> +
>> +//! @endcond
>> +
>> +/**
>> + * @brief Get the name of the command/task from its Process Id.
>> + *
>> + * @param sd: Data stream identifier.
>> + * @param pid: Process Id of the command/task.
>> + */
>> +char *kshark_comm_from_pid(int sd, int pid)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_context *kshark_ctx = NULL;
>> +	struct kshark_data_stream *stream;
>> +	struct kshark_entry e;
>> +
>> +	if (!kshark_instance(&kshark_ctx))
>> +		return NULL;
>> +
>> +	stream = kshark_get_data_stream(kshark_ctx, sd);
>> +	if (BROKEN_STREAM(stream))
>> +		return NULL;
> 
> Is kshark_get_data_stream() ever used without stream->interface? At least
> in this patch, all callers of kshark_get_data_stream() or
> kshark_get_stream_from_entry() (which the last thing it does is call
> kshark_get_data_stream()), is followed by this BROKEN_STREAM() check.
> 
> Would it make more sense to put in kshark_get_data_stream() the check for
> stream->interface, and return NULL if that's not set? Then we can remove
> all of the BROKEN_STREAM() callers and just have:
> 
> 	if (!stream)
> 		return NULL;
> 
Yes, it is used a lot in the GUI, but you are right. There is no point 
of having kshark_get_data_stream() return broken stream objects.
Will be changed in v4.

> 
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_task) {
>> +		e.visible = KS_PLUGIN_UNTOUCHED_MASK;
>> +		e.pid = pid;
>> +
>> +		return interface->get_task(stream, &e);
>> +	}
>> +
>> +	return NULL;
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
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_context *kshark_ctx = NULL;
>> +	struct kshark_data_stream *stream;
>> +	struct kshark_entry e;
>> +
>> +	if (!kshark_instance(&kshark_ctx))
>> +		return NULL;
>> +
>> +	stream = kshark_get_data_stream(kshark_ctx, sd);
>> +	if (BROKEN_STREAM(stream))
>> +		return NULL;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_event_name) {
>> +		e.visible = KS_PLUGIN_UNTOUCHED_MASK;
>> +		e.event_id = event_id;
>> +
>> +		return interface->get_event_name(stream, &e);
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * @brief Get the original process Id of the entry. Using this function make
>> + *	  sense only in cases when the original value can be overwritten by
>> + *	  plugins. If you know that no plugins are loaded use "entry->pid"
>> + *	  directly.
>> + *
>> + * @param entry: Input location for an entry.
>> + */
>> +int kshark_get_pid(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return -EFAULT;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_pid)
>> +		return -EFAULT;
>> +
>> +	return interface->get_pid(stream, entry);
>> +}
>> +
>> +/**
>> + * @brief Get the original event Id of the entry. Using this function make
>> + *	  sense only in cases when the original value can be overwritten by
>> + *	  plugins. If you know that no plugins are loaded use "entry->event_id"
>> + *	  directly.
>> + *
>> + * @param entry: Input location for an entry.
>> + */
>> +int kshark_get_event_id(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return -EFAULT;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_event_id)
>> +		return interface->get_event_id(stream, entry);
>> +
>> +	return -EFAULT;
>> +}
>> +
>> +/**
>> + * @brief Get an array of all event Ids for a given data stream.
>> + *
>> + * @param stream: Input location for a Trace data stream pointer.
>> + *
>> + * @returns An array of event Ids. The user is responsible for freeing the
>> + *	    outputted array.
>> + */
>> +int *kshark_get_all_event_ids(struct kshark_data_stream *stream)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return NULL;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_all_event_ids)
>> +		return interface->get_all_event_ids(stream);
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * @brief Find the event Ids corresponding to a given event name.
>> + *
>> + * @param stream: Input location for a Trace data stream pointer.
>> + * @param event_name: The name of the event.
>> + *
>> + * @returns Event Ids number.
>> + */
>> +int kshark_find_event_id(struct kshark_data_stream *stream,
>> +			 const char *event_name)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return -EFAULT;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->find_event_id)
>> +		return interface->find_event_id(stream, event_name);
>> +
>> +	return -EFAULT;
>> +}
>> +
>> +/**
>> + * @brief Find the event name corresponding to a given entry.
>> + *
>> + * @param entry: Input location for an entry.
>> + *
>> + * @returns The mane of the event on success, or NULL in case of failure.
>> + *	    The use is responsible for freeing the output string.
>> + */
>> +char *kshark_get_event_name(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return NULL;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_event_name)
>> +		return interface->get_event_name(stream, entry);
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * @brief Find the task name corresponding to a given entry.
>> + *
>> + * @param entry: Input location for an entry.
>> + *
>> + * @returns The mane of the task on success, or NULL in case of failure.
>> + *	    The use is responsible for freeing the output string.
>> + */
>> +char *kshark_get_task(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return NULL;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_task)
>> +		return interface->get_task(stream, entry);
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * @brief Get the basic information (text) about the entry.
>> + *
>> + * @param entry: Input location for an entry.
>> + *
>> + * @returns A the info text. The user is responsible for freeing the
>> + *	    outputted string.
>> + */
>> +char *kshark_get_info(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return NULL;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_info)
>> +		return interface->get_info(stream, entry);
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * @brief Get the auxiliary information about the entry. In the case of
>> + * 	  TEP (Ftrace) data, this function provides the latency info.
>> + *
>> + * @param entry: Input location for an entry.
>> + *
>> + * @returns A the auxiliary text info. The user is responsible for freeing the
>> + *	    outputted string.
>> + */
>> +char *kshark_get_aux_info(const struct kshark_entry *entry)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return NULL;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->aux_info)
>> +		return interface->aux_info(stream, entry);
>> +
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * @brief Get an array of all data field names associated with a given entry.
>> + *
>> + * @param entry: Input location for an entry.
>> + * @param fields: Output location of the array of field names. The user is
>> + *		  responsible for freeing the elements of the outputted array.
>> + *
>> + * @returns Total number of event fields on success, or a negative errno in
>> + *	    the case of a failure.
>> + */
>> +int kshark_get_all_event_field_names(const struct kshark_entry *entry,
>> +				     char ***fields)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return -EFAULT;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_all_event_field_names)
>> +		return interface->get_all_event_field_names(stream,
>> +							    entry, fields);
>> +
>> +	return -EFAULT;
>> +}
>> +
>> +/**
>> + * @brief Get the value type of an event field corresponding to a given entry.
>> + *
>> + * @param entry: Input location for an entry.
>> + * @param field: The name of the data field.
>> + *
>> + * @returns The type of the data field on success, or KS_INVALIDE_FIELD in
>> + *	    the case of a failure.
>> + */
>> +kshark_event_field_format
>> +kshark_get_event_field_type(const struct kshark_entry *entry,
>> +			    const char *field)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return KS_INVALIDE_FIELD;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->get_event_field_type)
>> +		return interface->get_event_field_type(stream, entry, field);
>> +
>> +	return KS_INVALIDE_FIELD;
>> +}
>> +
>> +/**
>> + * @brief Get the value of an event field in a given trace record.
>> + *
>> + * @param stream: Input location for a Trace data stream pointer.
>> + * @param rec: Input location for a record.
>> + * @param field: The name of the data field.
>> + * @param val: Output location for the value of the field.
>> + *
>> + * @returns Zero on success or a negative errno in the case of a failure.
>> + */
>> +int kshark_read_record_field_int(struct kshark_data_stream *stream, void *rec,
>> +				 const char *field, int64_t *val)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return -EFAULT;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->read_record_field_int64)
>> +		return interface->read_record_field_int64(stream, rec,
>> +							  field, val);
>> +
>> +	return -EFAULT;
>> +}
>> +
>> +/**
>> + * @brief Get the value of an event field corresponding to a given entry.
>> + *	  The value is retrieved via the offset in the file of the original
>> + *	  record.
>> + *
>> + * @param entry: Input location for an entry.
>> + * @param field: The name of the data field.
>> + * @param val: Output location for the value of the field.
>> + *
>> + * @returns Zero on success or a negative errno in the case of a failure.
>> + */
>> +int kshark_read_event_field_int(const struct kshark_entry *entry,
>> +				const char* field, int64_t *val)
>> +{
>> +	struct kshark_generic_stream_interface *interface;
>> +	struct kshark_data_stream *stream =
>> +		kshark_get_stream_from_entry(entry);
>> +
>> +	if (BROKEN_STREAM(stream))
>> +		return -EFAULT;
>> +
>> +	interface = stream->interface;
>> +	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> +	    interface->read_event_field_int64)
>> +		return interface->read_event_field_int64(stream, entry, field, val);
>> +
>> +	return -EFAULT;
>> +}
>> +
>> +/** @brief Print the entry. */
>> +void kshark_print_entry(const struct kshark_entry *entry)
>> +{
>> +	char *entry_str = kshark_dump_entry(entry);
> 
> Should there be a "if (!entry_str) return;" check here?
> 

Thanks a lot!
Y.

> -- Steve
> 
>> +
>> +	puts(entry_str);
>> +	free(entry_str);
>> +}
>> +
>> +/**
>> + * @brief Load the content of the trace data file asociated with a given
>> + *	  Data stream into an array of kshark_entries.
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
