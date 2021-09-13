Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF38C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BD460F6C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhIMMaI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239987AbhIMMaF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:30:05 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA51C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:49 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t6so12684593edi.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qHOJaoSBm0TbPBQGnch9X3UgUEnwrrs0AQUZ1AaLOy0=;
        b=mniz3qn6KtArOtCnYAZ+sbeul6biZ8BGXmYuMSNDwDd36x08zMk9Z9pGcujOLNt1xb
         7c/EV3Kj+0xUEyT3Pz10NS2SCWHogktSj+aKlkPUA9Y5qt0ph/AO/vHJCczId/VxMFC2
         djghZzTgmwLrofVyRp3dqlLeYOipaC8NZJd/53xemB4CRiqaA/GSL0zimaN4q8yLUxEy
         nSg0JS9vp7o3Lp7BtkTJtCW0he2fLQlBbWH1zmi38q56I2thfFi/KF4fJKULEGfWFTRM
         xml00ZP60KeDrq4Nfb1PJrXKX4lQ/CGZzq7wVm09YbE2vrETsb1TUQijGpeQIyiEN75r
         xJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qHOJaoSBm0TbPBQGnch9X3UgUEnwrrs0AQUZ1AaLOy0=;
        b=WbGtMmqbs9IZtnCVoCTg2SdQTSvkXrSCE3BV3ntEwpqV/VGtXzd0O+BN0wtmEil1/e
         2yi0lMO7yrvpF/cEs3hMVAUvsJ2wkU7O6YKzP5NQCjonZ346MFsocK1crVhS5iM6kTxQ
         KtbIZ56DTrh/VcKSAhwtguroG/e3iwHpPLmSAjPY8pSpVEj2iw1fxlAOZDXEiYICibNp
         yv8+sNO9i9H+0s/cj4nrRIOPnRf0slXwb55mHMmUBKzx6mJsuSY6F1vg8HCRXM6Y2v+k
         UmN/q4ujoE0+Noeezw2aJvjtWUnotz4EyvGr5Q9JsJoPaGhjklc9DcOf6tINUJBghFSV
         uRjg==
X-Gm-Message-State: AOAM532ciqi9FEH+qMk+QvuaVUM801pOpySZAoRtv0/SRv5yLRvl1IR8
        xANJnb3xiO6tdfIPNGbav51kt3z0mgg=
X-Google-Smtp-Source: ABdhPJwfq92DCNIlUx9ry5i0pUB4WpsEAv7C5im3y1d692xRsVd2FwX0M5roC2zKCFopNWPvjd0vsg==
X-Received: by 2002:a05:6402:1a53:: with SMTP id bf19mr6720678edb.235.1631536128225;
        Mon, 13 Sep 2021 05:28:48 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.108])
        by smtp.gmail.com with ESMTPSA id f30sm3363294ejl.78.2021.09.13.05.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 05:28:47 -0700 (PDT)
Subject: Re: [RFC PATCH 2/4] libtracefs: Transform tracefs_hist_add_sort_key()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210910163857.324696-1-y.karadz@gmail.com>
 <20210910163857.324696-3-y.karadz@gmail.com>
 <20210910160458.19eb7e0c@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <5e1278ea-592d-f7d8-c4dd-e13e40a9d3bc@gmail.com>
Date:   Mon, 13 Sep 2021 15:28:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910160458.19eb7e0c@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.09.21 г. 23:04, Steven Rostedt wrote:
> On Fri, 10 Sep 2021 19:38:55 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The current version of the API makes it hard to add multiple sort keys
>> to a histogram. The only way to do this is to use the variadic arguments,
>> however in order to do this the caller have to know the number of sort
>> keys at compile time, because the method overwrite all previously added
>> keys. The problem is addressed by splitting tracefs_hist_add_sort_key()
>> into two methods - one that overwrite and one that does not.
> 
> If I'm building a histogram via some interactive method, and have created a
> histogram instance. How do I add a new key before executing it?

Is this comment about adding 'key' or about adding 'sort key'?

Thanks!
Yordan

> 
> -- Steve
> 
