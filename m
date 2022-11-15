Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01069C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 20:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbiKOUxk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238610AbiKOUxQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 15:53:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E0926489
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 12:53:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2ED4CE1915
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B47CC433C1;
        Tue, 15 Nov 2022 20:53:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ov2wO-00ApFO-0D;
        Tue, 15 Nov 2022 15:53:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] trace-cmd utest: Add test for max buffer (record -m)
Date:   Tue, 15 Nov 2022 15:53:51 -0500
Message-Id: <20221115205355.2580214-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a unit test to test the trace-cmd recorcd -m <size> option where the
per_cpu buffers are capped at a maximum size. There was a bug due to the splice
code that the size was not being calculated correctly, and was becoming much
larger than specified.

In doing this, some restructuring needs to be done to make the helper functions
a bit more flexible, and some other clean ups.

Steven Rostedt (Google) (4):
  trace-cmd: Make the unit test depend on the static library
  trace-cmd: Only show unit test output when -v is supplied
  trace-cmd utest: Separate out the grep and pipes
  trace-cmd: Add test for max size option of record

 utest/Makefile         |   2 +-
 utest/tracecmd-utest.c | 187 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 170 insertions(+), 19 deletions(-)

-- 
2.35.1

