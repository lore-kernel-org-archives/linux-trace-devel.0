Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54398 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbeGKOMw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 10:12:52 -0400
Received: by mail-wm0-f65.google.com with SMTP id i139-v6so2556329wmf.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Jul 2018 07:08:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark-qt: Deal with the "no tasks" case in
 kshark_get_task_pids()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180711133709.26788-1-y.karadz@gmail.com>
 <20180711100249.615d9c2a@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <87c21cdd-b259-2be3-9fdb-9f471fc37cb5@gmail.com>
Date: Wed, 11 Jul 2018 17:08:17 +0300
MIME-Version: 1.0
In-Reply-To: <20180711100249.615d9c2a@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 11.07.2018 17:02, Steven Rostedt wrote:
> On Wed, 11 Jul 2018 16:37:08 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> kshark_get_task_pids() should not return a "memory allocation" error
>> in the case when it is called before having trace data loaded.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   kernel-shark-qt/src/libkshark.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
>> index 668b6df..75b88c9 100644
>> --- a/kernel-shark-qt/src/libkshark.c
>> +++ b/kernel-shark-qt/src/libkshark.c
>> @@ -303,6 +303,12 @@ ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids)
>>   		}
>>   	}
>>   
>> +	if (!pid_count) {
>> +		free(*pids);
>> +		*pids = NULL;
>> +		return pid_count;
>> +	}
>> +
>>   	temp_pids = realloc(*pids, pid_count * sizeof(int));
>>   	if (!temp_pids)
>>   		goto fail;
> 
> What about doing it this way:
> 
> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> index 668b6df8..34daa25e 100644
> --- a/kernel-shark-qt/src/libkshark.c
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -303,12 +303,17 @@ ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids)
>   		}
>   	}
>   
> -	temp_pids = realloc(*pids, pid_count * sizeof(int));
> -	if (!temp_pids)
> -		goto fail;
> +	if (pid_count) {
> +		temp_pids = realloc(*pids, pid_count * sizeof(int));
> +		if (!temp_pids)
> +			goto fail;
>   
> -	/* Paranoid: In the unlikely case of shrinking *pids, realloc moves it */
> -	*pids = temp_pids;
> +		/* Paranoid: In the unlikely case of shrinking *pids, realloc moves it */
> +		*pids = temp_pids;
> +	} else {
> +		free(*pids);
> +		*pids = NULL;
> +	}
>   
>   	return pid_count;
>   

Yes, this way is better.

Thanks!
Yordan


> 
> ?
> 
> -- Steve
> 
