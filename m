Return-Path: <SRS0=qwEJ=6G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D63C54FCB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Apr 2020 13:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E8EA20787
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Apr 2020 13:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V2OXxAXN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgDVNlB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Apr 2020 09:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgDVNlB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Apr 2020 09:41:01 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0ECC03C1A9
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Apr 2020 06:41:00 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e25so2317803ljg.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Apr 2020 06:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gUweMe25ZY+FWOwu1j0KzvL1X48NI8hG/yEl03mHbWo=;
        b=V2OXxAXNCbnxxapbnTbz6AcH2voPwPqTFHQ1CZaduHcTi0xITSukOI0v/xQMy7QdnS
         mJaFiZUjXkFtQBvJwf0GyUswr9Hr33zqSAFSSVqmR4WjVYOBOMjtV95nC5SGuO5fWLQ0
         SUuPqYoFrP9U456CDH47Ss+TOQniI/wu32h+b7OxmX3eGDbEp9XkPbmuzWvaXf5vp6Rx
         Rj2vmm3alzTF4fr7TYBSuMPg2sivW6EkpMRiYLZGAuDzl3LgRCx8Hv3SfxcT0hv87ja/
         n8SzYI7FE+dQdHQZKdHO+gRH1Ie6fMK7H6ZFi7RSOX0gInp5Pdo+vOXJV7574v2XKZ48
         3Jeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gUweMe25ZY+FWOwu1j0KzvL1X48NI8hG/yEl03mHbWo=;
        b=I9utaCY0Qf05i+TexulHChVAbIfD4WMIj8p5iXGNZFh5LaWUzSo5bK5VxBujZWjCpr
         3kMTPNlC7dMa+CU8Q/BFF+21SaoFpKdh9gR44jU3cCorSs0ktdlm9gpxbkLuvXXxgzeY
         vyeOFcGCR1rtjvjG2SElSebKQMM0V0mkBLhhpgM47fg6hCQOVL7SeBXAarRQc2+j03ji
         buIgjMb6iX0faJb6iUV6uopQgWN/xGEgNSSG5JWIFyzQzpfciFcmhVQGaKbfaNW8/NxQ
         JxMkPvcKRviqzpTR8tswP+pxS5I7oBQ3SgtKt0iadX+ktH17Yu0JJZa34xLgk2+pICrp
         Zl1Q==
X-Gm-Message-State: AGi0PuYruKgjgtuWI7o6Bw/qThsZpCEJJZ5ru0dyF8dHKv4wJ+MuqvJw
        cLUUnGaVEV7ZFmJU42DkXn9dCnL5xyY=
X-Google-Smtp-Source: APiQypLo9sHkGzEtOLNjIggI6DQL+QX8D4Evg03Owls2baPvRuNLl5Sj5nBegCi2uaDcVRxHI/KiCA==
X-Received: by 2002:a2e:920e:: with SMTP id k14mr11959172ljg.288.1587562859099;
        Wed, 22 Apr 2020 06:40:59 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.94])
        by smtp.gmail.com with ESMTPSA id d22sm4777960lfe.75.2020.04.22.06.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 06:40:58 -0700 (PDT)
Subject: Re: [PATCH v3 4/5] kernel-shark-2.alpha: Force trace-cmd.h to be used
 as plain C
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200416160047.77118-1-tz.stoyanov@gmail.com>
 <20200416160047.77118-5-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f2787def-0351-bcec-1e3a-644d1e022c21@gmail.com>
Date:   Wed, 22 Apr 2020 16:40:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416160047.77118-5-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 16.04.20 г. 19:00 ч., Tzvetomir Stoyanov (VMware) wrote:
> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> C++ compiler uses name mangling to handle function overloading. As there is no function overloading in C, function names are not mangled. This breaks the linking of C library into C++ binary.
> Declare functions from trace-cmd.h as pure C, so the loader will not mangle the names when resolving them.
> 
> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ---
>   src/plugins/KVMCombo.cpp | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
> index 3ff9ca5..1ae03aa 100644
> --- a/src/plugins/KVMCombo.cpp
> +++ b/src/plugins/KVMCombo.cpp
> @@ -13,7 +13,9 @@
>   #include<iostream>
>   
>   // trace-cmd
> +extern "C" {
>   #include "trace-cmd/trace-cmd.h"
> +}
>   

I think we do not need to include trace-cmd.h at all.
Thanks,
Yordan


>   // KernelShark
>   #include "libkshark.h"
> 
