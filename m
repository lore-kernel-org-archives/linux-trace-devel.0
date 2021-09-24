Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA04C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 16:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9266660F48
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 16:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbhIXQ6T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 12:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhIXQ6S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 12:58:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3729C061571
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 09:56:44 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v10so33897057edj.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 09:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P17ZLlT3nC9GiHar2DTXPTscPEKLL3cc95D7fNwqQCQ=;
        b=d9/E0sNRA9Du3mfqw6lwMpdzDFEYaS2xPl2LJnDYhIbKoQW50ctoFkj1IxHjKZ15JV
         eOxXus8BDotz7VyWFU8baUVic1742D9FZ3oTCQIYyDJKAJXogSPf+tKWQeFT2aNERrC5
         dRomy1uMNK1qAiYOfDKzaUMWiRECKJjc3pbOqevkuiV4zD2LtsmoMDg/EV94vIq2Jtgh
         M9r7bDo8WV3QM/OiNAlVHRltD6WC9XET3gg70M1ImNg3I4sTHighnOxIW9D5avy8Lqbg
         X5rz2cYLame/tbBqZ25KZadlz6FBH7TncI+blaPvqwZSlkdMtlUdoZ86xAautqSzxSVm
         c4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P17ZLlT3nC9GiHar2DTXPTscPEKLL3cc95D7fNwqQCQ=;
        b=lNjeoFRhxvlImvuJw2BZ/8KAi3eBEziYR7RgRnr7D3othiFZXgmSjKScZcw2OWpNZn
         Cftf81T+ygni3S4VVpk8iqycwv4xtY6pxtcECVPxtZWt2JkvyIBf1LtZ0RNtafkCcSl4
         Uyofx8jYpUFhdiQvBI4XRowiHZrOgDkXCwyOWOoM3twuEZX8uo8+62mVNkSyhRG3sk+C
         ZCY/jwldMn9RxFR+GQDGQNKGxL5QGfx775qQKse8X6K4+i2tHmmhOlZHe1CPgy79B8F8
         K9Jb5RyRe8NUs+WSC9FbeeynhVW9gcZ2Oj+lBilhMat+r2v3gCZKh9YCxA+aSd8LK25K
         O92w==
X-Gm-Message-State: AOAM530hgHt7u8BxVT1tNMRzaVr/hBH+QQfHF6gwbYLFWeckP7Nj1u/c
        L8Jn+MSt89wo9pj5bGnU6wyi/shBOlQ=
X-Google-Smtp-Source: ABdhPJxmURfGISKSxuaPqhqohXEBizmNqGzXcSsNrtvhUefsy88YsWYtbrD36+8xy+kFiLoO4be8ig==
X-Received: by 2002:a17:906:eca7:: with SMTP id qh7mr12486686ejb.45.1632502603097;
        Fri, 24 Sep 2021 09:56:43 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id fx4sm5316656ejb.113.2021.09.24.09.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:56:42 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] libtracefs: Transform tracefs_hist_add_sort_key()
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210924095702.151826-1-y.karadz@gmail.com>
 <20210924095702.151826-3-y.karadz@gmail.com>
 <CAPpZLN4yOiHBX2WRTWJHg+XUMULPUcx6KVE0_dNfP9hNaF-wgA@mail.gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <43ff18b5-8b79-970d-8670-375cd458f7be@gmail.com>
Date:   Fri, 24 Sep 2021 19:56:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAPpZLN4yOiHBX2WRTWJHg+XUMULPUcx6KVE0_dNfP9hNaF-wgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 24.09.21 г. 18:51, Tzvetomir Stoyanov wrote:
> On Fri, Sep 24, 2021 at 12:59 PM Yordan Karadzhov (VMware)
> <y.karadz@gmail.com> wrote:
>>
>> The current version of the API makes it hard to add multiple sort keys
>> to a histogram. The only way to do this is to use the variadic arguments,
>> however in order to do this the caller has to know the number of sort
>> keys at compile time, because the method overwrite all previously added
>> keys. The problem is addressed by creating a tracefs_hist_add_sort_key()
>> into two methods - one that overwrite and one that does not.
>> The current version of 'tracefs_hist_add_sort_key()' gets renamed to
>> 'tracefs_hist_set_sort_key()' without introducing any functional changes.
>> In the same time a new 'tracefs_hist_add_sort_key()' function is
>> defined. The new function can add one new sort key to the list of
>> previously added sort keys.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   include/tracefs.h  |  4 +++-
>>   src/tracefs-hist.c | 33 ++++++++++++++++++++++++++++++---
>>   2 files changed, 33 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/tracefs.h b/include/tracefs.h
>> index 5c4141e..230bc41 100644
>> --- a/include/tracefs.h
>> +++ b/include/tracefs.h
>> @@ -333,7 +333,9 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
>>                           enum tracefs_hist_key_type type);
>>   int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
>>   int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
>> -                             const char *sort_key, ...);
>> +                             const char *sort_key);
>> +int tracefs_hist_reset_sort_key(struct tracefs_hist *hist,
>> +                               const char *sort_key, ...);
> 
> The new name of the function, mentioned in the patch description, is
>      tracefs_hist_set_sort_key()
> I like the name with "set" instead of "reset". The behaviour of the
> function should be described in the function comments - to stress that
> the old keys are overwritten.
> 

Steven suggested to name it 'reset' in the review of the first version.
Both 'set' and 'reset' are OK for me.

Thanks!
Yordan


>>   int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
>>                                      const char *sort_key,
>>                                      enum tracefs_hist_sort_direction dir);
>> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
>> index ea12204..a7c20de 100644
>> --- a/src/tracefs-hist.c
>> +++ b/src/tracefs-hist.c
>> @@ -437,16 +437,43 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
>>   /**
>>    * tracefs_hist_add_sort_key - add a key for sorting the histogram
>>    * @hist: The histogram to add the sort key to
>> + * @sort_key: The key to sort
>> + *
>> + * Call the function to add to the list of sort keys of the histohram in
>> + * the order of priority that the keys would be sorted on output.
>> + *
>> + * Returns 0 on success, -1 on error.
>> + */
>> +int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
>> +                             const char *sort_key)
>> +{
>> +       char **list = hist->sort;
>> +
>> +       if (!hist || !sort_key)
>> +               return -1;
>> +
>> +       list = add_sort_key(hist, sort_key, hist->sort);
>> +       if (!list)
>> +               return -1;
>> +
>> +       hist->sort = list;
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>> + * tracefs_hist_reset_sort_key - set a key for sorting the histogram
>> + * @hist: The histogram to set the sort key to
>>    * @sort_key: The key to sort (and the strings after it)
>>    *  Last one must be NULL.
>>    *
>> - * Add a list of sort keys in the order of priority that the
>> + * Set a list of sort keys in the order of priority that the
>>    * keys would be sorted on output. Keys must be added first.
>>    *
>>    * Returns 0 on success, -1 on error.
>>    */
>> -int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
>> -                             const char *sort_key, ...)
>> +int tracefs_hist_reset_sort_key(struct tracefs_hist *hist,
>> +                               const char *sort_key, ...)
>>   {
>>          char **list = NULL;
>>          char **tmp;
>> --
>> 2.30.2
>>
> 
> 
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center
> 
