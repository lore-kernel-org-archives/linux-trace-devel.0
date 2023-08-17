Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D27C5479A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 21:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355010AbjHQU7b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355102AbjHQU7O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:59:14 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F9AD3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:59:13 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-790f0276911so7431439f.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692305952; x=1692910752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B8BOkTcflJNLdej79sIfmgUPs+VwJsYiEYSc7H1c4XI=;
        b=EnoIWPQiXYpQkRA2CKYyOsrmCrYPhBzyKuBm/dk/VXZZmaUQrbcbI1YvUc/90rkcP2
         9E8zwqiI2aqzMgd0kbU2U7rYpwpOlURiNwfnJLQ407dvJIlYCixG7blFG4QJwPAaK/N9
         YsR+Wjfvplrlvins0HWHtHAQ7SSQmTRad37484c5MWBZyILeeJ/aVbp+VZK/BcwLwi5z
         wRxrNfKsq5qIUL45tD+Zx3Nrf5sJojWwou9PaANNnY4ulZT0VAAhGIBvEPfzQGoWfcG2
         TEjgcmvUJPLaNNu7GbHogg1PxET4kqO1kIW338J60q7k0ivNw+Kb1NJiUubwdv6fvayL
         sD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692305952; x=1692910752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8BOkTcflJNLdej79sIfmgUPs+VwJsYiEYSc7H1c4XI=;
        b=ikAftV2DU+GSszRg1nCvmVjES9E1kjY7nEBaIcEh5K92TzYpvBGvu1F194///NuXQL
         o3aYbyXf66vyn91/i4UsJDNmqNaljFPxG8dTrKgPVTu3vxSfTTepNKW8EI06r40CJ4ey
         lW+PseRmkIcpQH8EV5hy2Jb8czFdJplv0J2AOFwZkaCysfCsVPNY0E8WPL5km3VTvwxs
         mXoEyC6icbPCaaiXXWjs0TX5MeI02PZd0BR4Y/20FDIgGCbs2SDHU0uoz0aGjW2n3TMo
         cYOGdsAoQBWCI9L0ZMlbNDU1FIkp2E8Q7fb16zVv5cJVXr3DjYSc2D7VcGVQ/+G+Wi/E
         1xuA==
X-Gm-Message-State: AOJu0YxjVr1LIIqHJQOefp98170EoU6hBvUbduv7fqT+d+f8tmY8B4ys
        1ns/7GaCNXEZb2ZPWnhrs4jxyA==
X-Google-Smtp-Source: AGHT+IE3O/7eWSpBmfi3hNFUOKCNpO7L5t3NYQTKnIKR5r50h/GuUJ69nkz2rVbikC2WtFyrQfnFPw==
X-Received: by 2002:a6b:f305:0:b0:791:35ed:cd64 with SMTP id m5-20020a6bf305000000b0079135edcd64mr966038ioh.16.1692305952374;
        Thu, 17 Aug 2023 13:59:12 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:b4cc:633b:f35:be2e])
        by smtp.gmail.com with ESMTPSA id ei9-20020a05663829a900b0042bb296863asm78279jab.56.2023.08.17.13.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 13:59:11 -0700 (PDT)
Date:   Thu, 17 Aug 2023 14:59:08 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v4 00/20] libtraceeval histogram: Updates
Message-ID: <20230817205908.GD73817@google.com>
References: <20230817204528.114577-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 04:45:08PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> This patch set is based on top of:
> 
>  https://lore.kernel.org/all/20230809175340.3066-1-stevie.6strings@gmail.com/
> 
> I added a sample program task-eval which is one of the tools that will be
> using this library. The first patch adds task-eval but that is still using
> the old API (defined in trace-analysis.c).
> 
> The next patches modify the new API to fit with the use case of task-eval.
> One is to use "pointer" as I'm not sure exactly the usecase of the dynamic
> structure.
> 
> The cmp and release callbacks are changed to be more generic, and they get
> called if they simply exist for a given type. I can imagine wanting a
> release function for event the most mundane types (like number_32).
> 
> The cmp was also updated to pass in the traceeval descriptor, as I found
> that I needed access to it while doing a compare (although, I rewrote the
> code a bit where that use case isn't in the tool anymore).
> 
> Some fixes were made to the query.
> 
> I also did a bit of code restructuring and add the hash and iterator logic.
> 
> The last patch updates the sample code task-eval.c and has it give pretty
> much the same logic as the original.
> 
> That sample could be updated to implement the code consolidation that Ross
> suggested. I may do that later.
> 
> Happy programming!

Looks good, you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>
> 
> Changes since v3: https://lore.kernel.org/all/20230817013310.88582-1-rostedt@goodmis.org/
> 
> - Added patch to reordered the parameters of copy_traceeval_data() and renamed
>   copy to dst and orig to src to match that of memcpy() and strcpy().
> 
> - Added patch to rename copy_traceeval_data_set() to dup_traceeval_data_set()
>   to not have the parameter order to be confusing with the typical copy order.
> 
> - Fixed comment of traceeval_remove() (Ross Zwisler)
> 
> Changes since v2: https://lore.kernel.org/all/20230811053940.1408424-1-rostedt@goodmis.org/
> 
>   - Fixed comments on traceeval_dyn_release_fn and traceeval_dyn_cmp_fn (Ross Zwisler)
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
>   - Fixed resetting iter->next = 0 in traceeval_iterator_sort_custom() (Ross Zwisler)
> 
>   - Added failure checks to task-eval.c sample for all traceeval_query() calls.
> 
>   - Added traceeval_remove() to remove an item from traceveal (opposite of traceeval_insert())
> 
> Changes since v1: https://lore.kernel.org/all/20230809031313.1298605-1-rostedt@goodmis.org/
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
> Steven Rostedt (Google) (20):
>   libtraceeval histograms: Fix traceeval_results_release() error message
>   libtraceeval: Reverse params of copy_traceeval_data()
>   libtraceeval: Rename copy_traceeval_data_set() to dup_traceeval_data()
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
>  src/histograms.c         | 945 ++++++++++++++++++++++++++++----------
>  9 files changed, 2023 insertions(+), 301 deletions(-)
>  delete mode 100644 include/traceeval-test.h
>  create mode 100644 samples/Makefile
>  create mode 100644 samples/task-eval.c
>  create mode 100644 src/eval-local.h
>  create mode 100644 src/hash.c
> 
> -- 
> 2.40.1
> 
