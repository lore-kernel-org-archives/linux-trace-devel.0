Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6489C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DA621901
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:51:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gS6QmNg+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfGZHvt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 03:51:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39825 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfGZHvt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 03:51:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so36472991wmc.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jul 2019 00:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=btyY7iDiuxe40QyrgHmfozR2cMYNkmpNG9LH3JRjq38=;
        b=gS6QmNg+X3M0KoYl6kG+BkqKhANxpIK2hyxj4FXHat+41ENfnyiO2kJ5fpAZvRgU27
         gIifb+ZzDc3FuZCi+n8fKFlvc+hPXZ3fsqdYPSDkAiJmbCe2MPecrVGGyxQMp1EdXUbt
         RMWbZB3rqtlA4vUtQCp71KUFwEElB/3MOXQqBwcw6bmRoSdPsId1huhWzXSxcsJuoRov
         Cfh6toq/k+K8CcjFj0aPXEwmogp9BpccrN1pZfjKTvUpQuiU0U4WLziC8QOkBiNi9Zgs
         x8bno7KNjt/EPToiVYpSIqCxYuq3kYarSmtvMKVj08ivS9ZslwYrXaFcNbOtHHnArdVO
         Cvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=btyY7iDiuxe40QyrgHmfozR2cMYNkmpNG9LH3JRjq38=;
        b=j/S3UTAXkYdQRoe/CMHD+4AuaMG+Mtw3tlcMY6inkZw5rHFAG2SMstLCwUFf8a7uLB
         dl00zinbGbvv3AhnGPWiWrbXKNILhts/Q+40BEZD4tPeLCYUjAJpoXPZMWdS79HEQiSl
         m7A/Usz71dZL8sjd4fh6yMgEHyDN8kPJ0j4deJIHC3ZCrB1PCHTPytANaNlzL+mxKKoP
         izAgU91SF6+Wiwj92gYg4KDfBGiEiCx2v0zAYPidhxkqOxhTTIMZ9D//Z3lA59JP58Gq
         lSRYCTDmv+wN5JPz6okwB+sT9WqlYh65C/aglM66SpYVqye/Al4HYQvE9epiU3MBHKim
         51wA==
X-Gm-Message-State: APjAAAXMBPYIAvtlNb2qZAlQnDkS/KJ1v/v7t6ufmu2TAer3QJjjDzNc
        /cSu3cAz2DUCw9wN5uShdjRf6aqI/pk=
X-Google-Smtp-Source: APXvYqwh67+k3q97vulT63sjMaDan2GlSQ1WGwtyy6QiqYXZzx7S1tPMB8GM6CuzY3OiBlBJ63K9jA==
X-Received: by 2002:a1c:407:: with SMTP id 7mr88145962wme.113.1564127507163;
        Fri, 26 Jul 2019 00:51:47 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x129sm49820834wmg.44.2019.07.26.00.51.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 00:51:46 -0700 (PDT)
Subject: Re: [PATCH 2/2] kernel-shark: Revert adding relative path to policy
 installation
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190725194537.884800321@goodmis.org>
 <20190725194739.140392211@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d1075641-107d-d5a3-de41-e0f40de6ded5@gmail.com>
Date:   Fri, 26 Jul 2019 10:51:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725194739.140392211@goodmis.org>
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
> This reverts the change in a45ab5a44 ("kernel-shark: Remove hard-coded
> install paths") that removed the full path of installing
> org.freedesktop.kshark-record.policy to a relative path. This means if we
> installed in /usr/local/bin the policy still needs to go into
> /usr/share/polkit-1/actions/
> 
> This does not affect DESTDIR, as installing still goes in the relative path
> from DESTDIR for package maintainers.
> 
> Suggested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Thanks!

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

> ---
>   kernel-shark/src/CMakeLists.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
> index d91c3650f0dd..21494cccaf55 100644
> --- a/kernel-shark/src/CMakeLists.txt
> +++ b/kernel-shark/src/CMakeLists.txt
> @@ -93,7 +93,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>               DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
>   
>       install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
> -            DESTINATION ${_INSTALL_PREFIX}/share/polkit-1/actions/)
> +            DESTINATION /usr/share/polkit-1/actions/)
>   
>       install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
>               DESTINATION ${_INSTALL_PREFIX}/bin/)
> 
