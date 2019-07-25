Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF32C7618B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A22D222BED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ga7OYKkA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388100AbfGYJBl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:01:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42125 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390002AbfGYJBk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 05:01:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id x1so34891751wrr.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 02:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=j4EEa7FZiykjNvyZ9LVSkeJ6UN+K8/K7ZjR2obEDKKo=;
        b=ga7OYKkAUjz0eyLCT2e/5XcyRxHZ57C3X+fwP5eFvNViSAWNoB4lgrMeeV100tAy2a
         mnL9nlZUfjkxUAeMYLRstGFmBQsQn4b50MqAAOZeJ5DnKypcb8mPTeEKUFWl0ysECUux
         tsV2uytw1LVUy0KwdXk58m8cbhPYM9oQVkNoQf1NjC/sQoOhGYborU9rM2iO2fSSy9Ak
         tQ7RDJ6J518hdKPxhagccG1t0hX5FAV8JkOTVDqyy0g0fR0Lh7RTBphyh8cM5JrPTF7O
         r+t0A1akhVO+uneAzwGXCGk1fnOiAeQAhTwl9ZUychsyWhzICPqUTCSnK09YWqzzrBQe
         N/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j4EEa7FZiykjNvyZ9LVSkeJ6UN+K8/K7ZjR2obEDKKo=;
        b=DTXnwmZWonT9XF2YWNDECU91YJ2YPk/7S+ymznwCXIijnwYY3gBUscvIxRdTcMusRr
         QBLKf4SmfLCC1GSbaWDy0JAD/yAeoJDZ2oGtqcO8z94iQgOwnG5+AzgXNRnD5sA9AKn4
         9ysxxOI9bNPscFfiF3hMpHB/IGDq+WQK0Gucs8zNq0MmIHGbuTbSli8GiFInb4a581Aj
         wf35mE7I1fWmbiG9XHu78y4Yb5TVeSyTOFFZSbVeSyK2semWGXXEjFCRDC3oDEXyEQRe
         x/8rspEp54HOey9iDVJ9sA6KlM67rkGUsT3im4Ef4cUIS6vUg4Pd1kl3wPmvnVep6/KU
         fZWQ==
X-Gm-Message-State: APjAAAWRnoKKQrV9pVdaZ6jxW/1RnaA6o/1enbEhvLk/KgZLBUCg9g5q
        mAfqB6zDqORs0S/3wv//+dDToLpx1QA=
X-Google-Smtp-Source: APXvYqxR2RKQu6n8tt05eMZc4H1jNiu3k214YB1hyx9zlcgkEt+Kr+1VdYAc+IDNgykAS6Twf+TYLA==
X-Received: by 2002:adf:db46:: with SMTP id f6mr42494433wrj.212.1564045298603;
        Thu, 25 Jul 2019 02:01:38 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id i13sm41818134wrr.73.2019.07.25.02.01.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 02:01:38 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark: Execute kshark-record from same dir as
 kshark-su-record
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190723225044.576298160@goodmis.org>
 <20190723225238.701263380@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f9ac2e19-cc65-6496-5c42-9668337e6506@gmail.com>
Date:   Thu, 25 Jul 2019 12:01:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723225238.701263380@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 24.07.19 г. 1:50 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Do not trust the PATH environment variable (and in fact that may not even be
> available with the pkexec). Instead, use the same path as kshark-su-record
> to find kshark-record. They should always be together anyway.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   kernel-shark/bin/kshark-su-record | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
> index 2477045f1710..7faff1cb3339 100755
> --- a/kernel-shark/bin/kshark-su-record
> +++ b/kernel-shark/bin/kshark-su-record
> @@ -5,4 +5,5 @@ then
>       xhost +si:localuser:root &>/dev/null
>   fi
>   
> -pkexec kshark-record -o ${PWD}/trace.dat
> +THIS_DIR=`dirname $0`
> +pkexec ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
> 

I just realized that there is one problem with the patch. With this 
modification, you can use only the installed version of the script (so 
you more or less depend on PATH).

This will work:
  kshark-su-record

This will work as well:
  /usr/local/bin/kshark-su-record

However this will not work:
  kernel-shark/bin/kshark-su-record

because you are trying to start with pkexec an executable from your $HOME

Thanks!
Yordan

