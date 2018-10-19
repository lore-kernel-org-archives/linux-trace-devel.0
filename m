Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:40945 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbeJTAwf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 20:52:35 -0400
Received: by mail-wm1-f44.google.com with SMTP id z204-v6so4306765wmc.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Oct 2018 09:45:41 -0700 (PDT)
Subject: Re: Issue with making of doxygen files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20181019114029.6ec42a95@gandalf.local.home>
 <002df723-e710-ade0-3156-eac106aaf4f5@gmail.com>
 <20181019124045.2ad35fa4@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <95c1af05-2cce-ddbe-2ac6-3bcc9559b6d3@gmail.com>
Date: Fri, 19 Oct 2018 19:45:38 +0300
MIME-Version: 1.0
In-Reply-To: <20181019124045.2ad35fa4@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 19.10.2018 19:40, Steven Rostedt wrote:
> On Fri, 19 Oct 2018 19:37:15 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> 
>>> Seems I'm missing the utility epstopdf.
>>
>> This is a LaTeX package. I guess it is needed to generate pdf documentation.
>>
>> Please try adding to "kernel-shark-qt/doc/dox_config" a line
>>
>> GENERATE_LATEX  = NO
>>
>> and see if the problem still persist. I don't want to add LaTeX as
>> dependency.
>>
> 
> I can confirm that adding it removes the warnings and removing it
> brings them back.
> 
> Can you make that generated? That is, have cmake check if the latex
> packages are installed, and if they are you create them?

Yes, this can be automated.

Please make a patch which adds this temporary fix and go ahead.
I will add the Cmake check in another patch.

Thanks!
Y.

> 
> -- Steve
> 
