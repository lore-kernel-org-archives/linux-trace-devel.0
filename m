Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F51C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jun 2022 16:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344364AbiFGQYY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243087AbiFGQYX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 12:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427666E8E8
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 09:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFDFBB821A2
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 16:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F6CC385A5;
        Tue,  7 Jun 2022 16:24:19 +0000 (UTC)
Date:   Tue, 7 Jun 2022 12:24:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd report: Explain the '-l' option better in the
 man page
Message-ID: <20220607122417.2e1ae9da@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.22.394.2206071816580.11966@hadrien>
References: <20220607113007.652e14e2@gandalf.local.home>
        <alpine.DEB.2.22.394.2206071816580.11966@hadrien>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 7 Jun 2022 18:17:22 +0200 (CEST)
Julia Lawall <julia.lawall@inria.fr> wrote:

> > +    The forth character represents the context the event was in when it triggered  
> 
> Thanks for the extra detail.
> 
> Forth should be fourth.

Bah, when people ask me what language is my mother tongue, I simply reply

   "C"


Thanks, will update.

-- Steve
