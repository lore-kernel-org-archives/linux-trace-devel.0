Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E933C63697
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCDE246AA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baeHVS3W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgKSQIV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgKSQIV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 11:08:21 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0FEC0613D4
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:08:20 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id s25so8667216ejy.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GwxqTdZcy+79SHKbtQ0GZGyJ8DlJ5UNDkuKrDF6emzk=;
        b=baeHVS3W6YU29ca8eAWc0VvDjCkBTcOU60m7Qv+mYfA2uqsNIdLdcYMVQoy5nxa6Yl
         WBu6w0la45aS1K0/u5pfvQZba8UqEjB/T9wamOsGy7aTbNS4Uf+zxPoZcqs0LEvv+jYe
         SoZGROpjVqea1zzqPkq46dqop8NchUix2UmEhAv1+XdmpTLwbtAES+yZ3qIof7LeVoEe
         460dhUh6lVnQx6wMBAulRyzcHuiN6qFGxHODBU9AKAaAdKkV97BbNW9GrpOqG6vBpQiJ
         TwCnzVeYcqh1w2whW9L7B+xarluAnLiGIKo8PXncPQpWQGwfm9AVjcG6K6rZ61eA/2lX
         MaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GwxqTdZcy+79SHKbtQ0GZGyJ8DlJ5UNDkuKrDF6emzk=;
        b=OARURlhHFrg0H5wzsEfZZrX/gtDEnnVAGgMO0TAQVxsBOJm/TAXDH/OYc6ihqayyP2
         28l/6ZjG+xV2lEnHdzFmDS9UkWNj9Sf7sY6CXw2aNX0xkaCpRyTNRsGtKgPi4Ppxu1KB
         r/DOHMsvL6qwGESTGTyT+lBTBF0MYwNUzeJh3ZhNPcOaDCAtWUIiCFF5xRsZQ24MnZJj
         wVXHTjzrk41hp2YX/VoCi/6EYqNH4DsxU9kX9Sm5WbWpsZheHiCvFmBIodvVyMKRmFVb
         u1+4IAMzDoQDjnYM2rRlDcsqAqUAlAGkeOhsGTYrnup+PR8Vhv519SwTYfn62eMjMnHT
         nCqw==
X-Gm-Message-State: AOAM5319eQoB6KnuWpPqPYYj2YDIlfFgSdL+z07C7I6yC4T7oHL4aR90
        mZyW/Cp75aru5wL+9RVXf317eqoR8DE=
X-Google-Smtp-Source: ABdhPJwIttYOYIkFO5ekouBuWlrCVC+qN8Dx31r6+yX7xf7uqlO+1l8lLVkgzzC7Bs3U0kNC9vAguw==
X-Received: by 2002:a17:906:3ecf:: with SMTP id d15mr2811572ejj.297.1605802099248;
        Thu, 19 Nov 2020 08:08:19 -0800 (PST)
Received: from [192.168.0.108] ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id b1sm45322ejg.60.2020.11.19.08.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 08:08:18 -0800 (PST)
Subject: Re: [PATCH v4 10/20] kernel-shark: Start using data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201118145003.156542-1-y.karadz@gmail.com>
 <20201118145003.156542-11-y.karadz@gmail.com>
 <20201118202929.08d8a30a@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b8aa7d00-0f8d-c0a6-cb16-f25b81f21465@gmail.com>
Date:   Thu, 19 Nov 2020 18:08:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201118202929.08d8a30a@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.11.20 г. 3:29 ч., Steven Rostedt wrote:
> On Wed, 18 Nov 2020 16:49:53 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> 
>> @@ -327,6 +302,34 @@ int kshark_add_stream(struct kshark_context *kshark_ctx)
>>   	return stream->stream_id;
>>   }
>>   
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
> 
> Should probably check the result of the allocation of file.
> 
>> +
>> +	if (kshark_tep_check_data(file)) {
>> +		kshark_set_data_format(stream->data_format,
>> +				       TEP_DATA_FORMAT_IDENTIFIER);
>> +
>> +		return kshark_tep_init_input(stream, file);
> 
> Why pass in file, if it is going to equal stream->file?
> 
> Couldn't kshark_tep_init_input() just use whatever is in the stream->file?
> 

Will change both in v5.
Thanks a lot!
Y.



> -- Steve
> 
> 
>> +	}
>> +
>> +	return -ENODATA;
>> +}
>> +
>>   /**
>>    * @brief Remove Data stream.
>>    *
