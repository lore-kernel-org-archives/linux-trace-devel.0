Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEB1C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D02EA20665
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tWWYfQ4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405849AbfITJul (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:50:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36911 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405771AbfITJul (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 05:50:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id f16so1638943wmb.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 02:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8GPBUv6m2PeD/Un/UO8XnMOy45sIKX73QRnLNBLcYMA=;
        b=tWWYfQ4dkbix/dycf88xROJjBuY0kx6aYfHuBIUZt5FuveKkRVac0esP6d0pqte2L+
         RJiSaOyQrxMvEWxVr0M4KmvF+uEsxwl0PqJwrPGKqgE3h0oAk5buT5FabJkbD8hk5aEO
         sKn9o7ccaTyinMbV0V5CpMw1bLEQEOsJy0n+ayo4XCfPqqWrV8Mq0NTxWmYJ4RTpCGMC
         dZqQSRZjDkTzGSHS99RtOBFj69JnPr/oofveS+YNze9KnqI1FNRqz8XKvdj2kf73p9Uz
         /q9dP5CMIs8f6Hjoq3TYDWsrX5SnYgrnNXCjRJ3rL/kXzAZNIbXkuyOcVzpOk/lp4+1G
         mnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8GPBUv6m2PeD/Un/UO8XnMOy45sIKX73QRnLNBLcYMA=;
        b=YsMi9QB5/GZuwwqsMlYV5nzNmBmk5VjAFXOxkJKPQDJucavdmQIyY92nR2a2YIiuvC
         QWG+VHMdL5hpLjCgz1iakDHFXLIimUAXX3bxxTRP5LPWwKZi+6OmNNFWxxIdzIGZqo7w
         B07/QVbSDqvxj5iRuTlkryzz5Q9QruXp/iqlOpl5Aa9jEYHsa++oWJmF4cTi1lRxgdPQ
         UJLxEEKM1t8GdNEM8KQIXcdPizD+jOyjidjiPwlxmFx6DZ1FWsuaJqNh57u7nTu+34Ra
         zDuBXUps6Z6fb2tfyc/G8tlWRn6poS1O6UKK8ZL1goYUuN0hBjWPqrJcwnylMcRFNAC4
         V5pQ==
X-Gm-Message-State: APjAAAV8lGpX2Im/sSpZc1aHAZBIFkaArf8iYKhFFo9IeSi3zu4RkgVg
        1N7zkC3WnY+vTife3rkw+FBVPqMJ
X-Google-Smtp-Source: APXvYqwVnuMP8HWmUy7Ig/Il6wgjMy2JVK67/5Plb6JxT1frVxWuHXMdcK2iTqAy72Xn0B9IhNCESg==
X-Received: by 2002:a1c:ed16:: with SMTP id l22mr2705955wmh.172.1568973039439;
        Fri, 20 Sep 2019 02:50:39 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r20sm2613469wrg.61.2019.09.20.02.50.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 02:50:39 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] kernel-shark: Add quotation marks parsing
 example/test
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, stephen@brennan.io
References: <20190918142319.11821-1-y.karadz@gmail.com>
 <20190918142319.11821-4-y.karadz@gmail.com>
 <20190919191252.013a5e58@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <6dafedf8-88c7-36f2-e62a-2e55ecbcc16e@gmail.com>
Date:   Fri, 20 Sep 2019 12:50:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919191252.013a5e58@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 20.09.19 г. 2:12 ч., Steven Rostedt wrote:
> On Wed, 18 Sep 2019 17:23:19 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The example implements a small GUI that executes shell commands.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> 
> The testing on this seems to do what I think it should do.
> 
> I did modify it with this change, to get rid of the "Unknown error"
> message on success. Care to send a v3?

I don't care, just get it upstream.

Thanks!
Yordan

> 
> -- Steve
> 
> diff --git a/kernel-shark/examples/cmd_split.cpp b/kernel-shark/examples/cmd_split.cpp
> index ac688442..b8cc1b59 100644
> --- a/kernel-shark/examples/cmd_split.cpp
> +++ b/kernel-shark/examples/cmd_split.cpp
> @@ -39,9 +39,10 @@ int main(int argc, char **argv)
>   			proc.start();
>   			proc.waitForFinished();
>   
> -			cout << proc.errorString().toStdString()
> -			     << endl
> -			     << proc.readAllStandardError().toStdString()
> +			if (proc.exitCode())
> +				cout << proc.errorString().toStdString() << endl;
> +
> +			cout << proc.readAllStandardError().toStdString()
>   			     << endl
>   			     << proc.readAllStandardOutput().toStdString()
>   			     << endl;
> 
