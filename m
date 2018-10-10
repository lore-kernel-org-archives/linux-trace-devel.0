Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700051.outbound.protection.outlook.com ([40.107.70.51]:41216
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726503AbeJJWsr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 18:48:47 -0400
Subject: Re: [PATCH 2/4] kernel-shark-qt: Add KernalShark Utils
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
 <20181008151629.13973-3-ykaradzhov@vmware.com>
 <20181009123419.22fe49f2@gandalf.local.home>
 <4eb2711d-5462-26a7-3ffb-a71035322521@vmware.com>
 <20181010112214.320b61fc@gandalf.local.home>
From: Yordan Karadzhov <ykaradzhov@vmware.com>
Message-ID: <2a8bf041-2fe6-9464-4795-f06b4bdad0e2@vmware.com>
Date: Wed, 10 Oct 2018 18:25:52 +0300
MIME-Version: 1.0
In-Reply-To: <20181010112214.320b61fc@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 10.10.2018 18:22, Steven Rostedt wrote:
> On Wed, 10 Oct 2018 17:12:40 +0300
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> On  9.10.2018 19:34, Steven Rostedt wrote:
>>>> +	if (!kshark_instance(&kshark_ctx))
>>>> +		return;
>>>> +
>>>> +	switch (filterId) {
>>>> +		case KS_SHOW_EVENT_FILTER:
>>>> +		case KS_HIDE_EVENT_FILTER:
>>>> +			kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
>>>> +			kshark_filter_clear(kshark_ctx, KS_HIDE_EVENT_FILTER);
>>> Hmm, I'm curious to why you clear both SHOW/HIDE filters if the
>>> filterId is one of SHOW or HIDE?
>>>
>>> Perhaps a comment should be here explaining it too.
>>>
>>>    
>>
>> This enforces that we cannot have both SHOW and HIDE filters being set.
>> I think that, having SHOW and HIDE filters set in the same time can be
>> useful in very limited number of cases. On the other hand this is an
>> easy way to confuse yourself.
>>
>> Note that this restriction is at the level of the GUI code. The C API
>> allows for having both SHOW and HIDE filters in the same time.
>>
> 
> Actually, there are real uses to do both. You may want to show a
> specific kind of event, and then you may want to filter a subset of
> that event.
> 

But if you want to filter a subset of one event you have to use the 
advanced filtering, while the logic in the "switch" is only for the "Id 
filters".

Thanks!
Yordan


> -- Steve
> 
