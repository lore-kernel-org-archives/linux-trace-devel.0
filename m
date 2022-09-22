Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74A5ECAAD8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 01:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiIVBgj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 21:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIVBgi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 21:36:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B7B9E125
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 18:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481D162644
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 01:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE20DC433D6;
        Thu, 22 Sep 2022 01:36:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obB9m-00DrE5-1U;
        Wed, 21 Sep 2022 21:37:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     morg@google.com, "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd library: Add tracecmd_follow_event() API
Date:   Wed, 21 Sep 2022 21:37:35 -0400
Message-Id: <20220922013737.3302850-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the tracecmd_follow_event() function to make it easier for applications
to track specific events from the iterator functions.

Steven Rostedt (Google) (2):
  trace-cmd library: Add tracecmd_follow_event()
  trace-cmd library: Add man pages for iterator functions

 .../libtracecmd/libtracecmd-iterate.txt       | 291 ++++++++++++++++++
 Documentation/libtracecmd/libtracecmd.txt     |  23 ++
 include/trace-cmd/trace-cmd.h                 |   8 +
 lib/trace-cmd/trace-input.c                   | 117 ++++++-
 4 files changed, 433 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/libtracecmd/libtracecmd-iterate.txt

-- 
2.35.1

