Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C172C6FA90
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiIVA2o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiIVA2n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:28:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52D7A8976
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73716B83347
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33624C4347C;
        Thu, 22 Sep 2022 00:28:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA61-00Dr58-04;
        Wed, 21 Sep 2022 20:29:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/5] trace-cmd library: Update the man pages
Date:   Wed, 21 Sep 2022 20:29:35 -0400
Message-Id: <20220922002940.3302285-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The man pages for trace-cmd library is out of date. Add the check logic to
make sure everything that is in the header file is documented, and all man
pages are also in the libtracecmd man page.

Steven Rostedt (Google) (5):
  tracecmd library documentation: Use star and not underscore for
    function names
  trace-cmd library: Make tracecmd_filter_match() local
  libtracecmd: Add check-manpages.sh
  libtracecmd: Add a man pages for handling of time stamps
  libtracecmd: Add documentation on tracecmd_set/get_private()

 .../libtracecmd/libtracecmd-files.txt         | 110 ++++++++------
 .../libtracecmd/libtracecmd-instances.txt     |  32 ++--
 Documentation/libtracecmd/libtracecmd-log.txt |  12 +-
 .../libtracecmd/libtracecmd-peer.txt          |  16 +-
 .../libtracecmd/libtracecmd-record.txt        |  36 ++---
 .../libtracecmd/libtracecmd-timestamp.txt     | 138 ++++++++++++++++++
 Documentation/libtracecmd/libtracecmd.txt     |  14 +-
 Makefile                                      |   5 +-
 check-manpages.sh                             |  54 +++++++
 include/trace-cmd/trace-cmd.h                 |   2 -
 lib/trace-cmd/include/trace-cmd-local.h       |   3 +
 lib/trace-cmd/trace-filter.c                  |   4 +-
 12 files changed, 326 insertions(+), 100 deletions(-)
 create mode 100644 Documentation/libtracecmd/libtracecmd-timestamp.txt
 create mode 100755 check-manpages.sh

-- 
2.35.1

