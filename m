Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACEFC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Apr 2021 02:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CBB16101E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Apr 2021 02:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhDAB7m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 21:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhDAB71 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 21:59:27 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552BCC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 18:59:27 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c3so829218qkc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 18:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=mnEb8v83UgMTd3no4/nBK6sA4BIjvrEp6dFPinh0GdY=;
        b=ABrKFRi4NuNNJ1YloDZrRkGKFdupLy1M3Yb0T267Jl9cmF/9EIhUBrxXklLhT4W/oO
         dzf4ZaOq8g6Fe+o7akVp+BR3w84Cl1nLLc905ty7o8X/LTAn5ViJ8ivcW5MIO0PeXkpW
         aduJZ7MNEqOzuXwM6H3x6vtLh5VmKz7fLydqrcxJC2Qa+QZlnOcdY2top2Kk/1CHX1+w
         VYWpo/wdCjGUqLmxTJR/2vCaJBsA33qa8poPD8MRTpNVzsS7ImsW0IxP82CHs+5wRUkD
         gO8Fhl9zC8016rM3cXCt588tHT1b3O5SAU5QKQqVBrBF9Z2gSbFdm9c1u2e8C0S0qgX2
         pgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mnEb8v83UgMTd3no4/nBK6sA4BIjvrEp6dFPinh0GdY=;
        b=Shf4ODXDM6O4vEh7iXtNWSZygtCEIQdDZx8J6RdCPwIQnZPRi+qPk6W7DEn/xurJxa
         HlyVhEuOUIK+r+E75RC3XhTqhF+zdM0yiLOzPhfvwC159dnd23jzWIJyx1pZD4i9QCqs
         9ORSHj1sMky1wb7tHV0wNQHgyNjEvVtY7sjn0pb1m6owkMHaEpcas+zhbb1t4WC7v3+x
         S7UzX8U/KIJdjuVAtFdxkya1m4ZBvYaTQUVAgwB7T0RIz8ueoZ8c3XxpDtgC9i6A/Odx
         NYqZym8V851nSnnElVs8XxVftr8MTm6h9j6pUIIMsU00m1UyG68xhsk2xOOQVho+Tusz
         AgMw==
X-Gm-Message-State: AOAM5321frfNuGIPbMQU7A3HLVWchnQwnBDfsAVAdyRfTrQVY0znXMG3
        OnpYR978+Feojf0OyDG7Sm3asG4uHT0=
X-Google-Smtp-Source: ABdhPJz8ZBn8+fxbdwhGaG+hiz4oCnlfSBGowPT5LWI15Cr/GiCv5mCNL0Yix63a+ddCwQctjAYuUQ==
X-Received: by 2002:a37:6108:: with SMTP id v8mr6235918qkb.448.1617242366224;
        Wed, 31 Mar 2021 18:59:26 -0700 (PDT)
Received: from [192.168.1.143] ([203.212.237.232])
        by smtp.gmail.com with ESMTPSA id b15sm2569454qtr.58.2021.03.31.18.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 18:59:25 -0700 (PDT)
Subject: Re: [PATCH 08/13 v2] libtracefs: Allow for setting filters with regex
 expressions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210330005123.151740983@goodmis.org>
 <20210330005248.391852830@goodmis.org>
 <96e9fc99-53c5-ea5a-7e5d-5ea6dafc1f7c@gmail.com>
 <20210331123912.6295e9c1@gandalf.local.home>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <fa1cb382-5984-d5de-5905-0eb3fd45a697@gmail.com>
Date:   Fri, 2 Apr 2021 07:29:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210331123912.6295e9c1@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi steve,

On 31/03/21 10:09 pm, Steven Rostedt wrote:
> On Thu, 1 Apr 2021 22:03:02 +0530
> sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
>
>> hi steve,
>>
>> On 30/03/21 6:21 am, Steven Rostedt wrote:
>>> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>>>
>>> All for full "regex(3)" processing of setting functions in the
>>> set_ftrace_filter file. Check if the filter passed in is just a glob
>>> expression that the kernel can process, or if it is a regex that should look
>>> at the available_filter_functions list instead.
>>>
>>> If it is a regex, it will read the available_filter_functions and write in
>>> each function as it finds it.
>>>
>>> Link: https://lore.kernel.org/linux-trace-devel/20210323013225.451281989@goodmis.org
>>>
>>> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>>> ---
>>>    Documentation/libtracefs-function-filter.txt |  10 ++
>>>    src/tracefs-tools.c                          | 139 ++++++++++++++++---
>>>    2 files changed, 128 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
>>> index c0c89f372c21..88aa3b923d54 100644
>>> --- a/Documentation/libtracefs-function-filter.txt
>>> +++ b/Documentation/libtracefs-function-filter.txt
>>> @@ -32,6 +32,16 @@ _errs_, is a pointer to an array of strings, which will be allocated if
>>>    any of filters fail to match any available function, If _errs_ is NULL, it will
>>>    be ignored.
>>>    
>>> +A filter in the array of _filters_ may be either a straight match of a
>>> +function, a glob or regex(3). a glob is where '*' matches zero or more
>>> +characters, '?' will match zero or one character, and '.' only matches a
>>> +period. If the filter is determined to be a regex (where it contains
>>> +anything other than alpha numeric characters, or '.', '*', '?') the filter
>>> +will be processed as a regex(3) following the rules of regex(3), and '.' is
>>> +not a period, but will match any one character. To force a regular
>>> +expression, either prefix the filter with a '^' or append it with a '$' as
>>> +all filters will act as complete matches of functions anyway.
>>> +
>> if we give the filter as regex "^ext4*$" from user side, ideally it
>> should match the ext4 filter functions, if i am not wrong, its not
>> matching any filter in the available_filter_functions
> If you add the "^" and/or "$" it makes it into a regex. The above means
> that the filter will match "ext", "ext4", "ext44", "ext4444444"
>
> Because "*" means zero or more of the previous character. So, unless
> there's a function that matches one of the above, it wont match anything
> else.
>
> If you left off the "^" and "$" then it would be a glob, where "*" means
> zero or more of any character. But if you want the same in regex, you need
> to use:
>
>   "^ext4.*$"

IF we use the regex in filters, running time of the program is 
increasing drastically.

lets say,

if we give the kernel glob as a filter, its getting converted to regex 
and running time of program is

5 secs, in other case where we use regex, its taking 80 secs to complete.

--sameer.
