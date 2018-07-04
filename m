Return-Path: <SRS0=h6hK=JU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:56173 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933160AbeGDLt6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jul 2018 07:49:58 -0400
Received: by mail-wm0-f67.google.com with SMTP id v16-v6so5507255wmv.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Jul 2018 04:49:57 -0700 (PDT)
Subject: Re: [PATCH 0/3] kernel-shark-qt: Merge
 kshark_load_data_records/entries()
To: Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20180703162130.082810105@goodmis.org>
 <da0c7baa-2845-7873-3015-b250dd93e79e@gmail.com>
 <EB1A5869-EAD2-4D4C-9C50-AF34D9A4C451@goodmis.org>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <89f94a30-8189-0a10-03f1-52aac387098a@gmail.com>
Date: Wed, 4 Jul 2018 14:49:55 +0300
MIME-Version: 1.0
In-Reply-To: <EB1A5869-EAD2-4D4C-9C50-AF34D9A4C451@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  4.07.2018 14:26, Steven Rostedt wrote:
> [Sorry for the top post, it's a US holiday]
> 
> Can we just disable warnings for structures? I'd like to keep the function warnings on.

It looks like this is not possible. At least, I can't see such option in 
the manual.

Yordan

> 
> -- Steve
> 
> 
> On July 4, 2018 7:17:26 AM EDT, "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>>
>>
>> On  3.07.2018 19:21, Steven Rostedt wrote:
>>> This works to consolidate the functions kshark_load_data_records()
>>> with kshark_load_data_entries(). It adds some helper functions
>>> for the two to use to simplify the code.
>>>
>>> Note, doxygen warns that struct rec_list is not documented. Really?
>>> Such a simple structure doesn't really require documentation. Is
>>> there a way to shut it up? Or I can just add code to say
>>>    /** Shut doxygen up! ;-)
>>
>> Yes, you can do
>>
>> //! @cond Doxygen_Suppress
>>
>> struct rec_list {
>> 	struct pevent_record	*rec;
>> 	struct rec_list		*next;
>> };
>>
>> //! @endcond
>>
>> Another solutions is to turn off all warnings. This can be done by
>> adding
>>
>>   WARN_IF_UNDOCUMENTED = NO
>>
>> to doc/dox_config
>>
>> On the other hand, do we expect the normal users to build doxygen
>> documentation, if this documentation is available at
>> http://kernelshark.org? So maybe we can tolerate having some warnings.
>>
>> Actually this reminds me that there is a third solution. We can make
>> this warnings invisible for the normal users by redirecting the
>> doxygen's stderr to a file.
>>
>> What do you think?
>>
>> Yordan
>>
>>
>>> Yordan, please review these.
>>>
>>> Steven Rostedt (VMware) (3):
>>>         kernel-shark-qt: Move declarations to top in datafilter.c
>> example
>>>         kernel-shark-qt: Consolidate load_data_entries and
>> load_data_records
>>>         kernel-shark-qt: Add helper function to find the next_cpu in
>> kshark_load_data_*()
>>>
>>> ----
>>>    kernel-shark-qt/examples/datafilter.c |   5 +-
>>>    kernel-shark-qt/src/libkshark.c       | 253
>> ++++++++++++++++++++--------------
>>>    2 files changed, 151 insertions(+), 107 deletions(-)
>>>
> 
