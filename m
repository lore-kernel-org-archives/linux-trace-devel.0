Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7EBC5ACA0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354805AbjHQUOM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354683AbjHQUOF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:14:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A50359B
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:14:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-26d12558d63so122122a91.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692303243; x=1692908043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/X08wKLfufSrZhXIc50Jy6PCmcukLocDBZcVoT76y0=;
        b=VLej+uPSoZdUXA/g5UsqjEjgEt+COVudaCl3b2pv0V4pBzxUmtUQ81aFXRIE0/lrRc
         d+6IQfJmu1RQnr8MNdaaC71wLSjgDetD0SPMbUz8KXQaqIE3a1G6Hn4IA2J4ILW8Bib3
         47oUDKhG5Gx7cdztG8PZlx0fkyK2H4fIYSrXHsea/gLAntAY7aBv6wdG+CqszdEwDqF2
         dqSMnloX/NoaT+npJxocR4WuxyB1i+nmkFTgIO8OoDlVAnkjfM0m1U9J8S/3s50Y1Su9
         OiBTQ3VPgDOM0bW+4NLFsvohFhqG/Tn1QWHPUzie9oznuPwhMcwvC3iBERe1F/y9s8oZ
         CIaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692303243; x=1692908043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q/X08wKLfufSrZhXIc50Jy6PCmcukLocDBZcVoT76y0=;
        b=l4bgDNrDrxRq2qgylhx07f5/6uYhxsiHONMMjMuMbcKy4PPh0KuRFtUbxSA/I3Wy0l
         9733xFxV9nvEV57g/G8H5YU7X2PlbVQhscupsVG6lAmz+fTfU6DdHEFgbAgQVYAp0L4Z
         /eklHKKa0taPZlWOl22LKuzF/VdQDdE/G5pVsHr5+0qAd148w6VLsqyKwTQ4Wp06DSQi
         27sVr6zyCFjeKxTDepFxlvWRpYmx5oXqiS0UOsarc/Uu7e5oU/dr/F5ByC48hpNRvrfq
         qnxuG2XYj9W9H1Q6RjY54nPQvAYbWdJnXIaJ0cIikvAIqqoj4P2UZ/8bbKBClSzIIzZw
         xHRw==
X-Gm-Message-State: AOJu0YywcG5Lyx8x8/29MfkV9WE5aIuvUbxyr2AVSILC2nVAbV0KhcH0
        LrMKTMBYU/ib00bOa8HxNbZFwKwSv5XuWuZkJVv24ibVHgT9W/UIgli//Q==
X-Google-Smtp-Source: AGHT+IFd2JLEV/RqY2cpw3bUPYvwe0av5mQE6ztitJukZTjnGDgi/mgDBPqW5WJdjWTy6CBtACSIGMWfRqON3ACTA28=
X-Received: by 2002:a17:90a:883:b0:267:f094:afcf with SMTP id
 v3-20020a17090a088300b00267f094afcfmr503475pjc.12.1692303243361; Thu, 17 Aug
 2023 13:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230817013310.88582-1-rostedt@goodmis.org>
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
From:   Ross Zwisler <zwisler@google.com>
Date:   Thu, 17 Aug 2023 14:13:52 -0600
Message-ID: <CAGRrVHxQTxNBJ-wTKEgxQb1suhCipWX_ZLk9L3-Hb2MwvWhTfg@mail.gmail.com>
Subject: Re: [PATCH v3 00/18] libtraceeval histogram: Updates
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Aug 16, 2023 at 7:33=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> This patch set is based on top of:
>
>  https://lore.kernel.org/all/20230809175340.3066-1-stevie.6strings@gmail.=
com/
>
> I added a sample program task-eval which is one of the tools that will be
> using this library. The first patch adds task-eval but that is still usin=
g
> the old API (defined in trace-analysis.c).
>
> The next patches modify the new API to fit with the use case of task-eval=
.
> One is to use "pointer" as I'm not sure exactly the usecase of the dynami=
c
> structure.
>
> The cmp and release callbacks are changed to be more generic, and they ge=
t
> called if they simply exist for a given type. I can imagine wanting a
> release function for event the most mundane types (like number_32).
>
> The cmp was also updated to pass in the traceeval descriptor, as I found
> that I needed access to it while doing a compare (although, I rewrote the
> code a bit where that use case isn't in the tool anymore).
>
> Some fixes were made to the query.
>
> I also did a bit of code restructuring and add the hash and iterator logi=
c.
>
> The last patch updates the sample code task-eval.c and has it give pretty
> much the same logic as the original.
>
> That sample could be updated to implement the code consolidation that Ros=
s
> suggested. I may do that later.
>
> Happy programming!
>
>
> Changes since v2: https://lore.kernel.org/all/20230811053940.1408424-1-ro=
stedt@goodmis.org/
>
>   - Fixed comments on traceeval_dyn_release_fn and traceeval_dyn_cmp_fn (=
Ross Zwisler)
>
>   - Change parameter ordering of compare_traceeval_data (Ross Zwisler)
>
>   - Added (size_t) to offset_of() macro (Ross Zwisler)
>
>   - Fixed iter->current_bucket off by one bug (Ross Zwisler)
>
>   - Removed HASH_MASK() from make_hash()
>
>   - Fixed goto fail_release in traceeval_init() (Ross Zwisler)
>
>   - Free sort and direction in traceeval_iterator_put() (Ross Zwisler)
>
>   - Use num_levels variable instead of (level + 1) (Ross Zwisler)
>
>   - Return 0 on success of update_entry (Ross Zwisler)
>
>   - Fixed the cleanup of old values in update_entry() (Ross Zwisler)
>
>   - Fixed resetting iter->next =3D 0 in traceeval_iterator_sort_custom() =
(Ross Zwisler)
>
>   - Added failure checks to task-eval.c sample for all traceeval_query() =
calls.
>
>   - Added traceeval_remove() to remove an item from traceveal (opposite o=
f traceeval_insert())

I think you've addressed all my review comments, you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>

to the series.  Thanks!

>
> Changes since v1: https://lore.kernel.org/all/20230809031313.1298605-1-ro=
stedt@goodmis.org/
>
>  - Lots!
>
>    - Converted to using a hash table
>
>    - Removed the unused compare code. With the other updates, it was
>      taking too much time to keep updating them.
>
>    - Added checks and labels to the types to have them know what type
>      they are, and index they are at.
>
>    - Added stat logic
>
>    - Added iterator logic
>
>    - Have a working sample with the new code!
>
>
> Steven Rostedt (Google) (18):
>   libtraceeval histograms: Fix traceeval_results_release() error message
>   libtraceeval: Add sample task-eval program
>   libtraceeval hist: Add pointer and const string types
>   libtraceeval histogram: Have cmp and release functions be generic
>   libtraceeval histograms: Add traceeval struct to compare function
>   libtraceeval histogram: Remove comparing of traceeval and types
>   libtraceeval: Convert hist array into a hash table
>   libtraceeval histograms: Move hash functions into their own file
>   libtraceeval histogram: Label and check keys and values
>   libtraceeval histogram: Add updating of stats
>   libtraceeval histogram: Add iterator APIs
>   libtraceeval histogram: Add data copy callback
>   libtraceeval histogram: Do the release on updates
>   libtraceeval histogram: Use stack for old copy in update
>   libtraceeval histogram: Add traceeval_iterator_sort_custom()
>   libtraceeval histogram: Have traceeval_query() just give the pointer
>     to results
>   libtraceeval samples: Update task-eval to use the histogram logic
>   libtraceeval: Add traceeval_remove()
>
>  Makefile                 |   4 +-
>  include/traceeval-hist.h | 117 +++--
>  include/traceeval-test.h |  16 -
>  samples/Makefile         |  29 ++
>  samples/task-eval.c      | 966 +++++++++++++++++++++++++++++++++++++++
>  src/Makefile             |   1 +
>  src/eval-local.h         | 123 +++++
>  src/hash.c               | 123 +++++
>  src/histograms.c         | 923 +++++++++++++++++++++++++++----------
>  9 files changed, 2012 insertions(+), 290 deletions(-)
>  delete mode 100644 include/traceeval-test.h
>  create mode 100644 samples/Makefile
>  create mode 100644 samples/task-eval.c
>  create mode 100644 src/eval-local.h
>  create mode 100644 src/hash.c
>
> --
> 2.40.1
>
