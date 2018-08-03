Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55131 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731994AbeHCPCj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 11:02:39 -0400
Received: by mail-wm0-f67.google.com with SMTP id c14-v6so6217773wmb.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Aug 2018 06:06:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark-qt: Deal with the "no tasks" case in
 kshark_get_task_pids()
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180711133709.26788-1-y.karadz@gmail.com>
 <20180711100249.615d9c2a@gandalf.local.home>
 <87c21cdd-b259-2be3-9fdb-9f471fc37cb5@gmail.com>
Message-ID: <8727eace-8acb-5a1f-e1bb-39af4f03e1f7@gmail.com>
Date: Fri, 3 Aug 2018 16:06:24 +0300
MIME-Version: 1.0
In-Reply-To: <87c21cdd-b259-2be3-9fdb-9f471fc37cb5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,
Should I send this patch again?

Thanks!
Yordan


On 11.07.2018 17:08, Yordan Karadzhov (VMware) wrote:
>>
>> What about doing it this way:
>>
>> diff --git a/kernel-shark-qt/src/libkshark.c 
>> b/kernel-shark-qt/src/libkshark.c
>> index 668b6df8..34daa25e 100644
>> --- a/kernel-shark-qt/src/libkshark.c
>> +++ b/kernel-shark-qt/src/libkshark.c
>> @@ -303,12 +303,17 @@ ssize_t kshark_get_task_pids(struct 
>> kshark_context *kshark_ctx, int **pids)
>>           }
>>       }
>> -    temp_pids = realloc(*pids, pid_count * sizeof(int));
>> -    if (!temp_pids)
>> -        goto fail;
>> +    if (pid_count) {
>> +        temp_pids = realloc(*pids, pid_count * sizeof(int));
>> +        if (!temp_pids)
>> +            goto fail;
>> -    /* Paranoid: In the unlikely case of shrinking *pids, realloc 
>> moves it */
>> -    *pids = temp_pids;
>> +        /* Paranoid: In the unlikely case of shrinking *pids, realloc 
>> moves it */
>> +        *pids = temp_pids;
>> +    } else {
>> +        free(*pids);
>> +        *pids = NULL;
>> +    }
>>       return pid_count;
> 
> Yes, this way is better.
> 
> Thanks!
> Yordan
> 
> 
>>
>> ?
>>
>> -- Steve
