Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB21AC41513
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 19:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjHITEn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjHITEm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 15:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD72E71
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 12:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBBE0644DC
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 19:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E5FC433C7;
        Wed,  9 Aug 2023 19:04:38 +0000 (UTC)
Date:   Wed, 9 Aug 2023 15:04:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v4 2/5] histograms: Add traceeval initialize and release
Message-ID: <20230809150403.109d6c49@gandalf.local.home>
In-Reply-To: <20230809175340.3066-3-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
        <20230809175340.3066-3-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  9 Aug 2023 13:53:35 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> 
> traceeval_init() creates a new struct traceeval instance with regards
> to the struct traceeval_type array arguments keys and vals. These arrays
> define the structure of the histogram, with each describing the expected
> structure of inserted arrays of union traceeval_data. The keys and vals
> arguments are copied on the heap to ensure that the struct traceeval
> instance has access to the definition regardless of how the user
> initialized keys and vals.
> 
> traceeval_init() uses traceeval_release() and it's helper functions to
> clean up on error.
> 
> traceeval_release() deconstructs a given struct traceeval instance. It
> frees any data allocated to the heap within the entries to the histogram,
> and the names allocated for the struct traceeval_type key-value
> definitions.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  Makefile                 |   2 +-
>  include/traceeval-hist.h |   7 +
>  src/Makefile             |   1 +
>  src/histograms.c         | 315 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 324 insertions(+), 1 deletion(-)
>  create mode 100644 src/histograms.c
> 
> diff --git a/Makefile b/Makefile
> index 4a24d5a..3ea051c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -172,7 +172,7 @@ libs: $(LIBRARY_A) $(LIBRARY_SO)
>  
>  VALGRIND = $(shell which valgrind)
>  UTEST_DIR = utest
> -UTEST_BINARY = trace-utest
> +UTEST_BINARY = eval-utest
>  

I forgot to mention this in previous reviews. I'm assuming this was a
leftover from previous versions?

Rest of this patch looks good.

-- Steve


>  test: force $(LIBRARY_STATIC)
>  ifneq ($(CUNIT_INSTALLED),1)
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 3565756..63e8b0e 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -127,4 +127,11 @@ struct traceeval_iterator;
>  
