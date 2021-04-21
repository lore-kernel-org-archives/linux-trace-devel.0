Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC58C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 09:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4444B613E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 09:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbhDUJOk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 05:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbhDUJOj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 05:14:39 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31805C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 02:14:05 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id e7so48373821edu.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 02:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5mev+IBpIaEVs6n02EKYcqIB8VXxMgCDUIjgrMZMhB8=;
        b=YhQaQ9+efddF8WkRH0/oAO4EUhNUGQKB42D+qoyKl7uA2At+LdLW2h3yfBZGZMCS2p
         oWGOM7NiMsU64ntzn3rSxFJ3NIV3VVtWbnwYLFstY5ECDyapm9v6uLiXb4BcsDNQYzl3
         9TjnM61hs51omeeTJSRANyaMSca5mTXAYZRQMtEbMErVLKy4v5RpFyCYc/TbkyTWxywb
         mzignUREPX6ThWFruhOrWjJR2mOwqCbarz9YkCz1bV82N5kLEKKJg5XPqNRcKqZgecJJ
         RD1LwnRh0LatrmE1nKu2jGHdv0LzRINf73SJ/lbKXRfHc52KxEnuNncNimJrusNyy/fb
         zIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5mev+IBpIaEVs6n02EKYcqIB8VXxMgCDUIjgrMZMhB8=;
        b=LO+cxkopBBeMLYYhXdu7liaudbwfmZmy+5OCW8kvfFsmDpQWKtYnll0sVjHH5l8Q2S
         h+9+qf5v5y2EtHcaarICiDJ0oboa/0JXT+xUg837Qu25reXMLudL+HKMBUe7pZ0PG+bY
         NMsY2Gupbuig6qP5Aeb6OV7SXgg8HT0TAzK1CelmpXnlLR3bnjg0ZX3zThTG4H8u3P4O
         QayrMG7fKekdpv/Y3uwG9dgjE0o8PRHD7Qfu5zrayyFP5KQPF8Ip/chkHUNyrPG35ZSH
         daPnh8dUcSJ8ZsAUPW0mPhjS49Ypjrzns9OScWFkYSEQYJnnqfS8I8fkrDW5+3NCwl30
         aNjw==
X-Gm-Message-State: AOAM53080ak1fqtI1hmotPoa6Y76L7fpm43Y/ToToFf5lcCH5Ov54ICA
        Jd766pZu41R/mjp+Pyyr74OyuLVD4UQ=
X-Google-Smtp-Source: ABdhPJy2Lig+MoL/HU1Y8wWrX+quNKJQfjetuq+j0xC2CLM47xuSqn8yor8qmxRoO42tHYKPiq++XA==
X-Received: by 2002:a05:6402:1588:: with SMTP id c8mr36636021edv.37.1618996443897;
        Wed, 21 Apr 2021 02:14:03 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id t14sm1692180ejc.121.2021.04.21.02.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 02:14:03 -0700 (PDT)
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        linux-trace-devel@vger.kernel.org, dfaggioli@suse.com
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
 <7edad92d-3297-fd42-9ac2-0334816fb524@gmail.com>
 <20210420221746.1899d496@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <67831491-54f3-a913-f787-f6a630f5b56b@gmail.com>
Date:   Wed, 21 Apr 2021 12:14:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210420221746.1899d496@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 21.04.21 г. 5:17, Steven Rostedt wrote:
> On Tue, 20 Apr 2021 11:12:59 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
>
>
>>> diff --git a/examples/checker.c b/examples/checker.c
>>> new file mode 100644
>>> index 0000000..0b04343
>>> --- /dev/null
>>> +++ b/examples/checker.c
>>> @@ -0,0 +1,202 @@
>> The first problem is that this patch fails to apply. My guess is that
>> you hand-edited the patch and removed some lines starting with "+". Note
>> that the total number of additions and removals in the file is indicated
>> in the line above. If this number does not match the number of lines
>> starting with "+", the patch will fail to apply.
>>
>> As a general advise - try to avoid hand-editing patches unless you are
>> certain you know what you are doing.
> Or hand edit the patches using emacs ;-)
>
> That's because emacs has a "patch mode" that updates those numbers when
> you modify the patch!

Cool! I didn't know that.

Y.



> -- Steve
