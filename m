Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1830DC4361B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 15:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEC7922B45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 15:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391232AbgLJOjj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 09:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391225AbgLJOjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:36 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A9BC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 06:38:56 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id l9so5697823wrt.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 06:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5dGRDZBJq98zKblOAc7rnvVk2CNRq+/7cBgw0Psk3Sk=;
        b=BlRi+J2Ynz1e85Plisu1k1OkspmF/DqzZ/E+QFrXC0m5gZo+mG6khEJTC06KS7X06z
         4GuKmHY2p/ZVA75nZDIbzI5+zMAJWOW8ojjG/uIHYFjMFVNFMKs23rrHfO9F1Nt8Tiso
         N+AAkBbBys4EZhj2dflIEv7oTtiKBcE0iQUbZNOGUcx6uLTwjF1JTATGZVwl711NUxn6
         3+AG2vmbFSYGXY0E9CgynwiUIIOqxUd9kPpBmbL6hsorIQ2PSgzRfHFFlUctBOOdwdgo
         YM6SVwbtcb7cGuDNl6WdU8Z1y5VLVdSPyYuDxJG5qE2oG2beHlmR1rJ8ER5LfXhdAoYG
         YkTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5dGRDZBJq98zKblOAc7rnvVk2CNRq+/7cBgw0Psk3Sk=;
        b=CYG8uHvKl5Lum/Ed2X8dA7IpMiYDfZSeSyQilBerx0r2KO61ojUy6IS7C0aHo8CSfe
         O72MC6j2JjooA0oEgTu5trDB6VlY2FITk6fFboe9FBr5aJb8qew9k55+9QnBpDyNaJfs
         mb66F4QdByFXSb/2//hQwRIFz30ncmg6e32koFgD/RDNgerALxCLNtLbMr4pBiQIao6b
         lSHUou03RxbyypyzqgfepP5a+DhMmgtzxDsTSuviZHyGHz0yVDJYpTMfv2gn+Mr7F01G
         fsNrnZg+wWEijDLWIqgi1GfOOZ/ZwGqYkPQ2x9tN+pjgKQa5x5CFxSSW2OKghi5H/bum
         zdYA==
X-Gm-Message-State: AOAM532XPdh0UQ7dDI77Gvab0vYMgEkLpLRtIrPg+rWKJfCOW8kVxNqc
        CPJIY+QqNkPFaNgv8u02IWb4N1XNjRk=
X-Google-Smtp-Source: ABdhPJxk8gYShVZ5YvmppK7wFVC83g5ZzsJeEI9P61rPgfbto4uatnSJHITEVVgzS6DcyOw4s3dtoQ==
X-Received: by 2002:a5d:6106:: with SMTP id v6mr8066045wrt.173.1607611135003;
        Thu, 10 Dec 2020 06:38:55 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id j7sm9051463wmb.40.2020.12.10.06.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 06:38:54 -0800 (PST)
Subject: Re: [PATCH v6 00/27] Start KernelShark v2 transformation
To:     David Runge <dave@sleepmap.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201209134203.428068-1-y.karadz@gmail.com>
 <20201209213822.74c90f15@oasis.local.home> <X9Hgwhhc5hbhLsFV@hmbx>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <da215051-467a-1378-2989-9b24f4b21a9b@gmail.com>
Date:   Thu, 10 Dec 2020 16:38:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X9Hgwhhc5hbhLsFV@hmbx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi David,

On 10.12.20 г. 10:48 ч., David Runge wrote:
> On 2020-12-09 21:38:22 (-0500), Steven Rostedt wrote:
>> On Wed,  9 Dec 2020 15:41:36 +0200
>> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>> I just realized that the current repo doesn't build against the latest
>> libtracefs, because the library's location has moved.  I noticed that
>> the CMake files have it hard coded with:
>>
>>   find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
>>   find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
>>
>> Is there a way to make cmake use pkg-config?
>>
>> 	pkg-config --cflags --libs libtracefs
>>
>> Will give us the correct includes and libraries for building against
>> libtracefs if installed.
>>
>> We'll want the same for libtraceevent and libtracecmd as well.
> 
> find_package() [1] is usually used for package discovery in cmake-land.
> If the NAMES argument is provided it overrides any provided package
> name.
> In more complex cases (of the package) it is better to have the
> package ship with a find_<PACKAGE>.cmake file that will be automatically
> used by cmake if it is installed in the system locations.

I agree. This is indeed the proper way to get CMake find the libtracefs 
automatically. And we should do the same for libtraceevent.

> 
> To use pkg-config/pkgconf directly, it is possible to make use of
> the FindPkgConfig [2] module.
> 
> Best,
> David
> 
> P.S.: Out of context: Why is the cmake minimum requirement so low? To
> make use of useful features in cmake it needs to be at least 3.4, better
> higher even.
> 

This is legacy and it has to be updated. Absolutely.

Thanks a lot!
Yordan

> [1] https://cmake.org/cmake/help/latest/command/find_package.html#command:find_package
> [2] https://cmake.org/cmake/help/latest/module/FindPkgConfig.html
> 
