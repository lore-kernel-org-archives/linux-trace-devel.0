Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36630 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbeJEW0f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 18:26:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id y16so13984959wrw.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Oct 2018 08:27:23 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] kernel-shark-qt: Add kshark_get_X_easy()
 functions.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
References: <20181001135921.32379-1-ykaradzhov@vmware.com>
 <20181001135921.32379-2-ykaradzhov@vmware.com>
 <20181002164420.37d75e18@gandalf.local.home>
 <dce5ae6d-900e-c612-2bae-81d2ad25a0a3@vmware.com>
 <5914b819-62eb-f2be-ba74-b12f138452fc@gmail.com>
 <20181005104607.0f205018@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <ad5dcd71-aa99-f2d0-f586-8f8af9e03bab@gmail.com>
Date: Fri, 5 Oct 2018 18:27:20 +0300
MIME-Version: 1.0
In-Reply-To: <20181005104607.0f205018@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  5.10.2018 17:46, Steven Rostedt wrote:
>>>>> +/**
>>>>> + * @brief This function allows for an easy access to the original value of the
>>>>> + *	  Process Id as recorded in the tep_record object. The record is read
>>>>> + *	  from the file only in the case of an entry being touched by a plugin.
>>>>> + *	  Be aware that using the kshark_get_X_easy functions can be
>>>>> + *	  inefficient if you need an access to more than one of the data fields
>>>>> + *	  of the record.
>>>>> + *
>>>>> + * @param entry: Input location for the KernelShark entry.
>>>>> + *
>>>>> + * @returns The original value of the Process Id as recorded in the
>>>>> + *	    tep_record object on success, otherwise negative error code.
>>>>> + */
>>>>> +int kshark_get_pid_easy(struct kshark_entry *entry)
>>>>> +{
>>>>> +	struct kshark_context *kshark_ctx = NULL;
>>>>> +	struct tep_record *data;
>>>>> +	int pid;
>>>>> +
>>>>> +	if (!kshark_instance(&kshark_ctx))
>>>>> +		return -EFAULT;
>>>> Perhaps this should return -ENODEV;
>>>>   
>>>>> +
>>>>> +	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
>>>> What's the "UNTOUCHED_MASK" mean?
>>> We use the KS_PLUGIN_UNTOUCHED_MASK to check the flag (bit)
>>> which indicates if the entry has been touched and potential modified by
>>> a plugin callback function. If the bit is set this means untouched.
>>>
>>> This flag (bit) gets set when we load the data ( libkshark.c /
>>> get_records())
>>>
>>> 	entry->visible = 0xFF;
>>>
>>> ...
>>>
>>> 	/* Execute all plugin-provided actions (if any). */
>>> 	evt_handler = kshark_ctx->event_handlers;
>>> 	while ((evt_handler = kshark_find_event_handler(evt_handler,
>>> 						entry->event_id))) {
>>> 		evt_handler->event_func(kshark_ctx, rec, entry);
>>> 		evt_handler = evt_handler->next;
>>> 		if (!evt_handler)
>>> 			entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
>>> 	}
>>>    
>>>>   
>>>>> +		pid = entry->pid;
>>>>> +	} else {
>>> In this case the entry has been touched by a plugin. Because of this we
>>> do not trust the value of "entry->pid".
> I guess my question is, can we reset the entry->pid back to something
> we do trust, and clear the flag?
> 
> Or do we not want to modify it, because the plugin now owns the value?
> 

If the value of "entry->pid" has been changed then the new value will be 
used when plotting graphs and we do not want to change this.
However, we still want to be able to retrieve the original value. The 
description of the function explains that it will return the original value.

Thanks!
Yordan

> -- Steve
> 
