Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE05C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE32B2075D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxW8A99n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbfCZNfe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:35:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41233 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731640AbfCZNfd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 09:35:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id r4so6688571wrq.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Mar 2019 06:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a8hzd0KAHYxuxg0033oYiiIPT8+HTk8BOWNbXXMYjxE=;
        b=ZxW8A99nCmZnkQEglx03aWTloev7qZZh0lsghm34Xzr/UxvTY7+mcJ5BGJYM3WfC6N
         XsEM2W5f5HeDZpsY2E6LJgJOZMtqPdCwcNSbyYT5E0fakBuQ8RKwavV6lZvKMbsWjZQu
         w6xtU3zN7MyMhh6Xwby3UREn3jBCJ2HwIg1GT1n/6OyWaJMFG+ISf7K7xAqeLDI5vIeT
         XO+W4ic8/u9Cz0sCTUHXxUq/923UAN25IJv3SVpJE4hnvIQDenwaHlszcEJfqbK/VuR5
         QobUOPl/R/XhEe+mvOLDHEePIKYXjZDob/Z57aVNaSnPSkL/dy+amqOdtsRB795DjRsa
         HYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a8hzd0KAHYxuxg0033oYiiIPT8+HTk8BOWNbXXMYjxE=;
        b=plAr2ezt6IuQbGSZNe+U5XIUphmg2FH2qIMzL3qqm3ixOl8edvYiy/v6vXWmf0fM/p
         OR8iWC5tv0CqzNEgOcm/dx/JW5jmXbC+8ZUBpaWQsnLBf1racoIN5JTOP47rJvwODGDk
         vIDCCKs1ngJbqhziHX9qc7xAJdi8Og9rC+uXsDdfmrzsJtY8P46QVDCRubRgM+VxvC2w
         u7iGMVs3RD8ZlFkLZCGOEcfdq6jydA2tW8s5WlXQrp1asQRJcBOicqvcrtq2ocjkXq8m
         2BFUf2V3qUsneKmlIFiH2ipt/qPMtnMDG6adzKPhoyuOXl25gg/k7nbRYBZcES0f4TsJ
         1Ldw==
X-Gm-Message-State: APjAAAUCbdrfPalf8JW6jT4gsvQpaOTtGnNOQNN7ttEGgxf5ywJaEZxs
        BHHnilR8Yr42y9PIyHOVE/w=
X-Google-Smtp-Source: APXvYqxGLT6SSonbFLWxdsbt4mncXo/zRd1yQ4oK2pKrylffUaIL+7q62S2d5hCWpsRO2rT9VKYlmg==
X-Received: by 2002:adf:ea0b:: with SMTP id q11mr13232201wrm.233.1553607331666;
        Tue, 26 Mar 2019 06:35:31 -0700 (PDT)
Received: from [10.27.112.183] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z84sm2847456wmg.24.2019.03.26.06.35.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 06:35:31 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] kernel-shark: Reorder the priority when searching
 for trace-cmd libs
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Patrick McLean <chutzpah@gentoo.org>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
 <20190313152220.22026-2-ykaradzhov@vmware.com>
 <20190326085821.394b6de0@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <c65445d3-6a7a-d414-30d1-cf5a19151cb1@gmail.com>
Date:   Tue, 26 Mar 2019 15:35:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190326085821.394b6de0@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 26.03.19 г. 14:58 ч., Steven Rostedt wrote:
> On Wed, 13 Mar 2019 17:22:18 +0200
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> The CMAKE build system of KernelShark performs automated search for the
>> trace-cmd libraries, headers and executable before building the GUI.
>> The new order of the list of directories to search in is the following:
>>
>> 1. ${TRACE_CMD}/  ($TRACE_CMD is an environment variable)
>>
>> 2. CMAKE_SOURCE_DIR/../
>>
>> 3. Platform / system specific locations
> 
> I'm still confused. We shouldn't be looking for any paths at build time.
> This should be done at run time.
> 
> Now, we can check the local directory that kernelshark lives in. That
> is, if we are running from a fresh build, at start up, we can look at
> 
>   `pwd`/../lib | `pwd`/../../plugins
> 
> and see if those directories exist at run time. And if they do, we can
> use them (as we would assume that the exec is running from a local
> source tree).
> 
> I really don't want any build artifacts in the executable. This will
> mean that you need to do special arrangements to build kernelshark and
> then move it to another machine.

I am confused. I do not know how we can make possible to build 
kernelshark on one machine and then move it to another machine and 
guarantee that it will work. Note that trace-cmd is not the only 
external dependency. We depend on OpenGL, Qt, ....

Qt itself depends on big number of things.

Is this really doable?
Y.

> 
> -- Steve
> 
>>
>> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>>
