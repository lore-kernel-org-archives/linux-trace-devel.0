Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mx1.redhat.com ([209.132.183.28]:37054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936434AbdLRWpk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 17:45:40 -0500
Subject: Re: [PATCH v1] trace-cmd: introduce --initital-delay for record
 command
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20171218112412.11898-1-david@redhat.com>
 <20171218104158.22519a7e@gandalf.local.home>
 <7b89f63f-3a6f-4182-c26a-934514ba5670@redhat.com>
 <20171218125231.445d8fa2@gandalf.local.home>
 <55abd06d-1cac-8deb-d9be-f661f0ba30e1@redhat.com>
 <20171218164308.658924b8@gandalf.local.home>
From: David Hildenbrand <david@redhat.com>
Message-ID: <9d275f1a-346a-7ca8-c6c8-d32758770fd7@redhat.com>
Date: Mon, 18 Dec 2017 23:45:39 +0100
MIME-Version: 1.0
In-Reply-To: <20171218164308.658924b8@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On 18.12.2017 22:43, Steven Rostedt wrote:
> On Mon, 18 Dec 2017 21:56:33 +0100
> David Hildenbrand <david@redhat.com> wrote:
>  
>> I'll have a try tomorrow if I I''lose events with 20MB buffers per CPU
>> when recording more than 60 seconds (on a very active system with
>> mentioned scheduler rtaces being turned on).
>>
> 
> Another option is to add a '-w' option to record that causes the
> recorders (what reads the data) to "wait" or force it to sleep even if
> it did read something. I'm fine with that.

Also thought about that. Might make sense (and makes -s actually do what
it advertises even when there are a lot of events coming in).

Thanks Steve

> 
> -- Steve
> 


-- 

Thanks,

David / dhildenb
