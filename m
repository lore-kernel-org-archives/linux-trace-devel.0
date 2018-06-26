Return-Path: <SRS0=k4No=JM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38114 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbeFZP1B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jun 2018 11:27:01 -0400
Received: by mail-wr0-f194.google.com with SMTP id e18-v6so17697034wrs.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Jun 2018 08:27:01 -0700 (PDT)
Subject: Re: [PATCH 3/7] kernel-shark-qt: Add API for loading trace.dat files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180625150121.14291-1-y.karadz@gmail.com>
 <20180625150121.14291-4-y.karadz@gmail.com>
 <20180625143006.6b2cbad3@gandalf.local.home>
 <aaaaab86-51c0-506e-939e-1604274e09fc@gmail.com>
 <20180626111611.67bae931@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <c602693b-c352-e670-ab1b-394f603744d5@gmail.com>
Date: Tue, 26 Jun 2018 18:26:57 +0300
MIME-Version: 1.0
In-Reply-To: <20180626111611.67bae931@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 26.06.2018 18:16, Steven Rostedt wrote:
> On Tue, 26 Jun 2018 17:47:13 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>> How hard would it be to switch over?
>>
>> I have no experience with "kernel doc", so I have no idea if it will be
>> easy or hard. I can try to investigate, but this will take some time.
>> I this the way to go?
> 
> Doing a search, I found this link:
> 
> https://groups.google.com/forum/#!topic/jailhouse-dev/mkfNiU3epaY
> 
> It's from Jan Kiszka (you may have met him in Prague. He gave one of
> the keynotes, and is the author of Jailhouse). Seems he finds
> kernel-doc limiting, and prefers doxygen. I respect Jan's opinion in
> this (oh, and he was on the Alps with me too). Let's follow the
> jailhouse use of doxygen. Would that do?
> 

OK, great!
I have been using Doxygen documentation as a user (to learn new 
libraries) so I feel a bit attached to it. It is really useful. That why 
I wanted to use Doxygen to document our code.
Thanks!
Yordan


> -- Steve
> 
