Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2F5C432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 09:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FE6521741
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 09:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BvMrSVYp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfK1JZi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 04:25:38 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35451 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfK1JZi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 04:25:38 -0500
Received: by mail-lf1-f68.google.com with SMTP id r15so16566886lff.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 01:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8JgviU3LbOJoGO7Xo+HUz8IjCkIWcmFCb2qg5QAZ3Sg=;
        b=BvMrSVYpMXzyHBC7SELhr0epdP9G9wyTJNvhvDv7zDZ6orieUfu6WQStvZ+i0YBAvn
         4Ju4c7F89hLgv/heMqV3Tk6rYTV9/JdEwTrL890bssKpnTNaYzpqJq5mvtLvNQv0Fthg
         fYhlqPCP+sSdjMbeFqYA0xWgTvppVimKNEeqLGlJmbuOJ1e68kJlzA2gGxTXXQC9oMwM
         MLEAa8YMz+7xfokb3LaIajUhdqIdfXSESK+/17QmqkHN3p0Tv4H/6HfwpNuSg7WbG2bG
         +XI+Ldaw0xX1Uvj0X27ZpAfKeDPC9kSXryhfYi6dzOGk8hfmJAP9ouALtqQItCu4x7Ip
         MOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8JgviU3LbOJoGO7Xo+HUz8IjCkIWcmFCb2qg5QAZ3Sg=;
        b=QY5tZzgmWPatUj0BnUezcDpSvM0Xi81wImc7AiRe25nLRd2gyXqcwph7Miub4h3Am7
         QmOCpjv2S90r3T1m8BBmGNYNBVWWCNErcSqgh9rc+Bvxzto9ydi8S/+e02/UC+8JO4C5
         SreN0SC1BoqUqrWZK43l/vY2/JJqHHkUDuORmjehgZ4qBiMMqYX+ttpW+M1A1fyFEs/E
         x47ScW+1xeGkuGbUQWn2ToPdiNyAfq4HrpUOQKXvgmc0u3/v0gQLkk8pdiBvbs8kCpNu
         XJXKzkiVMJqiJ4G17Xt4cggBy5R/jfE4N+Zdd6GCo7U/1TR29LVpAv7KXkUVyPxRbOTA
         +8uw==
X-Gm-Message-State: APjAAAVzpnkrmm45FpFgH1AqDRcsohH9SGYy7jwX7YMNDV6iB0jQ9qv4
        mQyBEO1bIRsATfusdORnhj3Bnb6R
X-Google-Smtp-Source: APXvYqxJbkIIaST0rxOBR4lX7EnDdUR75u+FcVp3cFR+NG3Ml6BH1HbcOtJSFWmmLOGtRB2iyDPDgQ==
X-Received: by 2002:ac2:410a:: with SMTP id b10mr4402503lfi.135.1574933135658;
        Thu, 28 Nov 2019 01:25:35 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u4sm8288799ljj.87.2019.11.28.01.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2019 01:25:35 -0800 (PST)
Subject: Re: [PATCH v2 2/3] kernel-shark: Fix potential memory leak in
 libkshark-collection
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20191023122145.14314-1-y.karadz@gmail.com>
 <20191023122145.14314-2-y.karadz@gmail.com>
 <20191127135416.6bcc0fd9@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <61ba76fd-25ba-821d-b8e8-0f3209f692b5@gmail.com>
Date:   Thu, 28 Nov 2019 11:25:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191127135416.6bcc0fd9@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 27.11.19 г. 20:54 ч., Steven Rostedt wrote:
> On Wed, 23 Oct 2019 15:21:44 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> When searching for the entry, do not loop over the original list of
>> requests. Use a copy instead. If we loop over the original list and
>> no entry is found in the first element of the list, later the memory
>> used for this first element will leak.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   kernel-shark/src/libkshark-collection.c | 14 ++++++--------
>>   1 file changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel-shark/src/libkshark-collection.c b/kernel-shark/src/libkshark-collection.c
>> index 02a014e..95fdbab 100644
>> --- a/kernel-shark/src/libkshark-collection.c
>> +++ b/kernel-shark/src/libkshark-collection.c
>> @@ -622,6 +622,7 @@ kshark_get_collection_entry_front(struct kshark_entry_request **req,
>>   				  ssize_t *index)
>>   {
>>   	const struct kshark_entry *entry = NULL;
>> +	struct kshark_entry_request *list;
> 
> Hi Yordan,
> 
> I was looking at this patch in more detail, and I'm thinking that we
> don't need to pass in the address of the req pointer, but just the req
> pointer itself. The only place that I see the req pointer being
> modified is the failure case in map_collection_request_init() where it
> does:
> 
> 	kshark_free_entry_request(*req);
> 	*req = NULL;
> 
> But all callers do that free anyway.
>

Yes, because the caller is expected to do 
kshark_free_entry_request(*req) at the end, here we have to set the 
original pointer to NULL. Otherwise we will get double free error.
I think this is what I have been trying to fix, when I introduced the 
memory leak.

And yes, I agree with you that carrying the address of the pointer 
through all these functions is a bit ugly.

Thanks!
Yordan

> Maybe I'm missing something, but why are we passing in the pointer to
> the pointer of req, and not just the req pointer itself? I don't see a
> need to modify the pointer.
> 
> Before this patch, *req is modified, but after this patch, it is not.
> If you pass in just "struct kshark_entry_request *req" then you don't
> even need to have the "list" variable, you could just use "req" because
> that would be a copy of the pointer.
> 
> -- Steve
> 
> 
> 
>>   	int req_count;
>>   
>>   	/*
>> @@ -638,12 +639,10 @@ kshark_get_collection_entry_front(struct kshark_entry_request **req,
>>   	 * Loop over the list of redefined requests and search until you find
>>   	 * the first matching entry.
>>   	 */
>> -	while (*req) {
>> -		entry = kshark_get_entry_front(*req, data, index);
>> +	for (list = *req; list; list = list->next) {
>> +		entry = kshark_get_entry_front(list, data, index);
>>   		if (entry)
>>   			break;
>> -
>> -		*req = (*req)->next;
>>   	}
>>   
>>   	return entry;
>> @@ -680,6 +679,7 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
>>   				 ssize_t *index)
>>   {
>>   	const struct kshark_entry *entry = NULL;
>> +	struct kshark_entry_request *list;
>>   	int req_count;
>>   
>>   	/*
>> @@ -695,12 +695,10 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
>>   	 * Loop over the list of redefined requests and search until you find
>>   	 * the first matching entry.
>>   	 */
>> -	while (*req) {
>> -		entry = kshark_get_entry_back(*req, data, index);
>> +	for (list = *req; list; list = list->next) {
>> +		entry = kshark_get_entry_back(list, data, index);
>>   		if (entry)
>>   			break;
>> -
>> -		*req = (*req)->next;
>>   	}
>>   
>>   	return entry;
> 
