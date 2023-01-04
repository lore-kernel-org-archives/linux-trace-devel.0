Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99116C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240082AbjADR1C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240106AbjADR1A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:27:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E3921BF
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93527B81891
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480B3C433EF;
        Wed,  4 Jan 2023 17:26:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pD7XU-000bsL-0T;
        Wed, 04 Jan 2023 12:26:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtraceevent: Remove duplicate man page functions
Date:   Wed,  4 Jan 2023 12:26:53 -0500
Message-Id: <20230104172655.145516-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When Daniel Wagner was working on converting the Makefiles over to meson, he
found that there were two functions that were duplicated in the man pages.
This causes issues with meson in the build process.

Not only remove the duplicate functions, but also update the check-manpages.sh
script to catch duplicates in the future.

Steven Rostedt (Google) (2):
  libtraceevent: Add check for duplicate functions in man pages
  libtraceevent: Remove tep_find_function{_address}() from
    libtraceevent-func_apis.txt

 Documentation/libtraceevent-func_apis.txt | 26 ++++-------------------
 check-manpages.sh                         |  9 +++++++-
 2 files changed, 12 insertions(+), 23 deletions(-)

-- 
2.35.1

