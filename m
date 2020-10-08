Return-Path: <SRS0=gEc1=DP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57CBC433E7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Oct 2020 07:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5685021924
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Oct 2020 07:30:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n32Pc++E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgJHHaO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 03:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgJHHaN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 03:30:13 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30A5C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Oct 2020 00:30:13 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r21so174060pgj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Oct 2020 00:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qFbSNdScLoLicrnE4Hyt9hbqzq+jJ3XshfQK3sb1yMs=;
        b=n32Pc++EADWs7eTw/e+d0HmCwQljdQjlMkyL+ez1wMk+Ug9soZcnTp0uzc9+YSQd2x
         I9X4r7ulg+2DVR6upUNQNxDDempE2Ert8i5iqSKEBxL1wjiCcYc47lMZh/b6L7LB2Qlq
         y+dWOGZHNdCYTpdu62H63mFmpBEWLkIRjB9hac4K1qdX3+IXumsg4FKHYGczGeiG4Bzo
         UvJcY6v2n8PKO9MlVPHvxyg+6LnaytMpfqp/5U9mARifWuJVGb8EIfEU38sLYgQd9WH1
         ML2Dw1VePgayo60UHhtc68JGYcYdoYWeDn0VADiJ8cY32VTneoVVEMTFVvru1GpG+W8e
         vIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qFbSNdScLoLicrnE4Hyt9hbqzq+jJ3XshfQK3sb1yMs=;
        b=Kq6Wi4GKimhJXBvJa9TA5BNijgmMY+HxYH6myu1mklHmWXjl715xo7ZgNxUFSMXBXH
         CVbEoZp+U0hnwhxPuF55a1CYeL26j2FxWq0mbgWPg95OjjW2ATlWloYkOZbEpxseobYa
         cIDSB8PVPqwz9lHKvQ2eQzB7fUbRrDCwMrXuHaBJRK3NG+XKRxNJgebSm+JBfGF8Y/bD
         4i6hKuPO+fH2EB6BlC1iL0sqDeEcoFMiuGe/RFIYz/1DUXs+rN85Kzrhk5KxcJSqMERy
         D9eLkyksODnbLdJw0bnFlaM5AWgUKAkkAzR9r0Af8GpyPCDscngD3RWtp6JhraSXHPot
         Rv2w==
X-Gm-Message-State: AOAM532q8H+awfSitYIdC1cKy/Qq/X8eeaguW2E2MIpijn2XTA1xelYI
        xe5NflIh376Oo4gU/0UAbvUo9CfnLTyLyQ==
X-Google-Smtp-Source: ABdhPJwzRWc8H0brF8lK5xj4jpxhcXNjMVwEMlE3hUXhmhmE221zDqI+yG0BIRF3H31TUXs62W5CUA==
X-Received: by 2002:a05:6a00:8c5:b029:13e:ce2c:88bd with SMTP id s5-20020a056a0008c5b029013ece2c88bdmr6608938pfu.0.1602142213382;
        Thu, 08 Oct 2020 00:30:13 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id t4sm6024929pgg.76.2020.10.08.00.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 00:30:12 -0700 (PDT)
Subject: Re: [PATCH] Documentation: Fix include level of Makefile scripts
To:     tz.stoyanov@gmail.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, sztsian@gmail.com
References: <20201008071858.96786-1-sztsian@gmail.com>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <7897620c-3039-5e4f-09d9-41606673fa63@gmail.com>
Date:   Thu, 8 Oct 2020 15:30:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201008071858.96786-1-sztsian@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Note, this patch is for libtraceevent.

And I think it makes more sense to port the missing 
scripts/utilities.mak by the maintainer rather than sending a patchset 
with lots of historical commits from kernel, so I did not include that 
part here.

HTH.

On 10/8/20 3:18 PM, sztsian@gmail.com wrote:
> From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>
> 
> Compiling the docs with `make doc` will result in
> 
> Makefile:2: ../../../scripts/utilities.mak: No such file or directory
> 
> This is caused by:
> * The reference should be two level up, rather than three
> * The utilities.mak is missing when fork the library out
> 
> This patch fixes the first issue by adjusting the include level. And I
> think the porting of utilities.mak is better to be done separately.
> 
> Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
> ---
>   Documentation/Makefile | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index aa72ab9..edb8623 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -1,5 +1,5 @@
> -include ../../../scripts/Makefile.include
> -include ../../../scripts/utilities.mak
> +include ../scripts/Makefile.include
> +include ../scripts/utilities.mak
>   
>   # This Makefile and manpage XSL files were taken from tools/perf/Documentation
>   # and modified for libtraceevent.
> 

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
