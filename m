Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FD7C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 152B7206B8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:51:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pyxowulg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGZHvX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 03:51:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43639 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGZHvX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 03:51:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so53317220wru.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jul 2019 00:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vkRK9Ptiu9ncz3J7VDwEhVJx1feX2EZggmj+MQlj1pk=;
        b=PyxowulgGMqSlNT+5YguPc/vQMWfw2UhAL+m/HTSck3RW1QrpT2s7BEvnp45V4TxRY
         YkRXZ3jazicZqUGgsx0W1scrp2tCV+ZQzah47EAEmYdmr9BkZFp7tQ2MOSqncq3uFZoU
         B17waQMPx1LGWdQ9sLuMVJHHpf4utT3Ucc5XUp624r3alK4Vgt8ey7lZbNbZ+waWAn22
         zfVEGWLJ1Jx6Ph1ax3OEDCjbwXtW0PuScrXQ4wJ3yR4pOYWZiFGcGVQcZKAQBAW4TIJS
         RS2DuHnfI+M0oCL2JmyVrPNv6vMSQSjTKJE+GMfvKEV3B/ifTRwfgj1gkQtwgJXtHbI5
         r26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vkRK9Ptiu9ncz3J7VDwEhVJx1feX2EZggmj+MQlj1pk=;
        b=hThSjUULtrAA29P/fRAQfxnpvluOfWrFI1HRTgGhy3u9z3RpNJ67j7b8UMXHIJ163v
         iBC9Kym64wQbs4riRVvEcfWg1qV/KaZMUMv+GycPGjUbiwauhYFHlRTxcbNg2TAnd6ZG
         inVageki/2koo1EUyNUHv7N6hhEVnjZ3q5Vjrvokv7K1A7q2mfuScWpYZ5rnBi6jlVdG
         8zqsvVWmMeFD5iSD8Fbd6LxEFEY103v1vkZSEPEmnvq9ldayr96i1VRHH7eBBs1FGg6g
         qapA4QvpeLz5MoDki1SVNRZCKAxaFoX9jVh0KFu0ikEAE40B+Z28JtanryoePtT5tNpw
         hrMQ==
X-Gm-Message-State: APjAAAXBYGfQtLEKXObjDVW8QsybnrZyHX2qPybEjjjbAvin+S716v9E
        yYb2dLzP6CVNVs+D1B+mN4TS8xK0oGk=
X-Google-Smtp-Source: APXvYqxpAd3izHfv9vwomWk8DyZztJpWSsaRRIRHqJyHcjJjX+TAAbzVPTRTPUU2eJVGRy162mmoGg==
X-Received: by 2002:adf:ed41:: with SMTP id u1mr94955271wro.162.1564127481320;
        Fri, 26 Jul 2019 00:51:21 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h14sm49468584wrs.66.2019.07.26.00.51.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 00:51:21 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark: Revert adding environment variables to
 kshark-su-record
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190725194537.884800321@goodmis.org>
 <20190725194738.979632340@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e0e0974d-a2b7-8c0c-96fd-ac918ad32a2f@gmail.com>
Date:   Fri, 26 Jul 2019 10:51:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725194738.979632340@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 25.07.19 г. 22:45 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> This reverts:
> 
>    8eb0d753e ("kernel-shark: Execute kshark-record from same dir as kshark-su-record")
>    b084eb5aa ("kernel-shark: Set the DISPLAY environment for pkexec kshark-record")
> 
> As the policykit (when installed correctly), should handle both the path to
> the executable, as well as the DISPLAY and XAUTHORITY environment variables.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>


Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>


> ---
>   kernel-shark/bin/kshark-su-record | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
> index c14f03da9684..70d781d84335 100755
> --- a/kernel-shark/bin/kshark-su-record
> +++ b/kernel-shark/bin/kshark-su-record
> @@ -2,5 +2,4 @@
>   
>   xhost +si:localuser:root &>/dev/null
>   
> -THIS_DIR=`dirname $0`
> -pkexec env DISPLAY=${DISPLAY} ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
> +pkexec kshark-record -o ${PWD}/trace.dat
> 
