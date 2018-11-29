Return-Path: <SRS0=ZWpJ=OI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f47.google.com ([209.85.221.47]:35637 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbeK2Wjo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 17:39:44 -0500
Received: by mail-wr1-f47.google.com with SMTP id 96so1552188wrb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Nov 2018 03:34:40 -0800 (PST)
Subject: Re: KernelShark enhancement request
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
References: <20181128211800.61aa8de6@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3ef5364c-e3a3-288a-50be-c075e2497b83@gmail.com>
Date: Thu, 29 Nov 2018 13:34:37 +0200
MIME-Version: 1.0
In-Reply-To: <20181128211800.61aa8de6@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 29.11.18 г. 4:17 ч., Steven Rostedt wrote:
> Hi Yordan,
> 
> Like I told you, I'm using KernelShark for actual work. One thing that
> I need, is a way to undo a "hide event" or task without having to clear
> all filters.
> 
> I picked an event to hide, and then after finding what I was looking
> for, I wanted that event back on. But I couldn't find a way to do that
> without clearing all filters.
> 
> It would be nice if the pop up menu had (perhaps at the bottom) a list
> of hidden events, and the menu state something like "unhide <event>".
> 
> Would that be too hard to implement?

Yes, this is a good idea. I guess we would want to be able to unhide 
Tasks and CPUs as well.

Thanks!
Yordan


> 
> Thanks!
> 
> -- Steve
> 
