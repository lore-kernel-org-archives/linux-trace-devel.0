Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0E4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Apr 2022 17:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350641AbiD1RxJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 13:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350640AbiD1RxI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 13:53:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA26BAB98
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 10:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98040B82EA7
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 17:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61709C385A0;
        Thu, 28 Apr 2022 17:49:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nk8H0-003LWB-77;
        Thu, 28 Apr 2022 13:49:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd: Still work without memfd_create()
Date:   Thu, 28 Apr 2022 13:49:47 -0400
Message-Id: <20220428174949.797657-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As some systems do not implement memfd_create() be able to fallback to the
tempfile method.

Depends on: https://lore.kernel.org/r/20220405192204.1551283-1-joel@joelfernandes.org
https://patchwork.kernel.org/project/linux-trace-devel/patch/20220405192204.1551283-1-joel@joelfernandes.org/

Steven Rostedt (Google) (2):
  trace-cmd Makefile: Change test-build to link as well
  trace-cmd agent: Test if memfd_create() is available

 Makefile                                          | 13 +++++++++++--
 lib/trace-cmd/include/private/trace-cmd-private.h |  5 +++++
 lib/trace-cmd/trace-msg.c                         |  8 ++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

-- 
2.35.1

