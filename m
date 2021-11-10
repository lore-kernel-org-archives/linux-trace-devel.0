Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43B2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C061C610A8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhKJOPD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhKJOPD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 09:15:03 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DB3C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:12:15 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id v11so11030048edc.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=7lVzV1s7lUKXd8+8dZw2G9kCxfMk5vbIMTiRAD0D8tk=;
        b=L4bfZU6Ay1PZOfRV9OgsP4is/0Mxn35nAI4TocZ+Bafv9Y59Vz8Y69rAqLgbUhFwAj
         YkgFsJzLdAKpzK3PB1GdRrPu+j1kzqPrRi73d4iCk4+7XhzNrxP+gNZPJ7PaETR7V/q2
         NNcvg9DLNG+Be8TRmY+1aaNhOurmYqFozRDkN1+BdVS7xnfYjDovg36dNzwMYO9HteVf
         OpY5v6MqvktdlxqRpttmuMW/bhBA/+rtvWL07gTaxhTJ9jNwQ2nkkxKQHly/L/z0bi+e
         lGuqN1HihQ0jMweq8hc7IOOCuB1o22Ap9wh2uA28uK89FCbpDc9C2l98nM9XTIjlyqMx
         mvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7lVzV1s7lUKXd8+8dZw2G9kCxfMk5vbIMTiRAD0D8tk=;
        b=18yq+Pf0hqfGBE0ifl3BfetWjC+4XHzVsQeXAWN0Pue/vMi/qOT+v8fpTmQC4f0NVk
         T3axijBx7S7F057zb/5QP3WdJDYuMTnPt6DBvc15I6V5KpYwxYVKAgu3aeMK5oYDPPFp
         UA+oajo1cDTYvmLlR+sKHnkzaDHOv7fRb9+OWIeGrZ580THeMsHXPmcaWWMIpT8HDo5F
         jmqUAy12b7kAbpt1+i4IRqwiHX368OS2iGTu+6nYhdcto/Y2srg/ypAmbc+trs38o9n7
         g4gG3PEG7jDRVZHDM9NjaKDmcS32Qv3F34vb3MgsG2XRBUPPzpYtAYmGrKYSTb7t+8Lx
         /+Fg==
X-Gm-Message-State: AOAM532IZV0rXw9mOqLTVpUgRGWt9AcD7ZyAH6zwCI0UNONJ1GspmilH
        1fvmyv5Ft13G6mTITQygMgamYgvkDKE=
X-Google-Smtp-Source: ABdhPJyVwos6hGY5eq0obAY7f7SI+k+ph8weSZgGTScRDKmdfBwqOJRNufnD4NxD9DKvafEJ9ddjFw==
X-Received: by 2002:a05:6402:2710:: with SMTP id y16mr21574102edd.258.1636553533756;
        Wed, 10 Nov 2021 06:12:13 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id go17sm11463775ejc.76.2021.11.10.06.12.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 06:12:13 -0800 (PST)
Message-ID: <db8be415-bb25-a2fe-1d30-8e4a446154f7@gmail.com>
Date:   Wed, 10 Nov 2021 16:12:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] trace-cmd: Add Requires: libtracefs to libtracecmd.pc
 file
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20211109111426.7639b2a6@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211109111426.7639b2a6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9.11.21 г. 18:14 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> In order to not have users of libtracecmd having to also include the
> includes and libraries for libtracefs and libraceevent, add a requires
> field for libtracefs to the libtracecmd.pc file. As libtracefs requires
> libtraceevent, it will pull that one in as well.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   libtracecmd.pc.template | 1 +
>   scripts/utils.mk        | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/libtracecmd.pc.template b/libtracecmd.pc.template
> index dc41076e..bcf4e39d 100644
> --- a/libtracecmd.pc.template
> +++ b/libtracecmd.pc.template
> @@ -6,5 +6,6 @@ Name: libtracecmd
>   URL: https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
>   Description: Library for creating and reading trace-cmd data files
>   Version: LIB_VERSION
> +Requires: libtracefs >= LIBTRACEFS_MIN_VERSION

BTW this works also without the 'lib' prefix:

Requires: tracefs >= LIBTRACEFS_MIN_VERSION

cheers,
Yordan


>   Cflags: -I${includedir}
>   Libs: -L${libdir} -ltracecmd
> diff --git a/scripts/utils.mk b/scripts/utils.mk
> index 237b2fc9..6865a746 100644
> --- a/scripts/utils.mk
> +++ b/scripts/utils.mk
> @@ -169,6 +169,7 @@ define do_make_pkgconfig_file
>   	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
>   	sed -i "s|LIB_VERSION|${LIBTRACECMD_VERSION}|g" ${PKG_CONFIG_FILE}; \
>   	sed -i "s|LIB_DIR|$(libdir)|g" ${PKG_CONFIG_FILE}; \
> +	sed -i "s|LIBTRACEFS_MIN_VERSION|$(LIBTRACEFS_MIN_VERSION)|g" ${PKG_CONFIG_FILE}; \
>   	sed -i "s|HEADER_DIR|$(includedir)/trace-cmd|g" ${PKG_CONFIG_FILE};
>   endef
>   
> 
