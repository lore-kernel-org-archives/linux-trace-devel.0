Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B69C4742C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0207221FA
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emSVjox7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgKEO6z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730461AbgKEO6z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:58:55 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B65C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:58:54 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c16so1909573wmd.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 06:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IR+hIuQCx208ggty+yxx0rsvxYJL8fDifFq5Vu3EpI8=;
        b=emSVjox7cOYkv4ccql0e/1mrZ1gmo3qPdECicLTkudg3ivagEZpdhqGT3RCJ8jP/RS
         1eCyLiJDoHkCqHQoh9XV5pWSgKZ08iZJ88R9nn8jpEE1cgrjgg7c9m2S9QdqRZ09QKYj
         rGF4qj0msB3zqgiumeut3nPwNBcrrqBHSfxgwL97LFy4GgCNatk8/IcamHCEUJX63qdg
         m4KBsiqwgFLEsLdL9Ku+6unArsk2u43i4SZE/835VSw+NCQ7FsflllRiSK3J01r2n81B
         C+fG902qFYDm/+K+mhG9dkImUhoxYN+maTLSFK66xmfN07OpULB1zHFG+0R/BHW5jRZG
         I/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IR+hIuQCx208ggty+yxx0rsvxYJL8fDifFq5Vu3EpI8=;
        b=VG1eBD1ohRU4gaC4JY05GllqtCeIdn4ZEbm/9qJRPtxMY+g/llLL+gP6/x5qTvh4OG
         oH13UHHwnNtYFe/vCk5HD4cgMkorL6NKl2Wt3K90NmP3Fe5SQpJXRIwZO2tvDmPCQLQG
         rzsqqET3gugX+TOHawt7azYdEyc610rQY+SBwMHco1Hdjvs6b9cmyc9DxLk4oKc7FEKq
         fxJ1aFD508HfrYJAOHs9/RoO5eNPdtjnGee/e93nHZEiItRcUWIsdFZeDGda/KKs6goE
         0oGtB2Tjiuzkig+UTD0iloIDf4gGzqnZxrybHhyDOVoJ0WxlpKLYD2Bgrcs6Cv9PI2TA
         cWoA==
X-Gm-Message-State: AOAM533HxIZsKCQbUp22HG0SthriI5QfC6s2UzjZxiHBUF6ioRC2uiLW
        AGjo05xak7GPpJxL6ij/sHzWP+fsMP8=
X-Google-Smtp-Source: ABdhPJyVCI5gxCu1jmn7tWhfPRAHis8D0QJe2lSXgCWEojK2ZshGIaGUWS34R49Af/65Ye5s7zO5zA==
X-Received: by 2002:a05:600c:2048:: with SMTP id p8mr3286470wmg.165.1604588332921;
        Thu, 05 Nov 2020 06:58:52 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id t4sm3015120wmb.20.2020.11.05.06.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 06:58:52 -0800 (PST)
Subject: Re: [PATCH v2 10/20] kernel-shark: Start using data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-11-y.karadz@gmail.com>
 <20201014145627.675e3c70@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b5569725-239f-3e5b-dfa0-97f7d51b5d01@gmail.com>
Date:   Thu, 5 Nov 2020 16:58:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201014145627.675e3c70@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 14.10.20 г. 21:56 ч., Steven Rostedt wrote:
> On Mon, 12 Oct 2020 16:35:13 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Here we switch to using the trace data readout, provided by the Data
>> stream interface. The actual implementation of the new readout was
>> done in the previous commits.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>> --- a/src/libkshark.c
>> +++ b/src/libkshark.c
>> @@ -19,6 +19,7 @@
>>   
>>   // KernelShark
>>   #include "libkshark.h"
>> +#include "libkshark-tepdata.h"
>>   
>>   static __thread struct trace_seq seq;
>>   
>> @@ -32,6 +33,9 @@ static bool kshark_default_context(struct kshark_context **context)
>>   	if (!kshark_ctx)
>>   		return false;
>>   
>> +	kshark_ctx->stream = calloc(KS_MAX_NUM_STREAMS,
>> +				    sizeof(*kshark_ctx->stream));
>> +
>>   	kshark_ctx->event_handlers = NULL;
>>   	kshark_ctx->collections = NULL;
>>   	kshark_ctx->plugins = NULL;
>> @@ -108,62 +112,28 @@ bool kshark_instance(struct kshark_context **kshark_ctx)
>>   	return true;
>>   }
>>   
>> -static void kshark_free_task_list(struct kshark_context *kshark_ctx)
>> -{
>> -	struct kshark_task_list *task;
>> -	int i;
>> -
>> -	if (!kshark_ctx)
>> -		return;
>> -
>> -	for (i = 0; i < KS_TASK_HASH_SIZE; ++i) {
>> -		while (kshark_ctx->tasks[i]) {
>> -			task = kshark_ctx->tasks[i];
>> -			kshark_ctx->tasks[i] = task->next;
>> -			free(task);
>> -		}
>> -	}
>> -}
>> -
>>   /**
>>    * @brief Open and prepare for reading a trace data file specified by "file".
>> - *	  If the specified file does not exist, or contains no trace data,
>> - *	  the function returns false.
>>    *
>>    * @param kshark_ctx: Input location for context pointer.
>>    * @param file: The file to load.
>>    *
>> - * @returns True on success, or false on failure.
>> + * @returns The Id number of the data stream associated with this file on success.
>> + * 	    Otherwise a negative errno code.
>>    */
>> -bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
>> +int kshark_open(struct kshark_context *kshark_ctx, const char *file)
>>   {
>> -	struct tracecmd_input *handle;
>> -
>> -	kshark_free_task_list(kshark_ctx);
>> -
>> -	handle = tracecmd_open(file);
>> -	if (!handle)
>> -		return false;
>> -
>> -	if (pthread_mutex_init(&kshark_ctx->input_mutex, NULL) != 0) {
>> -		tracecmd_close(handle);
>> -		return false;
>> -	}
>> -
>> -	kshark_ctx->handle = handle;
>> -	kshark_ctx->pevent = tracecmd_get_pevent(handle);
>> +	int sd, rt;
>>   
>> -	kshark_ctx->advanced_event_filter =
>> -		tep_filter_alloc(kshark_ctx->pevent);
>> +	sd = kshark_add_stream(kshark_ctx);
>> +	if (sd < 0)
>> +		return sd;
>>   
>> -	/*
>> -	 * Turn off function trace indent and turn on show parent
>> -	 * if possible.
>> -	 */
>> -	tep_plugin_add_option("ftrace:parent", "1");
>> -	tep_plugin_add_option("ftrace:indent", "0");
>> +	rt = kshark_stream_open(kshark_ctx->stream[sd], file);
>> +	if (rt < 0)
> 
> On failure, we should probably destroy the stream that was created.


Correct, will be fixed in v3.

> 
>> +		return rt;
>>   
>> -	return true;
>> +	return sd;
>>   }
>>   
>>   static void kshark_stream_free(struct kshark_data_stream *stream)
>> @@ -253,6 +223,56 @@ int kshark_add_stream(struct kshark_context *kshark_ctx)
>>   	return stream->stream_id;
>>   }
>>   
>> +static bool is_tep(const char *filename)
>> +{
>> +	/*
>> +	 * TODO: This is very naive. Implement more appropriate check. Ideally
>> +	 * it should be part of the trace-cmd library.
>> +	 */
>> +	char *ext = strrchr(filename, '.');
>> +	return ext && strcmp(ext, ".dat") == 0;
>> +}
>> +
>> +static void set_format(struct kshark_context *kshark_ctx,
>> +		       struct kshark_data_stream *stream,
>> +		       const char *filename)
>> +{
>> +	stream->format = KS_INVALIDE_DATA;
>> +
>> +	if (is_tep(filename)) {
>> +		stream->format = KS_TEP_DATA;
>> +		return;
>> +	}
>> +}
>> +
>> +/**
>> + * @brief Use an existing Trace data stream to open and prepare for reading
>> + *	  a trace data file specified by "file".
>> + *
>> + * @param stream: Input location for a Trace data stream pointer.
>> + * @param file: The file to load.
>> + *
>> + * @returns Zero on success or a negative error code in the case of an errno.
>> + */
>> +int kshark_stream_open(struct kshark_data_stream *stream, const char *file)
>> +{
>> +	struct kshark_context *kshark_ctx = NULL;
>> +
>> +	if (!stream || !kshark_instance(&kshark_ctx))
>> +		return -EFAULT;
>> +
>> +	stream->file = strdup(file);
>> +	set_format(kshark_ctx, stream, file);
>> +
>> +	switch (stream->format) {
>> +	case KS_TEP_DATA:
>> +		return kshark_tep_init_input(stream, file);
>> +
>> +	default:
>> +		return -ENODATA;
>> +	}
>> +}
>> +
>>   /**
>>    * @brief Get the Data stream object having given Id.
>>    *
>> @@ -313,45 +333,76 @@ int *kshark_all_streams(struct kshark_context *kshark_ctx)
>>   	return ids;
>>   }
>>   
>> +static void kshark_stream_close(struct kshark_data_stream *stream)
>> +{
>> +	struct kshark_context *kshark_ctx = NULL;
>> +
>> +	if (!stream || !kshark_instance(&kshark_ctx))
>> +		return;
>> +
>> +	/*
>> +	 * All filters are file specific. Make sure that all Process Ids and
>> +	 * Event Ids from this file are not going to be used with another file.
>> +	 */
>> +	kshark_hash_id_clear(stream->show_task_filter);
>> +	kshark_hash_id_clear(stream->hide_task_filter);
>> +	kshark_hash_id_clear(stream->show_event_filter);
>> +	kshark_hash_id_clear(stream->hide_event_filter);
>> +	kshark_hash_id_clear(stream->show_cpu_filter);
>> +	kshark_hash_id_clear(stream->hide_cpu_filter);
>> +
>> +	switch (stream->format) {
>> +	case KS_TEP_DATA:
>> +		kshark_tep_close_interface(stream);
>> +		break;
>> +
>> +	default:
>> +		break;
>> +	}
>> +
>> +	pthread_mutex_destroy(&stream->input_mutex);
>> +}
>> +
>>   /**
>>    * @brief Close the trace data file and free the trace data handle.
>>    *
>>    * @param kshark_ctx: Input location for the session context pointer.
>> + * @param sd: Data stream identifier.
>>    */
>> -void kshark_close(struct kshark_context *kshark_ctx)
>> +void kshark_close(struct kshark_context *kshark_ctx, int sd)
>>   {
>> -	if (!kshark_ctx || !kshark_ctx->handle)
>> +	struct kshark_data_stream *stream;
>> +
>> +	stream = kshark_get_data_stream(kshark_ctx, sd);
>> +	if (!stream)
>>   		return;
>>   
>> -	/*
>> -	 * All filters are file specific. Make sure that the Pids and Event Ids
>> -	 * from this file are not going to be used with another file.
>> -	 */
>> -	tracecmd_filter_id_clear(kshark_ctx->show_task_filter);
>> -	tracecmd_filter_id_clear(kshark_ctx->hide_task_filter);
>> -	tracecmd_filter_id_clear(kshark_ctx->show_event_filter);
>> -	tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
>> -	tracecmd_filter_id_clear(kshark_ctx->show_cpu_filter);
>> -	tracecmd_filter_id_clear(kshark_ctx->hide_cpu_filter);
>> -
>> -	if (kshark_ctx->advanced_event_filter) {
>> -		tep_filter_reset(kshark_ctx->advanced_event_filter);
>> -		tep_filter_free(kshark_ctx->advanced_event_filter);
>> -		kshark_ctx->advanced_event_filter = NULL;
>> -	}
>> +	kshark_stream_close(stream);
>> +	kshark_stream_free(stream);
>> +	kshark_ctx->stream[sd] = NULL;
>> +	kshark_ctx->n_streams--;
> 
> So, if you have multiple streams, and you close one that's not the last,
> and then add a new one, this will cause the new one to be overwritten.
> 
> As add_stream has:
> 
> 	kshark_ctx->stream[kshark_ctx->n_streams++] = stream;
> 

I see the problem. This is definitely wrong.

What if in addition to "n_streams" I add another counter called 
"last_stream_added" and initialize this counter to -1?

Then I can add streams like this:

	kshark_ctx->stream[++kshark_ctx->last_stream_added] = stream;
	++kshark_ctx->n_streams;

> You may want to do instead:
> 
> 	kshark_ctx->stream[sd] = NULL;
> 	while (!kshark->streams[kshark_ctx->n_streams - 1])
> 		kshark_ctx->n_streams--;
> 
> You can also add a free store, where you store an index in the stream[sd]
> field of the next free item. Then for adding you have:
> 
> 	if (kshark_ctx->free >= 0) {
> 		sd = kshark_ctx->free;
> 		kshark_ctx->free = (int)kshark_ctx->stream[kshark_ctx->free];
> 	} else {
> 		sd = kshark_ctx->n_streams++;
> 	}
> 
> and on freeing:
> 
> 	kshark_ctx->streams[sd] = (void *)kshark_ctx->free;
> 	kshark_ctx->free = sd;
> 
> Just need to initialize kshark_ctx->free to -1.
> 
> And never decrement n_streams. If you do any loops over the stream, you
> could verify that it is a real stream by:
> 

I really need n_streams to show the true number of active streams 
because the widgets are using this a lot.

The way I loop over the active streams is the following:

	int *stream_ids = kshark_all_streams(kshark_ctx);
	for (i = 0; i < kshark_ctx->n_streams; ++i) {
		stream = kshark_ctx->stream[stream_ids[i]];

		....
	}

	free(stream_ids);

and with the addition of "last_stream_added" kshark_all_streams() will 
look like this:

int *kshark_all_streams(struct kshark_context *kshark_ctx)
{
	int *ids, i, count = 0;

	ids = calloc(kshark_ctx->n_streams, (sizeof(*ids)));
	if (!ids)
		return NULL;

	for (i = 0; i <= kshark_ctx->last_stream_added; ++i)
		if (kshark_ctx->stream[i])
			ids[count++] = i;

	return ids;
}

What do you think?

Thanks a lot!
Yordan

> 	if ((unsigned long)kshark_ctx->streams[sd] > kshark_ctx->n_streams)
> 		/* pointer to a stream */
> 	else
> 		/* a free item. */
> 
> Places like kshark_close() would need the above (if doing a free store).
> 
> -- Steve
> 
> 
>> +}
>> +
>> +/**
>> + * @brief Close all currently open trace data file and free the trace data handle.
>> + *
>> + * @param kshark_ctx: Input location for the session context pointer.
>> + */
>> +void kshark_close_all(struct kshark_context *kshark_ctx)
>> +{
>> +	int i, *stream_ids, n_streams;
>> +
>> +	stream_ids = kshark_all_streams(kshark_ctx);
>>   
>>   	/*
>> -	 * All data collections are file specific. Make sure that collections
>> -	 * from this file are not going to be used with another file.
>> +	 * Get a copy of shark_ctx->n_streams befor you start closing. Be aware
>> +	 * that kshark_close() will decrement shark_ctx->n_streams.
>>   	 */
>> -	kshark_free_collection_list(kshark_ctx->collections);
>> -	kshark_ctx->collections = NULL;
>> -
>> -	tracecmd_close(kshark_ctx->handle);
>> -	kshark_ctx->handle = NULL;
>> -	kshark_ctx->pevent = NULL;
>> +	n_streams = kshark_ctx->n_streams;
>> +	for (i = 0; i < n_streams; ++i)
>> +		kshark_close(kshark_ctx, stream_ids[i]);
>>   
>> -	pthread_mutex_destroy(&kshark_ctx->input_mutex);
>> +	free(stream_ids);
>>   }
>>   
>>   /**
