Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69009C4649B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 13:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 457FF218CD
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 13:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfGENbV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 09:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfGENbU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 09:31:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF42B218A3;
        Fri,  5 Jul 2019 13:31:19 +0000 (UTC)
Date:   Fri, 5 Jul 2019 09:31:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Thelen <gthelen@google.com>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: remove ununsed knuth_hash*() routines
Message-ID: <20190705093118.4af25f16@gandalf.local.home>
In-Reply-To: <20190629062752.204113-1-gthelen@google.com>
References: <20190627121542.2dc0d328@gandalf.local.home>
        <20190629062752.204113-1-gthelen@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 28 Jun 2019 23:27:52 -0700
Greg Thelen <gthelen@google.com> wrote:

> Neither 16-bit knuth_hash16() nor the 32-bit knuth_hash() are used.
> Delete them both.
> 
> And rename the remaining function: knuth_hash8() => knuth_hash()
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
>

Thanks Greg, I applied this.

Note, when sending a v2 patch, it is best to start a new thread, as
some maintainer's patch maintenance systems (including mine) have
trouble dealing with patches within threads. That is, they tend to get
lost easier.

Thanks!

-- Steve
