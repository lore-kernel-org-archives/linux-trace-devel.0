Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E4DC3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 14:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C871B22CED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 14:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CgQhDu6d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfH1OKw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 10:10:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35973 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfH1OKw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 10:10:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id p13so223071wmh.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 07:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EABsAN9Nc5QrJvtMEPxJfbXuODC1SGOraQj0+Ff3XN4=;
        b=CgQhDu6djRaXPCMxJZM41gK58mD0YI0sCHMPq2/23Qa6cTooON0ehMNWVQyp7m2RTT
         bPz3QT1aKISmZK9deM1xWdFhfam3nc2lRpXfYva98RftvlgvcfZ2FDnmr7DPqsYbDmNm
         GzT5dDg8YDTNY4Qep5aDWkB1bfsCAjaEZViu4g8xviyl7bfjLnHZu4XOYBexu2RzhWTq
         5LfYTPNt94ttelXaDNjRgP9MQuZmtVXTme7RZrTYqsKvqrJgCS7uKcKkMwItibAUPmLz
         bM2nA++i3/IKSH99ZmYvL/Gq67FoKW5YiXdINHHHzRTSUQIwo6kks2EcOWWvthDHX9qw
         Xt+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EABsAN9Nc5QrJvtMEPxJfbXuODC1SGOraQj0+Ff3XN4=;
        b=Pg9IMthZ8oMHE3WPoNvkZ1BcBXYA25Lxanu59uEsxAYosLNp/n0NrVoQnEq8TyyxRn
         8pZedtj5Ztp3z0zShcA9b712kw4tyRexStFDAgCLaJEvnlEyCfPyjKPQl8JDQ6cibiBC
         Dd5tVmTeB0MWpj2OsmgFgE0hDpwUXSLD3tq9M1jGrok0HSVbxBdeNGMEOrCKSCxZbR6E
         p23feF4ZkKVT0A4scVv2cU1QsrNk0MHPIoQeMGxpwhOnhVesxkfV2CVYsSBOEQUD/072
         WiFzTHBKcaqzpNQRSjTgMOf+SlDd7lRz490vz1gtZzIyi2KcaJmr+jEtOej17ncdgU8W
         znDA==
X-Gm-Message-State: APjAAAULcvqp7t/z2EXBxPlJwheHgGTueVFZOzXOOjGWdTgUvBGomlqz
        bounTo6jRe+Qmdd20mxy5WlAee3ur4s=
X-Google-Smtp-Source: APXvYqwe7REybT+Juj9VxmWxxbW6gQN1ihK9hA6/L6M4NUDMdFxCJUTZEqOQYdmqORSofRvDdRfS8w==
X-Received: by 2002:a1c:e487:: with SMTP id b129mr5257456wmh.93.1567001449996;
        Wed, 28 Aug 2019 07:10:49 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f6sm5550833wrh.30.2019.08.28.07.10.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 07:10:49 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Provide parsing for quotation marks in
 Record command line
To:     Steven Rostedt <rostedt@goodmis.org>, stephen@brennan.io
Cc:     linux-trace-devel@vger.kernel.org
References: <20190827131418.18713-1-y.karadz@gmail.com>
 <20190828051018.GA5316@greed> <20190828090614.1372a9a8@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d86d746e-fe00-2d0c-5fef-4a7d1c09c245@gmail.com>
Date:   Wed, 28 Aug 2019 17:10:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828090614.1372a9a8@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 28.08.19 г. 16:06 ч., Steven Rostedt wrote:
> On Tue, 27 Aug 2019 22:10:18 -0700
> stephen@brennan.io wrote:
> 
>> It strikes me that this explicitly supports only a single set of quotes.
>> This sort of behavior would be pretty surprising for people expecting shell
>> quote support, and for people expecting just splitting on spaces.
>>
>> I looked and couldn't really find any Qt utility for properly parsing shell
>> quoting (similar to python's shlex module). I totally get that it's a lot
>> of work to implement a correct shell quoting parser.
>>
>> Maybe a compromise would be to add a checkbox to the capture dialog, which
>> tells kernel-shark to pass the entire textbox contents, unmodified, to the
>> shell implementation on the system. So, my example of:
>>
>>      python -c 'print("hello world")'
>>
>> Would get put into the third argument of the command:
>>
>>      /bin/sh -c INSERT_TEXTBOX_CONTENTS_HERE
>>
>> Then you could rely on /bin/sh doing the parsing for you. The downside is
>> that it adds a whole new process. But you can't always get everything in
>> life, right?
>>
> 
> I need to look at this a bit deeper. I've written lots of cases where I
> had to capture single and double quotes and turn them into a single
> command. This is definitely needed here.
> 

Can you send me few of the of most trickier examples that comes to your 
mind, so that I can use them to test the parsing?

Thanks!
Yordan

> I'm very reluctant to just use a simple /bin/sh, as this is being run
> as root. Grant you, it is open to do anything, but I rather not just
> make it into a root shell. Although we still allow you to run any
> command. But once you add a full shell with the "sh -c" you now need to
> deal with environment variables and such, which can cause more
> unexpected side effects.
> 
> Basically, we want to be able to add single and double quotes, as well
> as backslashes: my -c 'command\'s here' and '\\' this "too"
> 
> Thanks for the feedback.
> 
> -- Steve
> 
