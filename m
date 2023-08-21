Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A73EE4996
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Aug 2023 14:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbjHUOdB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 10:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbjHUOdB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 10:33:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A5EE3
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Aug 2023 07:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7115B63A1C
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Aug 2023 14:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAB6C433C8;
        Mon, 21 Aug 2023 14:32:58 +0000 (UTC)
Date:   Mon, 21 Aug 2023 10:33:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 2/9] libtraceeval: Add traceeval_iterator_query()
Message-ID: <20230821103312.24e2d34e@gandalf.local.home>
In-Reply-To: <20230820181801.GA5956@3xKetch>
References: <20230817222422.118568-1-rostedt@goodmis.org>
        <20230817222422.118568-3-rostedt@goodmis.org>
        <20230820181801.GA5956@3xKetch>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 20 Aug 2023 14:18:01 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> > +/**
> > + * traceeval_iterator_query - return the results of the last entry in the iterator  
> 
> Nit, 'last entry' made me think you were referring to the *last* entry.
> Maybe say previous entry instead?

Good point. hmm, what about:

  - return the results from the current entry in the iterator

as traceeval_iterator_next() really just updates the "current" entry.

-- Steve
