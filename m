Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897B1C7EE29
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 23:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbjFGX3h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 19:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbjFGX3d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 19:29:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517E42697;
        Wed,  7 Jun 2023 16:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB13B61E85;
        Wed,  7 Jun 2023 23:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CC9C433EF;
        Wed,  7 Jun 2023 23:29:30 +0000 (UTC)
Date:   Wed, 7 Jun 2023 19:29:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Subject: [ANNOUNCE] libtracefs v1.7 is released
Message-ID: <20230607192928.50b51b2b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/tag/?h=libtracefs-1.7.0

libtracefs 1.7

Changes since libtracefs 1.6.4

New API:

 - tracefs_instance_reset() to reset a tracefs instance like trace-cmd reset
   does.

 - Added keyword stacktrace to tracefs_sql() to be able to pass and set
   stacktraces between events.

 - tracefs_instance_tracers() that shows the available traces for an instance.
   Currently there's only tracefs_tracers() which only give the top level
   tracers, but instances may have a limited set.

 - tracefs_synth_set_instance() to set the instance that does the work to make
   the synthetic event such that the histograms it uses does not affect the top
   level or other instance.

 - tracefs_find_cid_pid() helper used to map the main guest thread to a given
   vsocket CID.

 - tracefs_time_conversion() helper function that does a perf system call to
   find out what the multiplier and shift that the kernel uses to calculate
   nanoseconds from the CPU time stamp counter.

 - tracefs_kprobe_destory() used to complement tracefs_kprobe_raw() and
   tracefs_kretprobe_raw(), as those do not return descriptors that can be used
   to delete the kprobe and kretprobe.

Updates:

 - Fixes to the tests.

 - Added meson build support (but it is not the default).

https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

Enjoy!

-- Steve
