Return-Path: <SRS0=lMx0=LH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37590 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbeHYADk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Aug 2018 20:03:40 -0400
Received: by mail-wm0-f66.google.com with SMTP id n11-v6so2780058wmc.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Aug 2018 13:27:29 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] kernel-shark-qt: Add C++ API for drawing of Graphs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180824142116.21339-1-y.karadz@gmail.com>
 <20180824142116.21339-4-y.karadz@gmail.com>
 <20180824105001.40064c74@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d4d5fda7-4e4d-0420-700b-e147ccd7aad9@gmail.com>
Date: Fri, 24 Aug 2018 23:27:25 +0300
MIME-Version: 1.0
In-Reply-To: <20180824105001.40064c74@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 24.08.2018 17:50, Steven Rostedt wrote:
>> +	/*
>> +	 * Check the content of the very firs bin and see if the CPU is
> I haven't really looked too much at this patch yet, but this spelling
> stood out. Seems your 't' key is not working well when typing "first
> bin". There's several places that have that;-)
> 

I am sorry for this annoying typos. This is happening because my editor 
is trying to auto-complete the words when I am typing. And it does this 
based on what I already wrote in the file. So if I misspell a word once 
next time the editor will suggest the same typo.

Thanks!
Yordan

> -- Steve
> 
