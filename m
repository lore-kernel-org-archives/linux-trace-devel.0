Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35977 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731580AbeITTJc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 15:09:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id j192-v6so11075821wmj.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Sep 2018 06:26:00 -0700 (PDT)
Subject: Re: [PATCH v4 2/7] kernel-shark-qt: Add Plugin event handlers to
 session.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180919143657.19472-1-y.karadz@gmail.com>
 <20180919143657.19472-3-y.karadz@gmail.com>
 <20180919232432.52be5d1b@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e79dde81-68a4-4310-348d-a7da677a5d4d@gmail.com>
Date: Thu, 20 Sep 2018 16:26:11 +0300
MIME-Version: 1.0
In-Reply-To: <20180919232432.52be5d1b@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 20.09.2018 06:24, Steven Rostedt wrote:
>>   	/** Special mask used whene filtering events. */
>>   	KS_EVENT_VIEW_FILTER_MASK	= 1 << 2,
>> +
>> +	/**
>> +	 * Use this mask to check if the content of the entry has been accessed
>> +	 * by a plugin-defined function.
>> +	 */
>> +	KS_PLUGIN_UNTOUCHED_MASK	= 1 << 7
> Why the jump to 7?

The "visible" field of the entry will use 8 bits. I know that it is 
uint16_t now, but my plan is to use 8 of its bits for the stream_id field.

Currently we use the first 3 bits as different visibility flags and we 
have 4 unused bits available for adding more visibility flags in the 
future. Because the PLUGIN_UNTOUCHED flag has a different meaning I 
decided to place it at the very end.

Is this a problem?

Thanks!
Yordan
