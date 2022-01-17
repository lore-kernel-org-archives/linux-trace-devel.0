Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E7FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 23:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbiAQXWP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 18:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiAQXWO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 18:22:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6571C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 15:22:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7C46120A
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 23:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504FFC36AE7;
        Mon, 17 Jan 2022 23:22:13 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n9bKG-006fYr-8G;
        Mon, 17 Jan 2022 18:22:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs/Documentation: Fix up man pages
Date:   Mon, 17 Jan 2022 18:22:07 -0500
Message-Id: <20220117232210.1589656-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs-hist.txt and libtracefs-synth2.txt had more than 9 functions
defined in them. When that happens, the man page build process starts spitting
out errors. Split out some of the functions into their own man pages to keep
all man pages under the limit of 9.

Also, the SEE ALSO section underlined the commands when they should have been
bold. Fix them and a couple of other command references.

Steven Rostedt (3):
  libtracefs: Split up libtracefs-hist.txt man page
  libtracefs: Split up libtracefs-synth2.txt man page
  libtracefs/Documentation: Referencing commands should be bold not
    underlined

 Documentation/libtracefs-dynevents.txt        |   6 +-
 Documentation/libtracefs-eprobes.txt          |   6 +-
 Documentation/libtracefs-error.txt            |   6 +-
 Documentation/libtracefs-events-tep.txt       |   8 +-
 Documentation/libtracefs-events.txt           |   6 +-
 Documentation/libtracefs-files.txt            |   6 +-
 Documentation/libtracefs-filter.txt           |  28 +-
 Documentation/libtracefs-function-filter.txt  |   6 +-
 Documentation/libtracefs-hist-cont.txt        |  28 +-
 Documentation/libtracefs-hist-mod.txt         | 540 ++++++++++++++++++
 Documentation/libtracefs-hist.txt             | 142 +----
 .../libtracefs-instances-affinity.txt         |   8 +-
 .../libtracefs-instances-file-manip.txt       |   6 +-
 Documentation/libtracefs-instances-files.txt  |   6 +-
 Documentation/libtracefs-instances-manage.txt |   6 +-
 Documentation/libtracefs-instances-utils.txt  |   6 +-
 Documentation/libtracefs-kprobes.txt          |   6 +-
 Documentation/libtracefs-log.txt              |   6 +-
 Documentation/libtracefs-marker.txt           |   6 +-
 Documentation/libtracefs-marker_raw.txt       |   6 +-
 Documentation/libtracefs-option-get.txt       |   6 +-
 Documentation/libtracefs-option-misc.txt      |   6 +-
 Documentation/libtracefs-options.txt          |   6 +-
 Documentation/libtracefs-sql.txt              |  52 +-
 Documentation/libtracefs-stream.txt           |   6 +-
 Documentation/libtracefs-synth-info.txt       | 298 ++++++++++
 Documentation/libtracefs-synth.txt            |  48 +-
 Documentation/libtracefs-synth2.txt           | 110 ++--
 Documentation/libtracefs-traceon.txt          |   6 +-
 Documentation/libtracefs-tracer.txt           |   6 +-
 Documentation/libtracefs-utils.txt            |   6 +-
 Documentation/libtracefs.txt                  |   4 +-
 32 files changed, 1039 insertions(+), 353 deletions(-)
 create mode 100644 Documentation/libtracefs-hist-mod.txt
 create mode 100644 Documentation/libtracefs-synth-info.txt

-- 
2.33.0

