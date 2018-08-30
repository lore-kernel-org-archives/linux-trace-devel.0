Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38935 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbeH3PrF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 11:47:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id o37-v6so7767806wrf.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Aug 2018 04:45:19 -0700 (PDT)
Subject: Re: [PATCH 1/7] kernel-shark-qt: Add plugin infrastructure to be used
 by the Qt-baset KS.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180829164224.20677-1-y.karadz@gmail.com>
 <20180829164224.20677-2-y.karadz@gmail.com>
 <20180829163253.7ba150f5@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b7b16558-a42f-55d8-7bb1-9f6c868d1897@gmail.com>
Date: Thu, 30 Aug 2018 14:45:16 +0300
MIME-Version: 1.0
In-Reply-To: <20180829163253.7ba150f5@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 29.08.2018 23:32, Steven Rostedt wrote:
>> +	struct kshark_event_handler **last = handlers;
>> +	struct kshark_event_handler *list;
>> +
>> +	for (list = *handlers; list; list = list->next) {
> You can simplify this to:
> 
> 	for (last = handlers; *last; last = &(*last)->next) {
> 		list = *last;
> 
>> +		if (list->id == event_id &&
>> +		    list->event_func == evt_func &&
>> +		    list->draw_func == dw_func) {
>> +			*last = list->next;
>> +			free(list);
>> +			return;
>> +		}
>> +
> 
>> +		last = &list->next;
> Then you can remove the above line.
> 

I am confused. For me the two implementations of this for-loop are 
identical. Where is the simplification?

Thanks!
Yordan
