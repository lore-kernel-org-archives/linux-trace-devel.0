Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7332FC76190
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 23:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C13B229F3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 23:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfGYXIg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 19:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbfGYXIg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 19:08:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2CB7229F3;
        Thu, 25 Jul 2019 23:08:35 +0000 (UTC)
Date:   Thu, 25 Jul 2019 19:08:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Patrick McLean <chutzpah@gentoo.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Allow setting of the name of Python in
 pkgconfig
Message-ID: <20190725190834.2ebbe505@gandalf.local.home>
In-Reply-To: <20190725204237.3864194-1-chutzpah@gentoo.org>
References: <20190725204237.3864194-1-chutzpah@gentoo.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Jul 2019 13:42:37 -0700
Patrick McLean <chutzpah@gentoo.org> wrote:

> From: Patrick McLean <patrick.mclean@sony.com>
> 
> Some vendors use different names for Python in pkgconfig, this allows
> the name of the Python version in pkgconfig to differ from the Python
> interperter name. The default remains the Python version.

Applied. Thanks Patrick!

-- Steve

> 
> Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
> ---
>  Makefile | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 3e63e9e..3afd982 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -115,9 +115,10 @@ PYTHON		:= ctracecmd.so
>  PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
>  
>  PYTHON_VERS ?= python
> +PYTHON_PKGCONFIG_VERS ?= $(PYTHON_VERS)
>  
>  # Can build python?
> -ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo y"), y)
> +ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_PKGCONFIG_VERS) > /dev/null 2>&1 && echo y"), y)
>  	PYTHON_PLUGINS := plugin_python.so
>  	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
>  	BUILD_PYTHON_WORKS := 1
> @@ -387,8 +388,8 @@ report_nopythondev: force
>  	$(Q)echo
>  
>  ifndef NO_PYTHON
> -PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_VERS)`
> -PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
> +PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_PKGCONFIG_VERS)`
> +PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_PKGCONFIG_VERS)` \
>  		$(shell $(PYTHON_VERS)-config --ldflags)
>  PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
>  else

