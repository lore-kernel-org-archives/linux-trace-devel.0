Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9962C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 01:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B01CE6143E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 01:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhD2BUI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 21:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhD2BUI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 21:20:08 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56FAB6143D;
        Thu, 29 Apr 2021 01:19:22 +0000 (UTC)
Date:   Wed, 28 Apr 2021 21:19:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] trace-cmd library: Bump the trace file version to 7
Message-ID: <20210428211920.001a66c8@oasis.local.home>
In-Reply-To: <20210422071718.483383-2-tz.stoyanov@gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
        <20210422071718.483383-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 22 Apr 2021 10:17:13 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Adding a compression of the trace.dat file will change its structure.
> These changes are not backward compatible, the old trace-cmd binaries
> will not be able to read compressed trace files. Bumping the version to
> 7 will prevent old trace-cmd to read such files.

But this series doesn't add anything to the file that breaks the
version. The version should be updated with the patch that breaks the
backward compatibility. of the file, not before.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/include/trace-cmd-local.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index e8533b22..5578f00d 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -14,7 +14,7 @@ void tracecmd_warning(const char *fmt, ...);
>  void tracecmd_fatal(const char *fmt, ...);
>  
>  /* trace.dat file format version */
> -#define FILE_VERSION 6
> +#define FILE_VERSION 7
>  
>  #define _STR(x)	#x
>  #define STR(x)	_STR(x)

