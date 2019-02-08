Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80639C169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 21:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59E39218FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 21:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfBHVDt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 16:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfBHVDt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 16:03:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F23FF218D2;
        Fri,  8 Feb 2019 21:03:47 +0000 (UTC)
Date:   Fri, 8 Feb 2019 16:03:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: Re: [RFC PATCH v5 00/11] Add VM kernel tracing over vsockets and
 FIFOs
Message-ID: <20190208160345.2bae842e@gandalf.local.home>
In-Reply-To: <20190204065848.8248-1-kaslevs@vmware.com>
References: <20190204065848.8248-1-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  4 Feb 2019 08:58:37 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> This patchset adds support for tracing guest kernels to trace-cmd.

IIRC, you mentioned I should ignore these because you had another
series coming? Let me know if that's not what you said.

Also, I looked at the splice code wrt. the buffer percentage. The
splice code will return if either the file descriptor has O_NONBLOCK or
the splice command has SPLICE_F_NONBLOCK set.

Or do you think that we need to do something in case the flag changes?
To make everything non-block, we need to send a single to the code,
which should cause the code to start again.

Once the trace_fd is set to O_NONBLOCK the splice fd should return
immediately when there's nothing it can read left.

-- Steve


> 
> Changes in v5:
>  - add FIFOs transport for tracing data
>  - fixed a bug in tracecmd_msg_wait_close
> 
