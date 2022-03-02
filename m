Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208FFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 07:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiCBHQP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 02:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiCBHQO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 02:16:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD4F47AE8
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 23:15:32 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nPJCs-0000eo-EB; Wed, 02 Mar 2022 08:15:30 +0100
Date:   Wed, 2 Mar 2022 08:15:30 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] trace-cmd: Use errno from zlib, if available
Message-ID: <Yh8Zkh7nQhLZnpsU@breakpoint.cc>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
 <20220302045131.387658-4-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220302045131.387658-4-tz.stoyanov@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-03-02 06:51:29 [+0200], Tzvetomir Stoyanov (VMware) wrote:
> Some zlib APIs set the errno in case of an error and return Z_ERRNO.
> In these cases, errno should not be overwritten by the tarce-cmd zlib
> wrappers.
> 
> Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-compress-zlib.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
> index 41342597..0dfd4f15 100644
> --- a/lib/trace-cmd/trace-compress-zlib.c
> +++ b/lib/trace-cmd/trace-compress-zlib.c
> @@ -33,6 +33,8 @@ static int zlib_compress(const void *in, int in_bytes, void *out, int out_bytes)
>  	case Z_STREAM_ERROR:
>  		errno = -EINVAL;
>  		break;
> +	case Z_ERRNO:
> +		break;
>  	default:
>  		errno = -EFAULT;
>  		break;
> @@ -61,6 +63,8 @@ static int zlib_decompress(const void *in, int in_bytes, void *out, int out_byte
>  	case Z_DATA_ERROR:
>  		errno = -EINVAL;
>  		break;
> +	case Z_ERRNO:
> +		break;
>  	default:
>  		errno = -EFAULT;
>  		break;

I was thinking about returning the error for compress/decompress via the
return value and not touching errno at all.

Sebastian
