Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36368 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbeITTMV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 15:12:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id j192-v6so11087414wmj.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Sep 2018 06:28:49 -0700 (PDT)
Subject: Re: [PATCH v4 2/7] kernel-shark-qt: Add Plugin event handlers to
 session.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180919143657.19472-1-y.karadz@gmail.com>
 <20180919143657.19472-3-y.karadz@gmail.com>
 <20180919232432.52be5d1b@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b5cbf76c-38d1-0c88-d455-18ba9833dcb2@gmail.com>
Date: Thu, 20 Sep 2018 16:29:00 +0300
MIME-Version: 1.0
In-Reply-To: <20180919232432.52be5d1b@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 20.09.2018 06:24, Steven Rostedt wrote:
>> static size_t get_records(struct kshark_context *kshark_ctx,
>>   			  struct rec_list ***rec_list, enum rec_type type)
>>   {
>> +	struct kshark_event_handler *evt_handler;
>>   	struct event_filter *adv_filter;
>>   	struct kshark_task_list *task;
>>   	struct tep_record *rec;
>> @@ -608,6 +618,17 @@ static size_t get_records(struct kshark_context *kshark_ctx,
>>   
>>   				entry = &temp_rec->entry;
>>   				kshark_set_entry_values(kshark_ctx, rec, entry);
>> +
>> +				/* Execute all plugin-provided actions (if any). */
>> +				evt_handler = kshark_ctx->event_handlers;
>> +				while ((evt_handler = find_event_handler(evt_handler,
>> +									 entry->event_id))) {
>> +					evt_handler->event_func(kshark_ctx, rec, entry);
>> +
>> +					if ((evt_handler = evt_handler->next))
> Please break the above if, to remove the assignment. It's just easier
> to read. That is:
> 
> 					event_handler = event_hanndler->next;
> 					if (event_handler)
>> +						entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
>> +				}
>> +

Actually this is a bug (typo). I meant to have

					evt_handler = evt_handler->next;
					if (!evt_handler)
						entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;

This way the KS_PLUGIN_UNTOUCHED flag gets unset only once and it is 
guaranteed that the value of the bit cannot be changed by the plugin 
callback function.

Thanks!
Yordan


>>   				pid = entry->pid;
>>   				/* Apply event filtering. */
>>   				ret = FILTER_MATCH;
