Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0174C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 16:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD2D321655
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 16:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfLLQTC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 11:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbfLLQTC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 11:19:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A7B2073B;
        Thu, 12 Dec 2019 16:19:01 +0000 (UTC)
Date:   Thu, 12 Dec 2019 11:19:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <acme@redhat.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        arnaldo.melo@gmail.com, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: allow custom libdir path
Message-ID: <20191212111900.3f46e033@gandalf.local.home>
In-Reply-To: <20191207111440.6574-1-sudipm.mukherjee@gmail.com>
References: <20191207111440.6574-1-sudipm.mukherjee@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Arnaldo,

Can you pull this patch in?

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


On Sat,  7 Dec 2019 11:14:40 +0000
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> When I use prefix=/usr and try to install libtraceevent in my laptop it
> tries to install in /usr/lib64. I am not having any folder as /usr/lib64
> and also the debian policy doesnot allow installing in /usr/lib64. It
> should be in /usr/lib/x86_64-linux-gnu/.
> 
> Quote: No package for a 64 bit architecture may install files in
> 	/usr/lib64/ or in a subdirectory of it.
> ref: https://www.debian.org/doc/debian-policy/ch-opersys.html
> 
> Make it more flexible by allowing to mention libdir_relative while
> installing so that distros can mention the path according to their policy
> or use the default one.
> 
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
> 
> Hi Steve,
> 
> And yet another one (hopefully the final one for now). I know I missed
> the merge window, but your Ack should be ok.
> 
>  tools/lib/traceevent/Makefile         | 5 +++--
>  tools/lib/traceevent/plugins/Makefile | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index c5a03356a999..7e2450ddd7e1 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -39,11 +39,12 @@ DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
>  
>  LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
>  ifeq ($(LP64), 1)
> -  libdir_relative = lib64
> +  libdir_relative_temp = lib64
>  else
> -  libdir_relative = lib
> +  libdir_relative_temp = lib
>  endif
>  
> +libdir_relative ?= $(libdir_relative_temp)
>  prefix ?= /usr/local
>  libdir = $(prefix)/$(libdir_relative)
>  man_dir = $(prefix)/share/man
> diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
> index f440989fa55e..edb046151305 100644
> --- a/tools/lib/traceevent/plugins/Makefile
> +++ b/tools/lib/traceevent/plugins/Makefile
> @@ -32,11 +32,12 @@ DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
>  
>  LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
>  ifeq ($(LP64), 1)
> -  libdir_relative = lib64
> +  libdir_relative_tmp = lib64
>  else
> -  libdir_relative = lib
> +  libdir_relative_tmp = lib
>  endif
>  
> +libdir_relative ?= $(libdir_relative_tmp)
>  prefix ?= /usr/local
>  libdir = $(prefix)/$(libdir_relative)
>  

