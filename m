Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3A6C31E51
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 12:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 989E320665
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 12:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfFRM6D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 08:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfFRM6D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 08:58:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10D5E20665;
        Tue, 18 Jun 2019 12:58:01 +0000 (UTC)
Date:   Tue, 18 Jun 2019 08:58:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, Troy Engel <troyengel@gmail.com>
Subject: Re: [PATCH 1/2] kernel-shark: Have "make clean" run cmake-clean.sh
Message-ID: <20190618085800.4bc0b0c9@gandalf.local.home>
In-Reply-To: <16545372-cf74-9911-542f-bcf16590c4a0@gmail.com>
References: <20190617223129.706595135@goodmis.org>
        <20190617223221.815886530@goodmis.org>
        <16545372-cf74-9911-542f-bcf16590c4a0@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 Jun 2019 13:54:30 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> I agree with all functional changes in those patches. However, the 
> README file becomes a bit ambiguous.

Heh, I wrote that at the last minute and was a bit tired. I was hoping
for a better write up from someone ;-)

> 
> I would prefer having something like this
> 
> 2. Building KernelShark:
> 2.1 Option 1 : build KernelShark as part of trace-cmd
> 
>       make gui
>       All explanations for this build option are following
>       ...
> 
> 2.2 Option 2 : standalone build of KernelShark (for hackers only)
> 
>       cd kernel-shark/build
>       cmake ../
>       make
>       All explanations for this build option are following ...
>       ...
> 
> Note that in Option 1
> 
>   make clean
> 
>   is equivalent to
> 
>   make clean
>   ./cmake_clean.sh
> 
> in Option 2.

Makes sense.

Thanks!

-- Steve
