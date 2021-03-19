Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FBBC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 16:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 246D264F1D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 16:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhCRQuC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhCRQte (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 12:49:34 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C848C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Mar 2021 09:49:34 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y5so3886313pfn.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Mar 2021 09:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5qTTdU+2rEmL328igGGrstN8z19D5FzMhptVZHLqqd8=;
        b=BdalogttusJiKJfXddwlm0RGPQ/Y6Oq+9lOCwMfQvr9iUtak8+TY/Rm1+MW6R59VXq
         4y5kJMSfhsY+BeJGvzOYatNniygiTwJJ6Zz4Dkj43uESWuKq9EWUyZO1OissfJwOo984
         TbCAmOYd21dFVgIO3C43lKx6AxwX0o2j366n6EdmhcEhw0OzxhkQNlrJK08pCh0Zbzti
         uIPXcl/Grdz8xKvlUD3jm4u94mpGIyJx4zP24X3ZHLOUzp34C8S7Km6HeO0VzyTNIpC0
         TWpuUvloGBh5RG9TgUdU+dOPkQRpsgmPcu1MHcS/0ZxKXBcihVKyD2wfv8Cu7w+lHgpc
         AXNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5qTTdU+2rEmL328igGGrstN8z19D5FzMhptVZHLqqd8=;
        b=QuoE6gJ+gDO8kTCV7xlbhEyVpATxH9OVgaNmqwsRdKN8a/GYFWM+2/+cdrwyzOdTUw
         tgiw4flXWdQD7TvQE27tOT4sbcX7t7H8qa2PXkns85a1nGZjQzT4gA0mxMkaIGJGrOuG
         hGuon1PacEH/hHEzL7mt2a0tAL0FK1gT5lT2zF+cleBHkfoUgYIlt57IwOiVJ8ZNCqpt
         0MqhqLrMfenoBEPeIR3w14WP0VOOVbkfzzFZt9SLFQoD67bAJ4MgTnbN6SUz7BS+K/Gd
         om2MQvp/47clYhp5cb6dpKmvigzK5Yrb8gIRbFTS/5qMGqY3+IrsKzAi2aRz0eKzvvSf
         h4eA==
X-Gm-Message-State: AOAM533p9t5fka6MJ3hvqsMoR82kNDbBkw6bC+qYIfeglT5zwXrVcUCs
        Joqnz49QDRONfqj0hMuodOeYgGRc4i/1GA==
X-Google-Smtp-Source: ABdhPJxVsVEzfEH5A124jJ2d9uLeSeaqIsHrBkSyZf42/FzeuvZHuPG7JgdMxoXo1CkjB0iv2KinqA==
X-Received: by 2002:a65:5288:: with SMTP id y8mr7616767pgp.105.1616086173325;
        Thu, 18 Mar 2021 09:49:33 -0700 (PDT)
Received: from [192.168.1.143] ([116.74.250.179])
        by smtp.gmail.com with ESMTPSA id y19sm3311461pfo.0.2021.03.18.09.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:49:32 -0700 (PDT)
Subject: Re: [PATCH v2] libtracefs: An API to set the filtering of functions
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <1616081417-4107-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <CAPpZLN6MFmDar-7gvtb7Ke3=NrxWo==2BZQcKc7961ew8YXd7w@mail.gmail.com>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <75015c59-f983-f8af-80ed-27cf7f3f34e2@gmail.com>
Date:   Fri, 19 Mar 2021 22:20:13 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPpZLN6MFmDar-7gvtb7Ke3=NrxWo==2BZQcKc7961ew8YXd7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir Stoyanov,

Thanks for your support and reviews. It's  been a pleasure working with 
you guys, I am so grateful for your time, effort and reviews. I will try 
to continue my support.

Thanks,

sameer

On 18/03/21 9:53 am, Tzvetomir Stoyanov wrote:
> Hi Sameer,
> I have only one comment on this version:
>
> On Wed, Mar 17, 2021 at 6:02 PM Sameeruddin shaik
> <sameeruddin.shaik8@gmail.com> wrote:
>> This new API will write the function filters into the
>> set_ftrace_filter file.
>>
>> tracefs_function_filter()
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=210643
>>
>> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
>> ---
>> Error handling is addressed as per the comments
>> if filters[i] is not NULL, then only we are going inside for loop, at the asprintf i think it won't be necessary to check the filters[i] is NULL or not again, when it throws error, if i am wrong please correct me.
>>
>> diff --git a/include/tracefs.h b/include/tracefs.h
>> index f3eec62..c1f07b0 100644
>> --- a/include/tracefs.h
>> +++ b/include/tracefs.h
>> @@ -145,5 +145,6 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
>>   int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
>>   int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
>>   const char *tracefs_option_name(enum tracefs_option_id id);
>> -
>> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
>> +                           const char *module, bool reset, const char ***errs);
>>   #endif /* _TRACE_FS_H */
>> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
>> index e2dfc7b..ca6077b 100644
>> --- a/src/tracefs-tools.c
>> +++ b/src/tracefs-tools.c
>> @@ -18,6 +18,7 @@
>>   #include "tracefs-local.h"
>>
>>   #define TRACE_CTRL     "tracing_on"
>> +#define TRACE_FILTER   "set_ftrace_filter"
>>
>>   static const char * const options_map[] = {
>>          "unknown",
>> @@ -387,3 +388,108 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
>>          if (options && id > TRACEFS_OPTION_INVALID)
>>                  options->mask &= ~(1ULL << (id - 1));
>>   }
>> +
>> +static int controlled_write(const char *filter_path, const char **filters,
>> +                           const char *module, bool reset, const char ***errs)
>> +{
>> +       int flags = reset ? O_TRUNC : O_APPEND;
>> +       const char **e = NULL;
>> +       char *each_str = NULL;
>> +       int write_size = 0;
>> +       int size = 0;
>> +       int fd = -1;
>> +       int ret = 0;
>> +       int j = 0;
>> +       int i;
>> +
>> +       fd = open(filter_path, O_WRONLY | flags);
>> +       if (fd < 0)
>> +               return 1;
>> +
>> +       for (i = 0; filters[i]; i++) {
>> +               if (module)
>> +                       write_size = asprintf(&each_str, "%s:mod:%s ", filters[i], module);
>> +               else
>> +                       write_size = asprintf(&each_str, "%s ", filters[i]);
>> +               if (write_size < 0) {
>> +                       ret = 1;
>> +                       goto error;
>> +               }
>> +               size = write(fd, each_str, write_size);
>> +               /* compare written bytes*/
>> +               if (size < write_size) {
>> +                       if (errs) {
>> +                               e = realloc(e, (j + 1) * (sizeof(char *)));
>> +                               if (!e) {
> The commonly used pattern when working with realloc is to use a
> temporary pointer for the return value. The problem when using the
> same pointer is that in case of a realloc() error, it will return NULL
> which will overwrite our original pointer and we will lose it. The old
> memory is still valid, realloc() does not free it in case of an error,
> but we cannot access it as the old pointer is overwritten with that
> NULL. So, I would suggest something like that:
>                                e_new = realloc(e, (j + 1) * (sizeof(char *)));
>                                if (!e_new) {
>                                         free(e);
>                                         ret = 1;
>                                         goto error;
>                                 } else
>                                       e = e_new;
>
>
>> +                                       ret = 1;
>> +                                       goto error;
>> +                               }
>> +                               e[j++] = filters[i];
>> +                               ret -= 1;
>> +                       }
>> +               }
>> +               free(each_str);
>> +               each_str = NULL;
>> +       }
>> +       if (errs) {
>> +               e = realloc(e, (j + 1) * (sizeof(char *)));
>> +               if (!e) {
>> +                       free(e);
> The same comment as above. Here "e" is already NULL. Calling
> free(NULL) will not crash, but will not free the old memory.
>
>> +                       ret = 1;
>> +                       goto error;
>> +               }
>> +               e[j] = NULL;
>> +               *errs = e;
>> +       }
>> + error:
>> +       if (each_str)
>> +               free(each_str);
>> +       close(fd);
>> +       return ret;
>> +}
>> +
>> +/**
>> + * tracefs_function_filter - write to set_ftrace_filter file to trace
>> + * particular functions
>> + * @instance: ftrace instance, can be NULL for top tracing instance
>> + * @filters: An array of function names ending with a NULL pointer
>> + * @module: Module to be traced
>> + * @reset: set to true to reset the file before applying the filter
>> + * @errs: A pointer to array of constant strings that will be allocated
>> + * on negative return of this function, pointing to the filters that
>> + * failed.May be NULL, in which case this field will be ignored.
>> + *
>> + * The @filters is an array of strings, where each string will be used
>> + * to set a function or functions to be traced.
>> + *
>> + * If @reset is true, then all functions in the filter are cleared
>> + * before adding functions from @filters. Otherwise, the functions set
>> + * by @filters will be appended to the filter file
>> + *
>> + * returns -x on filter errors (where x is number of failed filter
>> + * srtings) and if @errs is not NULL will be an allocated string array
>> + * pointing to the strings in @filters that failed and must be freed
>> + * with free().
>> + *
>> + * returns 1 on general errors not realted to setting the filter.
>> + * @errs is not set even if supplied.
>> + *
>> + * return 0 on success and @errs is not set.
>> + */
>> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
>> +                           const char *module, bool reset, const char ***errs)
>> +{
>> +       char *ftrace_filter_path;
>> +       int ret = 0;
>> +
>> +       if (!filters)
>> +               return 1;
>> +
>> +       ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
>> +       if (!ftrace_filter_path)
>> +               return 1;
>> +
>> +       ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
>> +       tracefs_put_tracing_file(ftrace_filter_path);
>> +       return ret;
>> +}
>> --
>> 2.7.4
>>
> Thanks for sending this version, Sameer!
> I think we can merge it,  when you fix that realloc() error checking.
> I consider this patch as a good foundation for the API, but we should
> work on some optimizations on top of it, in separate patches. What
> else should be added, when this patch is merged:
>   1. A unit test of the API
>   2. Man page of the API
>   3. Optimizations: new kernels support writing indexes instead of
> strings into the "set_ftrace_filter" file. This is faster, as there is
> no string comparison in the kernel context. The function index can be
> retrieved from "available_filter_functions" files - the first function
> is with index 0, the next is 1 ... and so forth. So, the possible
> optimization of the API is to check - if the kernel supports indexes,
> use it, or fail back to the legacy logic with strings.
>
