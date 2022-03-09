Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE79C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Mar 2022 16:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbiCIQrU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Mar 2022 11:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiCIQpq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Mar 2022 11:45:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE1DC484C
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Mar 2022 08:39:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 088BCB82164
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Mar 2022 16:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3AFC340E8;
        Wed,  9 Mar 2022 16:39:34 +0000 (UTC)
Date:   Wed, 9 Mar 2022 11:39:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cmd: Use builtin for offset_of
Message-ID: <20220309113932.0ed90ffb@gandalf.local.home>
In-Reply-To: <20220309043815.1301991-1-irogers@google.com>
References: <20220309043815.1301991-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  8 Mar 2022 20:38:15 -0800
Ian Rogers <irogers@google.com> wrote:

> Arithmetic on null pointers is undefined behavior, spotted by C compiler
> sanitizers such as with clang. The builtin offset of is available in all
> recent compilers, so unconditionally use it as discussed for libbpf in:
> https://lore.kernel.org/all/a0a26308-a1d7-a57c-727c-000652a5d246@fb.com/

Applied, thanks Ian!

-- Steve

> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tracecmd/include/list.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/include/list.h b/tracecmd/include/list.h
> index cf9dd47e..fa0de6df 100644
> --- a/tracecmd/include/list.h
> +++ b/tracecmd/include/list.h
> @@ -6,7 +6,7 @@
>  #ifndef __LIST_H
>  #define __LIST_H
>  
> -#define offset_of(type, field)		(long)(&((type *)0)->field)
> +#define offset_of(type, field)		__builtin_offsetof(type, field)
>  #define container_of(p, type, field)	(type *)((long)p - offset_of(type, field))
>  
>  struct list_head {

