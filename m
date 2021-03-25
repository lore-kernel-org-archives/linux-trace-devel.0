Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF52C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 21:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA8261A3C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 21:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCYVYQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 17:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhCYVX7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 17:23:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22250619BF;
        Thu, 25 Mar 2021 21:23:59 +0000 (UTC)
Date:   Thu, 25 Mar 2021 17:23:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>
Subject: [ANNOUNCE] trace-cmd 2.9.2
Message-ID: <20210325172357.6e059c31@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I'm happy to announce trace-cmd version 2.9.2!

*** NOTICE ***

This is the last version that is self contained for interacting
with the tracefs directory and parsing the events.

The parsing of events is now a separate repository:

  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

And the access to the tracefs directory is here:

  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

After this release, trace-cmd will depend on those repositories and
its internal copies will be removed. Please install those libraries
for future building of trace-cmd.


*** NOTICE 2 ***

KernelShark is now in its own repository (and will depend on libtracecmd
in this repo, but has not been officially released just yet, but soon!).
This is the last version that will home KernelShark in this repository.

KernelShark now lives here:

  https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/

After this release, "make gui" will no longer build KernelShark.

*** END NOTICES ***

Features and user visible updates since 2.9.1:

- Will use system libraries libtraceevent and libtracefs if they are
  present and will only build the local versions if they are not.

- The saved comms are stored at the end of running a trace-cmd record
  to be able to get the names of what is running after they ran.

- trace-cmd clear is now instance aware.

- New trace-cmd report --ts-check option to check if timestamps are
  monotonic.

- New "make uninstall" to remove an installed instance of trace-cmd
  executables and libraries.

- Added make-trace-cmd.sh script as a template on how to install the
  libraries and executables.

For more information, please visit https://www.trace-cmd.org.

-- Steve
