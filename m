Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33675C11F65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 19:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DBD61477
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 19:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhF3Tk4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 15:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhF3Tkz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 15:40:55 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD9AC061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 12:38:26 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id hc16so6127667ejc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 12:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gaIhuc3UJnG7ZS4PA2ue5umdkuTlCueAFsSXzdxQfxE=;
        b=KXQ5Yp3e4Tpz1zEfzjnZ6g1YjaEUt/x0E1zHwD9dotEDfqgIZnW30iT5bMQ+nTkQdN
         QoS8ACEAchTa/JBFSfWSrXEnN0IRTKqVZkiBvqEuEG2guKC5IrYAVVbPHIjKXSSI/Cit
         BYFYwyqN7b3KfxVpryUifnu3M1gTOUiWOfx2eWR5Tf1bOFEo4OMmVWkd8WXrOjQdQ+kU
         66XVGNE/u8bGPsexWfZx6XuLR+OMySFalRwf6Tw3ryiuXb2HVCQ/nfPr8y2MgU6/z7Ye
         EhKA0QbP54Y45N44fF2PAtQTMAp6IxiAnZFGrkMrSIWcoYT+0GNynda6eMjugjIDiTmf
         JW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gaIhuc3UJnG7ZS4PA2ue5umdkuTlCueAFsSXzdxQfxE=;
        b=IR4ErY8ec4Y3htTHF+kCkgz+AlYWpy8idIgoxrCOIQ/Clo6/dzDfhzNwjPca7C/cnt
         xm9NeD0BuA6TdrtC3zJs7UZqPBv5xnNmzUn10x/z0VTYyvZl+4j8Eq54e6ew7Svfkli8
         HHVAfr2Ilo9OlHORvVkTXaMx1HakrR/mnvoMw+vUN3YbhWoqLVwNncoBTUO232ziq7eI
         KFc8097tg36yvIe4eUqIln9npV4dTK2L5Hk7LwH9pmvjACRdOWCizYW4RIZL+hgomN7t
         SHoO4VNfaVUR+/cimSR1UJjeblKhC17xZqqpWzPmkIybgktrRbpRL3XsYBYESAudCUHz
         PQ/w==
X-Gm-Message-State: AOAM532mHZ2anRg+kZt0E5lISBKOIEumv8kmaQlxS9Rbc4F5sjxGVmvb
        Je97bgyaHV1hr6Be5NBfBkDZiId3LTQ=
X-Google-Smtp-Source: ABdhPJz3qKP/JmghRVq/MF4FZPvFGKLeyfNNfWOA10VY83KEx4XDdLAfa1NnBaSq1GfjKzFx44aoAg==
X-Received: by 2002:a17:907:c87:: with SMTP id gi7mr36697219ejc.452.1625081904990;
        Wed, 30 Jun 2021 12:38:24 -0700 (PDT)
Received: from [192.168.0.109] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id zd21sm2910415ejb.50.2021.06.30.12.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 12:38:24 -0700 (PDT)
Subject: Re: [PATCH] libtraceevent: Fix bug in tep_print_event()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210630141913.20675-1-y.karadz@gmail.com>
 <20210630110635.57411548@oasis.local.home>
 <5af941a3-5760-3a3e-188a-6a6921d079d4@gmail.com>
 <20210630145059.32798730@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d78a0336-46ba-758d-ea8c-c24d25afcf18@gmail.com>
Date:   Wed, 30 Jun 2021 22:38:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630145059.32798730@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 30.06.21 г. 21:50, Steven Rostedt wrote:
>> Should I send v2?
>>
> Yeah, if it's not too much of a hassle.

Done.

Thanks!
Y.

