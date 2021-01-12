Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8BCC4332E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 21:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D4DB23122
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 21:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390963AbhALVhd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437164AbhALVdI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 16:33:08 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF442311F;
        Tue, 12 Jan 2021 21:32:27 +0000 (UTC)
Date:   Tue, 12 Jan 2021 16:32:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Link unit test to use static local library
Message-ID: <20210112163226.53a4db07@gandalf.local.home>
In-Reply-To: <20210107083208.15967-1-tz.stoyanov@gmail.com>
References: <20210107083208.15967-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Jan 2021 10:32:08 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Unit test must test the library located in the sorce tree, instead the
> one installed in the system.

I don't think this does what you want it to do.

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  utest/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utest/Makefile b/utest/Makefile
> index 403540a..6e9c760 100644
> --- a/utest/Makefile
> +++ b/utest/Makefile
> @@ -12,7 +12,7 @@ OBJS += tracefs-utest.o
>  
>  LIBS += -lcunit				\
>  	-ldl				\
> -	-L$(obj)/lib/tracefs -ltracefs
> +	-L$(obj)/lib/tracefs -l:libtracefs.a
>  
>  OBJS := $(OBJS:%.o=$(bdir)/%.o)
>  DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)

OK, I added to src/tracefs_events.c:

void tracefs_hello(void)
{
	printf("hello world!\n");
}


And then to utest/trace-utest.c in main():

	void tracefs_hello(void);
	tracefs_hello();

And try building. It caused this:

/usr/bin/ld: /work/git/libtracefs.git/utest/trace-utest.o: in function `main':
/work/git/libtracefs.git/utest/trace-utest.c:38: undefined reference to `tracefs_hello'
collect2: error: ld returned 1 exit status

That's because I have libtracefs.a installed as well as libtracefs.so, and
it is using the system libtracefs.a and not the local one.

But by making the following change:

diff --git a/utest/Makefile b/utest/Makefile
index 6e9c760..4899365 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -12,7 +12,7 @@ OBJS += tracefs-utest.o
 
 LIBS += -lcunit				\
 	-ldl				\
-	-L$(obj)/lib/tracefs -l:libtracefs.a
+	$(obj)/lib/tracefs/libtracefs.a
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)

It builds.

I just use the full path to the library, instead of using the linker option.

-- Steve
