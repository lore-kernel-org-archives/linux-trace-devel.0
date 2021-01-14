Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A307EC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jan 2021 02:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64488235E4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jan 2021 02:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbhANCEz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:04:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729568AbhANCEo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jan 2021 21:04:44 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BA4923442;
        Thu, 14 Jan 2021 02:04:03 +0000 (UTC)
Date:   Wed, 13 Jan 2021 21:04:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix lib audit warning message
Message-ID: <20210113210401.4299b2ed@oasis.local.home>
In-Reply-To: <1610606688-5186-1-git-send-email-sameeruddin.shaik8@gmail.com>
References: <1610606688-5186-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Jan 2021 12:14:48 +0530
Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

Thanks Sameer!

Just FYI, this isn't that important for this patch, but just to inform
you about basic procedures (we follow the Linux kernel method). When
sending a second version of the patch, add a "v2" to the subject. That
is, "[PATCH v2] trace-cmd: Fix lib audit warning message". Then below
the Signed-off-by (after the "---") add a section of "Changes since
v1:" that gives a brief list of changes that were made in the new
version. But again, not a big deal for this one, but something to be
aware of for future patches :)

Anyway, I did a preliminary test, and it looks like you this applies
without issue. I'll add it tomorrow. Thanks!

-- Steve


> statically updated the warning message which we will get, when
> compiling trace-cmd without the libaudit library.
> 
> Following are the the messages which will pop out when compiling
> 
> Before:
> -------
> trace-profile.c:23:3: warning: #warning "lib audit not found, using raw syscalls " "(install libaudit-devel and try again)"
> 
> After:
> -------
> trace-profile.c:23:3: warning: #warning "lib audit not found, using raw syscalls " "(install libaudit-devel(for fedora) or libaudit-dev(for debian/ubuntu) and try again)"
> 
> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> ---
>  tracecmd/trace-profile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
> index cfae2a2..9b5c385 100644
> --- a/tracecmd/trace-profile.c
> +++ b/tracecmd/trace-profile.c
> @@ -21,7 +21,7 @@
>  
>  #ifdef WARN_NO_AUDIT
>  # warning "lib audit not found, using raw syscalls "	\
> -	"(install libaudit-devel and try again)"
> +	"(install libaudit-devel(for fedora) or libaudit-dev(for debian/ubuntu) and try again)"
>  #endif
>  
>  #define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"

