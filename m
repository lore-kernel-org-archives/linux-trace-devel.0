Return-Path: <SRS0=NQzT=3J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C17C32771
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7360B22522
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgATWdi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgATWdi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 17:33:38 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C1CD217F4;
        Mon, 20 Jan 2020 22:33:37 +0000 (UTC)
Date:   Mon, 20 Jan 2020 17:33:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: generate cscope.files when building cscope
 index
Message-ID: <20200120173335.7ec9609f@rorschach.local.home>
In-Reply-To: <20200112190537.170197-1-marcgonzalez@google.com>
References: <20200112190537.170197-1-marcgonzalez@google.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 12 Jan 2020 14:05:37 -0500
Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:

> Currently, running 'make cscope' gives this output:

Hi Marcelo!

> 
> rm -f cscope*
> find . -name '\.pc' -prune -o -name '*\.[ch]' -print -o -name '*\.[ch]pp' ! -name '\.#' -print | cscope -b -q
> cscope: no source files found
> make: *** [Makefile:351: cscope] Error 1
> 
> By default, cscope looks in cscope.files for the list of
> sources, so printing the source file list to this file
> fixes the above error.
> 
> Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
> ---
>  Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index efd9ed4..0b15bf5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -348,7 +348,8 @@ TAGS:	force
>  
>  cscope: force
>  	$(RM) cscope*
> -	$(call find_tag_files) | cscope -b -q
> +	$(call find_tag_files) > cscope.files
> +	cscope -b -q

I think the following should work too, without the need to create an
extra file:

diff --git a/Makefile b/Makefile
index efd9ed4b..782df41b 100644
--- a/Makefile
+++ b/Makefile
@@ -348,7 +348,7 @@ TAGS:	force
 
 cscope: force
 	$(RM) cscope*
-	$(call find_tag_files) | cscope -b -q
+	$(call find_tag_files) | cscope -b -q -i-
 
 install_plugins_traceevent: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins install_plugins


Care to test it out. And feel free to resend this version.

Thanks!

-- Steve
