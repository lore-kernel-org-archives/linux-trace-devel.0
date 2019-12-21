Return-Path: <SRS0=3JjO=2L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21938C43603
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 02:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED0A32070C
	for <linux-trace-devel@archiver.kernel.org>; Sat, 21 Dec 2019 02:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfLUCec (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 21:34:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfLUCec (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 21:34:32 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61D622070C;
        Sat, 21 Dec 2019 02:34:31 +0000 (UTC)
Date:   Fri, 20 Dec 2019 21:34:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v18 03/18] trace-cmd: Add implementations of htonll()
 and ntohll()
Message-ID: <20191220213428.45544b28@rorschach.local.home>
In-Reply-To: <20191213153029.133570-4-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
        <20191213153029.133570-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ Replying this time to the latest version. Same comment though ]

On Fri, 13 Dec 2019 17:30:14 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> 
> Implementations of htonll() and ntohll() are added as
> macros, if they are not already defined.
> 

I'm somewhat nervous about this being in a global header, as it is
mostly generic. I wonder if we should prefix these with "tracecmd_"
just to avoid any name collisions.

We could update this later when we make trace-cmd into a library.

-- Steve


> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  include/trace-cmd/trace-msg.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/trace-cmd/trace-msg.h b/include/trace-cmd/trace-msg.h
> index aab8a69..654ca43 100644
> --- a/include/trace-cmd/trace-msg.h
> +++ b/include/trace-cmd/trace-msg.h
> @@ -12,4 +12,14 @@
>  
>  extern unsigned int page_size;
>  
> +#ifndef htonll
> +# if __BYTE_ORDER == __LITTLE_ENDIAN
> +#define htonll(x) __bswap_64(x)
> +#define ntohll(x) __bswap_64(x)
> +#else
> +#define htonll(x) (x)
> +#define ntohll(x) (x)
> +#endif
> +#endif
> +
>  #endif /* _TRACE_MSG_H_ */

