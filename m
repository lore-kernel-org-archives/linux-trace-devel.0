Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C46C5479A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354824AbjHQUZd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354877AbjHQUZK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ECA35B3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11BEE6325F
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB92C433C7;
        Thu, 17 Aug 2023 20:25:04 +0000 (UTC)
Date:   Thu, 17 Aug 2023 16:25:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v3 14/18] libtraceeval histogram: Use stack for old copy
 in update
Message-ID: <20230817162510.462f2cfe@gandalf.local.home>
In-Reply-To: <20230817194459.GB73817@google.com>
References: <20230817013310.88582-1-rostedt@goodmis.org>
        <20230817013310.88582-15-rostedt@goodmis.org>
        <20230817192926.GA73817@google.com>
        <20230817154245.26b014e6@gandalf.local.home>
        <20230817194459.GB73817@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Aug 2023 13:44:59 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > I need to change the parameter names to "src" and "dst" as I can't think of
> > "orig" and "copy" as which direction they go.   
> 
> I was thinking the same thing, 'src' and 'dst' would be better. :)

and to make it even more confusing, I made made the compare callback
function ordering that of "copy, orig" ("dst, src")

 typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
                                     union traceeval_data *copy,
                                     const union traceeval_data *origin);

I've just updated my next version to start out by reversing the order of
the copy and to call it "dst" and "src", and I renamed
copy_traceveal_data_set() to dup_traceeval_data_set(), as it's just
duplicating the set, and not really "copying" it (think strdup()), as it
needs to allocate it. That way, I can keep the order, as duplication
variables should come at the end. And this will remove the ambiguity of the
copy order.

-- Steve
