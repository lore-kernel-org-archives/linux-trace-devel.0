Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6C7C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Nov 2022 11:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiKALP0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 07:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKALPY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 07:15:24 -0400
Received: from mailrelay1-1.pub.mailoutpod1-cph3.one.com (mailrelay1-1.pub.mailoutpod1-cph3.one.com [46.30.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F2A178BB
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Nov 2022 04:15:23 -0700 (PDT)
Received: from mailrelay6.pub.mailoutpod2-cph3.one.com (mailrelay6.pub.mailoutpod2-cph3.one.com [104.37.34.11])
        by mailrelay1.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPS
        id 7a04bf8a-59d6-11ed-a6d5-d0431ea8a283;
        Tue, 01 Nov 2022 11:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=rsa1;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
         mime-version:date:message-id:from;
        bh=Ym5Jr3BsyKUqUs55JEwcIK2d1n1du66eVJRBCx9zdPc=;
        b=heiqOk7UEuwL+92Cz78uVRvTnqdGAIutVyHFw8q+/anV+GaJ5YYQB9N6qvM9fDqZi6qka55Qw8+1M
         kW7fFjWMyfnLy8wi8E2DR8A6D9l5rH0qNB5ykOMnOPrK7LbC9uhl/+vjX20eicNrgoqPSegsGdpduW
         jHDHgEzlG+mg533cqPNULjoMFEsdP0o4WZ9GuQgIuZdQpyM4qQH+cW9jXPU0aYCbJFwxqbntrpEEQy
         Y+/GaqdtYbvInmdiVtvO+cTblWUcSbAhnCcUt4Oestg4tEotfl1VbfddJEXpvl5Pu1Jqe1mCQsDZ/a
         R4iAGD0O2CreZ2mUI0hjGvFBsUvDIrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=berginkonsult.se; s=ed1;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
         mime-version:date:message-id:from;
        bh=Ym5Jr3BsyKUqUs55JEwcIK2d1n1du66eVJRBCx9zdPc=;
        b=R74P+fRU5FVg2l/OjLfpnRmp+4VnOdXGSDDwa4woA+3Jv6p4KwPOXhPTJbdaFF555L51wpHAj74nW
         Dd5NUQtBw==
X-HalOne-ID: 793af140-59d6-11ed-8b9f-a782043f7fe3
Received: from [192.168.100.34] (ua-213-113-159-147.bbcust.telenor.se [213.113.159.147])
        by mailrelay6 (Halon) with ESMTPSA
        id 793af140-59d6-11ed-8b9f-a782043f7fe3;
        Tue, 01 Nov 2022 11:15:22 +0000 (UTC)
Message-ID: <ed05620a-7ce2-cd8b-320f-9a07019758d2@berginkonsult.se>
Date:   Tue, 1 Nov 2022 12:15:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] libtraceevent: make it possible to set libdir and mandir
 from outside
Content-Language: en-US
To:     linux-trace-devel@vger.kernel.org
References: <20221031212140.170601-1-peter@berginkonsult.se>
From:   Peter Bergin <peter@berginkonsult.se>
In-Reply-To: <20221031212140.170601-1-peter@berginkonsult.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-10-31 22:21, Peter Bergin wrote:
> When building in build frameworks such as openembedded it is desired
> to use the defintion of libdir and mandir from the build framework.
>
> Signed-off-by: Peter Bergin <peter@berginkonsult.se>
> ---
>   Makefile | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index fab8f7e..e974117 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -46,8 +46,8 @@ endif
>   
>   libdir_relative ?= $(libdir_relative_temp)
>   prefix ?= /usr/local
> -libdir = $(prefix)/$(libdir_relative)
> -man_dir = $(prefix)/share/man
> +libdir ?= $(prefix)/$(libdir_relative)
> +man_dir ?= $(prefix)/share/man
>   man_dir_SQ = '$(subst ','\'',$(man_dir))'
>   pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
>   			--variable pc_path pkg-config | tr ":" " "))

This patch has been superseded by a v2 patch because I did a mistake and 
wrote the wrong prefix. Reference to new patch: 
https://lore.kernel.org/linux-trace-devel/20221101111143.191772-1-peter@berginkonsult.se/

Best regards,
/Peter

