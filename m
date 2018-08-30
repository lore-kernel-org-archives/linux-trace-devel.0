Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38891 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbeH3Pxo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 11:53:44 -0400
Received: by mail-wm0-f66.google.com with SMTP id t25-v6so1698280wmi.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Aug 2018 04:51:57 -0700 (PDT)
Subject: Re: [PATCH 7/7] kernel-shark-qt: Add a plugin for sched events.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20180829164224.20677-1-y.karadz@gmail.com>
 <20180829164224.20677-8-y.karadz@gmail.com>
 <20180829224312.25c7a16e@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3e416b26-7155-51e0-fd27-be3a5d8a3c4d@gmail.com>
Date: Thu, 30 Aug 2018 14:51:54 +0300
MIME-Version: 1.0
In-Reply-To: <20180829224312.25c7a16e@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 30.08.2018 05:43, Steven Rostedt wrote:
>> +static int plugin_get_wakeup_pid_lazy(struct kshark_context *kshark_ctx,
> I thought we would use "_simple" ?
> 

can we use "_easy"?

Thanks!
Yordan
