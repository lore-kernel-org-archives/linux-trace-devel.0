Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1F5C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF3F61057
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 13:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhHTNgy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 09:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbhHTNgx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 09:36:53 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75BBC061575
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Aug 2021 06:36:15 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id x11so20450303ejv.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Aug 2021 06:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nkXklqdNVgi+i5FnZ/Sb+n57lxBOkrzgJ+suDwQc32M=;
        b=pBh1RO8y/YTXO6CuhxzBdkeDUvQP2SN+9HZK3uTycf5nk+Ib6aX0qZFJXsT1W29Q8m
         boMJMCZgatlMlWJcyvyviKF/SIjmojmqmiMCiRyAv6fY1b4rv0d1jcK1e3icVj+zkQ6J
         uDSPWiK86DmuIjDvJ9pdf5TYSMVdMk739oUqjDmsS/9MZacR1Yd7yK1HBz+Ge6QtWGrk
         3MBsKnIhToaVn+5rCMx4hEuBWhGF0m8xr401JbR4SRSfDG71HYRcnnjjsXIy65eeY5OX
         Qkrkmv4zRX/SnVnGCr9GbpLVg/y0T1VclC8RRbygaEnaS/Lfj+RfZ0/t4WyKJhKul1/y
         byuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nkXklqdNVgi+i5FnZ/Sb+n57lxBOkrzgJ+suDwQc32M=;
        b=kmvFT+7UVNNpXFrTdiJ+S+ClgLFOOgq+ByrpdyDbNDQw3FlPSqRqziolbGmT7VZHVI
         1lKWb3Xpz9VPnaitZLUrwmqlwiNIS9/hm4intYYIXWiV5HtlT/WjCp1/n8lmHZYbB54d
         AT3tDFwRWAHocUA3k/blPFmcluso68CEE0UNV6WjLMiDNrqvhyh7E0LPHLGG6k5+isC+
         ETM/pYhkvSVfUVmGqvo0HfV051Ygou5/2dxVDsAbN8w5Oxikkf1ZTfz9nHt6ce5oIlN+
         nuE+mxU/rROvJLWnOA3OX11+7/Yjml5F8iAh54L9dblzvG8QJ7LfJCLY1b2N11tREPVz
         vfYA==
X-Gm-Message-State: AOAM533T8A46Mzu8D1+M1ZlztLB14X1nnKiyE6X5uXbH5kbtHiI9umwK
        U/1yMWZVj8ZTaylZP3vhLAFAHGM7O7Q=
X-Google-Smtp-Source: ABdhPJx05As7uDuxk/KBpY5VmJsePv2L5WHjQQNwCJYVzGGfDx5Gb+/decvUs3b72oaRWZiVP9n25A==
X-Received: by 2002:a17:906:659:: with SMTP id t25mr21664562ejb.372.1629466574242;
        Fri, 20 Aug 2021 06:36:14 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id s24sm3573983edq.56.2021.08.20.06.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 06:36:13 -0700 (PDT)
Subject: Re: [PATCH v6 5/5] libtraceevent: Add tep_print_selected_fields()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210812085929.54832-1-y.karadz@gmail.com>
 <20210812085929.54832-6-y.karadz@gmail.com>
 <20210819125510.0b0b04c2@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <a15c7f5f-aa16-7e34-f2fe-bf05a13069e5@gmail.com>
Date:   Fri, 20 Aug 2021 16:36:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210819125510.0b0b04c2@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.08.21 г. 19:55, Steven Rostedt wrote:
> On Thu, 12 Aug 2021 11:59:29 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The new method can print only a subset of the unique data fields of
>> the trace event. The print format is derived from the parsing tokens
>> (tep_print_parse objects) of the event.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   src/event-parse.c | 26 ++++++++++++++++++++++----
>>   src/event-parse.h |  3 +++
>>   2 files changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/src/event-parse.c b/src/event-parse.c
>> index 0795135..645506e 100644
>> --- a/src/event-parse.c
>> +++ b/src/event-parse.c
>> @@ -5455,20 +5455,38 @@ void tep_print_field(struct trace_seq *s, void *data,
>>   	_tep_print_field(s, data, field, NULL);
>>   }
>>   
>> -void tep_print_fields(struct trace_seq *s, void *data,
>> -		      int size __maybe_unused, struct tep_event *event)
>> +static inline void
>> +print_selected_fields(struct trace_seq *s, void *data,
>> +		      struct tep_event *event,
>> +		      unsigned long long ignore_mask)
>>   {
>>   	struct tep_print_parse *parse = event->print_fmt.print_cache;
>>   	struct tep_format_field *field;
>> +	unsigned long long field_mask = 1;
>>   
>>   	field = event->format.fields;
>> -	while (field) {
>> +	for (;field; field = field->next, field_mask *= 2) {
> 
> The above should be:
> 
> 	for(; field; field = field->next, field_mask <<= 1) {
> 
> As a shift should be done with a shift operator and not a
> multiplication.
> 
> Other than that, the rest looks good. I'll go ahead and pull in patches
> 1 and 2.
> 
> -- Steve
> 
> 
>> +		if (field_mask & ignore_mask)
>> +			continue;
>> +
>>   		trace_seq_printf(s, " %s=", field->name);
>>   		_tep_print_field(s, data, field, &parse);
>> -		field = field->next;
>>   	}
>>   }
>>   
>> +void tep_print_selected_fields(struct trace_seq *s, void *data,
> 
> As the above is an API, it needs a kernel doc type comment, and also an
> addition to the man pages. The man page may be a separate patch.
> 

I was thinking of maybe changing the second argument of the function to

void tep_print_selected_fields(struct trace_seq *s,
			       struct tep_record *record,
			       struct tep_event *event,
			       unsigned long long ignore_mask)


> -- Steve
> 
> 
>> +			       struct tep_event *event,
>> +			       unsigned long long ignore_mask)
>> +{
>> +	print_selected_fields(s, data, event, ignore_mask);

respectively here we will have

	print_selected_fields(s, record->data, event, ignore_mask);
>> +}

This way the call will look cleaner.

	tep_print_selected_fields(s, record, event, mask);

instead of

	tep_print_selected_fields(s, record->data, event, mask);

But on the other hand, this will make the new API inconsistent with the existing
"tep_print_fields()" API bellow.

What do you think?

Thanks!
Yordan


>> +
>> +void tep_print_fields(struct trace_seq *s, void *data,
>> +		      int size __maybe_unused, struct tep_event *event)
>> +{
>> +	print_selected_fields(s, data, event, 0);
>> +}
>> +
>>   static int print_function(struct trace_seq *s, const char *format,
>>   			  void *data, int size, struct tep_event *event,
>>   			  struct tep_print_arg *arg)
>> diff --git a/src/event-parse.h b/src/event-parse.h
>> index d4a876f..e3638cf 100644
>> --- a/src/event-parse.h
>> +++ b/src/event-parse.h
>> @@ -545,6 +545,9 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
>>   
>>   void tep_print_field(struct trace_seq *s, void *data,
>>   		     struct tep_format_field *field);
>> +void tep_print_selected_fields(struct trace_seq *s, void *data,
>> +			       struct tep_event *event,
>> +			       unsigned long long ignore_mask);
>>   void tep_print_fields(struct trace_seq *s, void *data,
>>   		      int size __maybe_unused, struct tep_event *event);
>>   int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
> 
