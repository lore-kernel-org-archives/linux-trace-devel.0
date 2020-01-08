Return-Path: <SRS0=VTjS=25=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D27C282DD
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jan 2020 20:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2326820720
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jan 2020 20:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgAHUJM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 15:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgAHUJM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 15:09:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E399C20720;
        Wed,  8 Jan 2020 20:09:11 +0000 (UTC)
Date:   Wed, 8 Jan 2020 15:09:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] kernel-shark: Use new tracefs library
Message-ID: <20200108150910.31167272@gandalf.local.home>
In-Reply-To: <20200106154058.60660-3-tz.stoyanov@gmail.com>
References: <20200106154058.60660-1-tz.stoyanov@gmail.com>
        <20200106154058.60660-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Jan 2020 17:40:55 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
> index d3e145c..f27fafe 100644
> --- a/kernel-shark/build/FindTraceCmd.cmake
> +++ b/kernel-shark/build/FindTraceCmd.cmake
> @@ -6,6 +6,8 @@
>  #  TRACEEVENT_FOUND, If false, do not try to use traceevent.
>  #
>  #  TRACECMD_INCLUDE_DIR, where to find trace-cmd header.
> +#  TRACEFS_INCLUDE_DIR, where to find tracefs header.
> +#  TRACEFS_LIBRARY, the tracefs library.
>  #  TRACECMD_LIBRARY, the trace-cmd library.
>  #  TRACECMD_FOUND, If false, do not try to use trace-cmd.
>  
> @@ -31,12 +33,21 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
>                                  PATHS  $ENV{TRACE_CMD}/include/
>                                         ${CMAKE_SOURCE_DIR}/../include/
>                                  NO_DEFAULT_PATH)
> +find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
> +                                PATHS  $ENV{TRACE_CMD}/include/
> +                                       ${CMAKE_SOURCE_DIR}/../include/
> +                                NO_DEFAULT_PATH)
>  
>  find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
>                                  PATHS  $ENV{TRACE_CMD}/lib/
>                                         ${CMAKE_SOURCE_DIR}/../lib/
>                                  NO_DEFAULT_PATH)
>  
> +find_library(TRACEFS_LIBRARY    NAMES  trace-cmd/libtracefs.a

I believe the above should be "tracefs/libtracefs.a" (I had to change
this to get it to compile).

-- Steve

> +                                PATHS  $ENV{TRACE_CMD}/lib/
> +                                       ${CMAKE_SOURCE_DIR}/../lib/
> +                                NO_DEFAULT_PATH)
> +
>  find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
>                                  PATHS  $ENV{TRACE_CMD}/lib/
>                                         ${CMAKE_SOURCE_DIR}/../lib/
