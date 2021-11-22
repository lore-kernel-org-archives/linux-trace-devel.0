Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C548CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 09:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbhKVJj6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:39:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238829AbhKVJj5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 04:39:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2394960200;
        Mon, 22 Nov 2021 09:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637573811;
        bh=eq1ED6aEo75KazI2kql+iW+JTAl+eOmaEKchhnZV0O0=;
        h=From:To:Cc:Subject:Date:From;
        b=Jf/rY7538cwWzsILB4nTGrfHeEh/KLeakeqrcPTlg7pvwYerDmwcdKsvsSFtELna4
         j97Bo6f2Cg0XbqHGXI3TQHDH989OcUGCw2vjmr0+Eq/pD8ot38/sKk1Xx2IuuFw3MQ
         /tE3sgN+GnveWnPx19qfHujvfcmZMVJ6/+P9uAHgUAmdlOFfqhDh6GclXxDD9NpQ5H
         vavZi2PiAQMHTk5J9V1CkABOYl9gSNKwyCmBR+ph36GPF8vcEVx7bv788g9gNFiMgU
         rr5HnvWEJydRG1a/fGGqJxstZREcCx6z6FIBeSN6+0a8CWl0LtBPDufFZNGahfGdD6
         +bU5HKgI7PJOg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] libtraceevent: Add __rel_loc support
Date:   Mon, 22 Nov 2021 18:36:47 +0900
Message-Id: <163757380763.511392.6830680420693577369.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello,

Here is the patch to add new '__rel_loc' relative dynamic
array attribute support. The patch series for linux kernel
corresponding to this patch is here;

https://lore.kernel.org/all/163757340321.510314.9399950115238632705.stgit@devnote2/T/#u

(I've CC'ed to this mailing list too)

This patch is the porting of [4/5] in above patch to the
libtraceevent.

Thank you,

---

Masami Hiramatsu (1):
      libtraceevent: Add __rel_loc relative location attribute support


 src/event-parse.c  |   54 +++++++++++++++++++++++++++++++++-------------------
 src/event-parse.h  |    5 +++--
 src/parse-filter.c |    5 ++++-
 3 files changed, 41 insertions(+), 23 deletions(-)

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
