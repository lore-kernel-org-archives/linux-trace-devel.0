Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F861C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 313F660555
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbhIMM2L (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM2K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:28:10 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A835CC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:26:54 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g21so14098984edw.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dFo72YRGbnVyRtwMRIW3E2/NJwxrMBWrGOWqWLREPNk=;
        b=NGSdr/xsnlFL8Ldpa/rXmYp8FA5RWEXLvtD7RaCego+zUuhinh3+LaI4mm4UrmOFth
         usqCBii7U6rvHgOxwYfrlW+pPidUTVSQRqRttpKV5vXFkm/+5C0iu5yM14CAmRQIUk3f
         +gNKWAs1oGPLWDfb+j5v7lp4nFwIlqh1S4ZM81QDzy8LNJHpEFZOuVcg+kR2LDY3+n/1
         i3vlWFzehqgCw+ehItuJbgEsG16Iu4P/hSOhjsKQ709VJP7AEBVsm/fEHrUPZi1kJZPq
         TtvZq0YmCjgX8LtCPRngKempN1SrgC4rTkD/Kpoz3gYgjt4D28+G5mN+lFZ5WWTVKImh
         B1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dFo72YRGbnVyRtwMRIW3E2/NJwxrMBWrGOWqWLREPNk=;
        b=dqll/IODStJKFL1PKdBNkicbn0VQKt+cGCKYk3EVA5sfI1gC87xPPY/aO5Qki3XAym
         gv6r7HuAtKz95T6OUEzqDwqNlNzxdOWHsmgPTRtUq/WbDQgqZpIJfjNYSJ5pSK+R1Bve
         woV1f3Z++ZmxGl3tebI7MdTTxwuKzbGX7klUgRczOTVDoDLbrx1FH8kSYInsecjtnt+6
         zcWV3k0rAm5HD+KM2RbxT8Ot/uy3YGFhcuTqmLVB1Si5lNQArAakwrZC7fkaJ7PVI6TH
         UM565ugMo6WSRs7tHCD7mxThB7XHjlRbiv6LMGPObNhlYewgGktKQpg2n60BdluG03TQ
         AWFA==
X-Gm-Message-State: AOAM533RYgvzRPpxOZkNH1YeSX3LC7Z+TyjxgZ+54/H/Ii9K86+UUVfl
        4DeqmRGmBm55ewTTKnmidaCVGtghXpw=
X-Google-Smtp-Source: ABdhPJx9FfgfYEVy4NWoDi+cPDsdGl4v4nJYDEVMhx8ZG3HQ4bsXKKv5toLR7+WHPA+FfIntbqxV+Q==
X-Received: by 2002:aa7:c617:: with SMTP id h23mr11455727edq.357.1631536013046;
        Mon, 13 Sep 2021 05:26:53 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.108])
        by smtp.gmail.com with ESMTPSA id kt19sm778909ejb.26.2021.09.13.05.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 05:26:52 -0700 (PDT)
Subject: Re: [RFC PATCH 2/4] libtracefs: Transform tracefs_hist_add_sort_key()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210910163857.324696-1-y.karadz@gmail.com>
 <20210910163857.324696-3-y.karadz@gmail.com>
 <20210910160101.2ef82513@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <7ae3ea27-082c-c5d8-c13b-e1da96d348aa@gmail.com>
Date:   Mon, 13 Sep 2021 15:26:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910160101.2ef82513@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.09.21 г. 23:01, Steven Rostedt wrote:
> On Fri, 10 Sep 2021 19:38:55 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The current version of the API makes it hard to add multiple sort keys
>> to a histogram. The only way to do this is to use the variadic arguments,
>> however in order to do this the caller have to know the number of sort
>> keys at compile time, because the method overwrite all previously added
>> keys. The problem is addressed by splitting tracefs_hist_add_sort_key()
>> into two methods - one that overwrite and one that does not.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   include/tracefs.h  |  4 +++-
>>   src/tracefs-hist.c | 21 +++++++++++++++++++--
>>   2 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/tracefs.h b/include/tracefs.h
>> index 64fbb3f..c3fa1d6 100644
>> --- a/include/tracefs.h
>> +++ b/include/tracefs.h
>> @@ -303,7 +303,9 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
>>   			 enum tracefs_hist_key_type type);
>>   int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
>>   int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
>> -			      const char *sort_key, ...);
>> +			      char *sort_key);
> 
> Why did you remove the const? The add_sort_key() takes a const and makes a
> copy of it.

This is a mistake. It must be 'const'.

> 
>> +int tracefs_hist_sort_key(struct tracefs_hist *hist,
>> +			  const char *sort_key, ...);
>>   int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
>>   				    const char *sort_key,
>>   				    enum tracefs_hist_sort_direction dir);
>> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
>> index 8501d64..2ea90d9 100644
>> --- a/src/tracefs-hist.c
>> +++ b/src/tracefs-hist.c
>> @@ -453,6 +453,23 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
>>   	return tracefs_list_add(list, sort_key);
>>   }
>>   
> 
> Needs a kerneldoc documentation header.

OK

> 
>> +int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
>> +			      char *sort_key)
>> +{
>> +	char **list = hist->sort;
>> +
>> +	if (!hist || !sort_key)
>> +		return -1;
>> +
>> +	list = add_sort_key(hist, sort_key, hist->sort);
>> +	if (!list)
>> +		return -1;
>> +
>> +	hist->sort = list;
>> +
>> +	return 0;
>> +}
>> +
>>   /**
>>    * tracefs_hist_add_sort_key - add a key for sorting the histogram
> 
> The above name needs to be updated.
> 
>>    * @hist: The histogram to add the sort key to
>> @@ -464,8 +481,8 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
>>    *
>>    * Returns 0 on success, -1 on error.
>>    */
>> -int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
>> -			      const char *sort_key, ...)
>> +int tracefs_hist_sort_key(struct tracefs_hist *hist,
> 
> How about if we call this:
> 
> 	tracefs_hist_replace_sort_keys()
> 
> I think that would be a more intuitive name.

The user may call this function with a histogram that has no sort keys added.
So there will be nothing to replace.
What about naming it 'tracefs_hist_set_sort_keys()'?

Thanks a lot!
Yordan

> 
> -- Steve
> 
>> +			  const char *sort_key, ...)
>>   {
>>   	char **list = NULL;
>>   	char **tmp;
> 
