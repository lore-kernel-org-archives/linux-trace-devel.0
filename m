Return-Path: <SRS0=6G4v=TE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E374CC43219
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 May 2019 08:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F6F20652
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 May 2019 08:28:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8GlYjGx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfEDI2L (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 4 May 2019 04:28:11 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37327 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfEDI2L (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 4 May 2019 04:28:11 -0400
Received: by mail-wm1-f66.google.com with SMTP id y5so9257045wma.2
        for <linux-trace-devel@vger.kernel.org>; Sat, 04 May 2019 01:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D2kQo9hRx9o7bEDD0UK11w3ULUGMCCDibaIvyvg+7C8=;
        b=M8GlYjGxD9yD7LPfMXpbbpz6Humusww5cU8PiK4hFhT2CXq08aAkutRHiAgni0X++6
         dppHdK0sZBFSLyXjcwBNhkAyS42ydAInTcMJzEXJe7RXuA+guXEP8q27aRbx83BxGFe3
         92VLXpI34MTvK8CF8BIbJmlO6wg8JrXTmAVgpJ1Ty0kGwxAGyma/xIo26fa0RnMyTJa+
         QIU2YHSbeGjDbtwMuzElNR6IuWcB79u36CW+Y2J699h0Sc2qXDMmNwdIP42iPVFmzuNS
         jeXY7jp3hxZ4Jig4I87vG6AaAgaonvVBpAcdPAhRyDnSXfWbtAAjwWkc6JTzG1D87RIW
         HfqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D2kQo9hRx9o7bEDD0UK11w3ULUGMCCDibaIvyvg+7C8=;
        b=Bjli85PHDb0TxbgUWXwYTyhL4J1HHKuTR5t7au4naae3KAruuBDAQ4IVAnSXpKSUv9
         ZJjNkyfS212WbGUvXhC6X0RkN08AILFodlc5oKxSlt1ZRyrxO4zi8/RrRx+uJiCRNMDx
         paVYRlCUl8CAEqDex44r6jTPqwswpzj9cmPBTojeDNecEKHOMLy5ughGl04R3THK8pvq
         TBpCczKupOQzV/5HQkoi68YpE/pS7ysdrhaE7untZgXEShXSJh2VNelv2QkF6VRL1MKR
         Yt5QzFzssb4LgevFBKisj/Nw6kuacrukb0+UHvHHW0ZowvI02ecbyUzK1gVVQH/OtRTZ
         Mhmg==
X-Gm-Message-State: APjAAAUwKYjCwviXt7QGuxys2qyr2TSmVWDxBBvNhWDTR8SDaitoVbix
        vDoVuXY7docj9AdOfVXX0+I=
X-Google-Smtp-Source: APXvYqyiBHknj5bBXLtgLP1HN031wgcsPmoymK8mcDjrwG5WmRrFd5Ej4ja+537TpnugybOxinoJWg==
X-Received: by 2002:a7b:c3da:: with SMTP id t26mr9782773wmj.40.1556958488978;
        Sat, 04 May 2019 01:28:08 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.104.204])
        by smtp.gmail.com with ESMTPSA id h16sm8304904wrb.31.2019.05.04.01.28.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 01:28:08 -0700 (PDT)
Subject: Re: [PATCH v2 3/8] kernel-shark: Add logic for the plugins search
 path
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, troyengel@gmail.com,
        Slavomir Kaslev <kaslevs@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
 <20190502124009.32208-4-ykaradzhov@vmware.com>
 <20190503190557.6e36e59a@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <4dbc5d6a-a9fc-218b-d78d-9f3f9d216cbb@gmail.com>
Date:   Sat, 4 May 2019 11:28:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503190557.6e36e59a@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 4.05.19 г. 2:05 ч., Steven Rostedt wrote:
> On Thu,  2 May 2019 15:40:04 +0300
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> If the application has not been started from its installation location
>> and the the directory
>>
>>   app_file_path + "../../kernel-shark/lib"
>>
>> exists, all build-in plugins will be loaded from this directory. In any
>> other case all build-in plugins will be loaded from
>>
>> _INSTALL_PREFIX/lib/kshark/plugins/
>>
>> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>> ---
>>   kernel-shark/src/KsUtils.cpp            | 40 ++++++++++++++++++-------
>>   kernel-shark/src/KsUtils.hpp            |  2 ++
>>   kernel-shark/src/plugins/CMakeLists.txt |  2 +-
>>   3 files changed, 32 insertions(+), 12 deletions(-)
>>
> 
> Hi Yordan,
> 
> After applying this patch, kernelshark's behavior for loading trace.dat
> changed. It no longer looks for the file in the current directory. If I
> run:
> 
>   # trace-cmd record -e sched_switch sleep 1
>   # kernelshark
> 
> It loads without loading the produced trace.dat.
> 
> If I run:
> 
>   # kernelshark trace.dat
> 
> I get an error message stating:
> 
>   "Unable to find file trace.dat"

I see the problem. Have you pushed this patch already? I can send you a 
corrected version of the patch or a separate patch with the fix.

Thanks!
Yordan

> 
> -- Steve
> 
