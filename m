Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5C0C54EBD
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 15:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjAIP4X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 10:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjAIP4W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 10:56:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0673015F1F
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 07:56:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B281FB80D68
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 15:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7AFC433EF;
        Mon,  9 Jan 2023 15:56:17 +0000 (UTC)
Date:   Mon, 9 Jan 2023 10:56:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6] libtraceevent: Add initial support for meson
Message-ID: <20230109105616.168057c3@gandalf.local.home>
In-Reply-To: <20230105121144.11829-1-dwagner@suse.de>
References: <20230105121144.11829-1-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  5 Jan 2023 13:11:44 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> Introduce Meson as build framework for building libtraceevent.
> 
> The build steps are:
> 
>   # configure using .build as build directory and install destination
>   # /tmp/test
>   meson setup --prefix=/tmp/libtraceevent .build
> 
>   # trigger the build
>   meson compile -C .build
> 
>   # In case you want to build the documentation, trigger the
>   # build via the 'docs' target:
>   meson compile -C build docs
> 
>   # install the library (and documentation)
>   meson install -C .build

So I followed the above steps, and when I did:

$ ls -l /tmp/libtraceevent
total 1108
drwxr-xr-x 3 rostedt rostedt    60 Jan  9 10:49 lib
drwxr-xr-x 3 rostedt rostedt    60 Jan  9 10:49 include
drwxr-xr-x 3 rostedt rostedt    60 Jan  9 10:49 share
-rw-r--r-- 1 rostedt rostedt 23539 Jan  9 10:49 libtraceevent-set_flag.html
-rw-r--r-- 1 rostedt rostedt 31026 Jan  9 10:49 libtraceevent-parse-files.html
-rw-r--r-- 1 rostedt rostedt 36636 Jan  9 10:49 libtraceevent.html
-rw-r--r-- 1 rostedt rostedt 21390 Jan  9 10:49 libtraceevent-cpus.html
-rw-r--r-- 1 rostedt rostedt 23962 Jan  9 10:49 libtraceevent-header_page.html
-rw-r--r-- 1 rostedt rostedt 21790 Jan  9 10:49 libtraceevent-endian_read.html
-rw-r--r-- 1 rostedt rostedt 32679 Jan  9 10:49 libtraceevent-reg_event_handler.html
-rw-r--r-- 1 rostedt rostedt 24278 Jan  9 10:49 libtraceevent-event_find.html
-rw-r--r-- 1 rostedt rostedt 23586 Jan  9 10:49 libtraceevent-host_endian.html
-rw-r--r-- 1 rostedt rostedt 23775 Jan  9 10:49 libtraceevent-handle.html
-rw-r--r-- 1 rostedt rostedt 30738 Jan  9 10:49 libtraceevent-tseq.html
-rw-r--r-- 1 rostedt rostedt 35979 Jan  9 10:49 libtraceevent-filter.html
-rw-r--r-- 1 rostedt rostedt 48365 Jan  9 10:49 libtraceevent-kvm-plugin.html
-rw-r--r-- 1 rostedt rostedt 25273 Jan  9 10:49 libtraceevent-event_list.html
-rw-r--r-- 1 rostedt rostedt 22342 Jan  9 10:49 libtraceevent-page_size.html
-rw-r--r-- 1 rostedt rostedt 37832 Jan  9 10:49 libtraceevent-kbuffer-create.html
-rw-r--r-- 1 rostedt rostedt 23697 Jan  9 10:49 libtraceevent-parse_event.html
-rw-r--r-- 1 rostedt rostedt 23958 Jan  9 10:49 libtraceevent-event_get.html
-rw-r--r-- 1 rostedt rostedt 26292 Jan  9 10:49 libtraceevent-record_parse.html
-rw-r--r-- 1 rostedt rostedt 42977 Jan  9 10:49 libtraceevent-kbuffer-timestamp.html
-rw-r--r-- 1 rostedt rostedt 22496 Jan  9 10:49 libtraceevent-strerror.html
-rw-r--r-- 1 rostedt rostedt 31737 Jan  9 10:49 libtraceevent-func_apis.html
-rw-r--r-- 1 rostedt rostedt 46054 Jan  9 10:49 libtraceevent-kbuffer-read.html
-rw-r--r-- 1 rostedt rostedt 29118 Jan  9 10:49 libtraceevent-func_find.html
-rw-r--r-- 1 rostedt rostedt 28187 Jan  9 10:49 libtraceevent-plugins.html
-rw-r--r-- 1 rostedt rostedt 28611 Jan  9 10:49 libtraceevent-field_print.html
-rw-r--r-- 1 rostedt rostedt 22167 Jan  9 10:49 libtraceevent-file_endian.html
-rw-r--r-- 1 rostedt rostedt 25399 Jan  9 10:49 libtraceevent-fields.html
-rw-r--r-- 1 rostedt rostedt 21357 Jan  9 10:49 libtraceevent-long_size.html
-rw-r--r-- 1 rostedt rostedt 25549 Jan  9 10:49 libtraceevent-event_print.html
-rw-r--r-- 1 rostedt rostedt 21348 Jan  9 10:49 libtraceevent-log.html
-rw-r--r-- 1 rostedt rostedt 23701 Jan  9 10:49 libtraceevent-debug.html
-rw-r--r-- 1 rostedt rostedt 22353 Jan  9 10:49 libtraceevent-parse_head.html
-rw-r--r-- 1 rostedt rostedt 23027 Jan  9 10:49 libtraceevent-field_read.html
-rw-r--r-- 1 rostedt rostedt 28251 Jan  9 10:49 libtraceevent-field_get_val.html
-rw-r--r-- 1 rostedt rostedt 29720 Jan  9 10:49 libtraceevent-commands.html
-rw-r--r-- 1 rostedt rostedt 30686 Jan  9 10:49 libtraceevent-reg_print_func.html
-rw-r--r-- 1 rostedt rostedt 27448 Jan  9 10:49 libtraceevent-field_find.html


Is the html files suppose to be there?

-- Steve
