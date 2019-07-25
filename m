Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78718C7618B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53C6A22BF5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388308AbfGYRIk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 13:08:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47662 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387923AbfGYRIk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 13:08:40 -0400
Received: from patrickm (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id C5179348ACC;
        Thu, 25 Jul 2019 17:08:39 +0000 (UTC)
Date:   Thu, 25 Jul 2019 10:08:37 -0700
From:   Patrick McLean <chutzpah@gentoo.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Generate proper soname
Message-ID: <20190725100837.5bd4ce96@patrickm>
In-Reply-To: <20190725084932.43e05c27@gandalf.local.home>
References: <20190725014808.3646716-1-chutzpah@gentoo.org>
        <20190725084932.43e05c27@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Jul 2019 08:49:32 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 24 Jul 2019 18:48:08 -0700
> Patrick McLean <chutzpah@gentoo.org> wrote:
> 
> > From: Patrick McLean <patrick.mclean@sony.com>
> > 
> > The previous soname patch was an earlier version that included the
> > full path to the build output as the soname (not sure how that
> > happened). This just uses the basename as the soname, so ld will be
> > able to properly find the library.  
> 
> Hi Patrick,
> 
> You forgot to add the Signed-off-by, can you reply to this with one.
> Thanks. I can't add it without it.
> 
My apologies.

> -- Steve
> 

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
> > ---
> >  scripts/utils.mk | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/scripts/utils.mk b/scripts/utils.mk
> > index 9eb127d..98d7b3c 100644
> > --- a/scripts/utils.mk
> > +++ b/scripts/utils.mk
> > @@ -54,7 +54,7 @@ do_build_static_lib
> > =				\ 
> >  do_compile_shared_library =			\
> >  	($(print_shared_lib_compile)		\
> > -	$(CC) --shared $^ -Wl,-soname,$@ -o $@)
> > +	$(CC) --shared $^ -Wl,-soname,$(@F) -o $@)
> >  
> >  do_compile_plugin_obj =				\
> >  	($(print_plugin_obj_compile)		\  
> 

