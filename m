Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE39C433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 00:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F9F61A1B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 00:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhCYAZ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhCYAZH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 20:25:07 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F414EC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 17:25:06 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so3382706pjb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 17:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=dJJc8dJ8o1vdWx6YA1ryoy9fgabvMHxzaV1mnDeCYYo=;
        b=p+TGgHzq/aXrGA/pm/THTm4idlZ5Djl+rdU9IyC6EWnU9LP7cgLn2jPr5BGGJhyYlD
         LC6jnaViBEtR8RQRm5ZX6yVtnuI8crGGyn2MOC8Gipb/Ncmei4ES7PY/ozSBnIjBQKMg
         DEzqDCmOSq+JoZ1DcFjerrh24XIv7CnmUEKOhqQv/rb4wE+ECyoIxlW3yJRU5Dk5kEeN
         uvUNt9Op+M3qor0YtMq1Lffo32mScNspsYhE8nblIOWivz078AL5GHzBuN7eFsmk5fvB
         FM6C0mrzRoWgu4IL84BQBVEgnHSzn98a5TWRgBVLVukLg63Bn3KqeNPtah5r2iDHoiYu
         cMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dJJc8dJ8o1vdWx6YA1ryoy9fgabvMHxzaV1mnDeCYYo=;
        b=GLyLRW2K/ISykGhIJjoMveoW864WVXaOORLiNpCUdRz71d/G2lqw9otR1gWuCEcewO
         WX1h1tlg4xyp8P3JUvZO9HtQNfIDZPL9ZHpP9GQZbm32kBtfI2YSAc9KTSYXA0TSatGn
         UMZhcG8sH8yIRmqkNfUuVje4mHnuVk3alcgoLxg/VenBqOZ2WLthZI1diIdmPemC498K
         VchSd4NSMvy824mW+7t/s+Tv6d6GNZ+VAy7vurXckg2RHrXGZdpbp/vKQGnt4hOX7ItC
         IEy6Nf1hPsO+NyqTeyhfuXxWz9aK4EgHUNiCLsRAqXk27ZMYFQamr+jCtISCRmapzUMC
         9pJQ==
X-Gm-Message-State: AOAM530LHy4OLgqfYSIGqrUl493AhmfNoJxbWafOtpIgIFW5RoP3d5Vm
        eGCYLD1HyHqyw+hjF3aITIFHJpriGLZRZA==
X-Google-Smtp-Source: ABdhPJxd4PmXN466MMcQsyn79Us5M/EQ5OQnzS+LMobknDbVSROHtopszSN4wYLxS2WoJHKy0ds2hA==
X-Received: by 2002:a17:90a:f286:: with SMTP id fs6mr6107316pjb.183.1616631906162;
        Wed, 24 Mar 2021 17:25:06 -0700 (PDT)
Received: from [192.168.1.143] ([27.6.175.206])
        by smtp.gmail.com with ESMTPSA id t18sm3583502pfh.57.2021.03.24.17.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 17:25:05 -0700 (PDT)
Subject: Re: [PATCH 0/7] libtracfes: Add tracefs_function_filter()
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20210323012755.155237800@goodmis.org>
 <20210323085220.6e20d125@gandalf.local.home>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <743080c8-6b22-83b7-6b2b-0221c2ee945b@gmail.com>
Date:   Fri, 26 Mar 2021 05:55:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210323085220.6e20d125@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 23/03/21 6:22 pm, Steven Rostedt wrote:
> On Mon, 22 Mar 2021 21:27:55 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> This adds a new API tracefs_function_filter() as described in:
>>
>>   https://bugzilla.kernel.org/show_bug.cgi?id=210643
>>
>> It will use regular expressions against available_filter_functions (or even
>> the kernel glob expression) to enable the function by the index method if it
>> is supported. If it is not supported, it will go back to the writing of the
>> filter strings directly into the set_ftrace_filter file.
>>
>>
> Playing with the interface some more, I feel it's not quite adequate.
>
> The returning the negative number of filters that failed, isn't very
> useful. Having the errs array that points to those filters gives us that
> information.
Yeah, Anyway we are pointing the failed filters using the errs pointer. 
But to differentiate

the failed filters from the general errors, we can return -1, what you say?
>
> Also, because of the way that file works in the kernel, we need to be able
> to call this function several times without closing the file. That's
> because the actions take place when the file is closed, *not* when a write
> is made. Having the interface return errors without closing the file would
> allow the user to fix the failed filters and try again.
>
> I plan on committing this patch series, so any new changes will be done on
> top of them. But here's what I think needs to be done to make the interface
> more usable.
>
>   - Create a tracefs_function_filter_commit(instance) API that will close
>     the file and commit the changes.
>
>   - Have the tracefs_function_filter() open the set_ftrace_filter file if it
>     is not already opened. This will allow for the function to be called
>     multiple times. The file descriptor will be part of the instance
>     descriptor or a global variable for the top level instance. The opening
>     of the files will need to be protected by a pthread mutex.
>     Note, the "reset" parameter is only applicable if the file is not
>     already opened.
>
>   - On success, return 0 and tracefs_function_filter_commit() must be called.
>
>   - If the file descriptor is opened and an error happens, return 1, and the
>     tracefs_function_filter_commit() still needs to be called, but the user
>     can call tracefs_function_filter() again to try to fix the problem.
>
>   - If an error is found before the file descriptor is opened, then
>     tracefs_function_filter_commit() does not need to be called.
>
> That is:
>
> 	ret = tracefs_function_filter(...);
> 	if (ret >= 0)
> 		tracefs_function_filter_commit();
>
>   - Now for errs, it will be allocated if a problem happened on a filter,
>     and may be set if the return value is non zero (1 or -1). The user can
>     use it to know if the problem happened on a filter as well as find out
>     which filter had the problem.
>
>   - We can have a tracefs_read_function_filter() that returns an array of
>     strings which ends with a NULL pointer (and needs to be freed with
>     tracefs_list_free(), and have this:
>
>     save_filters = tracefs_read_function_filter(instance);
>
>     ret = tracefs_function_filter(instance, filters, NULL, true, &errs);
>     if (ret > 0 && errs) {
> 	/* Modified but failed */
> 	int i, j;
> 	for (i = 0; filters[i]; i++)
> 		;
> 	for (j = 0; errs[i]; j++)
> 		;
> 	if (i == j)
> 		/* all filters failed! Put back the original */
> 		tracefs_function_filter(instance, save_filters, NULL, false, NULL);
>     }
>     if (ret >= 0)
> 	tracefs_function_filter_commit(instance);
>
> Another reason to have it not close the file is because we only support
> passing in one module at a time. If the user wants to enable functions in
> two modules, they would need to call this twice, and we want them to be
> able to do so and have both changes take affect at the same time.
>
> Thoughts?
>
> -- Steve
