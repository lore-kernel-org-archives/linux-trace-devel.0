Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDCEC43214
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E716100A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhHCC7f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 22:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhHCC7e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 22:59:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D24A261037;
        Tue,  3 Aug 2021 02:59:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAkeI-002qFx-JS; Mon, 02 Aug 2021 22:59:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/7] libtracefs: Updates to the histograms for tracefs_sql()
Date:   Mon,  2 Aug 2021 22:59:14 -0400
Message-Id: <20210803025921.677469-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In preparation for tracefs_sql(), the histogram logic needs some updates.
Restructure the API a little better. Since the API has not been part of a
tagged release, it is still allowed to change.

Add a way to show a partially created synthetic event, which can be used by
tracefs_sql() for creating histograms. 

Steven Rostedt (VMware) (7):
  libtracefs: Change the tracefs_hist API to not take an instance
    immediately
  libtracefs: Expose tracefs_hist_command() as an API
  libtracefs: Add API tracefs_hist_append_filter()
  libtracefs: Add API tracefs_hist_show()
  libtracefs: Split up libtracefs-synth man page
  libtracefs: Add API tracefs_synth_get_start_hist()
  libtracefs: Add API tracefs_synth_complete()

 Documentation/libtracefs-hist.txt   | 105 +++++++--
 Documentation/libtracefs-synth.txt  |  31 +--
 Documentation/libtracefs-synth2.txt | 247 +++++++++++++++++++++
 include/tracefs.h                   | 148 ++++++++++---
 src/tracefs-hist.c                  | 325 +++++++++++++++++-----------
 5 files changed, 664 insertions(+), 192 deletions(-)
 create mode 100644 Documentation/libtracefs-synth2.txt

-- 
2.30.2

