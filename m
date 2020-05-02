Return-Path: <SRS0=xxv2=6Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A53FC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 May 2020 18:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F97206CD
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 May 2020 18:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QxzdFmLJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgEBSsN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 2 May 2020 14:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726306AbgEBSsM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 2 May 2020 14:48:12 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD2CC061A0C
        for <linux-trace-devel@vger.kernel.org>; Sat,  2 May 2020 11:48:11 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b20so6055372lff.2
        for <linux-trace-devel@vger.kernel.org>; Sat, 02 May 2020 11:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=2LWzZQWVMjFyhihctyuvajhjvbxToxVg+F1SfQKj8rI=;
        b=QxzdFmLJNKRGtd62K0d2a2HQUwIgsB/qpGF4JPzm9bnpSgtrQyHIU/xJ+OFFV7SOq/
         /3Bglhs0fT7U42ZFkNtyk4KGSksG5GEyhaqBTDvqYyhB8hZOfsbm/t6OWJjD1Ba381ol
         f7WM0jftP7mSU9RqQ+89Kxm+DegjVK+BsZZC6YbwFFCXn9vIuk4cmz/mP/1C4WyC+UJ/
         UxzKc6mlacGe/xMjrYOv9sPcEzWWmWiFnp1iYSd+rENXL49EUFwQa+3Fcdtrz8SEJIL1
         vxemU42P7mlGjExxIQqCzNUXFgd/alXiMprg7FO83HcBMIm+r4jFGBYD0FGAyiTDx/KG
         EyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2LWzZQWVMjFyhihctyuvajhjvbxToxVg+F1SfQKj8rI=;
        b=LwpdU2nKn6Upx/IQ70TLlg92yPE5Txghg6NqQkrO9rgSQmJujWxAbUhLczNFx/QCan
         pKDTzwEnwu2YUBRlKn6cWrIyL+nbT50kL6tepF2DONEk0Vcs5MaFcBbgz8lo4O1sNjvp
         9E1E5a5XJhSf/iOtdb7ChtC6ek2dnQHSJOw28fGsxtjAu2t7HV7bbWLQJMTdbOm6xbcn
         wW6FJdEw91mZKptSpl60U7mavReF3MWTJHjbuNyrsMesyuxsIsMY1cbKHbwdSJlGUOKS
         jurWA8U6PjRrOK/MWUI/tX/V6Ls85XPj8EYMbnfh3qEs3en/dKiiOVwstGGWcH8zKX8q
         AQ/Q==
X-Gm-Message-State: AGi0PuY9d6o6+Oe7rAXxlZP0sEmY9KsXGwHkINCkjaZrgUvVRSdDF3AB
        FhlAxXqznFA0BRnGcYFeHcFn91m5Pvk=
X-Google-Smtp-Source: APiQypLm1sQJYyTqeztVtX0rZRdJGGPdma/VhhOnnz3VZTk8TUAPI9cGMwTxiLRxUZjJIUEKvmhJ9Q==
X-Received: by 2002:a19:6a18:: with SMTP id u24mr6390485lfu.191.1588445290249;
        Sat, 02 May 2020 11:48:10 -0700 (PDT)
Received: from [192.168.0.104] ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id r1sm4316163ljg.50.2020.05.02.11.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 11:48:09 -0700 (PDT)
From:   Yordan Karadzhov <y.karadz@gmail.com>
X-Google-Original-From: Yordan Karadzhov <y.karadz@Gmail.com>
Subject: Re: [PATCH 2/3] kernel-shark: Change the mechanism of the
 multi-threaded search
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20200330161723.29816-1-y.karadz@gmail.com>
 <20200330161723.29816-3-y.karadz@gmail.com>
 <20200424161246.4d9f22b8@gandalf.local.home>
 <69e2a749-8582-35dc-0a6d-5d08988d4a5c@gmail.com>
 <20200427151802.7a3a9be3@gandalf.local.home>
 <20200430225637.1b05d3ed@gandalf.local.home>
 <20200501210342.029e8358@oasis.local.home>
Message-ID: <b6ec14e0-8d06-bd5f-43ad-4954096546ec@Gmail.com>
Date:   Sat, 2 May 2020 21:48:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501210342.029e8358@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2.05.20 г. 4:03 ч., Steven Rostedt wrote:
> On Thu, 30 Apr 2020 22:56:37 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> On Mon, 27 Apr 2020 15:18:02 -0400
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>>> I would say we can apply both. What do you think?
>>> I'll try it out and let you know.
>> Want to resend this patch with this change?
>>
> BTW, I had to test this on my laptop (which doesn't have 24 logical
> CPUs), but was able to reproduce it with the following patch. Perhaps
> we should try various numbers to make sure it works for other strange
> combinations.
>
> -- Steve
>
> diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
> index 12371ad7..6e2b5fc6 100644
> --- a/kernel-shark/src/KsTraceViewer.cpp
> +++ b/kernel-shark/src/KsTraceViewer.cpp
> @@ -676,7 +676,7 @@ void KsTraceViewer::_setSearchIterator(int row)
>   
>   void KsTraceViewer::_searchItemsMT()
>   {
> -	int nThreads = std::thread::hardware_concurrency();
> +	int nThreads = 24; //std::thread::hardware_concurrency();
Yes, I did the same.
Y.


>   	int startFrom, nRows(_proxyModel.rowCount({}));
>   	std::vector<QPair<int, int>> ranges(nThreads);
>   	std::vector<std::future<QList<int>>> maps;

