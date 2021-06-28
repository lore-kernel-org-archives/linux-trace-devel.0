Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70017C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 13:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E7D061A1D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 13:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhF1NYS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 09:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhF1NYS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 09:24:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5DDC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Jun 2021 06:21:52 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id q14so25886518eds.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Jun 2021 06:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UNSgfZHroNnv9+dniKr2LkHA4a08NBFkjcsIRNl58WY=;
        b=UWb4VWIU8dov51N8SVXGddBIw6t+7mF4erSv6eqF79k77VJxk0+AgyPiFF1xOaFCMG
         V8kZJSjjYjIeD+zhPXIg3G/z1R7UOwIVYtsJuZGYTH1otPOhq7pPyNg8JJuH2aCl+XbB
         1wu8bfzuF6OH4GTCI2OxxOlxyKZ3Qbtsi4Arjt+jTARnxsbQQ31XwFF9KeIk890lHToO
         c4bPiodpNPSSQZRviRFmi8d5OUxaI0GgRG9Q9NVe0ZppdcBiW9xIKa4HGF8QZkGIL4Q/
         RVkrYHCfKCcoVXyGNqq+ioCUMJT2qjuXl1aV0lic3KUXGBs7tlhN6RtOYDFRWZ3NV3oY
         ZXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UNSgfZHroNnv9+dniKr2LkHA4a08NBFkjcsIRNl58WY=;
        b=D7eDs4xqEdQYGAjNMjbOLqlZrNzPKEHEBXhyADLvb9hh5xMDVV7DPxxIuW3Hi+LxBS
         lZuuh4Bkf+EwvRsPkf5+enG106ISnbQ6WjJM94gaWT0XzJsI2eeV9ysG5m1zC9zhaS3v
         waNwU3A0wED1T81U3O+CDYXl+KmPoKMZf0hwWkTTDSyU9OhlcXgyU6BTvzH/bBOttkWr
         vqK3zEwsI4rKVTmha6QwcYOWfoVHtI67iGT49giQ7KhGpnOjINHRlAhK7sGJwRSWrpuG
         N391TBsViqMQZHo4ANC+Kj27SViSs1NeA1645sJlVQfwfDeiNlBIKqwo8RAL8Hx2ZJbt
         +FYQ==
X-Gm-Message-State: AOAM533k+6sX8oEvGBQ6UoxL5tJFs+KzbYXE2Nf37Jk7UEx5bUa9XtVy
        FI3+BFx8NSRxBtAzuUd//5Mt76OFSko=
X-Google-Smtp-Source: ABdhPJz6wbmaXOna2X9wkvi1wrLp+X/uFI0GLrrwOCJg4HtNpp/oc2gN2fJ8fpHrPCqmAoJy+0Xmfg==
X-Received: by 2002:a05:6402:27ce:: with SMTP id c14mr14380999ede.333.1624886510901;
        Mon, 28 Jun 2021 06:21:50 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id w17sm6924481ejk.112.2021.06.28.06.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 06:21:50 -0700 (PDT)
Subject: Re: [PATCH v5] libtracefs: Add APIs for data streaming
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20210625142737.6c028a93@oasis.local.home>
 <e2032e1f-8b4b-2e7c-9d36-aa1bb3eb31ba@gmail.com>
 <20210628091350.1d03dbb0@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <55507393-e8b9-5feb-8702-31e550968c0c@gmail.com>
Date:   Mon, 28 Jun 2021 16:21:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628091350.1d03dbb0@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 28.06.21 г. 16:13, Steven Rostedt wrote:

> Are you OK with that?

Yes, with the minor corrections I sent, everything seems to work fine on my side.

Please push upstream, so that I can send the trace-cruncher patches.

Thanks!
Yordan
