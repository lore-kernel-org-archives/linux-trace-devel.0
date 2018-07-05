Return-Path: <SRS0=lN8X=JV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45512 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753801AbeGEOxS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jul 2018 10:53:18 -0400
Received: by mail-pf0-f196.google.com with SMTP id y24-v6so5639260pfe.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Jul 2018 07:53:18 -0700 (PDT)
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180703162432.316240087@goodmis.org>
 <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
 <20180705104740.188490bb@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <128ec518-fcc1-a807-542d-0e140fdb430f@gmail.com>
Date: Thu, 5 Jul 2018 17:53:12 +0300
MIME-Version: 1.0
In-Reply-To: <20180705104740.188490bb@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  5.07.2018 17:47, Steven Rostedt wrote:
> On Wed, 4 Jul 2018 14:39:01 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>>    /**
>>>     * @brief Load the content of the trace data file into an array of
>>>     *	  kshark_entries. This function provides fast loading, however the
>>
>> Actually , after applying the patch for trace-input.c and this patch on
>> top kshark_load_data_entries() becomes slower than
>> kshark_load_data_records(). Just make this clear in the description of
>> the functions.
> 
> So what should the purpose of this function be stated here then?
> 
> "This function provides an abstraction of the entries from the raw data
> that is read." ?

Yes,

--Yordan


> 
> -- Steve
> 
> 
>>
>>> @@ -521,9 +587,11 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>>>    				struct kshark_entry ***data_rows)
> 
