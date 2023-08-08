Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DFFC001DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 18:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbjHHSgc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 14:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbjHHSgI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 14:36:08 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F942D1E7
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 11:02:00 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-40fcc91258fso39228711cf.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 11:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691517719; x=1692122519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZISvlB1ysjmWaBQhPed18MmpC58ubp1jFjtsobwcSs=;
        b=OacVwzc32idKmRzHgmye7R98zCDhi+Ud6MH6NfCgMBN/1AfKEO+qsJLKPXe00wIObj
         W+Hp/UgoarG54t2go89quZPRbIes7vVxXw6Ia7qXs/gRgZQFrgmD7kHN3yRa5B1ZQHLG
         AqkHzCnGNvAIw/JPWXgMUFxURpLV8ltRUKYYEcimVDyJQ3GcLqDyHNYvEqAHjMAuo3QN
         Z2DP1KsZ+BZFYFbpPRpfppzaX2Lokij6erOoknmuoRFcqWeTBZBDlM12ufHZr8BdDurd
         QOlmrCICTK+XLhFg7ZpO6clxC005wSqbfgREYIL90Rj7xhaa7Z4xciuSiriL3RjvmCbo
         cZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691517719; x=1692122519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZISvlB1ysjmWaBQhPed18MmpC58ubp1jFjtsobwcSs=;
        b=GQi9gU4A25qkTqONiPkIIU0OqtNptxk2j2KJ0o5gimB9cxh7Novvghsi7e91WFruUm
         O0tFeSvl2KwtLsCORE0KWSHZ4EkRJFhRdYS6zbw4QUOl3PDzX4Qw3jB5SgMHrDmMzZRu
         EGuuYUsoN+iYoc9V/vGd+7F5tXH87lipVEEJeSkHwiYl+72H12J1D/gYTtYihvFZFbv/
         WzIdLxIZysi84uwV349Hj3sXay0ElFc/oui7fkCxYCzawxtyxi5mCfvChXEdzGg5Ip3g
         zTKvNW/8uamqDReZSQyEVbZYouOGOsBUb8oth8EGPC10D6WI79tBM2iF5rnipQimtJqg
         5jKw==
X-Gm-Message-State: AOJu0YxIxwRuPLNmStZb7QbYg8htiGv1zH3L8UeDIQwkKmB8VG2DW4uM
        A3Ed/Qb8Y8b7dFSEuQ9oniSE9avsZsM=
X-Google-Smtp-Source: AGHT+IHBlQZ8/gX/r9N7KTMGSIp8/4SATYN/D5T8+UBsDgvf7pgkmXiC/oCXq4YhP2T1oVgHNrnCGw==
X-Received: by 2002:ac8:5c02:0:b0:40f:f17e:9adf with SMTP id i2-20020ac85c02000000b0040ff17e9adfmr458113qti.47.1691517719334;
        Tue, 08 Aug 2023 11:01:59 -0700 (PDT)
Received: from 3xKetch ([2601:180:8300:500::6aa8])
        by smtp.gmail.com with ESMTPSA id m25-20020aed27d9000000b0040fe0fdf555sm3542653qtg.22.2023.08.08.11.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 11:01:58 -0700 (PDT)
Date:   Tue, 8 Aug 2023 14:01:56 -0400
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v3 0/6] histograms: Add query and insert
Message-ID: <20230808180156.GA1300@3xKetch>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808161204.5704-1-stevie.6strings@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 12:11:53PM -0400, Stevie Alvarez wrote:
> From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> 
> Changes in v3:
>  * Added traceeval_query() and traceeval_results_release().
>  * Added traceeval_insert().
>  * Reordered enum traceeval_data_type for logical numeric use.
>  * Reordered traceeval_type fields for legibility.
>  * Removed traceeval_flag's STAT as numerics will aggregate by default.
>  * Declared traceeval_type before dyn function typedefs.
>  * Changed dyn_release call's argument to pointer offset for legibility.
>  * Changed dyn_release signature's argument order for legibility.
>  * Removed traceeval_iterator since it isn't used.
>  * Moved type_alloc()'s for-loop's semi-colon to a new line for legibility.
>  * Made lables less verbose.
>  * Updated type_alloc's error messages.
>  * type_alloc() frees allocated data on error instead of traceeval_init().
>  * Squashed initialize and release patches as init depends on release.
>  * Capitalized first letter of error messages.
>  * Added error message for clean_data() if data exists without defs.
>  * Aligned all function parameters with opening parenthesis.
>  * Remove compare and testing patches, beyond current scope of project.
> ---
> v2 discussion: https://lore.kernel.org/linux-trace-devel/20230804083737.0d8f1d95@gandalf.local.home/T/#t
> 
> Stevie Alvarez (Google) (6):
>   histograms: Initial histograms interface
>   histograms: Add traceeval initialize and release
>   histograms: Add traceeval compare
>   histograms: Add traceeval query
>   histograms: Add traceeval insert
>   histograms: Initial unit tests

The patch series counts six patches total, but you may notice that only
five were sent. The last patch, 'Initial unit tests,' was purposefully
not included, since it's beyond the current scope of the project. My
apologies for the confusion.

-- Stevie
> 
>  Makefile                 |   2 +-
>  include/traceeval-hist.h | 147 ++++++++
>  include/traceeval-test.h |  16 +
>  src/Makefile             |   1 +
>  src/histograms.c         | 792 +++++++++++++++++++++++++++++++++++++++
>  utest/.gitignore         |   1 +
>  utest/Makefile           |  35 ++
>  utest/eval-test.h        |  13 +
>  utest/eval-utest.c       |  28 ++
>  utest/traceeval-utest.c  | 290 ++++++++++++++
>  10 files changed, 1324 insertions(+), 1 deletion(-)
>  create mode 100644 include/traceeval-hist.h
>  create mode 100644 include/traceeval-test.h
>  create mode 100644 src/histograms.c
>  create mode 100644 utest/.gitignore
>  create mode 100644 utest/Makefile
>  create mode 100644 utest/eval-test.h
>  create mode 100644 utest/eval-utest.c
>  create mode 100644 utest/traceeval-utest.c
> 
> -- 
> 2.41.0
> 
