Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB525C25B0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Aug 2022 02:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbiHSCDn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 22:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242485AbiHSCDm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 22:03:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6135B7A5
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Aug 2022 19:03:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 108BEB82508
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Aug 2022 02:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BCDC433C1;
        Fri, 19 Aug 2022 02:03:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oOrMT-0038Rl-3B;
        Thu, 18 Aug 2022 22:03:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs: Some fixes for sqlhis
Date:   Thu, 18 Aug 2022 22:03:46 -0400
Message-Id: <20220819020349.747429-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

While playing with sqlhist, I found three bugs.

 Two dealing with freeing issues.

 One where the matching is more restrictive than the kernel.

Steven Rostedt (Google) (3):
  libtracefs: Fix use after free in tracefs_synth_alloc()
  libtracefs: Remove double free attempt of new_event in
    tracefs_synth_echo_cmd()
  libtracefs sqlhist: Allow pointers to match longs

 src/tracefs-hist.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

-- 
2.35.1

