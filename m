Return-Path: <SRS0=QejA=KV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37818 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733171AbeHFSSB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Aug 2018 14:18:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id u12-v6so12900016wrr.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Aug 2018 09:08:14 -0700 (PDT)
Subject: Re: [PATCH v3 4/6] kernel-shark-qt: Define Data collections
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180803142937.3970-1-y.karadz@gmail.com>
 <20180803142937.3970-5-y.karadz@gmail.com>
 <20180803222731.4e47e97f@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <0e0742a9-c594-f2e6-f7c1-7a82b00dd50d@gmail.com>
Date: Mon, 6 Aug 2018 19:08:13 +0300
MIME-Version: 1.0
In-Reply-To: <20180803222731.4e47e97f@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

On  4.08.2018 05:27, Steven Rostedt wrote:
>> +static struct kshark_entry_collection *
>> +kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
>> +			     struct kshark_entry **data,
>> +			     size_t first,
>> +			     size_t n_rows,
>> +			     matching_condition_func cond,
>> +			     int val,
>> +			     size_t margin)
> What exactly is margin used for?
> 


The margin allows the user to inflate each of the interval, by appending 
additional data which do not satisfy the matching condition. This data 
is added to each interval at the beginning and at the end of the data 
which satisfies the condition, as well as at the beginning and at the 
end of data-set. The margin data can be useful in the case when the user 
wants to be able to see what is happening before and after the 
appearance of his data of interest.

Thanks!
Yordan
