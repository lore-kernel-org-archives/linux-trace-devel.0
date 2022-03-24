Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88884C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 00:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346689AbiCXAKN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 20:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346802AbiCXAKE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 20:10:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135C074633
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Mar 2022 17:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40FDBB821BE
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Mar 2022 00:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EF6C340F4;
        Thu, 24 Mar 2022 00:08:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXB1K-0071SN-SS;
        Wed, 23 Mar 2022 20:08:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd library: Fix memory leak in tracecmd_close()
Date:   Wed, 23 Mar 2022 20:08:03 -0400
Message-Id: <20220324000805.1666464-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

While writing the trace-cmd analyze command, I ran valgrind on it and found
that tracecmd_close() does not clean up the page_maps that were created, at
least not when reading a v6 file.

Steven Rostedt (Google) (2):
  trace-cmd library: Use cpu_data variable to shorten commands
  trace-cmd library: Fix memory leak of page_maps

 lib/trace-cmd/trace-input.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

-- 
2.35.1

