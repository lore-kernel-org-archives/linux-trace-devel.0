Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C6CC388F7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 13:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB76322201
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 13:47:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IuDAYvEE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgKMNrJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 08:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgKMNrI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 08:47:08 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68790C0613D1
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Nov 2020 05:47:08 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id dk16so13455053ejb.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Nov 2020 05:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=arNuayBaw4+sNOFtUQRZk123gcSh2NCnuOh/BKKbOW8=;
        b=IuDAYvEEmgsEbm8c+FAWwXHUNG09PXoJdjLRrJaOO+qj3e8QgXzdlqUda9cxkHHZPr
         3DpiZzs2zw/KdvbR/jK4IPD44H1qGtuq2fjRa+/Azz0VHqgA/D8higvEIUOTxfXnMXHq
         +kb12mVtSSmZfhkL3uWziogL+BVZiiA61kFkgH0kL8sfQY1ept+4w5Y7cEyb4Vx6ppk7
         s08p7fzU0F1L2Tk4a1vdS5d6Nis4z8rk6Vn8q3yI7qeyGbMq+33lChJQ++aeTqxUocpm
         5XqIyNrnbXJdnAAx3BHooeMJt7Au755/amGqroYu/LtttmUQIFviLa3Qk2U6YAhHTYnL
         0nRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=arNuayBaw4+sNOFtUQRZk123gcSh2NCnuOh/BKKbOW8=;
        b=rK7M2u6zIHGz0Z3d9eeaFvb3PBVZJm4Fj9HEJtb1SdtUWDt+5ZO+SbdzNuWMjkWSNk
         9UC8o4RXg5BEYvHsPa8RU16IDvjnBIo37g/5Oik9xNAAmYrQy/S4dK+6FBhRIVOJxg00
         dOyXZ+Kapqb1hcQoPt+uEki8KJQZvTHEC6mELH2HLsHy7ekhXlFAO/bFTMkDybwqJUHD
         lK3V8wGqDKtH9+s+tN/mP7WUywvsv+hv9UIYGQcZ07oqv09g+rJl8ySeg+cYml4aGJ/X
         zxUMFgN3HIdWJEjmyV+O4qwmBwlQoiPr55+HFY62yJb6xpPlVE49HdME0lKHlzRMyNZY
         Yafw==
X-Gm-Message-State: AOAM530gEwvts/D7aCm0FNGpG1lzUCizj5XAvIn8sM3MP0tEoLqVZDCt
        p3oeYFvJL0ddH7tRnIW2Mu8krf9npIs=
X-Google-Smtp-Source: ABdhPJwuzr5Hw60XCdmbAFczrip8NzadAUFmVgyq502YuCjB2yZQrVy9NiUKkGSByQNgNHVIfzL+ow==
X-Received: by 2002:a17:906:c1ce:: with SMTP id bw14mr1974623ejb.302.1605275226907;
        Fri, 13 Nov 2020 05:47:06 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id 22sm3652870ejw.27.2020.11.13.05.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 05:47:06 -0800 (PST)
Subject: Re: [PATCH v3 04/20] kernel-shark: Introduce Data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201112142358.36821-1-y.karadz@gmail.com>
 <20201112142358.36821-5-y.karadz@gmail.com>
 <20201112155051.18e226e9@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <164442c9-0732-2fda-d6d2-96077d6f170e@gmail.com>
Date:   Fri, 13 Nov 2020 15:47:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112155051.18e226e9@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 12.11.20 г. 22:50 ч., Steven Rostedt wrote:
> On Thu, 12 Nov 2020 16:23:42 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> With the help of Data stream, KernelShark will be able to load and
>> merge multiple trace files (streams). Each stream can have different
>> plugins or filters, registered for it, which means that the raw trace
>> data of the streams can have different formats, and will allow for a
>> great degree of customization of the provided data visualization. In
>> this patch we only provide the basic definitions. The actual integration
>> of the Data streams into the C API of KernelShark will happen in the
>> following patches.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   src/libkshark.h | 216 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 216 insertions(+)
>>
>> diff --git a/src/libkshark.h b/src/libkshark.h
>> index cc20077f..c8fdd266 100644
>> --- a/src/libkshark.h
>> +++ b/src/libkshark.h
>> @@ -121,6 +121,222 @@ void kshark_hash_id_free(struct kshark_hash_id *hash);
>>   
>>   int *kshark_hash_ids(struct kshark_hash_id *hash);
>>   
>> +struct kshark_data_stream;
>> +
>> +/** A function type to be used to initialize the interface of the data stream. */
>> +typedef int (*interface_init_func) (struct kshark_data_stream *,
>> +				    const char *);
>> +
>> +/** A function type to be used to initialize the interface of the data stream. */
>> +typedef int (*interface_close_func) (struct kshark_data_stream *,
>> +				     const char *);
> 
> These two typedefs should probably be introduced when a patch that uses them
> is added. Otherwise they are basically meaningless for the reviewer.
> 
> Also, it the above looks like a cut-and-paste error as the close has the
> same description as the init.
> 
> I don't even see the above used in later patches :-/
> 

You are right. This is a dead code left over from previous versions of 
the way input plugins have been loaded.

> 
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef char *(*stream_get_str_func) (struct kshark_data_stream *,
>> +				      const struct kshark_entry *);
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef const int (*stream_get_int_func) (struct kshark_data_stream *,
>> +					  const struct kshark_entry *);
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef int (*stream_find_id_func) (struct kshark_data_stream *,
>> +				    const char *);
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef int *(*stream_get_ids_func) (struct kshark_data_stream *);
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef int (*stream_get_names_func) (struct kshark_data_stream *,
>> +				      const struct kshark_entry *,
>> +				      char ***);
>> +
>> +/** Event field format identifier. */
>> +typedef enum kshark_event_field_format {
>> +	/** A field of unknown type. */
>> +	KS_INVALIDE_FIELD,
> 
> 	KS_INVALID_FIELD ?
> 

My idea is this identifier to be used for event fields having type that 
is not supported by the interface. For example strings or arrays.

>> +
>> +	/** Integer number */
>> +	KS_INTEGER_FIELD,
>> +
>> +	/** Floating-point number */
>> +	KS_FLOAT_FIELD
>> +} kshark_event_field_format;
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef kshark_event_field_format
>> +(*stream_event_field_type) (struct kshark_data_stream *,
>> +			    const struct kshark_entry *,
>> +			    const char *);
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef const int (*stream_read_event_field) (struct kshark_data_stream *,
>> +					      const struct kshark_entry *,
>> +					      const char *,
>> +					      int64_t *);
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef const int (*stream_read_record_field) (struct kshark_data_stream *,
>> +					       void *,
>> +					       const char *,
>> +					       int64_t *);
>> +
>> +struct kshark_context;
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef ssize_t (*load_entries_func) (struct kshark_data_stream *,
>> +				      struct kshark_context *,
>> +				      struct kshark_entry ***);
>> +
>> +/** A function type to be used by the method interface of the data stream. */
>> +typedef ssize_t (*load_matrix_func) (struct kshark_data_stream *,
>> +				     struct kshark_context *,
>> +				     int16_t **event_array,
>> +				     int16_t **cpu_array,
>> +				     int32_t **pid_array,
>> +				     int64_t **offset_array,
>> +				     int64_t **ts_array);
>> +
>> +/** Data format identifier. */
>> +typedef enum kshark_data_format {
>> +	/** A data of unknown type. */
>> +	KS_INVALIDE_DATA,
> 
> 	KS_INVALID_DATA ?

this identifier will be used in the case you are trying to open an 
arbitrary file that contains no tracing data (.jpeg for example).
> 
>> +
>> +	/** Ftrace data. */
>> +	KS_TEP_DATA,
>> +
>> +	/** VMware SchedTrace data. */
>> +	KS_VMW_ST_DATA,
>> +} kshark_data_format;
> 
> I wonder if this should be a string value that gets registered? Otherwise
> we will have to be the registry of every new stream format added.
> 
> This is the approach that Tzvetomir took for protocol ids, because that way
> we don't need to keep track of them:
> 
>   https://lore.kernel.org/r/20201029111816.247241-2-tz.stoyanov@gmail.com
> 

I wonder how we can avoid name collisions, especially in the case when 
some of the data readout plugins will be proprietary.
Also I don't think we can expect more than a dozen of distinct data 
formats to be supported.

Thanks!
Yordan


> -- Steve
> 
>> +
>> +/** Data interface identifier. */
>> +typedef enum kshark_data_interface_id {
>> +	/** An interface with unknown type. */
>> +	KS_INVALIDE_INTERFACE,
>> +
>> +	/** Generic interface suitable for Ftrace data. */
>> +	KS_GENERIC_DATA_INTERFACE,
>> +} kshark_data_interface_id;
>> +
