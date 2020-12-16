Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B409FC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BE01233A2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgLPU10 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727439AbgLPU10 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:27:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92BB82371F;
        Wed, 16 Dec 2020 20:26:45 +0000 (UTC)
Date:   Wed, 16 Dec 2020 15:26:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Re-enable the build of KernelShark v1
Message-ID: <20201216152643.0ae516fc@gandalf.local.home>
In-Reply-To: <20201216130715.181002-1-y.karadz@gmail.com>
References: <20201216130715.181002-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Dec 2020 15:07:15 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> libtraceevent and libtracefs are now stand-alone libraries, independent
> from trace-cmd, but nevertheless trace-cmd still provides legacy/obsolete
> versions of this libraries. Since we are "freezing" KernelShark v1 and
> all active development is now focused on  KernelShark v2, we will keep
> v1 use the legacy/obsolete versions of the libraries.
> 
> An additional problem is that trace-filter-hash.h is no longer a public
> header of libtracecmd. For this reason we are adding the path to the
> tarce-cmd private headers to the list of header file locations.
> 
> We also remove the inclusion of event-utils.h in parse-utils.c in order
> to fix a compilation error when building libtraceevent.a.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  Makefile                              | 16 ++++++++-------
>  kernel-shark/CMakeLists.txt           |  1 +
>  kernel-shark/build/FindTraceCmd.cmake | 29 ++++++---------------------
>  kernel-shark/src/libkshark.c          | 14 ++++++++-----
>  kernel-shark/src/libkshark.h          |  2 +-
>  lib/traceevent/parse-utils.c          |  2 --
>  6 files changed, 26 insertions(+), 38 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index ab91ae7..a2a41ae 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -356,13 +356,6 @@ $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
>  $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
>  	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
>  
> -gui: force
> -	$(MAKE) $(CMD_TARGETS)
> -	$(MAKE) $(kshark-dir)/build/Makefile
> -	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> -	@echo "gui build complete"
> -	@echo "  kernelshark located at $(kshark-dir)/bin"
> -
>  trace-cmd: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC_BUILD) \
>  	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
>  	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
> @@ -387,6 +380,15 @@ libtracefs.a: $(LIBTRACEFS_STATIC)
>  
>  libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD)
>  
> +gui: force
> +	$(MAKE) $(CMD_TARGETS)
> +	$(MAKE) $(LIBTRACEEVENT_STATIC)
> +	$(MAKE) $(LIBTRACEFS_STATIC)
> +	$(MAKE) $(kshark-dir)/build/Makefile
> +	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> +	@echo "gui build complete"
> +	@echo "  kernelshark located at $(kshark-dir)/bin"
> +
>

The above didn't seem to work, so I changed it to:

  gui: force $(CMD_TARGETS) $(LIBTRACEEVENT_STATIC) $(LIBTRACEFS_STATIC)
	$(MAKE) $(kshark-dir)/build/Makefile
	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
	@echo "gui build complete"
	@echo "  kernelshark located at $(kshark-dir)/bin"


And let the make dependencies do the work for us. And this appears to have
worked.

Want to send a v3?

Thanks,

-- Steve
