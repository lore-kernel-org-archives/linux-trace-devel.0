Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5312C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 11:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634C122B40
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 11:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAFLVL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 06:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbhAFLVK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 06:21:10 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B905FC061357
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Jan 2021 03:20:29 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id lt17so4584862ejb.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Jan 2021 03:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YY+Fl445ajb5DTJZAutFxQSTykJMupT/Txbzo0dagi8=;
        b=rtmUjZWVz09oVBUPhZHQJnsbw+kar6nT52um+10bm223uJHLXUPN3JAlhqafhYdhvj
         0rUuOffPAOu/9mK7z9vGtYh/iIcI3X5kaVuRPvw8KMCK1o3du62eWjhVD/gxa6S2bv8c
         7ECxrRa/7a8CdCov4lLxHBKHrqsixpEnFK45DC1dzR3qwFLi3yjRFVICLLuqlypq+Dy9
         RL64Qq1xaIhKJaHAuijRzhLIA0nrlrAYSF+gnnyCpmOwETSrEVF320HE5tqoDK8sYSv0
         ZqTYqyA9ueApQJsuS3IAaW6uRJwVIv4jEA7yXiY/+3+BXjfjtqqAQU02XkFCK/RXPswe
         9V0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YY+Fl445ajb5DTJZAutFxQSTykJMupT/Txbzo0dagi8=;
        b=HfE1lRE/gjkHDXws8tTltTH2ykxZaVNQEIZi4Ce/b1T9NlzzNPqRPyFKke9kN1dgVK
         mMjrgepe0ftP4vmDQr1N3/lhQMp/EbppNXkQGK+zsBgHUhAFcn9Y8Kc56Vqmw/M0/LXn
         PAcSCHTiH8vbp5g5MqnvP/HkGeN3+vd3B4cRg7uSENqOTF8IR6SaM3z3JbvbUwTLZxyK
         byYVyPTIdJ8jinntn3+ouHUKvmGlk9flKewmEmTZ1Ew/eKsbYC3jJwoK1aEL9ST/ANxC
         9HIqx/HqXd9XEx3Gmgctf0pykRQsxb9tia9mkYQpxqQUZE7LaT7EGOsiMxhj2olF3uCt
         a5rw==
X-Gm-Message-State: AOAM531SSVL9/rxy30vrGJDQEHWwF6geUSSvw3rzSqvNyF25Zk+IMWP7
        KLx0EXFNRqX2H3uaFMnqJJDB9+cE43e1pw==
X-Google-Smtp-Source: ABdhPJxbUurdBveZ2w1BnwoYRP2L0LYb5XcVXJoCZ7t/dZeRSnZtKN1Y7+8u1ivlvnv3TaXE6tgYLQ==
X-Received: by 2002:a17:906:1302:: with SMTP id w2mr2668010ejb.413.1609932028326;
        Wed, 06 Jan 2021 03:20:28 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id n16sm1319342edq.62.2021.01.06.03.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 03:20:27 -0800 (PST)
Subject: Re: [PATCH 4/5] kernel-shark: Split the installation in two
 components
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210105155453.41228-1-y.karadz@gmail.com>
 <20210105155453.41228-5-y.karadz@gmail.com>
 <20210105162931.06db93c1@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <7ba6ef27-b80c-ce27-8051-235b74d47502@gmail.com>
Date:   Wed, 6 Jan 2021 13:20:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210105162931.06db93c1@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On 5.01.21 г. 23:29 ч., Steven Rostedt wrote:
> On Tue,  5 Jan 2021 17:54:52 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The user can choose to install only the KernelShark GUI via
>> "install_gui.sh". It is also possible to install the library headers
>> and this can be done via "install_libkshark-devel.sh".
>>
>> The changes implemented in this patch are inspired by the talk
>> "Deep CMake For Library Authors" presented at CppCon 2019 by Craig Scott.
>> https://crascit.com/2019/10/16/cppcon-2019-deep-cmake-for-library-authors/
>>
> 
> I applied the series. But is there a way to install in a specific directory
> and not in the system directories? (I didn't watch the talk).
> 
> For example, I can do:
> 
>   $ mkdir /tmp/install
>   $ make DESTDIR=/tmp/install/ install
> 
> for libtraceveent, libtracefs and trace-cmd / libtracecmd and it will
> install into /tmp/install/... just like it would have installed in /. The
> big difference is, I don't need to be root to run that command.
> 

Yes, we have a similar functionality since the very beginning of KS 1.0 
and it is not been changed here. You can specify the install destination 
using a cmake command line argument like this:

cmake -D_INSTALL_PREFIX=/tmp/install/ ..

All this is documented in the README file. The only difference is that 
in your case you provide the destination at the very end when you do 
"make install", while here it has to be done at the very beginning when 
you call cmake.

Note that the two new helper scripts (install_gui.sh and 
install_libkshark-devel.sh) can be used instead of "sudo make install" 
but this is needed only if you want to split the installation. A normal 
"make install" will just install everything.

However, you are right that it is probably better if we remove the sudo 
from the two helper scripts.

Thanks!
Yordan


> Then what I can do is:
> 
>   $ cd /tmp/install
>   $ tar -cvjf ../package.tar.bz2 .
>   $ scp ../package.tar.bz2 root@somebox:/tmp
>   $ ssh root@somebox
>   # cd /
>   # tar -xvjf /tmp/package.tar.bz2
> 
> And that would have installed the package on to the machine "somebox".
> 
> -- Steve
> 
