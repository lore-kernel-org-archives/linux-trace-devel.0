Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26DFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 07:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiCBHD7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 02:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiCBHD6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 02:03:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99004B3E44
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 23:03:13 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nPJ0t-0000a0-PX; Wed, 02 Mar 2022 08:03:07 +0100
Date:   Wed, 2 Mar 2022 08:03:07 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/5] trace-cmd: Use a structure to describe a compression
 protocol
Message-ID: <Yh8Wq4KAGJ6WtqKc@breakpoint.cc>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
 <20220302045131.387658-2-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220302045131.387658-2-tz.stoyanov@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-03-02 06:51:27 [+0200], Tzvetomir Stoyanov (VMware) wrote:
> Changed the tracecmd_compress_proto_register() function to use a
> structure instead of list of arguments to describe new compression
> protocol. That approach is more flexible and allows to extend the API in
> the future without changing the already implemented protocols.
> 
> Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Thank you.

Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

> index a697cc61..8b9758c9 100644
> --- a/lib/trace-cmd/trace-compress-zlib.c
> +++ b/lib/trace-cmd/trace-compress-zlib.c
> @@ -103,7 +103,16 @@ static bool zlib_is_supported(const char *name, const char *version)
>  
>  int tracecmd_zlib_init(void)
>  {
> -	return tracecmd_compress_proto_register(__ZLIB_NAME, zlibVersion(), __ZLIB_WEIGTH,
> -						zlib_compress, zlib_decompress,
> -						zlib_compress_bound, zlib_is_supported);
> +	struct tracecmd_compression_proto proto;
> +
> +	memset(&proto, 0, sizeof(proto));
> +	proto.name = __ZLIB_NAME;
> +	proto.version = zlibVersion();
> +	proto.weight = __ZLIB_WEIGTH;
> +	proto.compress = zlib_compress;
> +	proto.uncompress = zlib_decompress;
> +	proto.is_supported = zlib_is_supported;
> +	proto.compress_size = zlib_compress_bound;

	struct tracecmd_compression_proto proto = {
		.name = __ZLIB_NAME,
		.version = zlibVersion(),
		.weight = __ZLIB_WEIGTH,
		.compress = zlib_compress,
		.uncompress = zlib_decompress,
		.is_supported = zlib_is_supported,
		.compress_size = zlib_compress_bound,
	}

this way to initialize ensures that members which are not explicitly
touched are set to 0. And you don't have to type proto that often ;)

> +
> +	return tracecmd_compress_proto_register(&proto);
>  }

Sebastian
