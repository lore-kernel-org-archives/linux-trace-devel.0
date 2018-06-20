Return-Path: <SRS0=8rzQ=JG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54897 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752855AbeFTLsf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jun 2018 07:48:35 -0400
Received: by mail-wm0-f66.google.com with SMTP id o13-v6so5474210wmf.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jun 2018 04:48:34 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH v2 2/2] trace-filter: Change the hashing function used
 when filtering
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180619132259.21387-1-y.karadz@gmail.com>
 <20180619132259.21387-2-y.karadz@gmail.com>
 <20180619185408.58931c8f@gandalf.local.home>
Message-ID: <b43f0a7b-d237-0ab6-c2d6-97ae9cb8b5fc@gmail.com>
Date: Wed, 20 Jun 2018 14:48:31 +0300
MIME-Version: 1.0
In-Reply-To: <20180619185408.58931c8f@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 20.06.2018 01:54, Steven Rostedt wrote:
> On Tue, 19 Jun 2018 16:22:59 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The hashing function used in trace-filter-hash is changed.
>> The new hashing functions is based on the Donald E. Knuth's
>> Multiplicative hashing, suggested in his book "The Art of
>> Computer Programming". This improves the performance, but
>> also removes the restrictions resulting  from using the
>> Paul Hsieh's super fast hash, published under the terms of
>> the GPL 2.0 license.
>>
>> Paul Hsieh's hash function, defined in trace-hash-local.h,
>> is still used in trace-graph.c, trace-plot.c, trace-plot-cpu.c
>> and trace-plot-task.c. Because trace-hash-local.h is no longer
>> included in trace-filter-hash.h, it has to be included
>> explicitly in these four source files.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
> 
> I've applied these but haven't pushed them out yet. Which files need to
> be changed from GPL to LGPL? Now that we have removed the GPL code from
> the filter hash.
> 

I would like to have trace-filter-hash.h and trace-filter-hash.c changed 
to LGPL. Also I would like trace-filter-hash.o to became part of 
libtracecmd and respectively trace-filter-hash.h to be moved to 
/include/trace-cmd/

Thank you very much!

Yordan

> -- Steve
> 
