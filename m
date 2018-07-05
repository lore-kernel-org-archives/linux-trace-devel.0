Return-Path: <SRS0=lN8X=JV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36940 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753606AbeGEQJB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jul 2018 12:09:01 -0400
Received: by mail-wm0-f68.google.com with SMTP id n17-v6so11852905wmh.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Jul 2018 09:09:01 -0700 (PDT)
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20180703162432.316240087@goodmis.org>
 <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
Message-ID: <c76e5486-1431-7a81-63e8-cac67858d5e8@gmail.com>
Date: Thu, 5 Jul 2018 19:08:58 +0300
MIME-Version: 1.0
In-Reply-To: <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steve,
I am still learning how to answer to patches, and I guess because of 
this you didn't notice my comment at the bottom. I think you have to 
remove the line

   free_record(rec);

You don't have to send me another patch.
Thanks!
Yordan

On  4.07.2018 14:39, Yordan Karadzhov (VMware) wrote:
>>
>> +            rec = rec_list[next_cpu]->rec;
>> +            rows[count] = rec;
>> -        ++count;
>> +            pid = pevent_data_pid(kshark_ctx->pevent, rec);
>> +            task = kshark_add_task(kshark_ctx, pid);
>> +            if (!task)
>> +                goto fail;
>> +
>> +            temp_rec = rec_list[next_cpu];
>> +            rec_list[next_cpu] = rec_list[next_cpu]->next;
>> +            free(temp_rec);
>> +            free_record(rec);
> 
> You have to free only the element of the list.
> The user is responsible for freeing the record.
> 
>> +        }
>>       }
>> -    free(cpu_list);
>> +    free_rec_list(rec_list, n_cpus);
>>       *data_rows = rows; 
