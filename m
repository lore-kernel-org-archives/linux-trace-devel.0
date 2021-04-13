Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_24_48,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AAAC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 01:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E87466120A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 01:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhDLBFh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhDLBFh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 11 Apr 2021 21:05:37 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207C1C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 18:05:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so1957997pjb.4
        for <linux-trace-devel@vger.kernel.org>; Sun, 11 Apr 2021 18:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=y4f2MCYFgHbnr5LEIAILjDo/IXv0wjYxvLeRicjnlqk=;
        b=mpXj07eyYTKm4CrzMcy7qYZJ5Z53YsJmSe8rm0DWqdxTHWEee2XKDeRyQIN6Onjxnq
         yUOnKMAbt6+QSsrnWUjsWLfmYn5qZezPkyFcXW+jR5keeEkrxpp5vkGTToTcezhERP2+
         JvQNQUfBlCXp/ANVejlNEz3eXa4vlhSQ02uFIW75Amudi9lqoLureCwF/MnAiiivX8cK
         STTNH2sZ/nM13TMoDwRUYgzUQVDqfFHsoKL3uwhhrqfk8FOBq3J6f91c+6k0UNzg2+c5
         NunPlz87RxYCvxOqrudQ9whWkB8lmYM/gB4YIcJPVX2Uvv6ZNHpjIbpD04X3LYk4bb/l
         /biA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=y4f2MCYFgHbnr5LEIAILjDo/IXv0wjYxvLeRicjnlqk=;
        b=TV9GYwU1JwZ5xwVSEuuKnCXzqvD4Y+FGKiJLCauxCJ19Ca8kgnIThFJSkJvDREVOJM
         QWvlwZ4o8GKaWs+DWgxKsLyJRabkX1rEPi6LGPcqRnEDjVjrlYmszsYziwvea9QwfZYe
         QOw1++A7LK9f27KXIihOFK52wJxLEpnRHHiHiWx3oZ2JBgTopYoj2QaXDkCdhwAbfaEg
         WFHiV001PPxg86rYmJ20GyHtIj2ag7Co4pTJNf6tI0gjso55VwC9hEJ4t4dbcl0nWCFd
         W9MIzpH+weM6JUxAiKbhZvZA3eVdk9j1MKYGvSpkx5DgAxKF8nbFMrRWsmk078B1wRYU
         5sqA==
X-Gm-Message-State: AOAM532SI/U7tz+Hxra+KMB/9zfvIKaIXY1v21PgmHOU8SSrfBI0YBAg
        ogti+b3Xj1kfdC6FtgZZbAWBz4ZUj45CfA==
X-Google-Smtp-Source: ABdhPJxzAlls2/GhQiovCwoRmg00LfQnCcijfgICr5WMGTE5OVGSNLEM6aRIfmJBxntvcOLY/iywBQ==
X-Received: by 2002:a17:902:8504:b029:e9:7aac:a092 with SMTP id bj4-20020a1709028504b02900e97aaca092mr21755442plb.12.1618189519235;
        Sun, 11 Apr 2021 18:05:19 -0700 (PDT)
Received: from [192.168.0.115] ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id fs9sm9013242pjb.40.2021.04.11.18.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 18:05:17 -0700 (PDT)
Subject: Re: Bug in Test code
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <6b3b676e-b57c-5d05-142e-9e85e61a6ce5@gmail.com>
 <20210410222331.24d04032@oasis.local.home>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <1fb3ff49-133c-2414-3de9-922dfb73fcc6@gmail.com>
Date:   Tue, 13 Apr 2021 06:35:43 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210410222331.24d04032@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 11/04/21 7:53 am, Steven Rostedt wrote:
> On Mon, 12 Apr 2021 06:43:44 +0530
> sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
>
>> hi,
>>
>> Test: tracing options ...FAILED
>>       1. tracefs-utest.c:746  - check_options_mask_empty(all)
>>       2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
>>     Test: custom system directory ...FAILED
>>       1. tracefs-utest.c:746  - check_options_mask_empty(all)
>>       2. tracefs-utest.c:747  - check_options_mask_empty(enabled)
>>     Test: ftrace marker ...trace-utest: ../nptl/pthread_mutex_lock.c:81:
>> __pthread_mutex_lock: Assertion `mutex->__data.__owner == 0' failed.
>> Aborted (core dumped)
>>
>>
>> Above tests are failing for me, what about you guys?
>>
>> Do i have to give any command line options when running the test ?
>>
>> I ran test like below
>>
>> -----------------------
>>
>> #./trace-utest
>>
>> -----------------------
>>
> Hi Sameer,
>
> Thanks for the report. Yes, it is a bug in the tests. We did a last
> minute change to have the options bitmask be stored in the instance and
> it is immutable, but did not update the tests. The below patch should
> fix it for you. Let us know if it does.
>
> Thanks!
>
> -- Steve
>
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index 1f48e6f..3407202 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -679,7 +679,7 @@ out:
>   	return ret;
>   }
>   
> -static bool check_options_mask_empty(struct tracefs_options_mask *mask)
> +static bool check_options_mask_empty(const struct tracefs_options_mask *mask)
>   {
>   	int i;
>   
> @@ -692,8 +692,9 @@ static bool check_options_mask_empty(struct tracefs_options_mask *mask)
>   
>   static void test_instance_tracing_options(struct tracefs_instance *instance)
>   {
> -	struct tracefs_options_mask *enabled;
> -	struct tracefs_options_mask *all, *all_copy;
> +	const struct tracefs_options_mask *enabled;
> +	const struct tracefs_options_mask *all_copy;
> +	const struct tracefs_options_mask *all;
>   	enum tracefs_option_id i = 1;
>   	char file[PATH_MAX];
>   	const char *name;
> @@ -745,9 +746,6 @@ static void test_instance_tracing_options(struct tracefs_instance *instance)
>   	}
>   	CU_TEST(check_options_mask_empty(all));
>   	CU_TEST(check_options_mask_empty(enabled));
> -
> -	free(all);
> -	free(enabled);
>   }
>   
>   static void test_tracing_options(void)

No steve it didn't resolved the issue,

root@sameeraaron-Lenovo-Z50-70:/home/sameeraaron/hobbies/libtracefs/utest# 
./trace-utest


      CUnit - A unit testing framework for C - Version 2.1-3
      http://cunit.sourceforge.net/

*** Error in `./trace-utest': malloc(): memory corruption: 
0x0000000001251670 ***
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6(+0x777f5)[0x7f7f8171f7f5]
/lib/x86_64-linux-gnu/libc.so.6(+0x8215e)[0x7f7f8172a15e]
/lib/x86_64-linux-gnu/libc.so.6(__libc_malloc+0x54)[0x7f7f8172c1d4]
/usr/local/lib64/libtraceevent.so.1(tep_register_print_string+0x1f)[0x7f7f81ea322c]
/usr/local/lib64/libtraceevent.so.1(tep_parse_printk_formats+0x10c)[0x7f7f81ea34cf]
./trace-utest[0x40bf2e]
./trace-utest[0x40bf9d]
./trace-utest[0x40c160]
./trace-utest(tracefs_local_events_system+0x48)[0x40c1c0]
./trace-utest[0x408c19]
/usr/lib/x86_64-linux-gnu/libcunit.so.1(+0x3e7e)[0x7f7f81a75e7e]
/usr/lib/x86_64-linux-gnu/libcunit.so.1(CU_run_all_tests+0x6e)[0x7f7f81a763be]
./trace-utest(main+0x10b)[0x403501]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f7f816c8840]
./trace-utest(_start+0x29)[0x4032a9]


--sameer.

