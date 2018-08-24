Return-Path: <SRS0=lMx0=LH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36209 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbeHYAzl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Aug 2018 20:55:41 -0400
Received: by mail-wm0-f68.google.com with SMTP id j192-v6so2890778wmj.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Aug 2018 14:19:20 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] kernel-shark-qt: Add an example showing how to
 draw shapes and Graphs.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180824142116.21339-1-y.karadz@gmail.com>
 <20180824142116.21339-5-y.karadz@gmail.com>
 <20180824112303.7fab6bdd@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <987acc41-4fc1-60c0-59e6-83c284b98d1d@gmail.com>
Date: Sat, 25 Aug 2018 00:19:18 +0300
MIME-Version: 1.0
In-Reply-To: <20180824112303.7fab6bdd@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 24.08.2018 18:23, Steven Rostedt wrote:
> Should make some warning message. I ran this from the build directory
> like:
> 
>   ../bin/dplot ../../trace.dat
> 
> and it did nothing. But if I ran it from the trace-cmd.git repo as
> 
> kernel-shark-qt/bin/dplot trace.dat
> 

You are right, this example is a mess. I will fix the bugs and will add 
a help message.

> Then it did something. We need to make it work when called from
> anywhere with a path to any trace.dat file. And give some kind of
> message if no parameter is passed in.
> 
> Hmm, we should also probably make a separate directory for example
> programs. Perhaps have a "demo" directory for these?

Yes, we can do this. Or maybe we can even move the examples to a 
different repo and call it "kshark_demos"?

Thanks!
Yordan

> 
> -- Steve
