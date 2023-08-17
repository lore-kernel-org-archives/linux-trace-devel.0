Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C21C7112B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355686AbjHQWY1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355695AbjHQWYT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE5A30D8
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B79F06669F
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2514CC433C8;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000UsE-26;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/9] libtraceeval: Even more updates!
Date:   Thu, 17 Aug 2023 18:24:13 -0400
Message-Id: <20230817222422.118568-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

More updates to libtraceeval

- As the results and stats are often needed in the iterator loops, add helper
  functions to quickly retrieve them. The iterator has a handle on the current
  entry, no need to do a key lookup to find it.

- The iterator can be used to search for items to remove or update. Add a
  helper function to remove the current iterator item. This will also update
  the iterator so that other functions called are still safe, even if the removed
  entry is the current one.

- Convert traceeval_data into a proper structure with a "type" field and a
  union data portion. This will allow for checking the type of data being
  passed into the functions to make sure they match their corresponding types.

- Add checks to make sure that the data matches the types.

- Make traceeval_insert() and traceeval_query() into macros and add a
  traceeval_query_size() and traceeval_insert_size() that take the size of the
  list of data being passed into it. The macros work when the arrays are defined.

- Add checks to make sure the array sizes passed in match the sizes internally.

- Add back the STATS flag, and only do STATS on values that are numeric and
  have this set. This should speed things up, and also allow for optimizations
  in the future.

Steven Rostedt (Google) (9):
  libtraceeval: Add check for updates to know to recreate iter array
  libtraceeval: Add traceeval_iterator_query()
  libtraceeval: Add traceeval_iterator_stat()
  libtraceeval: Add traceeval_iterator_remove()
  libtraceeval histogram: Add type to traceeval_data and make it a
    structure
  libtraceveal: Add type checks to traceeval_data vals and keys
  libtraceeval: Add size checks to insert and query functions
  libtraceeval: Add checks to traceeval_insert() and query()
  libtraceeval: Only do stats on values marked with the STAT flag

 include/traceeval-hist.h | 102 +++++++++----
 samples/task-eval.c      | 146 ++++++++-----------
 src/eval-local.h         |   6 +-
 src/histograms.c         | 300 ++++++++++++++++++++++++++++++---------
 4 files changed, 372 insertions(+), 182 deletions(-)

-- 
2.40.1

