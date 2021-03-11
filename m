Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E193CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 876F264FAA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhCKOJ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:09:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233071AbhCKOJt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 09:09:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF11B64FA9;
        Thu, 11 Mar 2021 14:09:48 +0000 (UTC)
Date:   Thu, 11 Mar 2021 09:09:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michal Sojka <michal.sojka@cvut.cz>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
Message-ID: <20210311090946.7d24cb40@gandalf.local.home>
In-Reply-To: <20210311131221.13600-1-michal.sojka@cvut.cz>
References: <20210311131221.13600-1-michal.sojka@cvut.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Mar 2021 14:12:21 +0100
Michal Sojka <michal.sojka@cvut.cz> wrote:

Hi Michal,

Thanks for the fix!

Note, even when submitting an "obvious" patch, it's always good to add some
content to the change log body. Basically, why it shouldn't be hard coded.
That is, what failed because of it. I can think of a few things, but we try
to have content in the change log body for all commits, even obvious ones.
The only exception is spelling fixes don't need content.

Thanks!

-- Steve


> ---
>  kernel-shark/src/CMakeLists.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
> index 457c100..687e150 100644
> --- a/kernel-shark/src/CMakeLists.txt
> +++ b/kernel-shark/src/CMakeLists.txt
> @@ -92,7 +92,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
>              DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
>  
>      install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
> -            DESTINATION /usr/share/polkit-1/actions/)
> +            DESTINATION ${_INSTALL_PREFIX}/share/polkit-1/actions/)
>  
>      install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
>              DESTINATION ${_INSTALL_PREFIX}/bin/)

