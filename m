Return-Path: <SRS0=hkP+=TV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32525C04AAF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 May 2019 13:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 052D121743
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 May 2019 13:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfEUN74 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 May 2019 09:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbfEUN74 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 May 2019 09:59:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677C921479;
        Tue, 21 May 2019 13:59:55 +0000 (UTC)
Date:   Tue, 21 May 2019 09:59:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "slavomir.kaslev@gmail.com" <slavomir.kaslev@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH 0/6] Various modifications and fixes toward KS 1.0
Message-ID: <20190521095953.01474ec3@gandalf.local.home>
In-Reply-To: <CAE0o1NuLW1E7wayZA2CKtDGp4YciJjVz9-4KFkk+XWiB+GyDLA@mail.gmail.com>
References: <20190515190911.20755-1-ykaradzhov@vmware.com>
        <CAE0o1NuLW1E7wayZA2CKtDGp4YciJjVz9-4KFkk+XWiB+GyDLA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 16 May 2019 13:42:41 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> All the new patches looks good to me.
> 
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Thanks Yordan and Slavomir!

I'm applying these patches. Although, it appears I already had patches
3 and 4 applied.

-- Steve
