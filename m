Return-Path: <SRS0=6MOi=3V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_DBL_ABUSE_MALW,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49A1C33CB3
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 Feb 2020 18:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B58C1206D3
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 Feb 2020 18:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgBASO4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 1 Feb 2020 13:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgBASO4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 1 Feb 2020 13:14:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2719A206D3;
        Sat,  1 Feb 2020 18:14:55 +0000 (UTC)
Date:   Sat, 1 Feb 2020 13:14:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] MAINTAINERS: add TRACE EVENT LIBRARY section
Message-ID: <20200201131453.32018229@gandalf.local.home>
In-Reply-To: <20200201161931.29665-1-lukas.bulwahn@gmail.com>
References: <20200201161931.29665-1-lukas.bulwahn@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat,  1 Feb 2020 17:19:31 +0100
Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:

> The git history shows that the files under ./tools/lib/traceevent/ are
> being developed and maintained by Tzetomir Stoyanov and Steven Rostedt
> and are discussed on the linux-trace-devel list.
> 
> Add a suitable section in MAINTAINERS for patches to reach them.
> 
> This was identified with a small script that finds all files only
> belonging to "THE REST" according to the current MAINTAINERS file, and I
> acted upon its output.

Thanks Lukas!

Arnaldo, would you like to take this?

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Ceco, Steven, I added the information based on what I could see from an
> outsider view. Please change and more files to the entry if needed.
> 
> applies cleanly on current master and next-20200131
> 
> Ceco, congrats becoming a kernel maintainer :)
> 
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1f77fb8cdde3..17eb358c3fda 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16903,6 +16903,13 @@ T:	git git://git.infradead.org/users/jjs/linux-tpmdd.git
>  S:	Maintained
>  F:	drivers/char/tpm/
>  
> +TRACE EVENT LIBRARY
> +M:	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> +M:	Steven Rostedt <rostedt@goodmis.org>
> +L:	linux-trace-devel@vger.kernel.org
> +S:	Maintained
> +F:	tools/lib/traceevent/
> +
>  TRACING
>  M:	Steven Rostedt <rostedt@goodmis.org>
>  M:	Ingo Molnar <mingo@redhat.com>

