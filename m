Return-Path: <SRS0=6fae=VP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33578C76191
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jul 2019 13:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C062E20873
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jul 2019 13:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3IpIncz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfGRNvm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 09:51:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46500 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfGRNvm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 09:51:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so28762781wru.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jul 2019 06:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H32Qg9HahWlCv7UrzcBGqwSolDLNKV16DKA9R9z+870=;
        b=A3IpInczVlbPH2iMeXFvRE3GDfJp9BOBnPSB2Bo00bvro60/02whvm3cBzrZ/krvz3
         q/JMf1uUpYTfO+PeVnp6w8W3fR6uHFHSt6OmVD2bsUahecjbg3BgkziNFrXRMRSeM3HL
         01gPtEeewleb7U1KMvqPjbN17dPRzMxIK2AfW9tpeZht9F42FOgMwC6kSUFgdBsFZGjl
         jmRQoX+Q/k1IDQ1bfRfwxnZXm+wK/i4M5h3I2fiBsKzi4iG4rGRwRKeTHlpgBuxZ/b5Q
         e/z6G8H70Ctav9X6KzorAethZUECgeCJTrSpD6yIPwUOim0vvmPkIUwogMlZvyyvAAIZ
         7bKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H32Qg9HahWlCv7UrzcBGqwSolDLNKV16DKA9R9z+870=;
        b=WHAoL7hrcxXUsvdwAcTJaua/o4qVZr8w2zFgS2evfchWyskfYCgElYkwVWMYJxW86y
         83ajLZ0zP1IE2Ngxm1ietT4712q2D5fnudcZxJ6BA91YE5LnhS3XtXOT3RNuk4Qy0EkI
         NZpKQLxLK37jdHs1HQxfbVEPMdhUijmLymgXVcBvxzPR/iTXytG3GLpEkITZQmSlnMm5
         ek8BcqxOe4NshDF6am1/vhe8TXG+sdlJXteW387bJLjYCft9VW3Rc56ypZsD/dmL+vHE
         d7LomCbyeoNkTVRxMXJ1/xQ1Gp1t47hu+iFsumQ4txN4qcCSF1v5BUrhls7TWxrzmVr6
         36TA==
X-Gm-Message-State: APjAAAUOyRZqW8OQm5v2L5ZcEHm7E0PClax6dQFdB3+mHCssMvzkKoJd
        kVKB4bJIUgR9MAMpt+zh2IBnS++TxjM=
X-Google-Smtp-Source: APXvYqzzAMpsLdwCPRS9DZgXOXlox+Wx7LOc6VONNIV94iMQKqBVHs73SxeCGmR8k4bglroYevjIcA==
X-Received: by 2002:a5d:5386:: with SMTP id d6mr51072933wrv.207.1563457900188;
        Thu, 18 Jul 2019 06:51:40 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a64sm27636129wmf.1.2019.07.18.06.51.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 06:51:39 -0700 (PDT)
Subject: Re: [PATCH 3/3] kernel-shark: Don't try to update the markers if no
 data is loaded
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190715132042.5154-1-y.karadz@gmail.com>
 <20190715132042.5154-4-y.karadz@gmail.com>
 <20190717153014.2de929ef@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <8bd7baaf-0bc9-4023-867b-9f2d77562034@gmail.com>
Date:   Thu, 18 Jul 2019 16:51:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717153014.2de929ef@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.07.19 г. 22:30 ч., Steven Rostedt wrote:
> On Mon, 15 Jul 2019 16:20:42 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> This change aims to avoid showing the labels of the time axis (zeros)
>> when no data is loaded.
> 
> What is this actually fixing? I don't see a difference with adding this
> patch and without it.
> 

Before applying the patch, try to open the GUI without a .dat file. Then 
try to change the marker by pressing one of the marker's buttons. This 
will try to update the labels of the time axis. But because no data is 
loaded and nothing is plotted you will see only zeros at the place where 
the time axis is supposed to be plotted.

Thanks!
Yordan


> -- Steve
> 
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>>
