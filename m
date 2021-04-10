Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BA1C433B4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 13:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B18561185
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 13:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhDJNlI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Apr 2021 09:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234180AbhDJNlH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Apr 2021 09:41:07 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775BC6044F;
        Sat, 10 Apr 2021 13:40:49 +0000 (UTC)
Date:   Sat, 10 Apr 2021 09:40:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Linux-trace Users <linux-trace-users@vger.kernel.org>
Cc:     Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tony Jones <tonyj@suse.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Subject: [ANNOUNCE] libtracefs 1.1.0
Message-ID: <20210410094046.0a23f960@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I'm pleased to announce the new version of libtracefs library has been
released:

  libtracefs: 1.1.0


 https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/libtracefs-1.1.0.tar.gz
 https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/


Changes since 1.0.2:

 - Depends on libtraceevent 1.2.0 or later

 - New APIs for opening and reading ftrace files
    tracefs_instance_file_read_number()
    tracefs_instance_file_open()

 - New APIs for enable / disable tracing
    tracefs_trace_is_on()
    tracefs_trace_on()
    tracefs_trace_off()
    tracefs_trace_on_get_fd()
    tracefs_trace_on_fd()
    tracefs_trace_off_fd()

 - New APIs for trace options
    tracefs_option_set()
    tracefs_option_clear()
    tracefs_option_is_set()
    tracefs_options_get_supported()
    tracefs_option_is_supported()
    tracefs_options_get_enabled()
    tracefs_option_is_enabled()
    tracefs_option_enable()
    tracefs_option_diasble()
    tracefs_option_name()
    tracefs_option_id()
    tarcefs_option_mask_is_set()

 - New APIs for getting existing trace instance
    tracefs_instance_alloc()
    tracefs_instance_get_trace_dir()

 - New APIs to set the filtering of functions
    tracefs_function_filter()
    tracefs_function_notrace()

 - New APIs to writing strings into the tracing buffer
    tracefs_print_init()
    tracefs_printf()
    tracefs_vprintf()
    tracefs_print_close()

 - New APIs to writing binary data into the tracing buffer
    tracefs_binary_init()
    tracefs_binary_write()
    tracefs_binary_close()

 - tracefs_iterate_raw_events() now calls the callbacks in
   time stamp sorted order (instead of calling all events in
   a CPU buffer, then the next CPU buffer). Also fixed record->cpu
   to match the CPU that's also passed to the callback, instead
   of always being zero.

 - Loading of events with tracefs_local_events(),
   tracefs_local_event_system() and tracefs_fill_local_events()
   now pull in kallsyms, saved_cmdlines, and printk_format mappings
   into the tep handler.

 - New API to reload the saved_cmdlines
    tracefs_load_cmdlines()

 - Warnings now can be overwritten with tracefs_warning() and no
   longer the too generic name warning()

 - All files opened in the library now are done so with O_CLOEXEC

 - Cleaner building and installation.


-- Steve
