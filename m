Return-Path: <SRS0=wCVW=VV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C61C7618B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 10:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ACDE229ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 10:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="psDAZv2J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfGXKhW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 06:37:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37896 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfGXKhV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 06:37:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so19784057wmj.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2019 03:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JcDkMer/z7MkHqnN9ChPA19vAwhG4h9C+bQ7znTpGmE=;
        b=psDAZv2J8I6btNA1IpHEU0DfNSbaVWEv4ZRiNpn8Lv2ab21wzJPLXXrLvFPP0Tpie4
         vjqqK0tbeYNkmyVjbzwLgSDNqepI1sKQMTQU0Z3FlKdkNSt+anKz1RHQHSNGfA8TN2WZ
         eiGSNVi7iRfKIyLzMG2CPNUE3vXAU1CAOxuMg0Bs7yzfXEdJMC2AfjiWCEhf9aUYaXIi
         LOVaUuKW/hAn4EMeko09dgROUEP7sYELo4BQJnIzTeif8iyEEdX0W8edFEICQG4Vskso
         Y3Xux2Zaascz695hFRmGdH0XX6x0wLrRai+7izWgg3T31OUGolwGYllApai/8mcYTR26
         BVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JcDkMer/z7MkHqnN9ChPA19vAwhG4h9C+bQ7znTpGmE=;
        b=SQ1PirseYgGot6843cV8Eo9FV+jd+8xiNzYEuFHefa27rnxjxtiRtPJz0lPlfDsYvA
         8eww88hP+P2HgGTKTnOIRNkpF+zmupFguJlhnxDAf1K5tRq4ngS+Ap+rYDw4ZDa1JkxS
         kSXIn3aPkLNWVhJ/nnnYxY7e2tWoHevxkycC6EWXb/RXg4QpvTdz/wyQi/V1ByqEy0/2
         coqycejgvRCD0lgYKjthsQcoSx4zNIMa0+hXYEs2e3qL/KOSg9wc/OgU0oc5j1aXaLny
         6Wk6Z6tCy2tSqYnai1q9mT4N4C7W2x+cslDGlol0KslLeWDpepVcNFCFmvS9cDg7O0NC
         7E6Q==
X-Gm-Message-State: APjAAAUQHnFY9j6DX6PxDM9wzkuRuGWyxjXpx2RBVmA5OC1g24Uhr45R
        bgz7GJyZR4k0dRyVE6BAr5YHXYh25EQ=
X-Google-Smtp-Source: APXvYqz7YuLBJQvnJ5jsqTjq7FC2AHsHgzDjt+tZJXbneBffpo32CC3k0QpPajhnSx36eGFsvZufDA==
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr1827962wmg.155.1563964639630;
        Wed, 24 Jul 2019 03:37:19 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm34739821wma.32.2019.07.24.03.37.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 03:37:19 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Suppress "Root privileges are required" if
 already root
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20190723165935.300f58e8@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <ca2fce2f-8d04-ef94-f367-0ccc9739ef22@gmail.com>
Date:   Wed, 24 Jul 2019 13:37:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723165935.300f58e8@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 23.07.19 г. 23:59 ч., Steven Rostedt wrote:
> 
> From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> If the tracefs directory is configured into the kernel, and
> kshark-record  fails to find the tracing directory, it should test if
> it already has root privileges (geteuid() returns zero), before posting
> a message "Root privileges are required" as that can confuse users.
> 

Yes, the message can be misleading without this check. Thanks!

> Reported-by: howaboutsynergy@pm.me
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
> index 2e6e8f9c..dbf73302 100644
> --- a/kernel-shark/src/KsCaptureDialog.cpp
> +++ b/kernel-shark/src/KsCaptureDialog.cpp
> @@ -18,6 +18,12 @@
>   #include "KsCmakeDef.hpp"
>   #include "KsCaptureDialog.hpp"
>   
> +extern "C" {
> +  // To get access to geteuid()
> +  #include <unistd.h>
> +  #include <sys/types.h>
> +}
> +
>   static inline tep_handle *local_events()
>   {
>   	return tracecmd_local_events(tracecmd_get_tracing_dir());
> @@ -65,7 +71,9 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
>   
>   		if (!_localTEP)
>   			message += "Cannot find or mount tracing directory.\n";
> -		if (!pluginList.count())
> +
> +		// geteuid() returns 0 if running as effective id of root
> +		if (!pluginList.count() && geteuid())
>   			message += "Root privileges are required.\n";
>   
>   		QLabel *errorLabel = new QLabel(message);
> 

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
