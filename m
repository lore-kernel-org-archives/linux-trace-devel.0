Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A8CC3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56E072080F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389058AbfITPU0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387520AbfITPUZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:20:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 605BE2080F;
        Fri, 20 Sep 2019 15:20:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iBKhs-0003oU-Gl; Fri, 20 Sep 2019 11:20:24 -0400
Message-Id: <20190920151526.528126066@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 20 Sep 2019 11:15:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 0/2] trace-cmd/kernel-shark: Use one quick hash algorithm
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Instead of having multiple "knuth_hash()" static functions, make one
generic tracecmd_quick_hash() function and use that. It also adds
a "bits" field so that the result can be limited to any power of
2 that is less than 2^32.


Steven Rostedt (VMware) (2):
      trace-cmd: Make a global tracecmd_quick_hash() instead of a local knuth_hash()
      kernel-shark: Increase the size of the task hash

----
 include/trace-cmd/trace-filter-hash.h | 24 ++++++++++++++++++++++++
 kernel-shark/src/libkshark.c          | 18 ++++--------------
 kernel-shark/src/libkshark.h          |  3 ++-
 lib/trace-cmd/trace-filter-hash.c     | 20 +++++---------------
 4 files changed, 35 insertions(+), 30 deletions(-)

