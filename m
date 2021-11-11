Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0109C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F8661354
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhKKSOX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 13:14:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhKKSOW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 13:14:22 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 438DD61268;
        Thu, 11 Nov 2021 18:11:33 +0000 (UTC)
Date:   Thu, 11 Nov 2021 13:11:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Jerome Marchand" <jmarchan@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracecmd: don't ignore LDFLAGS when linking the
 shared libs
Message-ID: <20211111131131.585caf0a@gandalf.local.home>
In-Reply-To: <20211111180318.499099-1-jmarchan@redhat.com>
References: <20211111180318.499099-1-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 19:03:18 +0100
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> do_compile_shared_library should't ignore LDFLAGS. That makes it
> difficult for packager to follow their distribution packaging
> guidelines.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Thanks Jerome, I'll queue this up.

Looks like libtracefs may suffer from the same issue (and libtraceevent
looks fine).

  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

Did you want to submit a patch for libtracefs too?

-- Steve

> ---
>  scripts/utils.mk | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/utils.mk b/scripts/utils.mk
> index 6865a746..53b2b074 100644
> --- a/scripts/utils.mk
> +++ b/scripts/utils.mk
> @@ -72,7 +72,7 @@ do_build_static_lib =				\
>  
>  do_compile_shared_library =			\
>  	($(print_shared_lib_compile)		\
> -	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LIBS))
> +	$(CC) --shared $^ '-Wl,-soname,$(@F),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))
>  
>  do_compile_plugin_obj =				\
>  	($(print_plugin_obj_compile)		\

