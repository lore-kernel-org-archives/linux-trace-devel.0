Return-Path: <SRS0=efs/=J4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35996 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbeGLM7C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Jul 2018 08:59:02 -0400
Received: by mail-wm0-f67.google.com with SMTP id s14-v6so5945278wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Jul 2018 05:49:35 -0700 (PDT)
Subject: Re: [PATCH 1/6] kernel-shark-qt: Add generic instruments for
 searching inside the trace data
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180711133814.26854-1-y.karadz@gmail.com>
 <20180711133814.26854-2-y.karadz@gmail.com>
 <20180711124147.2bbf5b02@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <834b37c8-103a-b17f-b6a6-e5ac563e5a1a@gmail.com>
Date: Thu, 12 Jul 2018 15:49:33 +0300
MIME-Version: 1.0
In-Reply-To: <20180711124147.2bbf5b02@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 11.07.2018 19:41, Steven Rostedt wrote:
>> +/**
>> + * @brief Simple Pid matching function to be user for data requests.
>> + * @param kshark_ctx: Input location for the session context pointer.
>> + * @param e: kshark_entry to be checked.
>> + * @param pid: Matching condition value.
>> + * @returns True if the Pid of the entry matches the value of "pid".
>> + *	    Else false.
> Is this going to be extended in the future? Why the kshark_ctx?
> 

Yes, this is something we need to discuss.

in the header we have

/** Matching condition function type. To be user for data requests */
typedef bool (matching_condition_func)(struct kshark_context*,
				       struct kshark_entry*,
				       int);

I wanted the type of the abstract condition function to be such that it 
can accommodate complicated logic in the future.
What do you think?

Thanks!
Yordan

>> + */
>> +bool kshark_check_pid(struct kshark_context *kshark_ctx,
>> +		      struct kshark_entry *e, int pid)
>> +{
>> +	if (e->pid == pid)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
