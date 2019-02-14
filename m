Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55886C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 17:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EBA521928
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 17:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436957AbfBNRcm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395162AbfBNRcl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 12:32:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F46321928;
        Thu, 14 Feb 2019 17:32:40 +0000 (UTC)
Date:   Thu, 14 Feb 2019 12:32:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [PATCH 3/3] trace-cmd: Removed some unused #includes
Message-ID: <20190214123238.0acabfc6@gandalf.local.home>
In-Reply-To: <20190214140723.27804-3-kaslevs@vmware.com>
References: <20190214140723.27804-1-kaslevs@vmware.com>
        <20190214140723.27804-3-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Feb 2019 16:07:23 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> This patch removes several unused #include directives.
> 
> No changes in behaviour intended.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  lib/trace-cmd/trace-input.c    | 9 ---------
>  lib/trace-cmd/trace-recorder.c | 9 +--------
>  2 files changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index b628570..34a8301 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -4,22 +4,13 @@
>   *
>   */
>  #define _LARGEFILE64_SOURCE
> -#include <dirent.h>
>  #include <stdbool.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> -#include <string.h>
> -#include <getopt.h>
> -#include <stdarg.h>
> -#include <sys/types.h>
> -#include <sys/stat.h>
> -#include <sys/wait.h>
>  #include <sys/mman.h>
> -#include <pthread.h>
>  #include <regex.h>
>  #include <fcntl.h>
>  #include <unistd.h>
> -#include <ctype.h>
>  #include <errno.h>
>  
>  #include <linux/time64.h>
> diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
> index 1b6a995..0b8d98a 100644
> --- a/lib/trace-cmd/trace-recorder.c
> +++ b/lib/trace-cmd/trace-recorder.c
> @@ -4,18 +4,11 @@
>   *
>   */
>  #define _LARGEFILE64_SOURCE
> -#include <dirent.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> -#include <string.h>
> -#include <stdarg.h>
> -#include <sys/types.h>
> -#include <sys/stat.h>
> -#include <sys/wait.h>
> -#include <pthread.h>
>  #include <fcntl.h>
> +#include <time.h>
>  #include <unistd.h>
> -#include <ctype.h>
>  #include <errno.h>
>  
>  #include "trace-cmd.h"

Nice cleanup.

Just an FYI, even on random patches, it's still good to have a cover
email for more than one patch series "[PATCH 0/3]", as it organizes it
better in inboxes.

BTW, I applied all of these.

Thanks Slavomir!

-- Steve
