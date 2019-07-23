Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F3AC7618B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 08:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1054C2239F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 08:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKGNDjBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfGWIBr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 04:01:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36664 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfGWIBr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 04:01:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so33476164wme.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2019 01:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xZLIASRL7McbTJhMfiXOpIFwJ9zs8AtuUBIrBX6Xypc=;
        b=LKGNDjBaSSKUYdAEwOQLv2zA9HypoL09yTWj0HnWvcBTAVb9mHuWelTmgxhnJ/qhDk
         UdvI1yHXgpOGY5JcRi71Vj2wFLxU8eF6va7C5u12Wkf7ZN6MiTT3QtFIHa7xWDcct8mz
         /03Vsd0/V6ILSnxSWynuPfHF9I5xeX/yXn6n+Aj8RGWkbl1W9PbikT0UnOcHC05TjnDq
         BoEtl8k/l10xQtFQDlZUPFE278vQQ5LROy0eAikj3RMT5ZEycQro1HuGLDMWr+frsnc2
         7frpXxqZFZD/M18tW2aR4LSrjkrwVE88HdMqANe8O2CA3ry5L63Y6dxSioULrQiz6NBA
         mKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xZLIASRL7McbTJhMfiXOpIFwJ9zs8AtuUBIrBX6Xypc=;
        b=GeZ2b9cW0TYNS+PlG3b+RDvgTDeMoXU/DNCM47mQ2wDCy5Z/hDpegOJWNlBpn22aVl
         ZRxOPJdOhJqllXRje3amDAm+acVSiSD0ql9d5aXZkPZ6ao5XHQh6Nxo7tei4C0jx5Miq
         C2yMQH5Ze5CdMj5JLvwL4Ubs1hAKaWGcwXU9ZQsYqVnDLII1lOq6APnR+S9GpfrsfPy1
         XrUzvVAb69tpU89KiD+ESXDvwQ6PVc20zHV2YYRWKOwm5ENY4b9HHqfY/Gzo0BTbNhM3
         j66gIl5yNI+lRRn3tJa7Zl+DbLE6d6o0q+2bNQo51GgAlS3DQQcnwfLkpCIufnEAgqoI
         h4ww==
X-Gm-Message-State: APjAAAUuldc/ObtJarkJ1id3wDsG2XDyi5IiTTImWc1IPJKGcc0gu0bb
        JA51YWip0l1mCOR1m9F+wRI=
X-Google-Smtp-Source: APXvYqxM0pC/9bO154sn9ZJ99QqQKTRlIYnHBN8r+urJh8wRlsaXzCIuesBEQ2u0DTUJzAgn1EgAUQ==
X-Received: by 2002:a1c:1b97:: with SMTP id b145mr64455713wmb.158.1563868905389;
        Tue, 23 Jul 2019 01:01:45 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm31503521wrt.49.2019.07.23.01.01.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 01:01:44 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Add quotes around $XDG_SESSION_TYPE in
 kshark-su-record
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     howaboutsynergy@pm.me
References: <20190722113707.156a099f@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <208b69d0-1c73-d155-78b1-b446571a4904@gmail.com>
Date:   Tue, 23 Jul 2019 11:02:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190722113707.156a099f@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 22.07.19 г. 18:37 ч., Steven Rostedt wrote:
> 
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> If XDG_SESSION_TYPE is not set, then $XDG_SESSION_TYPE will become nothing,
> which means the test:
> 
>   if [ $XDG_SESSION_TYPE = "wayland" ];
> 
> turns into
> 
>   if [  = "wayland" ];
> 
> And will cause a shell error. Adding quotes around "$XDG_SESSION_TYPE"
> changes an empty $XDG_SESSION_TYPE into:
> 
>   if [ "" = "wayland" ];
> 
> which the shell can understand.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204261
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   kernel-shark/bin/kshark-su-record | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
> index ee839a26..2477045f 100755
> --- a/kernel-shark/bin/kshark-su-record
> +++ b/kernel-shark/bin/kshark-su-record
> @@ -1,6 +1,6 @@
>   #!/bin/bash
>   
> -if [ $XDG_SESSION_TYPE = "wayland" ]
> +if [ "$XDG_SESSION_TYPE" = "wayland" ]
>   then
>       xhost +si:localuser:root &>/dev/null
>   fi
> 

Thanks!

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
