Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E7ECCA47F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jun 2022 19:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiFFTaJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiFFT36 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 15:29:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF28C19C
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81ADCB81B40
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 19:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34311C3411D;
        Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyIQE-001Oym-3b;
        Mon, 06 Jun 2022 15:29:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Harald Seiler <hws@denx.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/6] libtracefs: Fixes for sqlhist
Date:   Mon,  6 Jun 2022 15:29:47 -0400
Message-Id: <20220606192953.334315-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

At Kernel Recipes, I demonstrated sqlhist and how to use it. Along the way,
I discovered several bugs. This series addresses those bugs that were found.

Steven Rostedt (Google) (6):
  libtracefs: Fix make sqlhist when built again
  libtracefs: Add libtracefs.a to dependency of sqlhist
  libtracefs: Differentiate FROM and JOIN events if they are the same
    event
  libtracefs: Use unique names for sql field variables
  libtracefs: Differentiate WHERE clause when FROM and TO events are the
    same
  libtracefs sqlhist: Report errors executing the commands

 Documentation/libtracefs-sql.txt |  18 ++++--
 include/tracefs-local.h          |   4 ++
 samples/Makefile                 |   4 +-
 src/sqlhist-parse.h              |   3 +-
 src/tracefs-hist.c               | 105 ++++++++++++++++++++++++++++---
 src/tracefs-sqlhist.c            |  44 +++++++++----
 6 files changed, 150 insertions(+), 28 deletions(-)

-- 
2.35.1

