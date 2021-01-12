Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062C0C433E9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 17:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2FDF2311D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 17:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392288AbhALR3t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:29:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387733AbhALR3t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 12:29:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5350D22285;
        Tue, 12 Jan 2021 17:29:08 +0000 (UTC)
Date:   Tue, 12 Jan 2021 12:29:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix lib audit warning message
Message-ID: <20210112122906.33c959f2@gandalf.local.home>
In-Reply-To: <CAK7tX=bWn89VxofeyK0hfb4_dQz3tKG2Y2+_47WnaYiWN5UN2w@mail.gmail.com>
References: <CAK7tX=bWn89VxofeyK0hfb4_dQz3tKG2Y2+_47WnaYiWN5UN2w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 12 Jan 2021 13:01:20 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

Hi Sameer,

> statically updated the warning message which we will get, when
> compiling trace-cmd without the libaudit library.
> 
> Following are the the messages which will pop out when compiling
> 
> Before:
> -------
> trace-profile.c:23:3: warning: #warning "lib audit not found, using
> raw syscalls " "(install libaudit-devel and try again)"
> 
> After:
> -------
> trace-profile.c:23:3: warning: #warning "lib audit not found, using
> raw syscalls " "(install libaudit-devel(for fedora) or
> libaudit-dev(for debian/ubuntu) and try again)"
> 
> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> ---
>  tracecmd/trace-profile.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
> index cfae2a2..4e5d68d 100644
> --- a/tracecmd/trace-profile.c
> +++ b/tracecmd/trace-profile.c
> @@ -21,7 +21,8 @@
> 
>  #ifdef WARN_NO_AUDIT
>  # warning "lib audit not found, using raw syscalls "    \

Your mail client turned tabs into spaces and this doesn't apply properly.
Are you able to fix that?

> -    "(install libaudit-devel and try again)"
> +    "(install libaudit-devel(for fedora) or libaudit-dev(for \
> +debian/ubuntu) and try again)"

Also, the above can stay on one line. Yes, it breaks the 80 char limit, but
that's more of a guideline and not a requirement ;-)


Care to send a v2?

Thanks!

-- Steve

>  #endif
> 
>  #define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"

