Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93484C41513
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Aug 2023 19:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjHAT35 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 15:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjHAT35 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 15:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333F21BF1
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Aug 2023 12:29:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA281616C3
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD969C433C8;
        Tue,  1 Aug 2023 19:29:52 +0000 (UTC)
Date:   Tue, 1 Aug 2023 15:29:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 1/5] histograms: initial histograms interface
Message-ID: <20230801152950.788bd18a@gandalf.local.home>
In-Reply-To: <20230801190856.GA2315@3xKetch>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728162500.244f7996@rorschach.local.home>
        <20230801190856.GA2315@3xKetch>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 1 Aug 2023 15:08:56 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> > Also, for header files, functions do not need kernel doc comments. They
> > should exist in the C files where the function is described.  
> 
> As I've been updating the documentation, I keep thinking about this. Is
> there a particular reason why the documentation should reside within the
> C file rather than the header?
> When I think about using libraries, my immediate thought is to look at the
> interface/header file to see what functions are avaiable and what they do,
> not the source. I'd think that the code would jumble up my view and make
> it more cumbersome and distracting to read.
> All that said, I'm not sure sure if that's not the standard way of doing
> things here.

The reason is that users should be using the man pages that we create. But
the comment around the code is to remind us (the code developers) what the
code is for while we are developing. When I work on a function, I like to
read the comment for that function to make sure I'm not breaking anything.

In other words, users of the code should not need to be looking at the
header files (I seldom do, unless there's missing man pages). If we put the
comment by the prototype, then really nobody will be seeing it.

We will have man pages before this is fully released.

-- Steve
