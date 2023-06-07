Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E900C7EE25
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 23:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjFGXZq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 19:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjFGXZp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 19:25:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AEA2111;
        Wed,  7 Jun 2023 16:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2201B61F82;
        Wed,  7 Jun 2023 23:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFAEC4339B;
        Wed,  7 Jun 2023 23:25:43 +0000 (UTC)
Date:   Wed, 7 Jun 2023 19:25:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Subject: [ANNOUNCE] trace-cmd v3.2 is released
Message-ID: <20230607192541.25780fef@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/tag/?h=trace-cmd-v3.2

trace-cmd: Version 3.2

Features and user visible updates since 3.1.6

 - Open coded the execvp() to not start tracing until the actual path of the
   executable is found. The trace no longer contains the failed execs of
   execvp() trying various paths.

 - Add global filter support to trace-cmd read. If the -F filter is placed
   before any -i file, it will be applied to all files. Otherwise the -F filter
   will only be applied to the last file specified.

 - Added new "attach" command that can take a trace.dat file created from the host
   at the same time a trace.dat file was created on one of its guests, and be
   able to set the meta data to hook them together like if it was done via
   trace-cmd agent. This is useful for boot time tracing.

Fixes since 3.1.6

 - Fix the way filters were applied to trace-cmd report with multiple trace.dat
   files.

 - Fixed trace-cmd extract to not extract the top level buffer unless
   specifically asked to. That is, "trace-cmd extract -B foo" will only extract
   the data from foo and not the top level buffer.

 - Fixed record and extract to not destroy specified instances if they were not
   created by the record or extract.

 - Add memory (valgrind) testing to utest.

 - Add meson build support (although it's not the default yet).

https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/

Enjoy!

-- Steve
