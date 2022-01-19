Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9C2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 15:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355981AbiASP5p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 10:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355860AbiASP5o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 10:57:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C19DC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 07:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1A976152E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 15:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC83C004E1;
        Wed, 19 Jan 2022 15:57:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nADLC-007PZf-6C;
        Wed, 19 Jan 2022 10:57:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] libtracefs: Address the comments that Tzvetomir had for the get affinity functions
Date:   Wed, 19 Jan 2022 10:57:37 -0500
Message-Id: <20220119155741.1766541-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This set fixes the issues that Tzvetomir had on the commits that added the
tracefs_instance_get_affinity*() functions.

  Link: https://lore.kernel.org/all/CAPpZLN4n=L-ZHCXM+LDRiQu0XwR4iCnGeCKJOuOWenkz2EhESA@mail.gmail.com/

Steven Rostedt (Google) (4):
  libtracefs: Add the get_affinity functions to the main libtracefs man
    page
  libtracefs: Fix typos and grammar in get_affinity man page
  libtracefs: Fix grammar in tracefs_instance_get_affinity() comment
  libtracefs: Do not count CPUs beyond set size in get_affinity

 Documentation/libtracefs-instances-affinity.txt |  4 ++--
 Documentation/libtracefs.txt                    |  3 +++
 src/tracefs-instance.c                          | 13 +++++++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

-- 
2.33.0

