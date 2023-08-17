Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C616FC2FC23
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347548AbjHQBdP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347551AbjHQBdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:33:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7985A1FC3
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CE0664A9B
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12275C43395;
        Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWRst-000N3b-1J;
        Wed, 16 Aug 2023 21:33:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 00/18] libtraceeval histogram: Updates
Date:   Wed, 16 Aug 2023 21:32:52 -0400
Message-Id: <20230817013310.88582-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This patch set is based on top of:

 https://lore.kernel.org/all/20230809175340.3066-1-stevie.6strings@gmail.com/

I added a sample program task-eval which is one of the tools that will be
using this library. The first patch adds task-eval but that is still using
the old API (defined in trace-analysis.c).

The next patches modify the new API to fit with the use case of task-eval.
One is to use "pointer" as I'm not sure exactly the usecase of the dynamic
structure.

The cmp and release callbacks are changed to be more generic, and they get
called if they simply exist for a given type. I can imagine wanting a
release function for event the most mundane types (like number_32).

The cmp was also updated to pass in the traceeval descriptor, as I found
that I needed access to it while doing a compare (although, I rewrote the
code a bit where that use case isn't in the tool anymore).

Some fixes were made to the query.

I also did a bit of code restructuring and add the hash and iterator logic.

The last patch updates the sample code task-eval.c and has it give pretty
much the same logic as the original.

That sample could be updated to implement the code consolidation that Ross
suggested. I may do that later.

Happy programming!


Changes since v2: https://lore.kernel.org/all/20230811053940.1408424-1-rostedt@goodmis.org/

  - Fixed comments on traceeval_dyn_release_fn and traceeval_dyn_cmp_fn (Ross Zwisler)

  - Change parameter ordering of compare_traceeval_data (Ross Zwisler)

  - Added (size_t) to offset_of() macro (Ross Zwisler)

  - Fixed iter->current_bucket off by one bug (Ross Zwisler)

  - Removed HASH_MASK() from make_hash()

  - Fixed goto fail_release in traceeval_init() (Ross Zwisler)

  - Free sort and direction in traceeval_iterator_put() (Ross Zwisler)

  - Use num_levels variable instead of (level + 1) (Ross Zwisler)

  - Return 0 on success of update_entry (Ross Zwisler)

  - Fixed the cleanup of old values in update_entry() (Ross Zwisler)

  - Fixed resetting iter->next = 0 in traceeval_iterator_sort_custom() (Ross Zwisler)

  - Added failure checks to task-eval.c sample for all traceeval_query() calls.

  - Added traceeval_remove() to remove an item from traceveal (opposite of traceeval_insert())

Changes since v1: https://lore.kernel.org/all/20230809031313.1298605-1-rostedt@goodmis.org/

 - Lots!

   - Converted to using a hash table

   - Removed the unused compare code. With the other updates, it was
     taking too much time to keep updating them.

   - Added checks and labels to the types to have them know what type
     they are, and index they are at.

   - Added stat logic

   - Added iterator logic

   - Have a working sample with the new code!


Steven Rostedt (Google) (18):
  libtraceeval histograms: Fix traceeval_results_release() error message
  libtraceeval: Add sample task-eval program
  libtraceeval hist: Add pointer and const string types
  libtraceeval histogram: Have cmp and release functions be generic
  libtraceeval histograms: Add traceeval struct to compare function
  libtraceeval histogram: Remove comparing of traceeval and types
  libtraceeval: Convert hist array into a hash table
  libtraceeval histograms: Move hash functions into their own file
  libtraceeval histogram: Label and check keys and values
  libtraceeval histogram: Add updating of stats
  libtraceeval histogram: Add iterator APIs
  libtraceeval histogram: Add data copy callback
  libtraceeval histogram: Do the release on updates
  libtraceeval histogram: Use stack for old copy in update
  libtraceeval histogram: Add traceeval_iterator_sort_custom()
  libtraceeval histogram: Have traceeval_query() just give the pointer
    to results
  libtraceeval samples: Update task-eval to use the histogram logic
  libtraceeval: Add traceeval_remove()

 Makefile                 |   4 +-
 include/traceeval-hist.h | 117 +++--
 include/traceeval-test.h |  16 -
 samples/Makefile         |  29 ++
 samples/task-eval.c      | 966 +++++++++++++++++++++++++++++++++++++++
 src/Makefile             |   1 +
 src/eval-local.h         | 123 +++++
 src/hash.c               | 123 +++++
 src/histograms.c         | 923 +++++++++++++++++++++++++++----------
 9 files changed, 2012 insertions(+), 290 deletions(-)
 delete mode 100644 include/traceeval-test.h
 create mode 100644 samples/Makefile
 create mode 100644 samples/task-eval.c
 create mode 100644 src/eval-local.h
 create mode 100644 src/hash.c

-- 
2.40.1

