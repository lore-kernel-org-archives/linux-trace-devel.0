Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E362CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 20:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBFB861059
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 20:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhEJUgA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 16:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhEJUgA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 16:36:00 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9551BC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 13:34:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c22so20256136edn.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 13:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4+rAKMg8jp6CzYgMZkSBJy7VhY4ftM22g0oKWWC0sI8=;
        b=HbpAL/OcC/nOizH1zsUTx5g1Q0HcKnqnysOcz6Ng59ZFfIAx69NZFbfF3gjlKWmEbo
         C3+Sh7prXKkozlhLRLx5iyZyf7Lot2CpgK7dEgDTmV5q3aSQaEwejmKuh+r97/XDqxy+
         p+/vb4lTYT5tqo60nQoyXZjFGriU6QG+OytgAt8mDXc4U1QNv+nzqviDkOU6NQdZPKZ3
         rDM6SDV0/lyqhwrdvHhJhhUHNAJW+fBBC5sW1KeaRvoz0XP6mWfSR6DzfoickjtzYI+n
         sEMXIAKK4oeft0dw9ie0gK8u0IbctvAo7QmjMERjitNrktsml25KSkhQd3ddxx5TY1YO
         hq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4+rAKMg8jp6CzYgMZkSBJy7VhY4ftM22g0oKWWC0sI8=;
        b=WV1J4sChe5Sevf/1HgiE0icgduaaVGVhU5VrTJ1hDle+Ne2hsvnpAA7b17JQTrubCW
         AOZZBDnUD3nUoqAmFWFr4TxSR76+D/MB2ii4fbkYBa+aLaLd1Z1eKHQrBKKKPI4aeneT
         xatp9aKDPrGrXrTGqmwFeDYZXx0CDR7CeaCFwl1eHEo1yR2OZHsLwg0fgj0xDf2pwHKN
         kUjKfma/gnasPolKkUeuN2dqbO+GKBUo6G7FKwnuzpgduFDtc7f/WYDsZO3xNHvcnWUq
         gzcfwpKQDZ81mN//HLHdcuMgc8Zg85u5YxLcV/5T4d5hh9x974/fx1ct29fkHooaO6QR
         eVVA==
X-Gm-Message-State: AOAM531qh/rekmMjxg3iwpZw/b1gPuxclHYdEXIoYPl+WTtr0yORAmJN
        YLRwEfpadgFp2cOT2bMxBQA5aV3mk58=
X-Google-Smtp-Source: ABdhPJxTeu6mTd9U/qPXgk+etsJ3+zyiHqm3aWQP6uXZavbUGn+jhmqw6nF8KDn/PolYcgmnJn8nwg==
X-Received: by 2002:a05:6402:1bc9:: with SMTP id ch9mr32260874edb.136.1620678891952;
        Mon, 10 May 2021 13:34:51 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id n11sm10571359ejg.43.2021.05.10.13.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 13:34:51 -0700 (PDT)
Subject: Re: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210428134730.187533-1-y.karadz@gmail.com>
 <20210428134730.187533-4-y.karadz@gmail.com>
 <20210506141151.2f31f263@gandalf.local.home>
 <6c352db2-1f2a-4442-1832-1810d4d6a1a2@gmail.com>
 <20210510142537.2628c47b@gandalf.local.home>
 <cc7b594f-194e-9d2e-81e2-49f60f6c6eab@gmail.com>
 <20210510152349.3de97b82@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <96e06290-f5e8-34ac-1b3e-db8559bffd1f@gmail.com>
Date:   Mon, 10 May 2021 23:34:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510152349.3de97b82@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.05.21 г. 22:23, Steven Rostedt wrote:
> Obviously, I'm missing something to connect the
> dots.

And I have to admit that the commit message is misleading.

Thanks a lot!
Yordan
