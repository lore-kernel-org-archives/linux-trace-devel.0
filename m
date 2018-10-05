Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56200 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728621AbeJEV3S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 17:29:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id 206-v6so2073225wmb.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Oct 2018 07:30:20 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] kernel-shark-qt: Add kshark_get_X_easy()
 functions.
To: Yordan Karadzhov <ykaradzhov@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
References: <20181001135921.32379-1-ykaradzhov@vmware.com>
 <20181001135921.32379-2-ykaradzhov@vmware.com>
 <20181002164420.37d75e18@gandalf.local.home>
 <dce5ae6d-900e-c612-2bae-81d2ad25a0a3@vmware.com>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <5914b819-62eb-f2be-ba74-b12f138452fc@gmail.com>
Date: Fri, 5 Oct 2018 17:30:17 +0300
MIME-Version: 1.0
In-Reply-To: <dce5ae6d-900e-c612-2bae-81d2ad25a0a3@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

I guess this email thread was lost on your side.

Is my explanation of the "UNTOUCHED_MASK" OK?
Should I send you v3 of the patches with the other fixes you asked for?

On  3.10.2018 10:34, Yordan Karadzhov wrote:
> 
> 
> On  2.10.2018 23:44, Steven Rostedt wrote:
>> On Mon,  1 Oct 2018 16:59:17 +0300
>> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>>
>>> From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
>>>
>>> The kshark_get_X_easy() functions allow for an easy access to the
>>> tep_record's fields. Using these functions can be inefficient if you
>>> need access to more than one of the fields of the record.
>>>
>>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>>> ---
>>>    kernel-shark-qt/src/libkshark.c | 185 ++++++++++++++++++++++++++++++++
>>>    kernel-shark-qt/src/libkshark.h |  12 +++
>>>    2 files changed, 197 insertions(+)
>>>
>>> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
>>> index 506511d..a7983eb 100644
>>> --- a/kernel-shark-qt/src/libkshark.c
>>> +++ b/kernel-shark-qt/src/libkshark.c
>>> @@ -888,6 +888,191 @@ static const char *kshark_get_info(struct tep_handle *pe,
>>>    	return seq.buffer;
>>>    }
>>>    
>>> +/**
>>> + * @brief This function allows for an easy access to the original value of the
>>> + *	  Process Id as recorded in the tep_record object. The record is read
>>> + *	  from the file only in the case of an entry being touched by a plugin.
>>> + *	  Be aware that using the kshark_get_X_easy functions can be
>>> + *	  inefficient if you need an access to more than one of the data fields
>>> + *	  of the record.
>>> + *
>>> + * @param entry: Input location for the KernelShark entry.
>>> + *
>>> + * @returns The original value of the Process Id as recorded in the
>>> + *	    tep_record object on success, otherwise negative error code.
>>> + */
>>> +int kshark_get_pid_easy(struct kshark_entry *entry)
>>> +{
>>> +	struct kshark_context *kshark_ctx = NULL;
>>> +	struct tep_record *data;
>>> +	int pid;
>>> +
>>> +	if (!kshark_instance(&kshark_ctx))
>>> +		return -EFAULT;
>>
>> Perhaps this should return -ENODEV;
>>
>>> +
>>> +	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
>>
>> What's the "UNTOUCHED_MASK" mean?
> 
> We use the KS_PLUGIN_UNTOUCHED_MASK to check the flag (bit)
> which indicates if the entry has been touched and potential modified by
> a plugin callback function. If the bit is set this means untouched.
> 
> This flag (bit) gets set when we load the data ( libkshark.c /
> get_records())
> 
> 	entry->visible = 0xFF;
> 
> ...
> 
> 	/* Execute all plugin-provided actions (if any). */
> 	evt_handler = kshark_ctx->event_handlers;
> 	while ((evt_handler = kshark_find_event_handler(evt_handler,
> 						entry->event_id))) {
> 		evt_handler->event_func(kshark_ctx, rec, entry);
> 		evt_handler = evt_handler->next;
> 		if (!evt_handler)
> 			entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
> 	}
> 
>>
>>> +		pid = entry->pid;
>>> +	} else {
> 
> In this case the entry has been touched by a plugin. Because of this we
> do not trust the value of "entry->pid".
> 
>>> +		data = kshark_read_at(kshark_ctx, entry->offset);
>>> +		pid = tep_data_pid(kshark_ctx->pevent, data);
>>> +		free_record(data);
>>
>> Would it be possible to do:
>>
>> 		entry->visible |= KS_PLUGIN_UNTOUCHED_MASK;
>> 		entry->pid = pid;
>>
>> ?
>>
>> Of course this depends on what that mask means.
>>
>>> +	}
>>> +
>>> +	return pid;
>>> +}
>>> +
