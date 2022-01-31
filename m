Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592DDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Jan 2022 16:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380521AbiAaQgw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 11:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380522AbiAaQgu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 11:36:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2E7C06173D
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 08:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE535B82B5A
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 16:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4414C340ED;
        Mon, 31 Jan 2022 16:36:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nEZfa-00BYag-PP;
        Mon, 31 Jan 2022 11:36:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] libtracefs: synthetic event fixes
Date:   Mon, 31 Jan 2022 11:36:38 -0500
Message-Id: <20220131163642.2754485-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

While working on some utilities to create synthetic events, I was testing on
both older (4.19) and newer kernels and found a few bugs along the way.

This fixes a memory initialization issue, and errors in displaying commands to
create synthetic events that work on both new and older kernels.

Steven Rostedt (Google) (4):
  libtracefs: Initialized func_list in tracefs_filter_functions()
  libtracefs: Fix tracefs_synth_echo_cmd()
  libtracefs: Check README to know if we should do old onmatch format
  libtracefs: Have synthetic events use types pid_t, gfp_t and bool

 src/tracefs-hist.c  | 53 ++++++++++++++++++++++++++++++++++++++++-----
 src/tracefs-tools.c |  2 +-
 2 files changed, 49 insertions(+), 6 deletions(-)

-- 
2.33.0

