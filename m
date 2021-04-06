Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128D9C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 08:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3C11613C0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 08:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhDFISY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 04:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbhDFISY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 04:18:24 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC4DC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 01:18:15 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e7so15423439edu.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Apr 2021 01:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=XFpT/G2CqKVTMBwlSAgmeiqJcOyNQCM2ec0xYtEfF4A=;
        b=G7yEdg1ji/9c8bVvttqdX/UcsrnJCiDBr+bQgNogJmcakjo3TJEoWU6v3T6fVYQpx9
         Lp+IO4NuPuLPuATTbg97N2508kHstYe52Ulmf0kdIIkWZ9UXwmo+GggsmaTFkV1z8qga
         vKxwq/uJbQQeYMdIet7+hT2xhdnDnQ1k9+Npoz8bM+fECJK/J6fwMPIeLqjcDIvBtQlH
         5ECEGRVpeLoq1Hcwarr3gWbdDY7vzD/Sq4p9kVCxO8Znl3NoIstsw2ae7ByjyzIrSgvv
         diM9ocFCBY2KI7GDLDNhJwbDeT3mwd2ZJJHhVHjzr7tAbCxIZmUgdCO7yhL6yRZgpV/X
         Kn8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XFpT/G2CqKVTMBwlSAgmeiqJcOyNQCM2ec0xYtEfF4A=;
        b=ro7cpx81fHWbMY+lb/7onNoS229dEoEQRmxpx6OZn1Q0xph/wQ4IHvG38bliVx9eQ4
         HsJvi0+gNJQfdj20/wKcWadd39CFbSlxXimB5uCs3/ZaS5bnW6khzbRKusJJWhgI6E9j
         KSpSBDOww6k74HMMRqE/W53wewXVYzZtvGaCJM2AEgdwkmkLOrhaCcLGYaI5e46whumD
         Igf9DjHY0ZeerpU1VzgOSyiWFr99d6kJKQTYoO2UPYWGIEvxqcaspfa/tUE/dF2hoRnX
         FDZVCgaqFDLv7BguQULlLsf56PL9OCWrbUtk7ucDJRNtD3oKrVhohyJqvBNrjUwOSpB5
         8LqA==
X-Gm-Message-State: AOAM531Ns9uQpcuJ0icVUa0v3v7waH8tXGvFcqzsTfOOAywobNEjsLEC
        nEoml88VUoSqaP+MWjGJJpE=
X-Google-Smtp-Source: ABdhPJzc7oK5V6XL6TA/e4ku2OEtHLXOFk2ZhLeoXwio4QX7ka4vWzlkvsTPwW7IDVYMxoQaHQyoRg==
X-Received: by 2002:aa7:c451:: with SMTP id n17mr12963363edr.197.1617697093925;
        Tue, 06 Apr 2021 01:18:13 -0700 (PDT)
Received: from [192.168.0.106] ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id y24sm13460812eds.23.2021.04.06.01.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 01:18:13 -0700 (PDT)
Subject: Re: [PATCH] trace-cmd: Add CODING_STYLE and CONTRIBUTE documents
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
References: <20210405151959.1d6901b2@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <7ef527d0-b17e-6292-d8f5-dc730a1751aa@gmail.com>
Date:   Tue, 6 Apr 2021 11:18:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210405151959.1d6901b2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On 5.04.21 г. 22:19, Steven Rostedt wrote:
> Unless variables are tightly related, it is expected that each variable be on
> +its own line and not grouped by type. That is,
> +
> +		int r, cpus = 0;
> +
> +is to be discouraged, as the two variables are not related to each other.
> +But if you had a bunch of counters:
> +
> +		int i, j, k;
> +
> +That would be fine, as the variables are all related as they are all for the
> +same purpose (arbitrary counters). The same may go with pointers;
> +
> +
> +	char *begin, *end;
> +

Maybe we should include an explanation what to do in cases like this:

         struct instance_wrapper *iw, **iw_ptr;


Let's say, the two are closely related in the code of the function, 
however technically speaking the types are different. Is it OK to have 
both on the same line?

Thanks!

Yordan


