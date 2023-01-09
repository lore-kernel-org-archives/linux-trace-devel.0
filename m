Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF64C54EBD
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 16:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjAIQmy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 11:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjAIQmx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 11:42:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F81110F5
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 08:42:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C7A8B80DFE
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 16:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C41EC433D2;
        Mon,  9 Jan 2023 16:42:49 +0000 (UTC)
Date:   Mon, 9 Jan 2023 11:42:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6] libtraceevent: Add initial support for meson
Message-ID: <20230109114247.4cc214ff@gandalf.local.home>
In-Reply-To: <20230109163659.lddjs6zb45t32hyj@carbon.lan>
References: <20230105121144.11829-1-dwagner@suse.de>
        <20230109105616.168057c3@gandalf.local.home>
        <20230109163659.lddjs6zb45t32hyj@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 9 Jan 2023 17:36:59 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> On Mon, Jan 09, 2023 at 10:56:16AM -0500, Steven Rostedt wrote:
> > Is the html files suppose to be there?  
> 
> Don't know, I wasn't able to figure out the install path by
> reading the Makefile. Where should they go?

After doing an install with the Makefiles:

# ls -l /usr/local/share/doc/libtraceevent-doc/
total 1108
-rw-r--r-- 1 root staff 29720 Jan  9 11:00 libtraceevent-commands.html
-rw-r--r-- 1 root staff 21390 Jan  9 11:00 libtraceevent-cpus.html
-rw-r--r-- 1 root staff 23701 Jan  9 11:00 libtraceevent-debug.html
-rw-r--r-- 1 root staff 21790 Jan  9 11:00 libtraceevent-endian_read.html
-rw-r--r-- 1 root staff 24278 Jan  9 11:00 libtraceevent-event_find.html
-rw-r--r-- 1 root staff 23958 Jan  9 11:00 libtraceevent-event_get.html
-rw-r--r-- 1 root staff 25273 Jan  9 11:00 libtraceevent-event_list.html
-rw-r--r-- 1 root staff 25549 Jan  9 11:00 libtraceevent-event_print.html
-rw-r--r-- 1 root staff 27448 Jan  9 11:00 libtraceevent-field_find.html
-rw-r--r-- 1 root staff 28251 Jan  9 11:00 libtraceevent-field_get_val.html
-rw-r--r-- 1 root staff 28611 Jan  9 11:00 libtraceevent-field_print.html
-rw-r--r-- 1 root staff 23027 Jan  9 11:00 libtraceevent-field_read.html
-rw-r--r-- 1 root staff 25399 Jan  9 11:00 libtraceevent-fields.html
-rw-r--r-- 1 root staff 22167 Jan  9 11:00 libtraceevent-file_endian.html
-rw-r--r-- 1 root staff 35979 Jan  9 11:00 libtraceevent-filter.html
-rw-r--r-- 1 root staff 31737 Jan  9 11:00 libtraceevent-func_apis.html
-rw-r--r-- 1 root staff 29118 Jan  9 11:00 libtraceevent-func_find.html
-rw-r--r-- 1 root staff 23775 Jan  9 11:00 libtraceevent-handle.html
-rw-r--r-- 1 root staff 23962 Jan  9 11:00 libtraceevent-header_page.html
-rw-r--r-- 1 root staff 23586 Jan  9 11:00 libtraceevent-host_endian.html
-rw-r--r-- 1 root staff 36636 Jan  9 11:00 libtraceevent.html
-rw-r--r-- 1 root staff 37832 Jan  9 11:00 libtraceevent-kbuffer-create.html
-rw-r--r-- 1 root staff 46054 Jan  9 11:00 libtraceevent-kbuffer-read.html
-rw-r--r-- 1 root staff 42977 Jan  9 11:00 libtraceevent-kbuffer-timestamp.html
-rw-r--r-- 1 root staff 48365 Jan  9 11:00 libtraceevent-kvm-plugin.html
-rw-r--r-- 1 root staff 21348 Jan  9 11:00 libtraceevent-log.html
-rw-r--r-- 1 root staff 21357 Jan  9 11:00 libtraceevent-long_size.html
-rw-r--r-- 1 root staff 22342 Jan  9 11:00 libtraceevent-page_size.html
-rw-r--r-- 1 root staff 23697 Jan  9 11:00 libtraceevent-parse_event.html
-rw-r--r-- 1 root staff 31026 Jan  9 11:00 libtraceevent-parse-files.html
-rw-r--r-- 1 root staff 22353 Jan  9 11:00 libtraceevent-parse_head.html
-rw-r--r-- 1 root staff 28187 Jan  9 11:00 libtraceevent-plugins.html
-rw-r--r-- 1 root staff 26292 Jan  9 11:00 libtraceevent-record_parse.html
-rw-r--r-- 1 root staff 32679 Jan  9 11:00 libtraceevent-reg_event_handler.html
-rw-r--r-- 1 root staff 30686 Jan  9 11:00 libtraceevent-reg_print_func.html
-rw-r--r-- 1 root staff 23539 Jan  9 11:00 libtraceevent-set_flag.html
-rw-r--r-- 1 root staff 22496 Jan  9 11:00 libtraceevent-strerror.html
-rw-r--r-- 1 root staff 30738 Jan  9 11:00 libtraceevent-tseq.html

-- Steve
