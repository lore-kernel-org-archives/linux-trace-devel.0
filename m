Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D1FC678DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355635AbjHQWJP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355706AbjHQWJA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:09:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB64010E
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498BD62FB3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C16C433C7;
        Thu, 17 Aug 2023 22:08:04 +0000 (UTC)
Date:   Thu, 17 Aug 2023 18:08:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v4 0/5] histograms: Fix memory leak, logic bugs,
 legibility
Message-ID: <20230817180809.334046b1@gandalf.local.home>
In-Reply-To: <20230809175340.3066-1-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  9 Aug 2023 13:53:33 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> 
> Changes in v4:
>  * Reorder enum traceeval_data_type numeric types for algorithmic access.
>  * Reorder union traceeval_data numeric fields for legibility.
>  * Remove parenthesis from function name in kerneldocs.
>  * Optimize logic in type_alloc().
>  * Distinguish internal vs public interfaces within include statements.
>  * Rework copy_traceeval_data() logic for legibility.
>  * Rework comparator return types to fix query and insert bugs.
>  * update_entry() frees the entries old values to avoid a memory leak.
> 
> Steven, I didn't get around to adding in the cstring field to
> traceeval_data, as I wasn't able to completely grasp what you were
> looking for. My apologies.
>

Congratulations Stevie,

Your patches are now committed:

  https://github.com/rostedt/libtraceeval/commits?author=Shiztev

-- Steve
