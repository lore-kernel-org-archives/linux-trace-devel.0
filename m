Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44DCEB64DD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjHKFZf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjHKFZf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0882D43
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:25:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3160761000
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0B5C433C7;
        Fri, 11 Aug 2023 05:25:33 +0000 (UTC)
Date:   Fri, 11 Aug 2023 01:25:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 5/6] libtraceeval histogram: Fix the return value of
 traceeval_query()
Message-ID: <20230811012531.574327e7@gandalf.local.home>
In-Reply-To: <20230810174750.GA1961992@google.com>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
        <20230809031313.1298605-6-rostedt@goodmis.org>
        <20230810174750.GA1961992@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 10 Aug 2023 11:47:50 -0600
Ross Zwisler <zwisler@google.com> wrote:

> On Tue, Aug 08, 2023 at 11:13:12PM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > The comments state that traceeval_query() returns 1 if found, 0 if not,
> > and -1 on error, but in reality it returns 0 if found and 1 if not found.  
> 
> The comment currently says:
> 
> > /*
> >  * Find the entry that @keys corresponds to within @teval.
> >  *
> >  * Returns 0 on success, 1 if no match found, -1 on error.
> >  */  
> 
> I think this needs to be updated to match the new logic (1=found, 0=not
> found, -1=error)
> 

Yeah, but I believe Stevie's latest version fixed all this.

-- Steve
