Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2911C7EE29
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 23:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbjFGX1g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 19:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjFGX1g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 19:27:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66025268F;
        Wed,  7 Jun 2023 16:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECE90618BF;
        Wed,  7 Jun 2023 23:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA603C433D2;
        Wed,  7 Jun 2023 23:27:32 +0000 (UTC)
Date:   Wed, 7 Jun 2023 19:27:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Subject: [ANNOUNCE] libtracecmd v1.4 is released
Message-ID: <20230607192730.0e9dd418@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/tag/?h=libtracecmd-1.4.0

libtracecmd: version 1.4

Changes since v1.3.1

New API:

 - tracecmd_get_tsc2nsec() retrieve the conversion numbers used to convert the
   timestamp into nanoseconds (if the data file has it).

Fixes:

 - Unlock the records in tracecmd_iterate_events(), as if a callback were to
   exit out early, it would fail to free the records that were cached.

 - Fix tracecmd_compress_copy_from() as it was returning 4 bytes less than the
   size for compressed sections.

https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/

Enjoy!

-- Steve
