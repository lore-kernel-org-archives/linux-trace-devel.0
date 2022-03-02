Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8064DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 07:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiCBHIq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 02:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiCBHIq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 02:08:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEDE2AC73
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 23:08:03 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nPJ5d-0000bQ-SJ; Wed, 02 Mar 2022 08:08:01 +0100
Date:   Wed, 2 Mar 2022 08:08:01 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/5] trace-cmd: Make internal compression hooks more
 generic
Message-ID: <Yh8X0XH91izPKi3f@breakpoint.cc>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
 <20220302045131.387658-3-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220302045131.387658-3-tz.stoyanov@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-03-02 06:51:28 [+0200], Tzvetomir Stoyanov (VMware) wrote:
> Changed the prototypes of trace-cmd internal compression API to be more
> generic.
> 
> Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

> diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
> index 8b9758c9..41342597 100644
> --- a/lib/trace-cmd/trace-compress-zlib.c
> +++ b/lib/trace-cmd/trace-compress-zlib.c
> @@ -13,19 +13,17 @@
>  #define __ZLIB_NAME		"zlib"
>  #define __ZLIB_WEIGTH		10
>  
> -static int zlib_compress(const char *in, unsigned int in_bytes,
> -			 char *out, unsigned int *out_bytes)
> +static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
>  {
> -	unsigned long out_size = *out_bytes;
> +	unsigned long obytes = out_bytes;
>  	int ret;
>  
> -	ret = compress2((unsigned char *)out, &out_size,
> +	ret = compress2((unsigned char *)out, &obytes,
>  			(unsigned char *)in, (unsigned long)in_bytes, Z_BEST_COMPRESSION);
there is no need to cast to or from void *, this works always.

> -	*out_bytes = out_size;
>  	errno = 0;
>  	switch (ret) {
>  	case Z_OK:
> -		return 0;
> +		return obytes;
>  	case Z_BUF_ERROR:
>  		errno = -ENOBUFS;
>  		break;
