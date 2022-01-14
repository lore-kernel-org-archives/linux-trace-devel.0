Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB480C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 20:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244321AbiANUgU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 15:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244523AbiANUgI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 15:36:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2469DC06173E
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 12:36:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2179B82A28
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 20:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAFCC36AE9;
        Fri, 14 Jan 2022 20:36:05 +0000 (UTC)
Date:   Fri, 14 Jan 2022 15:36:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] libtracefs: Unify man pages style
Message-ID: <20220114153604.3ee9a7df@gandalf.local.home>
In-Reply-To: <20220114095950.41334-2-tz.stoyanov@gmail.com>
References: <20220114095950.41334-1-tz.stoyanov@gmail.com>
        <20220114095950.41334-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 Jan 2022 11:59:49 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Man pages of the library should have consistent view. There are some
> differences in functions and arguments visualisation across current man
> pages. Made the style of all pages consistent:
>  - all function names in bold
>  - all arguments are underlined.
> Fixed also a few spelling mistakes.
> 

A patch about consistency should be consistent ;-)

> --- a/Documentation/libtracefs-hist.txt
> +++ b/Documentation/libtracefs-hist.txt
> @@ -4,7 +4,7 @@ libtracefs(3)
>  NAME
>  ----
>  tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
> -tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction
> +tracefs_hist_destroy, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction
>  tracefs_hist_echo_cmd, tracefs_hist_get_name, tracefs_hist_get_event, tracefs_hist_get_system - Create, update and describe event histograms
>  
>  SYNOPSIS
> @@ -13,68 +13,68 @@ SYNOPSIS
>  --
>  *#include <tracefs.h>*
>  
> -enum tracefs_hist_key_type {
> -	TRACEFS_HIST_KEY_NORMAL = 0,
> -	TRACEFS_HIST_KEY_HEX,
> -	TRACEFS_HIST_KEY_SYM,
> -	TRACEFS_HIST_KEY_SYM_OFFSET,
> -	TRACEFS_HIST_KEY_SYSCALL,
> -	TRACEFS_HIST_KEY_EXECNAME,
> -	TRACEFS_HIST_KEY_LOG,
> -	TRACEFS_HIST_KEY_USECS,
> -	TRACEFS_HIST_KEY_MAX
> +enum *tracefs_hist_key_type* {
> +	_TRACEFS_HIST_KEY_NORMAL_ = 0,
> +	_TRACEFS_HIST_KEY_HEX_,
> +	_TRACEFS_HIST_KEY_SYM_,
> +	_TRACEFS_HIST_KEY_SYM_OFFSET_,
> +	_TRACEFS_HIST_KEY_SYSCALL_,
> +	_TRACEFS_HIST_KEY_EXECNAME_,
> +	_TRACEFS_HIST_KEY_LOG_,
> +	_TRACEFS_HIST_KEY_USECS_,
> +	_TRACEFS_HIST_KEY_MAX_
>  };
>  

The above you have enums be underlined.


> --- a/Documentation/libtracefs-synth2.txt
> +++ b/Documentation/libtracefs-synth2.txt
> @@ -14,24 +14,24 @@ SYNOPSIS
>  --

>  
> +[verse]
> +--
>  enum tracefs_synth_handler {
> -	TRACEFS_SYNTH_HANDLE_MATCH,
> -	TRACEFS_SYNTH_HANDLE_MAX,
> -	TRACEFS_SYNTH_HANDLE_CHANGE,
> +	*TRACEFS_SYNTH_HANDLE_MATCH*,
> +	*TRACEFS_SYNTH_HANDLE_MAX*,
> +	*TRACEFS_SYNTH_HANDLE_CHANGE*,
>  };

Here they are bold.

Actually, bold is correct.

-- Steve
