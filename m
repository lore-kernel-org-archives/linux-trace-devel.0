Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6934C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 17:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8DE64FCE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 17:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCKRCI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 12:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhCKRCC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 12:02:02 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE1EC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 09:02:02 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o19so3863176edc.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 09:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ZxwUvejY843FGNL9rYJNOkVZwKnwfeqtQJmpzt7aEA=;
        b=u6/DfxW5KIoOvtL2I3w+ROOG4QEl8nowZLbwYBDIos5stB0tosuj+qncdxkIN5lJFs
         rxmoraKzuGlNPyeDedLzDCC2arr+LR8sLKmIKzaAmWRH3E61HD70aAjLIhR13SH9xFR0
         EyTy8PRuYeFHMoAAbcJZ1R1V66GQHELesl+MdDMnPpyh4iT01RTP9fo6kK/Vx/Ikzjmk
         UQs4pbk2fthNRHpMmEooy1R1Ux+V/83C+ljzKRYBZXs9ZHdgYVAcVHAZIKODC9bIYSZh
         nWv+4cvZKRKBfCIzI9RS/nu2u/KNg782xxnprxH3wXGaTkysPgsEO6q/v7QuQHu5wtIX
         XEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ZxwUvejY843FGNL9rYJNOkVZwKnwfeqtQJmpzt7aEA=;
        b=WumCRSIB+o/t5n+BDX+DwnzNgsVtO0ixjV0UqeRpZo1kqJ188Z355plkol7c6tFn47
         wWlH72Ql/57/Y9/J8zh/Qi+Db+Kw1SQ2C4nXsoJR2htsoR6glBSjiV1ZzusfIWIVr8cV
         MFkXDyxkUQjW3zY1PoZt89a/b7aYW6aQPI3rdnAOx2FmThnyVaY6UvTXI7b8+d1VrhdX
         sgL7hIEZ7B2F8aYm1V/KmQ0fjqryfJAk8VeKZ+gIHSPYEGO7f7gMvpLL6vJLYYuOl7X0
         IQ9n1hpPteB1lgDCZRxBoumlKESGl/IkKM3Bxf5I/YN7wQ4pYw06QxWeQwqVtTTPqZWi
         v69w==
X-Gm-Message-State: AOAM531oHUeP42NbeyreACWNj0owhEnBZgaSUIgXvsr4Qpx7mWtWvzCJ
        9FfMiBuQLt0VI+MFiOjVi0o8xzkJUvvwRg==
X-Google-Smtp-Source: ABdhPJzyPBzKL1sTXDj0S3brBScUaTPlb4rYZQryA91XPnW6R7egSBvJO0gxxXBrlpSrCEpX/EfkVw==
X-Received: by 2002:a50:9d4d:: with SMTP id j13mr9285538edk.83.1615482121033;
        Thu, 11 Mar 2021 09:02:01 -0800 (PST)
Received: from [192.168.0.108] ([84.40.73.174])
        by smtp.gmail.com with ESMTPSA id u59sm1771756edc.73.2021.03.11.09.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 09:02:00 -0800 (PST)
Subject: Re: [PATCH v2] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
To:     Michal Sojka <michal.sojka@cvut.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <87mtv97nlj.fsf@steelpick.2x.cz>
 <20210311145059.27147-1-michal.sojka@cvut.cz>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <cf3243d3-65e0-18cd-0a20-81739552c105@gmail.com>
Date:   Thu, 11 Mar 2021 19:01:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311145059.27147-1-michal.sojka@cvut.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Michal,

Thank you very much for helping us improving kernelshark!


On 11.03.21 г. 16:50, Michal Sojka wrote:
> When one wants to install kernel-shark to a non-standard location,
> e.g., by configuring it as follows:
> 
>      cmake -D_INSTALL_PREFIX=$HOME ..
> 
> then "make install" fails, with the following error:
> 
>      CMake Error at src/cmake_install.cmake:225 (file):
>        file INSTALL cannot copy file
>        "/home/user/src/trace-cmd/kernel-shark/org.freedesktop.kshark-record.policy"
>        to "/usr/share/polkit-1/actions/org.freedesktop.kshark-record.policy".
> 
> This commit fixes that by ensuring that even the
> org.freedesktop.kshark-record.policy file is installed to the
> user-specified prefix and not to /usr where the user has no write
> permission.
In your case the installation fails to install the policy file used by
Polkit. Note that this doesn't mean that the kernelshark installation 
itself fails.

As far as I know the policy file can only go to a special locations so 
that Polkit can find it. Otherwise it will have no effect (I may be 
wrong on this).

If you know how to tell Polkit to search in an arbitrary location for 
those files, please let me know.

Thanks!
Yordan

> ---
>   kernel-shark/src/CMakeLists.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
> index 457c100..687e150 100644
> --- a/kernel-shark/src/CMakeLists.txt
> +++ b/kernel-shark/src/CMakeLists.txt
> @@ -92,7 +92,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>               DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
>   
>       install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
> -            DESTINATION /usr/share/polkit-1/actions/)
> +            DESTINATION ${_INSTALL_PREFIX}/share/polkit-1/actions/)
>   
>       install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
>               DESTINATION ${_INSTALL_PREFIX}/bin/)
> 
