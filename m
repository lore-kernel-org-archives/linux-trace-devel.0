Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86336C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 21:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243954AbhKXVb3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:31:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232874AbhKXVb1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 16:31:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CFCE61039;
        Wed, 24 Nov 2021 21:28:16 +0000 (UTC)
Date:   Wed, 24 Nov 2021 16:28:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V7 01/14] rtla: Real-Time Linux Analysis tool
Message-ID: <20211124162814.352ad8fd@gandalf.local.home>
In-Reply-To: <7c776914f3316cf6b5c21ec01b1e4eae497bb510.1635535309.git.bristot@kernel.org>
References: <cover.1635535309.git.bristot@kernel.org>
        <7c776914f3316cf6b5c21ec01b1e4eae497bb510.1635535309.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 29 Oct 2021 21:26:04 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> The rtla is a meta-tool that includes a set of commands that aims
> to analyze the real-time properties of Linux. But instead of testing
> Linux as a black box, rtla leverages kernel tracing capabilities to
> provide precise information about the properties and root causes of
> unexpected results.
> 
> rtla --help works and provide information about the available options.
> 
> This is just the "main" and the Makefile, no function yet.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Tom Zanussi <zanussi@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Clark Williams <williams@redhat.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: linux-rt-users@vger.kernel.org
> Cc: linux-trace-devel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
> ---
>  tools/tracing/rtla/Makefile   | 76 +++++++++++++++++++++++++++++++++++
>  tools/tracing/rtla/src/rtla.c | 72 +++++++++++++++++++++++++++++++++
>  2 files changed, 148 insertions(+)
>  create mode 100644 tools/tracing/rtla/Makefile
>  create mode 100644 tools/tracing/rtla/src/rtla.c
> 
> diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
> new file mode 100644
> index 000000000000..33f154f86519
> --- /dev/null
> +++ b/tools/tracing/rtla/Makefile
> @@ -0,0 +1,76 @@
> +NAME	:=	rtla
> +VERSION	:=	0.3
> +
> +# From libtracefs:
> +# Makefiles suck: This macro sets a default value of $(2) for the
> +# variable named by $(1), unless the variable has been set by
> +# environment or command line. This is necessary for CC and AR
> +# because make sets default values, so the simpler ?= approach
> +# won't work as expected.
> +define allow-override
> +  $(if $(or $(findstring environment,$(origin $(1))),\
> +            $(findstring command line,$(origin $(1)))),,\
> +    $(eval $(1) = $(2)))
> +endef
> +
> +# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
> +$(call allow-override,CC,$(CROSS_COMPILE)gcc)
> +$(call allow-override,AR,$(CROSS_COMPILE)ar)
> +$(call allow-override,STRIP,$(CROSS_COMPILE)strip)
> +$(call allow-override,PKG_CONFIG,pkg-config)
> +$(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
> +$(call allow-override,LDCONFIG,ldconfig)
> +
> +INSTALL	=	install
> +FOPTS	:=	-flto=auto -ffat-lto-objects -fexceptions -fstack-protector-strong \
> +		-fasynchronous-unwind-tables -fstack-clash-protection
> +WOPTS	:= 	-Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
> +
> +TRACEFS_HEADERS	:= $$($(PKG_CONFIG) --cflags libtracefs)
> +
> +CFLAGS	:=	-O -g -DVERSION=\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(TRACEFS_HEADERS)
> +LDFLAGS	:=	-ggdb
> +LIBS	:=	-ltracefs -ltraceevent -lprocps

For the -ltracefs and -ltracevent, you could use:

   $$($PKG_CONFIG) --libs libtracefs)

which would be more robust.

-- Steve

> +
> +SRC	:=	$(wildcard src/*.c)
> +HDR	:=	$(wildcard src/*.h)
> +OBJ	:=	$(SRC:.c=.o)
> +DIRS	:=	src
> +FILES	:=	Makefile
> +CEXT	:=	bz2
> +TARBALL	:=	$(NAME)-$(VERSION).tar.$(CEXT)
> +TAROPTS	:=	-cvjf $(TARBALL)
> +BINDIR	:=	/usr/bin
> +DATADIR	:=	/usr/share
> +DOCDIR	:=	$(DATADIR)/doc
> +MANDIR	:=	$(DATADIR)/man
> +LICDIR	:=	$(DATADIR)/licenses
> +
