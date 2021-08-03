Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A475AC4320A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 866AF6104F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhHCQs0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234696AbhHCQsZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 12:48:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28006604AC;
        Tue,  3 Aug 2021 16:48:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxaO-002uUY-Tz; Tue, 03 Aug 2021 12:48:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/7] libtracefs: Updates to the histograms for tracefs_sql()
Date:   Tue,  3 Aug 2021 12:48:04 -0400
Message-Id: <20210803164811.693731-1-rostedt@goodmis.org>
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

Changes since v1:

 - Fixed tracefs_synth_get_start_hist() when more than one key existed.

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
 src/tracefs-hist.c                  | 326 +++++++++++++++++-----------
 5 files changed, 665 insertions(+), 192 deletions(-)
 create mode 100644 Documentation/libtracefs-synth2.txt

-- 
2.30.2

